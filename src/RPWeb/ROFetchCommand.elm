module ROFetchCommand exposing (..)

import Http exposing (..)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (custom, hardcoded, required, decode)
import Model exposing (..)
import RemoteData
import Random
import Types.ActionRequired  exposing (..)
import Types.InProcess exposing (..)

fetchRO: String -> ROViewCategoryName -> Cmd Msg
fetchRO url selectedROViewName =
        Http.get url (roDecoder selectedROViewName)
                |> RemoteData.sendRequest
                |> Cmd.map OnFetchRO

commonFieldsDecoder : Decode.Decoder CommonROFields
commonFieldsDecoder =
    decode CommonROFields
            |> required "repairOrderNumber" Decode.int
            |> required "customerName" Decode.string

roDecoder : ROViewCategoryName -> Decode.Decoder RepairOrder
roDecoder selectedROViewName =
        let
                tempCoder = decode RepairOrder
                                        |> custom (commonFieldsDecoder)   
        in
                tempCoder |>
                case selectedROViewName of
                        ActionRequiredROView ->
                                        required "actionRequiredInternalROInfo" actionRequiredInternalROInfoDecoder
                        InProcessROView ->
                                        required "inProcessInternalROInfo" inProcessInternalROInfoDecoder

actionRequiredInternalROInfoDecoder : Decode.Decoder RepairOrderVariants
actionRequiredInternalROInfoDecoder =
    decode ActionRequiredRO
            |> required "branchName" (Decode.map BranchName Decode.string)
            |> required "branchLocation" Decode.string

inProcessInternalROInfoDecoder : Decode.Decoder RepairOrderVariants
inProcessInternalROInfoDecoder =
    decode InProcessRO
            |> required "unitNumber" (Decode.map UnitNumber Decode.string)
            |> required "unitVehicleIdNumber" (Decode.map UnitVehicleIdNumber Decode.string)