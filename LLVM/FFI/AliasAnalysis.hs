module LLVM.FFI.AliasAnalysis 
       (AliasAnalysis()
       ,AliasAnalysisC()
       ,newAliasAnalysis
       ,deleteAliasAnalysis
#if HS_LLVM_VERSION >= 303
       ,aliasAnalysisGetTargetLibraryInfo
#endif
       ,aliasAnalysisGetTypeStoreSize
#if HS_LLVM_VERSION>=209
       ,aliasAnalysisGetLocationLoad
       ,aliasAnalysisGetLocationStore
       ,aliasAnalysisGetLocationVAArg
#endif
#if HS_LLVM_VERSION >= 300
       ,aliasAnalysisGetLocationAtomicCmpXchg
       ,aliasAnalysisGetLocationAtomicRMWInst
#endif
       ,aliasAnalysisAlias
       ,AliasResult(..)
#if HS_LLVM_VERSION>=209
       ,Location()
       ,newLocation
#endif
       ) where

import LLVM.FFI.Interface
import LLVM.FFI.Value
#if HS_LLVM_VERSION >= 303
import LLVM.FFI.Pass (TargetLibraryInfo)
#endif
import LLVM.FFI.Type (TypeC)
#if HS_LLVM_VERSION >= 300
import LLVM.FFI.Instruction (LoadInst,StoreInst,VAArgInst,AtomicCmpXchgInst,AtomicRMWInst)
#else
import LLVM.FFI.Instruction (LoadInst,StoreInst,VAArgInst)
#endif
import Foreign.C
import Foreign.Ptr
import Data.Word

#include "Helper.h"

class AliasAnalysisC t

deleteAliasAnalysis :: AliasAnalysisC t => Ptr t -> IO ()
deleteAliasAnalysis = deleteAliasAnalysis_

#if HS_LLVM_VERSION >= 303
aliasAnalysisGetTargetLibraryInfo :: AliasAnalysisC t => Ptr t -> IO (Ptr TargetLibraryInfo)
aliasAnalysisGetTargetLibraryInfo = aliasAnalysisGetTargetLibraryInfo_
#endif

aliasAnalysisGetTypeStoreSize :: (AliasAnalysisC a,TypeC tp) => Ptr a -> Ptr tp -> IO Word64
aliasAnalysisGetTypeStoreSize = aliasAnalysisGetTypeStoreSize_

#if HS_LLVM_VERSION>=209
aliasAnalysisGetLocationLoad :: AliasAnalysisC t => Ptr t -> Ptr LoadInst -> IO (Ptr Location)
aliasAnalysisGetLocationLoad = aliasAnalysisGetLocationLoad_

aliasAnalysisGetLocationStore :: AliasAnalysisC t => Ptr t -> Ptr StoreInst -> IO (Ptr Location)
aliasAnalysisGetLocationStore = aliasAnalysisGetLocationStore_

aliasAnalysisGetLocationVAArg :: AliasAnalysisC t => Ptr t -> Ptr VAArgInst -> IO (Ptr Location)
aliasAnalysisGetLocationVAArg = aliasAnalysisGetLocationVAArg_
#endif

#if HS_LLVM_VERSION >= 300
aliasAnalysisGetLocationAtomicCmpXchg :: AliasAnalysisC t => Ptr t -> Ptr AtomicCmpXchgInst -> IO (Ptr Location)
aliasAnalysisGetLocationAtomicCmpXchg = aliasAnalysisGetLocationAtomicCmpXchg_

aliasAnalysisGetLocationAtomicRMWInst :: AliasAnalysisC t => Ptr t -> Ptr AtomicRMWInst -> IO (Ptr Location)
aliasAnalysisGetLocationAtomicRMWInst = aliasAnalysisGetLocationAtomicRMW_
#endif

#if HS_LLVM_VERSION>=209
aliasAnalysisAlias :: AliasAnalysisC t => Ptr t -> Ptr Location -> Ptr Location -> IO AliasResult
aliasAnalysisAlias ptr l1 l2 = fmap toAliasResult $ aliasAnalysisAlias_ ptr l1 l2

newLocation :: ValueC v => Ptr v -> Word64 -> Ptr MDNode -> IO (Ptr Location)
newLocation ptr size tbaa = newLocation_ ptr size tbaa
#else
aliasAnalysisAlias :: AliasAnalysisC t => Ptr t -> Ptr Value -> CUInt -> Ptr Value -> CUInt -> IO AliasResult
aliasAnalysisAlias ptr v1 l1 v2 l2 = fmap toAliasResult $ aliasAnalysisAlias_ ptr v1 l1 v2 l2
#endif