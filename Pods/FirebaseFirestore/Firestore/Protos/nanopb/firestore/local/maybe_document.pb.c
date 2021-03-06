/*
 * Copyright 2018 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* Automatically generated nanopb constant definitions */
/* Generated by nanopb-0.3.8 at Fri Jun  1 18:36:44 2018. */

#include "maybe_document.nanopb.h"

/* @@protoc_insertion_point(includes) */
#if PB_PROTO_HEADER_VERSION != 30
#error Regenerate this file with the current version of nanopb generator.
#endif



const pb_field_t firestore_client_NoDocument_fields[3] = {
    PB_FIELD(  1, STRING  , SINGULAR, CALLBACK, FIRST, firestore_client_NoDocument, name, name, 0),
    PB_FIELD(  2, MESSAGE , SINGULAR, STATIC  , OTHER, firestore_client_NoDocument, read_time, name, &google_protobuf_Timestamp_fields),
    PB_LAST_FIELD
};

const pb_field_t firestore_client_MaybeDocument_fields[3] = {
    PB_ONEOF_FIELD(document_type,   1, MESSAGE , ONEOF, STATIC  , FIRST, firestore_client_MaybeDocument, no_document, no_document, &firestore_client_NoDocument_fields),
    PB_ONEOF_FIELD(document_type,   2, MESSAGE , ONEOF, STATIC  , UNION, firestore_client_MaybeDocument, document, document, &google_firestore_v1beta1_Document_fields),
    PB_LAST_FIELD
};


/* Check that field information fits in pb_field_t */
#if !defined(PB_FIELD_32BIT)
/* If you get an error here, it means that you need to define PB_FIELD_32BIT
 * compile-time option. You can do that in pb.h or on compiler command line.
 * 
 * The reason you need to do this is that some of your messages contain tag
 * numbers or field sizes that are larger than what can fit in 8 or 16 bit
 * field descriptors.
 */
PB_STATIC_ASSERT((pb_membersize(firestore_client_NoDocument, read_time) < 65536 && pb_membersize(firestore_client_MaybeDocument, document_type.no_document) < 65536 && pb_membersize(firestore_client_MaybeDocument, document_type.document) < 65536), YOU_MUST_DEFINE_PB_FIELD_32BIT_FOR_MESSAGES_firestore_client_NoDocument_firestore_client_MaybeDocument)
#endif

#if !defined(PB_FIELD_16BIT) && !defined(PB_FIELD_32BIT)
/* If you get an error here, it means that you need to define PB_FIELD_16BIT
 * compile-time option. You can do that in pb.h or on compiler command line.
 * 
 * The reason you need to do this is that some of your messages contain tag
 * numbers or field sizes that are larger than what can fit in the default
 * 8 bit descriptors.
 */
PB_STATIC_ASSERT((pb_membersize(firestore_client_NoDocument, read_time) < 256 && pb_membersize(firestore_client_MaybeDocument, document_type.no_document) < 256 && pb_membersize(firestore_client_MaybeDocument, document_type.document) < 256), YOU_MUST_DEFINE_PB_FIELD_16BIT_FOR_MESSAGES_firestore_client_NoDocument_firestore_client_MaybeDocument)
#endif


/* @@protoc_insertion_point(eof) */
