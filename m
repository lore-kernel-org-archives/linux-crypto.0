From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 11/22] staging: crypto: skein: cleanup whitespace around
 operators/punc.
Date: Tue, 11 Mar 2014 21:32:43 +0000
Message-ID: <cc4b6cf800b5bdfa449111164b4205824abf2f2f.1394570068.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
 Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skein.h    | 168 +++++-----
 drivers/staging/skein/include/skein_iv.h | 224 +++++++-------
 drivers/staging/skein/skein.c            | 352 ++++++++++-----------
 drivers/staging/skein/skeinApi.c         |  22 +-
 drivers/staging/skein/skeinBlockNo3F.c   |  20 +-
 drivers/staging/skein/skein_block.c      | 513 +++++++++++++++----------------
 6 files changed, 648 insertions(+), 651 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index b7cd6c0cef2f..fef29ad64c93 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -29,12 +29,12 @@
 ***************************************************************************/
 
 #ifndef RotL_64
-#define RotL_64(x,N)    (((x) << (N)) | ((x) >> (64-(N))))
+#define RotL_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
 #endif
 
 /* below two prototype assume we are handed aligned data */
-#define Skein_Put64_LSB_First(dst08,src64,bCnt) memcpy(dst08,src64,bCnt)
-#define Skein_Get64_LSB_First(dst64,src08,wCnt) memcpy(dst64,src08,8*(wCnt))
+#define Skein_Put64_LSB_First(dst08, src64, bCnt) memcpy(dst08, src64, bCnt)
+#define Skein_Get64_LSB_First(dst64, src08, wCnt) memcpy(dst64, src08, 8*(wCnt))
 #define Skein_Swap64(w64)  (w64)
 
 enum
@@ -44,24 +44,24 @@ enum
     SKEIN_BAD_HASHLEN     =      2
     };
 
-#define  SKEIN_MODIFIER_WORDS  ( 2)          /* number of modifier (tweak) words */
+#define  SKEIN_MODIFIER_WORDS   (2)          /* number of modifier (tweak) words */
 
-#define  SKEIN_256_STATE_WORDS ( 4)
-#define  SKEIN_512_STATE_WORDS ( 8)
+#define  SKEIN_256_STATE_WORDS  (4)
+#define  SKEIN_512_STATE_WORDS  (8)
 #define  SKEIN1024_STATE_WORDS (16)
 #define  SKEIN_MAX_STATE_WORDS (16)
 
-#define  SKEIN_256_STATE_BYTES ( 8*SKEIN_256_STATE_WORDS)
-#define  SKEIN_512_STATE_BYTES ( 8*SKEIN_512_STATE_WORDS)
-#define  SKEIN1024_STATE_BYTES ( 8*SKEIN1024_STATE_WORDS)
+#define  SKEIN_256_STATE_BYTES  (8*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_STATE_BYTES  (8*SKEIN_512_STATE_WORDS)
+#define  SKEIN1024_STATE_BYTES  (8*SKEIN1024_STATE_WORDS)
 
 #define  SKEIN_256_STATE_BITS  (64*SKEIN_256_STATE_WORDS)
 #define  SKEIN_512_STATE_BITS  (64*SKEIN_512_STATE_WORDS)
 #define  SKEIN1024_STATE_BITS  (64*SKEIN1024_STATE_WORDS)
 
-#define  SKEIN_256_BLOCK_BYTES ( 8*SKEIN_256_STATE_WORDS)
-#define  SKEIN_512_BLOCK_BYTES ( 8*SKEIN_512_STATE_WORDS)
-#define  SKEIN1024_BLOCK_BYTES ( 8*SKEIN1024_STATE_WORDS)
+#define  SKEIN_256_BLOCK_BYTES  (8*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_BLOCK_BYTES  (8*SKEIN_512_STATE_WORDS)
+#define  SKEIN1024_BLOCK_BYTES  (8*SKEIN1024_STATE_WORDS)
 
 struct skein_ctx_hdr
     {
@@ -92,17 +92,17 @@ struct skein1024_ctx                              /* 1024-bit Skein hash context
     };
 
 /*   Skein APIs for (incremental) "straight hashing" */
-int  Skein_256_Init  (struct skein_256_ctx *ctx, size_t hashBitLen);
-int  Skein_512_Init  (struct skein_512_ctx *ctx, size_t hashBitLen);
-int  Skein1024_Init  (struct skein1024_ctx *ctx, size_t hashBitLen);
+int  Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen);
+int  Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen);
+int  Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen);
 
 int  Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCnt);
 int  Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt);
 int  Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt);
 
-int  Skein_256_Final (struct skein_256_ctx *ctx, u8 *hashVal);
-int  Skein_512_Final (struct skein_512_ctx *ctx, u8 *hashVal);
-int  Skein1024_Final (struct skein1024_ctx *ctx, u8 *hashVal);
+int  Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal);
+int  Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal);
+int  Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal);
 
 /*
 **   Skein APIs for "extended" initialization: MAC keys, tree hashing.
@@ -135,9 +135,9 @@ int  Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal);
 #define SKEIN_TREE_HASH (1)
 #endif
 #if  SKEIN_TREE_HASH
-int  Skein_256_Output   (struct skein_256_ctx *ctx, u8 *hashVal);
-int  Skein_512_Output   (struct skein_512_ctx *ctx, u8 *hashVal);
-int  Skein1024_Output   (struct skein1024_ctx *ctx, u8 *hashVal);
+int  Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal);
+int  Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal);
+int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
 #endif
 
 /*****************************************************************
@@ -158,18 +158,18 @@ int  Skein1024_Output   (struct skein1024_ctx *ctx, u8 *hashVal);
 #define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127)       /* bit  127     : final block flag         */
                                 
 /* tweak word T[1]: flag bit definition(s) */
-#define SKEIN_T1_FLAG_FIRST     (((u64)  1 ) << SKEIN_T1_POS_FIRST)
-#define SKEIN_T1_FLAG_FINAL     (((u64)  1 ) << SKEIN_T1_POS_FINAL)
-#define SKEIN_T1_FLAG_BIT_PAD   (((u64)  1 ) << SKEIN_T1_POS_BIT_PAD)
+#define SKEIN_T1_FLAG_FIRST     (((u64)  1) << SKEIN_T1_POS_FIRST)
+#define SKEIN_T1_FLAG_FINAL     (((u64)  1) << SKEIN_T1_POS_FINAL)
+#define SKEIN_T1_FLAG_BIT_PAD   (((u64)  1) << SKEIN_T1_POS_BIT_PAD)
                                 
 /* tweak word T[1]: tree level bit field mask */
 #define SKEIN_T1_TREE_LVL_MASK  (((u64)0x7F) << SKEIN_T1_POS_TREE_LVL)
 #define SKEIN_T1_TREE_LEVEL(n)  (((u64) (n)) << SKEIN_T1_POS_TREE_LVL)
 
 /* tweak word T[1]: block type field */
-#define SKEIN_BLK_TYPE_KEY      ( 0)                    /* key, for MAC and KDF */
-#define SKEIN_BLK_TYPE_CFG      ( 4)                    /* configuration block */
-#define SKEIN_BLK_TYPE_PERS     ( 8)                    /* personalization string */
+#define SKEIN_BLK_TYPE_KEY       (0)                    /* key, for MAC and KDF */
+#define SKEIN_BLK_TYPE_CFG       (4)                    /* configuration block */
+#define SKEIN_BLK_TYPE_PERS      (8)                    /* personalization string */
 #define SKEIN_BLK_TYPE_PK       (12)                    /* public key (for digital signature hashing) */
 #define SKEIN_BLK_TYPE_KDF      (16)                    /* key identifier for KDF */
 #define SKEIN_BLK_TYPE_NONCE    (20)                    /* nonce for PRNG */
@@ -197,73 +197,73 @@ int  Skein1024_Output   (struct skein1024_ctx *ctx, u8 *hashVal);
 #define SKEIN_ID_STRING_LE      (0x33414853)            /* "SHA3" (little-endian)*/
 #endif
 
-#define SKEIN_MK_64(hi32,lo32)  ((lo32) + (((u64) (hi32)) << 32))
-#define SKEIN_SCHEMA_VER        SKEIN_MK_64(SKEIN_VERSION,SKEIN_ID_STRING_LE)
-#define SKEIN_KS_PARITY         SKEIN_MK_64(0x1BD11BDA,0xA9FC1A22)
+#define SKEIN_MK_64(hi32, lo32)  ((lo32) + (((u64) (hi32)) << 32))
+#define SKEIN_SCHEMA_VER        SKEIN_MK_64(SKEIN_VERSION, SKEIN_ID_STRING_LE)
+#define SKEIN_KS_PARITY         SKEIN_MK_64(0x1BD11BDA, 0xA9FC1A22)
 
 #define SKEIN_CFG_STR_LEN       (4*8)
 
 /* bit field definitions in config block treeInfo word */
-#define SKEIN_CFG_TREE_LEAF_SIZE_POS  ( 0)
-#define SKEIN_CFG_TREE_NODE_SIZE_POS  ( 8)
+#define SKEIN_CFG_TREE_LEAF_SIZE_POS  (0)
+#define SKEIN_CFG_TREE_NODE_SIZE_POS  (8)
 #define SKEIN_CFG_TREE_MAX_LEVEL_POS  (16)
 
 #define SKEIN_CFG_TREE_LEAF_SIZE_MSK  (((u64) 0xFF) << SKEIN_CFG_TREE_LEAF_SIZE_POS)
 #define SKEIN_CFG_TREE_NODE_SIZE_MSK  (((u64) 0xFF) << SKEIN_CFG_TREE_NODE_SIZE_POS)
 #define SKEIN_CFG_TREE_MAX_LEVEL_MSK  (((u64) 0xFF) << SKEIN_CFG_TREE_MAX_LEVEL_POS)
 
-#define SKEIN_CFG_TREE_INFO(leaf,node,maxLvl)                   \
-    ( (((u64)(leaf  )) << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
-      (((u64)(node  )) << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
-      (((u64)(maxLvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS) )
+#define SKEIN_CFG_TREE_INFO(leaf, node, maxLvl)                   \
+    ((((u64)(leaf))   << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
+     (((u64)(node))   << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
+     (((u64)(maxLvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS))
 
-#define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0,0,0) /* use as treeInfo in InitExt() call for sequential processing */
+#define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0, 0, 0) /* use as treeInfo in InitExt() call for sequential processing */
 
 /*
 **   Skein macros for getting/setting tweak words, etc.
 **   These are useful for partial input bytes, hash tree init/update, etc.
 **/
-#define Skein_Get_Tweak(ctxPtr,TWK_NUM)         ((ctxPtr)->h.T[TWK_NUM])
-#define Skein_Set_Tweak(ctxPtr,TWK_NUM,tVal)    {(ctxPtr)->h.T[TWK_NUM] = (tVal);}
+#define Skein_Get_Tweak(ctxPtr, TWK_NUM)          ((ctxPtr)->h.T[TWK_NUM])
+#define Skein_Set_Tweak(ctxPtr, TWK_NUM, tVal)    {(ctxPtr)->h.T[TWK_NUM] = (tVal); }
 
-#define Skein_Get_T0(ctxPtr)    Skein_Get_Tweak(ctxPtr,0)
-#define Skein_Get_T1(ctxPtr)    Skein_Get_Tweak(ctxPtr,1)
-#define Skein_Set_T0(ctxPtr,T0) Skein_Set_Tweak(ctxPtr,0,T0)
-#define Skein_Set_T1(ctxPtr,T1) Skein_Set_Tweak(ctxPtr,1,T1)
+#define Skein_Get_T0(ctxPtr)     Skein_Get_Tweak(ctxPtr, 0)
+#define Skein_Get_T1(ctxPtr)     Skein_Get_Tweak(ctxPtr, 1)
+#define Skein_Set_T0(ctxPtr, T0) Skein_Set_Tweak(ctxPtr, 0, T0)
+#define Skein_Set_T1(ctxPtr, T1) Skein_Set_Tweak(ctxPtr, 1, T1)
 
 /* set both tweak words at once */
-#define Skein_Set_T0_T1(ctxPtr,T0,T1)           \
+#define Skein_Set_T0_T1(ctxPtr, T0, T1)           \
     {                                           \
-    Skein_Set_T0(ctxPtr,(T0));                  \
-    Skein_Set_T1(ctxPtr,(T1));                  \
+    Skein_Set_T0(ctxPtr, (T0));                  \
+    Skein_Set_T1(ctxPtr, (T1));                  \
     }
 
-#define Skein_Set_Type(ctxPtr,BLK_TYPE)         \
-    Skein_Set_T1(ctxPtr,SKEIN_T1_BLK_TYPE_##BLK_TYPE)
+#define Skein_Set_Type(ctxPtr, BLK_TYPE)         \
+    Skein_Set_T1(ctxPtr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
 
 /* set up for starting with a new type: h.T[0]=0; h.T[1] = NEW_TYPE; h.bCnt=0; */
-#define Skein_Start_New_Type(ctxPtr,BLK_TYPE)   \
-    { Skein_Set_T0_T1(ctxPtr,0,SKEIN_T1_FLAG_FIRST | SKEIN_T1_BLK_TYPE_##BLK_TYPE); (ctxPtr)->h.bCnt=0; }
+#define Skein_Start_New_Type(ctxPtr, BLK_TYPE)   \
+    { Skein_Set_T0_T1(ctxPtr, 0, SKEIN_T1_FLAG_FIRST | SKEIN_T1_BLK_TYPE_##BLK_TYPE); (ctxPtr)->h.bCnt = 0; }
 
 #define Skein_Clear_First_Flag(hdr)      { (hdr).T[1] &= ~SKEIN_T1_FLAG_FIRST;       }
 #define Skein_Set_Bit_Pad_Flag(hdr)      { (hdr).T[1] |=  SKEIN_T1_FLAG_BIT_PAD;     }
 
-#define Skein_Set_Tree_Level(hdr,height) { (hdr).T[1] |= SKEIN_T1_TREE_LEVEL(height);}
+#define Skein_Set_Tree_Level(hdr, height) { (hdr).T[1] |= SKEIN_T1_TREE_LEVEL(height); }
 
 /*****************************************************************
 ** "Internal" Skein definitions for debugging and error checking
 ******************************************************************/
-#ifdef  SKEIN_DEBUG             /* examine/display intermediate values? */
+#ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
 #include "skein_debug.h"
 #else                           /* default is no callouts */
-#define Skein_Show_Block(bits,ctx,X,blkPtr,wPtr,ksEvenPtr,ksOddPtr)
-#define Skein_Show_Round(bits,ctx,r,X)
-#define Skein_Show_R_Ptr(bits,ctx,r,X_ptr)
-#define Skein_Show_Final(bits,ctx,cnt,outPtr)
-#define Skein_Show_Key(bits,ctx,key,keyBytes)
+#define Skein_Show_Block(bits, ctx, X, blkPtr, wPtr, ksEvenPtr, ksOddPtr)
+#define Skein_Show_Round(bits, ctx, r, X)
+#define Skein_Show_R_Ptr(bits, ctx, r, X_ptr)
+#define Skein_Show_Final(bits, ctx, cnt, outPtr)
+#define Skein_Show_Key(bits, ctx, key, keyBytes)
 #endif
 
-#define Skein_Assert(x,retCode)/* default: ignore all Asserts, for performance */
+#define Skein_Assert(x, retCode)/* default: ignore all Asserts, for performance */
 #define Skein_assert(x)
 
 /*****************************************************************
@@ -272,34 +272,34 @@ int  Skein1024_Output   (struct skein1024_ctx *ctx, u8 *hashVal);
 enum    
     {   
         /* Skein_256 round rotation constants */
-    R_256_0_0=14, R_256_0_1=16,
-    R_256_1_0=52, R_256_1_1=57,
-    R_256_2_0=23, R_256_2_1=40,
-    R_256_3_0= 5, R_256_3_1=37,
-    R_256_4_0=25, R_256_4_1=33,
-    R_256_5_0=46, R_256_5_1=12,
-    R_256_6_0=58, R_256_6_1=22,
-    R_256_7_0=32, R_256_7_1=32,
+    R_256_0_0 = 14, R_256_0_1 = 16,
+    R_256_1_0 = 52, R_256_1_1 = 57,
+    R_256_2_0 = 23, R_256_2_1 = 40,
+    R_256_3_0 =  5, R_256_3_1 = 37,
+    R_256_4_0 = 25, R_256_4_1 = 33,
+    R_256_5_0 = 46, R_256_5_1 = 12,
+    R_256_6_0 = 58, R_256_6_1 = 22,
+    R_256_7_0 = 32, R_256_7_1 = 32,
 
         /* Skein_512 round rotation constants */
-    R_512_0_0=46, R_512_0_1=36, R_512_0_2=19, R_512_0_3=37,
-    R_512_1_0=33, R_512_1_1=27, R_512_1_2=14, R_512_1_3=42,
-    R_512_2_0=17, R_512_2_1=49, R_512_2_2=36, R_512_2_3=39,
-    R_512_3_0=44, R_512_3_1= 9, R_512_3_2=54, R_512_3_3=56,
-    R_512_4_0=39, R_512_4_1=30, R_512_4_2=34, R_512_4_3=24,
-    R_512_5_0=13, R_512_5_1=50, R_512_5_2=10, R_512_5_3=17,
-    R_512_6_0=25, R_512_6_1=29, R_512_6_2=39, R_512_6_3=43,
-    R_512_7_0= 8, R_512_7_1=35, R_512_7_2=56, R_512_7_3=22,
+    R_512_0_0 = 46, R_512_0_1 = 36, R_512_0_2 = 19, R_512_0_3 = 37,
+    R_512_1_0 = 33, R_512_1_1 = 27, R_512_1_2 = 14, R_512_1_3 = 42,
+    R_512_2_0 = 17, R_512_2_1 = 49, R_512_2_2 = 36, R_512_2_3 = 39,
+    R_512_3_0 = 44, R_512_3_1 =  9, R_512_3_2 = 54, R_512_3_3 = 56,
+    R_512_4_0 = 39, R_512_4_1 = 30, R_512_4_2 = 34, R_512_4_3 = 24,
+    R_512_5_0 = 13, R_512_5_1 = 50, R_512_5_2 = 10, R_512_5_3 = 17,
+    R_512_6_0 = 25, R_512_6_1 = 29, R_512_6_2 = 39, R_512_6_3 = 43,
+    R_512_7_0 =  8, R_512_7_1 = 35, R_512_7_2 = 56, R_512_7_3 = 22,
 
         /* Skein1024 round rotation constants */
-    R1024_0_0=24, R1024_0_1=13, R1024_0_2= 8, R1024_0_3=47, R1024_0_4= 8, R1024_0_5=17, R1024_0_6=22, R1024_0_7=37,
-    R1024_1_0=38, R1024_1_1=19, R1024_1_2=10, R1024_1_3=55, R1024_1_4=49, R1024_1_5=18, R1024_1_6=23, R1024_1_7=52,
-    R1024_2_0=33, R1024_2_1= 4, R1024_2_2=51, R1024_2_3=13, R1024_2_4=34, R1024_2_5=41, R1024_2_6=59, R1024_2_7=17,
-    R1024_3_0= 5, R1024_3_1=20, R1024_3_2=48, R1024_3_3=41, R1024_3_4=47, R1024_3_5=28, R1024_3_6=16, R1024_3_7=25,
-    R1024_4_0=41, R1024_4_1= 9, R1024_4_2=37, R1024_4_3=31, R1024_4_4=12, R1024_4_5=47, R1024_4_6=44, R1024_4_7=30,
-    R1024_5_0=16, R1024_5_1=34, R1024_5_2=56, R1024_5_3=51, R1024_5_4= 4, R1024_5_5=53, R1024_5_6=42, R1024_5_7=41,
-    R1024_6_0=31, R1024_6_1=44, R1024_6_2=47, R1024_6_3=46, R1024_6_4=19, R1024_6_5=42, R1024_6_6=44, R1024_6_7=25,
-    R1024_7_0= 9, R1024_7_1=48, R1024_7_2=35, R1024_7_3=52, R1024_7_4=23, R1024_7_5=31, R1024_7_6=37, R1024_7_7=20
+    R1024_0_0 = 24, R1024_0_1 = 13, R1024_0_2 =  8, R1024_0_3 = 47, R1024_0_4 =  8, R1024_0_5 = 17, R1024_0_6 = 22, R1024_0_7 = 37,
+    R1024_1_0 = 38, R1024_1_1 = 19, R1024_1_2 = 10, R1024_1_3 = 55, R1024_1_4 = 49, R1024_1_5 = 18, R1024_1_6 = 23, R1024_1_7 = 52,
+    R1024_2_0 = 33, R1024_2_1 =  4, R1024_2_2 = 51, R1024_2_3 = 13, R1024_2_4 = 34, R1024_2_5 = 41, R1024_2_6 = 59, R1024_2_7 = 17,
+    R1024_3_0 =  5, R1024_3_1 = 20, R1024_3_2 = 48, R1024_3_3 = 41, R1024_3_4 = 47, R1024_3_5 = 28, R1024_3_6 = 16, R1024_3_7 = 25,
+    R1024_4_0 = 41, R1024_4_1 =  9, R1024_4_2 = 37, R1024_4_3 = 31, R1024_4_4 = 12, R1024_4_5 = 47, R1024_4_6 = 44, R1024_4_7 = 30,
+    R1024_5_0 = 16, R1024_5_1 = 34, R1024_5_2 = 56, R1024_5_3 = 51, R1024_5_4 =  4, R1024_5_5 = 53, R1024_5_6 = 42, R1024_5_7 = 41,
+    R1024_6_0 = 31, R1024_6_1 = 44, R1024_6_2 = 47, R1024_6_3 = 46, R1024_6_4 = 19, R1024_6_5 = 42, R1024_6_6 = 44, R1024_6_7 = 25,
+    R1024_7_0 =  9, R1024_7_1 = 48, R1024_7_2 = 35, R1024_7_3 = 52, R1024_7_4 = 23, R1024_7_5 = 31, R1024_7_6 = 37, R1024_7_7 = 20
     };
 
 #ifndef SKEIN_ROUNDS
@@ -308,8 +308,8 @@ enum
 #define SKEIN1024_ROUNDS_TOTAL (80)
 #else                                        /* allow command-line define in range 8*(5..14)   */
 #define SKEIN_256_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/100) + 5) % 10) + 5))
-#define SKEIN_512_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/ 10) + 5) % 10) + 5))
-#define SKEIN1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS    ) + 5) % 10) + 5))
+#define SKEIN_512_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/10)  + 5) % 10) + 5))
+#define SKEIN1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS)     + 5) % 10) + 5))
 #endif
 
 #endif  /* ifndef _SKEIN_H_ */
diff --git a/drivers/staging/skein/include/skein_iv.h b/drivers/staging/skein/include/skein_iv.h
index 94ac2f7cde76..aff9394551a0 100644
--- a/drivers/staging/skein/include/skein_iv.h
+++ b/drivers/staging/skein/include/skein_iv.h
@@ -22,178 +22,178 @@
 /* blkSize =  256 bits. hashSize =  128 bits */
 const u64 SKEIN_256_IV_128[] =
     {
-    MK_64(0xE1111906,0x964D7260),
-    MK_64(0x883DAAA7,0x7C8D811C),
-    MK_64(0x10080DF4,0x91960F7A),
-    MK_64(0xCCF7DDE5,0xB45BC1C2)
+    MK_64(0xE1111906, 0x964D7260),
+    MK_64(0x883DAAA7, 0x7C8D811C),
+    MK_64(0x10080DF4, 0x91960F7A),
+    MK_64(0xCCF7DDE5, 0xB45BC1C2)
     };
 
 /* blkSize =  256 bits. hashSize =  160 bits */
 const u64 SKEIN_256_IV_160[] =
     {
-    MK_64(0x14202314,0x72825E98),
-    MK_64(0x2AC4E9A2,0x5A77E590),
-    MK_64(0xD47A5856,0x8838D63E),
-    MK_64(0x2DD2E496,0x8586AB7D)
+    MK_64(0x14202314, 0x72825E98),
+    MK_64(0x2AC4E9A2, 0x5A77E590),
+    MK_64(0xD47A5856, 0x8838D63E),
+    MK_64(0x2DD2E496, 0x8586AB7D)
     };
 
 /* blkSize =  256 bits. hashSize =  224 bits */
 const u64 SKEIN_256_IV_224[] =
     {
-    MK_64(0xC6098A8C,0x9AE5EA0B),
-    MK_64(0x876D5686,0x08C5191C),
-    MK_64(0x99CB88D7,0xD7F53884),
-    MK_64(0x384BDDB1,0xAEDDB5DE)
+    MK_64(0xC6098A8C, 0x9AE5EA0B),
+    MK_64(0x876D5686, 0x08C5191C),
+    MK_64(0x99CB88D7, 0xD7F53884),
+    MK_64(0x384BDDB1, 0xAEDDB5DE)
     };
 
 /* blkSize =  256 bits. hashSize =  256 bits */
 const u64 SKEIN_256_IV_256[] =
     {
-    MK_64(0xFC9DA860,0xD048B449),
-    MK_64(0x2FCA6647,0x9FA7D833),
-    MK_64(0xB33BC389,0x6656840F),
-    MK_64(0x6A54E920,0xFDE8DA69)
+    MK_64(0xFC9DA860, 0xD048B449),
+    MK_64(0x2FCA6647, 0x9FA7D833),
+    MK_64(0xB33BC389, 0x6656840F),
+    MK_64(0x6A54E920, 0xFDE8DA69)
     };
 
 /* blkSize =  512 bits. hashSize =  128 bits */
 const u64 SKEIN_512_IV_128[] =
     {
-    MK_64(0xA8BC7BF3,0x6FBF9F52),
-    MK_64(0x1E9872CE,0xBD1AF0AA),
-    MK_64(0x309B1790,0xB32190D3),
-    MK_64(0xBCFBB854,0x3F94805C),
-    MK_64(0x0DA61BCD,0x6E31B11B),
-    MK_64(0x1A18EBEA,0xD46A32E3),
-    MK_64(0xA2CC5B18,0xCE84AA82),
-    MK_64(0x6982AB28,0x9D46982D)
+    MK_64(0xA8BC7BF3, 0x6FBF9F52),
+    MK_64(0x1E9872CE, 0xBD1AF0AA),
+    MK_64(0x309B1790, 0xB32190D3),
+    MK_64(0xBCFBB854, 0x3F94805C),
+    MK_64(0x0DA61BCD, 0x6E31B11B),
+    MK_64(0x1A18EBEA, 0xD46A32E3),
+    MK_64(0xA2CC5B18, 0xCE84AA82),
+    MK_64(0x6982AB28, 0x9D46982D)
     };
 
 /* blkSize =  512 bits. hashSize =  160 bits */
 const u64 SKEIN_512_IV_160[] =
     {
-    MK_64(0x28B81A2A,0xE013BD91),
-    MK_64(0xC2F11668,0xB5BDF78F),
-    MK_64(0x1760D8F3,0xF6A56F12),
-    MK_64(0x4FB74758,0x8239904F),
-    MK_64(0x21EDE07F,0x7EAF5056),
-    MK_64(0xD908922E,0x63ED70B8),
-    MK_64(0xB8EC76FF,0xECCB52FA),
-    MK_64(0x01A47BB8,0xA3F27A6E)
+    MK_64(0x28B81A2A, 0xE013BD91),
+    MK_64(0xC2F11668, 0xB5BDF78F),
+    MK_64(0x1760D8F3, 0xF6A56F12),
+    MK_64(0x4FB74758, 0x8239904F),
+    MK_64(0x21EDE07F, 0x7EAF5056),
+    MK_64(0xD908922E, 0x63ED70B8),
+    MK_64(0xB8EC76FF, 0xECCB52FA),
+    MK_64(0x01A47BB8, 0xA3F27A6E)
     };
 
 /* blkSize =  512 bits. hashSize =  224 bits */
 const u64 SKEIN_512_IV_224[] =
     {
-    MK_64(0xCCD06162,0x48677224),
-    MK_64(0xCBA65CF3,0xA92339EF),
-    MK_64(0x8CCD69D6,0x52FF4B64),
-    MK_64(0x398AED7B,0x3AB890B4),
-    MK_64(0x0F59D1B1,0x457D2BD0),
-    MK_64(0x6776FE65,0x75D4EB3D),
-    MK_64(0x99FBC70E,0x997413E9),
-    MK_64(0x9E2CFCCF,0xE1C41EF7)
+    MK_64(0xCCD06162, 0x48677224),
+    MK_64(0xCBA65CF3, 0xA92339EF),
+    MK_64(0x8CCD69D6, 0x52FF4B64),
+    MK_64(0x398AED7B, 0x3AB890B4),
+    MK_64(0x0F59D1B1, 0x457D2BD0),
+    MK_64(0x6776FE65, 0x75D4EB3D),
+    MK_64(0x99FBC70E, 0x997413E9),
+    MK_64(0x9E2CFCCF, 0xE1C41EF7)
     };
 
 /* blkSize =  512 bits. hashSize =  256 bits */
 const u64 SKEIN_512_IV_256[] =
     {
-    MK_64(0xCCD044A1,0x2FDB3E13),
-    MK_64(0xE8359030,0x1A79A9EB),
-    MK_64(0x55AEA061,0x4F816E6F),
-    MK_64(0x2A2767A4,0xAE9B94DB),
-    MK_64(0xEC06025E,0x74DD7683),
-    MK_64(0xE7A436CD,0xC4746251),
-    MK_64(0xC36FBAF9,0x393AD185),
-    MK_64(0x3EEDBA18,0x33EDFC13)
+    MK_64(0xCCD044A1, 0x2FDB3E13),
+    MK_64(0xE8359030, 0x1A79A9EB),
+    MK_64(0x55AEA061, 0x4F816E6F),
+    MK_64(0x2A2767A4, 0xAE9B94DB),
+    MK_64(0xEC06025E, 0x74DD7683),
+    MK_64(0xE7A436CD, 0xC4746251),
+    MK_64(0xC36FBAF9, 0x393AD185),
+    MK_64(0x3EEDBA18, 0x33EDFC13)
     };
 
 /* blkSize =  512 bits. hashSize =  384 bits */
 const u64 SKEIN_512_IV_384[] =
     {
-    MK_64(0xA3F6C6BF,0x3A75EF5F),
-    MK_64(0xB0FEF9CC,0xFD84FAA4),
-    MK_64(0x9D77DD66,0x3D770CFE),
-    MK_64(0xD798CBF3,0xB468FDDA),
-    MK_64(0x1BC4A666,0x8A0E4465),
-    MK_64(0x7ED7D434,0xE5807407),
-    MK_64(0x548FC1AC,0xD4EC44D6),
-    MK_64(0x266E1754,0x6AA18FF8)
+    MK_64(0xA3F6C6BF, 0x3A75EF5F),
+    MK_64(0xB0FEF9CC, 0xFD84FAA4),
+    MK_64(0x9D77DD66, 0x3D770CFE),
+    MK_64(0xD798CBF3, 0xB468FDDA),
+    MK_64(0x1BC4A666, 0x8A0E4465),
+    MK_64(0x7ED7D434, 0xE5807407),
+    MK_64(0x548FC1AC, 0xD4EC44D6),
+    MK_64(0x266E1754, 0x6AA18FF8)
     };
 
 /* blkSize =  512 bits. hashSize =  512 bits */
 const u64 SKEIN_512_IV_512[] =
     {
-    MK_64(0x4903ADFF,0x749C51CE),
-    MK_64(0x0D95DE39,0x9746DF03),
-    MK_64(0x8FD19341,0x27C79BCE),
-    MK_64(0x9A255629,0xFF352CB1),
-    MK_64(0x5DB62599,0xDF6CA7B0),
-    MK_64(0xEABE394C,0xA9D5C3F4),
-    MK_64(0x991112C7,0x1A75B523),
-    MK_64(0xAE18A40B,0x660FCC33)
+    MK_64(0x4903ADFF, 0x749C51CE),
+    MK_64(0x0D95DE39, 0x9746DF03),
+    MK_64(0x8FD19341, 0x27C79BCE),
+    MK_64(0x9A255629, 0xFF352CB1),
+    MK_64(0x5DB62599, 0xDF6CA7B0),
+    MK_64(0xEABE394C, 0xA9D5C3F4),
+    MK_64(0x991112C7, 0x1A75B523),
+    MK_64(0xAE18A40B, 0x660FCC33)
     };
 
 /* blkSize = 1024 bits. hashSize =  384 bits */
 const u64 SKEIN1024_IV_384[] =
     {
-    MK_64(0x5102B6B8,0xC1894A35),
-    MK_64(0xFEEBC9E3,0xFE8AF11A),
-    MK_64(0x0C807F06,0xE32BED71),
-    MK_64(0x60C13A52,0xB41A91F6),
-    MK_64(0x9716D35D,0xD4917C38),
-    MK_64(0xE780DF12,0x6FD31D3A),
-    MK_64(0x797846B6,0xC898303A),
-    MK_64(0xB172C2A8,0xB3572A3B),
-    MK_64(0xC9BC8203,0xA6104A6C),
-    MK_64(0x65909338,0xD75624F4),
-    MK_64(0x94BCC568,0x4B3F81A0),
-    MK_64(0x3EBBF51E,0x10ECFD46),
-    MK_64(0x2DF50F0B,0xEEB08542),
-    MK_64(0x3B5A6530,0x0DBC6516),
-    MK_64(0x484B9CD2,0x167BBCE1),
-    MK_64(0x2D136947,0xD4CBAFEA)
+    MK_64(0x5102B6B8, 0xC1894A35),
+    MK_64(0xFEEBC9E3, 0xFE8AF11A),
+    MK_64(0x0C807F06, 0xE32BED71),
+    MK_64(0x60C13A52, 0xB41A91F6),
+    MK_64(0x9716D35D, 0xD4917C38),
+    MK_64(0xE780DF12, 0x6FD31D3A),
+    MK_64(0x797846B6, 0xC898303A),
+    MK_64(0xB172C2A8, 0xB3572A3B),
+    MK_64(0xC9BC8203, 0xA6104A6C),
+    MK_64(0x65909338, 0xD75624F4),
+    MK_64(0x94BCC568, 0x4B3F81A0),
+    MK_64(0x3EBBF51E, 0x10ECFD46),
+    MK_64(0x2DF50F0B, 0xEEB08542),
+    MK_64(0x3B5A6530, 0x0DBC6516),
+    MK_64(0x484B9CD2, 0x167BBCE1),
+    MK_64(0x2D136947, 0xD4CBAFEA)
     };
 
 /* blkSize = 1024 bits. hashSize =  512 bits */
 const u64 SKEIN1024_IV_512[] =
     {
-    MK_64(0xCAEC0E5D,0x7C1B1B18),
-    MK_64(0xA01B0E04,0x5F03E802),
-    MK_64(0x33840451,0xED912885),
-    MK_64(0x374AFB04,0xEAEC2E1C),
-    MK_64(0xDF25A0E2,0x813581F7),
-    MK_64(0xE4004093,0x8B12F9D2),
-    MK_64(0xA662D539,0xC2ED39B6),
-    MK_64(0xFA8B85CF,0x45D8C75A),
-    MK_64(0x8316ED8E,0x29EDE796),
-    MK_64(0x053289C0,0x2E9F91B8),
-    MK_64(0xC3F8EF1D,0x6D518B73),
-    MK_64(0xBDCEC3C4,0xD5EF332E),
-    MK_64(0x549A7E52,0x22974487),
-    MK_64(0x67070872,0x5B749816),
-    MK_64(0xB9CD28FB,0xF0581BD1),
-    MK_64(0x0E2940B8,0x15804974)
+    MK_64(0xCAEC0E5D, 0x7C1B1B18),
+    MK_64(0xA01B0E04, 0x5F03E802),
+    MK_64(0x33840451, 0xED912885),
+    MK_64(0x374AFB04, 0xEAEC2E1C),
+    MK_64(0xDF25A0E2, 0x813581F7),
+    MK_64(0xE4004093, 0x8B12F9D2),
+    MK_64(0xA662D539, 0xC2ED39B6),
+    MK_64(0xFA8B85CF, 0x45D8C75A),
+    MK_64(0x8316ED8E, 0x29EDE796),
+    MK_64(0x053289C0, 0x2E9F91B8),
+    MK_64(0xC3F8EF1D, 0x6D518B73),
+    MK_64(0xBDCEC3C4, 0xD5EF332E),
+    MK_64(0x549A7E52, 0x22974487),
+    MK_64(0x67070872, 0x5B749816),
+    MK_64(0xB9CD28FB, 0xF0581BD1),
+    MK_64(0x0E2940B8, 0x15804974)
     };
 
 /* blkSize = 1024 bits. hashSize = 1024 bits */
 const u64 SKEIN1024_IV_1024[] =
     {
-    MK_64(0xD593DA07,0x41E72355),
-    MK_64(0x15B5E511,0xAC73E00C),
-    MK_64(0x5180E5AE,0xBAF2C4F0),
-    MK_64(0x03BD41D3,0xFCBCAFAF),
-    MK_64(0x1CAEC6FD,0x1983A898),
-    MK_64(0x6E510B8B,0xCDD0589F),
-    MK_64(0x77E2BDFD,0xC6394ADA),
-    MK_64(0xC11E1DB5,0x24DCB0A3),
-    MK_64(0xD6D14AF9,0xC6329AB5),
-    MK_64(0x6A9B0BFC,0x6EB67E0D),
-    MK_64(0x9243C60D,0xCCFF1332),
-    MK_64(0x1A1F1DDE,0x743F02D4),
-    MK_64(0x0996753C,0x10ED0BB8),
-    MK_64(0x6572DD22,0xF2B4969A),
-    MK_64(0x61FD3062,0xD00A579A),
-    MK_64(0x1DE0536E,0x8682E539)
+    MK_64(0xD593DA07, 0x41E72355),
+    MK_64(0x15B5E511, 0xAC73E00C),
+    MK_64(0x5180E5AE, 0xBAF2C4F0),
+    MK_64(0x03BD41D3, 0xFCBCAFAF),
+    MK_64(0x1CAEC6FD, 0x1983A898),
+    MK_64(0x6E510B8B, 0xCDD0589F),
+    MK_64(0x77E2BDFD, 0xC6394ADA),
+    MK_64(0xC11E1DB5, 0x24DCB0A3),
+    MK_64(0xD6D14AF9, 0xC6329AB5),
+    MK_64(0x6A9B0BFC, 0x6EB67E0D),
+    MK_64(0x9243C60D, 0xCCFF1332),
+    MK_64(0x1A1F1DDE, 0x743F02D4),
+    MK_64(0x0996753C, 0x10ED0BB8),
+    MK_64(0x6572DD22, 0xF2B4969A),
+    MK_64(0x61FD3062, 0xD00A579A),
+    MK_64(0x1DE0536E, 0x8682E539)
     };
 
 #endif /* _SKEIN_IV_H_ */
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 2bed7c163316..0ea0a6aeb168 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -16,9 +16,9 @@
 
 /*****************************************************************/
 /* External function to process blkCnt (nonzero) full block(s) of data. */
-void    Skein_256_Process_Block(struct skein_256_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
-void    Skein_512_Process_Block(struct skein_512_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
-void    Skein1024_Process_Block(struct skein1024_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
+void    Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd);
+void    Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd);
+void    Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd);
 
 /*****************************************************************/
 /*     256-bit Skein                                             */
@@ -34,41 +34,41 @@ int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
         u64  w[SKEIN_256_STATE_WORDS];
     } cfg;                              /* config block */
 
-    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
+    Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
     ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
 
     switch (hashBitLen)
     {             /* use pre-computed values, where available */
     case  256:
-        memcpy(ctx->X,SKEIN_256_IV_256,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN_256_IV_256, sizeof(ctx->X));
         break;
     case  224:
-        memcpy(ctx->X,SKEIN_256_IV_224,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN_256_IV_224, sizeof(ctx->X));
         break;
     case  160:
-        memcpy(ctx->X,SKEIN_256_IV_160,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN_256_IV_160, sizeof(ctx->X));
         break;
     case  128:
-        memcpy(ctx->X,SKEIN_256_IV_128,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN_256_IV_128, sizeof(ctx->X));
         break;
     default:
         /* here if there is no precomputed IV value available */
         /* build/process the config block, type == CONFIG (could be precomputed) */
-        Skein_Start_New_Type(ctx,CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
+        Skein_Start_New_Type(ctx, CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
 
         cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);  /* set the schema, version */
         cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
         cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
-        memset(&cfg.w[3],0,sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
+        memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
 
         /* compute the initial chaining values from config block */
-        memset(ctx->X,0,sizeof(ctx->X));            /* zero the chaining variables */
-        Skein_256_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+        memset(ctx->X, 0, sizeof(ctx->X));            /* zero the chaining variables */
+        Skein_256_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
         break;
     }
     /* The chaining vars ctx->X are now initialized for the given hashBitLen. */
     /* Set up to process the data message portion of the hash (default) */
-    Skein_Start_New_Type(ctx,MSG);              /* T0=0, T1= MSG type */
+    Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
 
     return SKEIN_SUCCESS;
 }
@@ -76,7 +76,7 @@ int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to Skein_256_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_256_InitExt(struct skein_256_ctx *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
+int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes)
 {
     union
     {
@@ -84,42 +84,42 @@ int Skein_256_InitExt(struct skein_256_ctx *ctx,size_t hashBitLen,u64 treeInfo,
         u64  w[SKEIN_256_STATE_WORDS];
     } cfg;                              /* config block */
 
-    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
-    Skein_Assert(keyBytes == 0 || key != NULL,SKEIN_FAIL);
+    Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
+    Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
 
     /* compute the initial chaining values ctx->X[], based on key */
     if (keyBytes == 0)                          /* is there a key? */
     {
-        memset(ctx->X,0,sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
+        memset(ctx->X, 0, sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
     }
     else                                        /* here to pre-process a key */
     {
         Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
         /* do a mini-Init right here */
-        ctx->h.hashBitLen=8*sizeof(ctx->X);     /* set output hash bit count = state size */
-        Skein_Start_New_Type(ctx,KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
-        memset(ctx->X,0,sizeof(ctx->X));        /* zero the initial chaining variables */
-        Skein_256_Update(ctx,key,keyBytes);     /* hash the key */
-        Skein_256_Final_Pad(ctx,cfg.b);         /* put result into cfg.b[] */
-        memcpy(ctx->X,cfg.b,sizeof(cfg.b));     /* copy over into ctx->X[] */
+        ctx->h.hashBitLen = 8*sizeof(ctx->X);     /* set output hash bit count = state size */
+        Skein_Start_New_Type(ctx, KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
+        memset(ctx->X, 0, sizeof(ctx->X));        /* zero the initial chaining variables */
+        Skein_256_Update(ctx, key, keyBytes);     /* hash the key */
+        Skein_256_Final_Pad(ctx, cfg.b);         /* put result into cfg.b[] */
+        memcpy(ctx->X, cfg.b, sizeof(cfg.b));     /* copy over into ctx->X[] */
     }
     /* build/process the config block, type == CONFIG (could be precomputed for each key) */
     ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
-    Skein_Start_New_Type(ctx,CFG_FINAL);
+    Skein_Start_New_Type(ctx, CFG_FINAL);
 
-    memset(&cfg.w,0,sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
+    memset(&cfg.w, 0, sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
     cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
     cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
     cfg.w[2] = Skein_Swap64(treeInfo);          /* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
 
-    Skein_Show_Key(256,&ctx->h,key,keyBytes);
+    Skein_Show_Key(256, &ctx->h, key, keyBytes);
 
     /* compute the initial chaining values from config block */
-    Skein_256_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+    Skein_256_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
     /* The chaining vars ctx->X are now initialized */
     /* Set up to process the data message portion of the hash (default) */
-    Skein_Start_New_Type(ctx,MSG);
+    Skein_Start_New_Type(ctx, MSG);
 
     return SKEIN_SUCCESS;
 }
@@ -130,7 +130,7 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCnt
 {
     size_t n;
 
-    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     /* process full blocks, if any */
     if (msgByteCnt + ctx->h.bCnt > SKEIN_256_BLOCK_BYTES)
@@ -141,20 +141,20 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCnt
             if (n)
             {
                 Skein_assert(n < msgByteCnt);         /* check on our logic here */
-                memcpy(&ctx->b[ctx->h.bCnt],msg,n);
+                memcpy(&ctx->b[ctx->h.bCnt], msg, n);
                 msgByteCnt  -= n;
                 msg         += n;
                 ctx->h.bCnt += n;
             }
             Skein_assert(ctx->h.bCnt == SKEIN_256_BLOCK_BYTES);
-            Skein_256_Process_Block(ctx,ctx->b,1,SKEIN_256_BLOCK_BYTES);
+            Skein_256_Process_Block(ctx, ctx->b, 1, SKEIN_256_BLOCK_BYTES);
             ctx->h.bCnt = 0;
         }
         /* now process any remaining full blocks, directly from input message data */
         if (msgByteCnt > SKEIN_256_BLOCK_BYTES)
         {
             n = (msgByteCnt-1) / SKEIN_256_BLOCK_BYTES;   /* number of full blocks to process */
-            Skein_256_Process_Block(ctx,msg,n,SKEIN_256_BLOCK_BYTES);
+            Skein_256_Process_Block(ctx, msg, n, SKEIN_256_BLOCK_BYTES);
             msgByteCnt -= n * SKEIN_256_BLOCK_BYTES;
             msg        += n * SKEIN_256_BLOCK_BYTES;
         }
@@ -165,7 +165,7 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCnt
     if (msgByteCnt)
     {
         Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES);
-        memcpy(&ctx->b[ctx->h.bCnt],msg,msgByteCnt);
+        memcpy(&ctx->b[ctx->h.bCnt], msg, msgByteCnt);
         ctx->h.bCnt += msgByteCnt;
     }
 
@@ -176,33 +176,33 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCnt
 /* finalize the hash computation and output the result */
 int Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal)
 {
-    size_t i,n,byteCnt;
+    size_t i, n, byteCnt;
     u64 X[SKEIN_256_STATE_WORDS];
-    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
     if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)            /* zero pad b[] if necessary */
-        memset(&ctx->b[ctx->h.bCnt],0,SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
+        memset(&ctx->b[ctx->h.bCnt], 0, SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
 
-    Skein_256_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);  /* process the final block */
+    Skein_256_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);  /* process the final block */
 
     /* now output the result */
     byteCnt = (ctx->h.hashBitLen + 7) >> 3;             /* total number of output bytes */
 
     /* run Threefish in "counter mode" to generate output */
-    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
-    for (i=0;i*SKEIN_256_BLOCK_BYTES < byteCnt;i++)
+    memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++)
     {
-        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
-        Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein_256_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
+        ((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+        Skein_Start_New_Type(ctx, OUT_FINAL);
+        Skein_256_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN_256_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN_256_BLOCK_BYTES)
             n  = SKEIN_256_BLOCK_BYTES;
-        Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
-        Skein_Show_Final(256,&ctx->h,n,hashVal+i*SKEIN_256_BLOCK_BYTES);
-        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+        Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(256, &ctx->h, n, hashVal+i*SKEIN_256_BLOCK_BYTES);
+        memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
     }
     return SKEIN_SUCCESS;
 }
@@ -221,42 +221,42 @@ int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
         u64  w[SKEIN_512_STATE_WORDS];
     } cfg;                              /* config block */
 
-    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
+    Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
     ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
 
     switch (hashBitLen)
     {             /* use pre-computed values, where available */
     case  512:
-        memcpy(ctx->X,SKEIN_512_IV_512,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN_512_IV_512, sizeof(ctx->X));
         break;
     case  384:
-        memcpy(ctx->X,SKEIN_512_IV_384,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN_512_IV_384, sizeof(ctx->X));
         break;
     case  256:
-        memcpy(ctx->X,SKEIN_512_IV_256,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN_512_IV_256, sizeof(ctx->X));
         break;
     case  224:
-        memcpy(ctx->X,SKEIN_512_IV_224,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN_512_IV_224, sizeof(ctx->X));
         break;
     default:
         /* here if there is no precomputed IV value available */
         /* build/process the config block, type == CONFIG (could be precomputed) */
-        Skein_Start_New_Type(ctx,CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
+        Skein_Start_New_Type(ctx, CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
 
         cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);  /* set the schema, version */
         cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
         cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
-        memset(&cfg.w[3],0,sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
+        memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
 
         /* compute the initial chaining values from config block */
-        memset(ctx->X,0,sizeof(ctx->X));            /* zero the chaining variables */
-        Skein_512_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+        memset(ctx->X, 0, sizeof(ctx->X));            /* zero the chaining variables */
+        Skein_512_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
         break;
     }
 
     /* The chaining vars ctx->X are now initialized for the given hashBitLen. */
     /* Set up to process the data message portion of the hash (default) */
-    Skein_Start_New_Type(ctx,MSG);              /* T0=0, T1= MSG type */
+    Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
 
     return SKEIN_SUCCESS;
 }
@@ -264,7 +264,7 @@ int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to Skein_512_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_512_InitExt(struct skein_512_ctx *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
+int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes)
 {
     union
     {
@@ -272,42 +272,42 @@ int Skein_512_InitExt(struct skein_512_ctx *ctx,size_t hashBitLen,u64 treeInfo,
         u64  w[SKEIN_512_STATE_WORDS];
     } cfg;                              /* config block */
 
-    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
-    Skein_Assert(keyBytes == 0 || key != NULL,SKEIN_FAIL);
+    Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
+    Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
 
     /* compute the initial chaining values ctx->X[], based on key */
     if (keyBytes == 0)                          /* is there a key? */
     {
-        memset(ctx->X,0,sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
+        memset(ctx->X, 0, sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
     }
     else                                        /* here to pre-process a key */
     {
         Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
         /* do a mini-Init right here */
-        ctx->h.hashBitLen=8*sizeof(ctx->X);     /* set output hash bit count = state size */
-        Skein_Start_New_Type(ctx,KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
-        memset(ctx->X,0,sizeof(ctx->X));        /* zero the initial chaining variables */
-        Skein_512_Update(ctx,key,keyBytes);     /* hash the key */
-        Skein_512_Final_Pad(ctx,cfg.b);         /* put result into cfg.b[] */
-        memcpy(ctx->X,cfg.b,sizeof(cfg.b));     /* copy over into ctx->X[] */
+        ctx->h.hashBitLen = 8*sizeof(ctx->X);     /* set output hash bit count = state size */
+        Skein_Start_New_Type(ctx, KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
+        memset(ctx->X, 0, sizeof(ctx->X));        /* zero the initial chaining variables */
+        Skein_512_Update(ctx, key, keyBytes);     /* hash the key */
+        Skein_512_Final_Pad(ctx, cfg.b);         /* put result into cfg.b[] */
+        memcpy(ctx->X, cfg.b, sizeof(cfg.b));     /* copy over into ctx->X[] */
     }
     /* build/process the config block, type == CONFIG (could be precomputed for each key) */
     ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
-    Skein_Start_New_Type(ctx,CFG_FINAL);
+    Skein_Start_New_Type(ctx, CFG_FINAL);
 
-    memset(&cfg.w,0,sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
+    memset(&cfg.w, 0, sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
     cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
     cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
     cfg.w[2] = Skein_Swap64(treeInfo);          /* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
 
-    Skein_Show_Key(512,&ctx->h,key,keyBytes);
+    Skein_Show_Key(512, &ctx->h, key, keyBytes);
 
     /* compute the initial chaining values from config block */
-    Skein_512_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+    Skein_512_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
     /* The chaining vars ctx->X are now initialized */
     /* Set up to process the data message portion of the hash (default) */
-    Skein_Start_New_Type(ctx,MSG);
+    Skein_Start_New_Type(ctx, MSG);
 
     return SKEIN_SUCCESS;
 }
@@ -318,7 +318,7 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt
 {
     size_t n;
 
-    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     /* process full blocks, if any */
     if (msgByteCnt + ctx->h.bCnt > SKEIN_512_BLOCK_BYTES)
@@ -329,20 +329,20 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt
             if (n)
             {
                 Skein_assert(n < msgByteCnt);         /* check on our logic here */
-                memcpy(&ctx->b[ctx->h.bCnt],msg,n);
+                memcpy(&ctx->b[ctx->h.bCnt], msg, n);
                 msgByteCnt  -= n;
                 msg         += n;
                 ctx->h.bCnt += n;
             }
             Skein_assert(ctx->h.bCnt == SKEIN_512_BLOCK_BYTES);
-            Skein_512_Process_Block(ctx,ctx->b,1,SKEIN_512_BLOCK_BYTES);
+            Skein_512_Process_Block(ctx, ctx->b, 1, SKEIN_512_BLOCK_BYTES);
             ctx->h.bCnt = 0;
         }
         /* now process any remaining full blocks, directly from input message data */
         if (msgByteCnt > SKEIN_512_BLOCK_BYTES)
         {
             n = (msgByteCnt-1) / SKEIN_512_BLOCK_BYTES;   /* number of full blocks to process */
-            Skein_512_Process_Block(ctx,msg,n,SKEIN_512_BLOCK_BYTES);
+            Skein_512_Process_Block(ctx, msg, n, SKEIN_512_BLOCK_BYTES);
             msgByteCnt -= n * SKEIN_512_BLOCK_BYTES;
             msg        += n * SKEIN_512_BLOCK_BYTES;
         }
@@ -353,7 +353,7 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt
     if (msgByteCnt)
     {
         Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES);
-        memcpy(&ctx->b[ctx->h.bCnt],msg,msgByteCnt);
+        memcpy(&ctx->b[ctx->h.bCnt], msg, msgByteCnt);
         ctx->h.bCnt += msgByteCnt;
     }
 
@@ -364,33 +364,33 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt
 /* finalize the hash computation and output the result */
 int Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal)
 {
-    size_t i,n,byteCnt;
+    size_t i, n, byteCnt;
     u64 X[SKEIN_512_STATE_WORDS];
-    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
     if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)            /* zero pad b[] if necessary */
-        memset(&ctx->b[ctx->h.bCnt],0,SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
+        memset(&ctx->b[ctx->h.bCnt], 0, SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
 
-    Skein_512_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);  /* process the final block */
+    Skein_512_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);  /* process the final block */
 
     /* now output the result */
     byteCnt = (ctx->h.hashBitLen + 7) >> 3;             /* total number of output bytes */
 
     /* run Threefish in "counter mode" to generate output */
-    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
-    for (i=0;i*SKEIN_512_BLOCK_BYTES < byteCnt;i++)
+    memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++)
     {
-        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
-        Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein_512_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
+        ((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+        Skein_Start_New_Type(ctx, OUT_FINAL);
+        Skein_512_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN_512_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN_512_BLOCK_BYTES)
             n  = SKEIN_512_BLOCK_BYTES;
-        Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
-        Skein_Show_Final(512,&ctx->h,n,hashVal+i*SKEIN_512_BLOCK_BYTES);
-        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+        Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(512, &ctx->h, n, hashVal+i*SKEIN_512_BLOCK_BYTES);
+        memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
     }
     return SKEIN_SUCCESS;
 }
@@ -409,39 +409,39 @@ int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
         u64  w[SKEIN1024_STATE_WORDS];
     } cfg;                              /* config block */
 
-    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
+    Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
     ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
 
     switch (hashBitLen)
     {              /* use pre-computed values, where available */
     case  512:
-        memcpy(ctx->X,SKEIN1024_IV_512 ,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN1024_IV_512, sizeof(ctx->X));
         break;
     case  384:
-        memcpy(ctx->X,SKEIN1024_IV_384 ,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN1024_IV_384, sizeof(ctx->X));
         break;
     case 1024:
-        memcpy(ctx->X,SKEIN1024_IV_1024,sizeof(ctx->X));
+        memcpy(ctx->X, SKEIN1024_IV_1024, sizeof(ctx->X));
         break;
     default:
         /* here if there is no precomputed IV value available */
         /* build/process the config block, type == CONFIG (could be precomputed) */
-        Skein_Start_New_Type(ctx,CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
+        Skein_Start_New_Type(ctx, CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
 
         cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);  /* set the schema, version */
         cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
         cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
-        memset(&cfg.w[3],0,sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
+        memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
 
         /* compute the initial chaining values from config block */
-        memset(ctx->X,0,sizeof(ctx->X));            /* zero the chaining variables */
-        Skein1024_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+        memset(ctx->X, 0, sizeof(ctx->X));            /* zero the chaining variables */
+        Skein1024_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
         break;
     }
 
     /* The chaining vars ctx->X are now initialized for the given hashBitLen. */
     /* Set up to process the data message portion of the hash (default) */
-    Skein_Start_New_Type(ctx,MSG);              /* T0=0, T1= MSG type */
+    Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
 
     return SKEIN_SUCCESS;
 }
@@ -449,7 +449,7 @@ int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to Skein1024_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein1024_InitExt(struct skein1024_ctx *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
+int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes)
 {
     union
     {
@@ -457,42 +457,42 @@ int Skein1024_InitExt(struct skein1024_ctx *ctx,size_t hashBitLen,u64 treeInfo,
         u64  w[SKEIN1024_STATE_WORDS];
     } cfg;                              /* config block */
 
-    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
-    Skein_Assert(keyBytes == 0 || key != NULL,SKEIN_FAIL);
+    Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
+    Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
 
     /* compute the initial chaining values ctx->X[], based on key */
     if (keyBytes == 0)                          /* is there a key? */
     {
-        memset(ctx->X,0,sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
+        memset(ctx->X, 0, sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
     }
     else                                        /* here to pre-process a key */
     {
         Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
         /* do a mini-Init right here */
-        ctx->h.hashBitLen=8*sizeof(ctx->X);     /* set output hash bit count = state size */
-        Skein_Start_New_Type(ctx,KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
-        memset(ctx->X,0,sizeof(ctx->X));        /* zero the initial chaining variables */
-        Skein1024_Update(ctx,key,keyBytes);     /* hash the key */
-        Skein1024_Final_Pad(ctx,cfg.b);         /* put result into cfg.b[] */
-        memcpy(ctx->X,cfg.b,sizeof(cfg.b));     /* copy over into ctx->X[] */
+        ctx->h.hashBitLen = 8*sizeof(ctx->X);     /* set output hash bit count = state size */
+        Skein_Start_New_Type(ctx, KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
+        memset(ctx->X, 0, sizeof(ctx->X));        /* zero the initial chaining variables */
+        Skein1024_Update(ctx, key, keyBytes);     /* hash the key */
+        Skein1024_Final_Pad(ctx, cfg.b);         /* put result into cfg.b[] */
+        memcpy(ctx->X, cfg.b, sizeof(cfg.b));     /* copy over into ctx->X[] */
     }
     /* build/process the config block, type == CONFIG (could be precomputed for each key) */
     ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
-    Skein_Start_New_Type(ctx,CFG_FINAL);
+    Skein_Start_New_Type(ctx, CFG_FINAL);
 
-    memset(&cfg.w,0,sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
+    memset(&cfg.w, 0, sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
     cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
     cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
     cfg.w[2] = Skein_Swap64(treeInfo);          /* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
 
-    Skein_Show_Key(1024,&ctx->h,key,keyBytes);
+    Skein_Show_Key(1024, &ctx->h, key, keyBytes);
 
     /* compute the initial chaining values from config block */
-    Skein1024_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+    Skein1024_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
     /* The chaining vars ctx->X are now initialized */
     /* Set up to process the data message portion of the hash (default) */
-    Skein_Start_New_Type(ctx,MSG);
+    Skein_Start_New_Type(ctx, MSG);
 
     return SKEIN_SUCCESS;
 }
@@ -503,7 +503,7 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt
 {
     size_t n;
 
-    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     /* process full blocks, if any */
     if (msgByteCnt + ctx->h.bCnt > SKEIN1024_BLOCK_BYTES)
@@ -514,20 +514,20 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt
             if (n)
             {
                 Skein_assert(n < msgByteCnt);         /* check on our logic here */
-                memcpy(&ctx->b[ctx->h.bCnt],msg,n);
+                memcpy(&ctx->b[ctx->h.bCnt], msg, n);
                 msgByteCnt  -= n;
                 msg         += n;
                 ctx->h.bCnt += n;
             }
             Skein_assert(ctx->h.bCnt == SKEIN1024_BLOCK_BYTES);
-            Skein1024_Process_Block(ctx,ctx->b,1,SKEIN1024_BLOCK_BYTES);
+            Skein1024_Process_Block(ctx, ctx->b, 1, SKEIN1024_BLOCK_BYTES);
             ctx->h.bCnt = 0;
         }
         /* now process any remaining full blocks, directly from input message data */
         if (msgByteCnt > SKEIN1024_BLOCK_BYTES)
         {
             n = (msgByteCnt-1) / SKEIN1024_BLOCK_BYTES;   /* number of full blocks to process */
-            Skein1024_Process_Block(ctx,msg,n,SKEIN1024_BLOCK_BYTES);
+            Skein1024_Process_Block(ctx, msg, n, SKEIN1024_BLOCK_BYTES);
             msgByteCnt -= n * SKEIN1024_BLOCK_BYTES;
             msg        += n * SKEIN1024_BLOCK_BYTES;
         }
@@ -538,7 +538,7 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt
     if (msgByteCnt)
     {
         Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES);
-        memcpy(&ctx->b[ctx->h.bCnt],msg,msgByteCnt);
+        memcpy(&ctx->b[ctx->h.bCnt], msg, msgByteCnt);
         ctx->h.bCnt += msgByteCnt;
     }
 
@@ -549,33 +549,33 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt
 /* finalize the hash computation and output the result */
 int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
 {
-    size_t i,n,byteCnt;
+    size_t i, n, byteCnt;
     u64 X[SKEIN1024_STATE_WORDS];
-    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
     if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)            /* zero pad b[] if necessary */
-        memset(&ctx->b[ctx->h.bCnt],0,SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
+        memset(&ctx->b[ctx->h.bCnt], 0, SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
 
-    Skein1024_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);  /* process the final block */
+    Skein1024_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);  /* process the final block */
 
     /* now output the result */
     byteCnt = (ctx->h.hashBitLen + 7) >> 3;             /* total number of output bytes */
 
     /* run Threefish in "counter mode" to generate output */
-    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
-    for (i=0;i*SKEIN1024_BLOCK_BYTES < byteCnt;i++)
+    memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++)
     {
-        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
-        Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein1024_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
+        ((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+        Skein_Start_New_Type(ctx, OUT_FINAL);
+        Skein1024_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN1024_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN1024_BLOCK_BYTES)
             n  = SKEIN1024_BLOCK_BYTES;
-        Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
-        Skein_Show_Final(1024,&ctx->h,n,hashVal+i*SKEIN1024_BLOCK_BYTES);
-        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+        Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(1024, &ctx->h, n, hashVal+i*SKEIN1024_BLOCK_BYTES);
+        memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
     }
     return SKEIN_SUCCESS;
 }
@@ -587,14 +587,14 @@ int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
 /* finalize the hash computation and output the block, no OUTPUT stage */
 int Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal)
 {
-    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;        /* tag as the final block */
     if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)   /* zero pad b[] if necessary */
-        memset(&ctx->b[ctx->h.bCnt],0,SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
-    Skein_256_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);    /* process the final block */
+        memset(&ctx->b[ctx->h.bCnt], 0, SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
+    Skein_256_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);    /* process the final block */
 
-    Skein_Put64_LSB_First(hashVal,ctx->X,SKEIN_256_BLOCK_BYTES);   /* "output" the state bytes */
+    Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_256_BLOCK_BYTES);   /* "output" the state bytes */
 
     return SKEIN_SUCCESS;
 }
@@ -603,14 +603,14 @@ int Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal)
 /* finalize the hash computation and output the block, no OUTPUT stage */
 int Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal)
 {
-    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;        /* tag as the final block */
     if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)   /* zero pad b[] if necessary */
-        memset(&ctx->b[ctx->h.bCnt],0,SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
-    Skein_512_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);    /* process the final block */
+        memset(&ctx->b[ctx->h.bCnt], 0, SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
+    Skein_512_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);    /* process the final block */
 
-    Skein_Put64_LSB_First(hashVal,ctx->X,SKEIN_512_BLOCK_BYTES);   /* "output" the state bytes */
+    Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_512_BLOCK_BYTES);   /* "output" the state bytes */
 
     return SKEIN_SUCCESS;
 }
@@ -619,14 +619,14 @@ int Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal)
 /* finalize the hash computation and output the block, no OUTPUT stage */
 int Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal)
 {
-    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;        /* tag as the final block */
     if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)   /* zero pad b[] if necessary */
-        memset(&ctx->b[ctx->h.bCnt],0,SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
-    Skein1024_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);    /* process the final block */
+        memset(&ctx->b[ctx->h.bCnt], 0, SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
+    Skein1024_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);    /* process the final block */
 
-    Skein_Put64_LSB_First(hashVal,ctx->X,SKEIN1024_BLOCK_BYTES);   /* "output" the state bytes */
+    Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN1024_BLOCK_BYTES);   /* "output" the state bytes */
 
     return SKEIN_SUCCESS;
 }
@@ -636,27 +636,27 @@ int Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal)
 /* just do the OUTPUT stage                                       */
 int Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal)
 {
-    size_t i,n,byteCnt;
+    size_t i, n, byteCnt;
     u64 X[SKEIN_256_STATE_WORDS];
-    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     /* now output the result */
     byteCnt = (ctx->h.hashBitLen + 7) >> 3;    /* total number of output bytes */
 
     /* run Threefish in "counter mode" to generate output */
-    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
-    for (i=0;i*SKEIN_256_BLOCK_BYTES < byteCnt;i++)
+    memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++)
     {
-        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
-        Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein_256_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
+        ((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+        Skein_Start_New_Type(ctx, OUT_FINAL);
+        Skein_256_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN_256_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN_256_BLOCK_BYTES)
             n  = SKEIN_256_BLOCK_BYTES;
-        Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
-        Skein_Show_Final(256,&ctx->h,n,hashVal+i*SKEIN_256_BLOCK_BYTES);
-        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+        Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(256, &ctx->h, n, hashVal+i*SKEIN_256_BLOCK_BYTES);
+        memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
     }
     return SKEIN_SUCCESS;
 }
@@ -665,27 +665,27 @@ int Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal)
 /* just do the OUTPUT stage                                       */
 int Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal)
 {
-    size_t i,n,byteCnt;
+    size_t i, n, byteCnt;
     u64 X[SKEIN_512_STATE_WORDS];
-    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     /* now output the result */
     byteCnt = (ctx->h.hashBitLen + 7) >> 3;    /* total number of output bytes */
 
     /* run Threefish in "counter mode" to generate output */
-    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
-    for (i=0;i*SKEIN_512_BLOCK_BYTES < byteCnt;i++)
+    memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++)
     {
-        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
-        Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein_512_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
+        ((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+        Skein_Start_New_Type(ctx, OUT_FINAL);
+        Skein_512_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN_512_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN_512_BLOCK_BYTES)
             n  = SKEIN_512_BLOCK_BYTES;
-        Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
-        Skein_Show_Final(256,&ctx->h,n,hashVal+i*SKEIN_512_BLOCK_BYTES);
-        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+        Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(256, &ctx->h, n, hashVal+i*SKEIN_512_BLOCK_BYTES);
+        memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
     }
     return SKEIN_SUCCESS;
 }
@@ -694,27 +694,27 @@ int Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal)
 /* just do the OUTPUT stage                                       */
 int Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal)
 {
-    size_t i,n,byteCnt;
+    size_t i, n, byteCnt;
     u64 X[SKEIN1024_STATE_WORDS];
-    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
 
     /* now output the result */
     byteCnt = (ctx->h.hashBitLen + 7) >> 3;    /* total number of output bytes */
 
     /* run Threefish in "counter mode" to generate output */
-    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
-    for (i=0;i*SKEIN1024_BLOCK_BYTES < byteCnt;i++)
+    memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++)
     {
-        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
-        Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein1024_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
+        ((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+        Skein_Start_New_Type(ctx, OUT_FINAL);
+        Skein1024_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN1024_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN1024_BLOCK_BYTES)
             n  = SKEIN1024_BLOCK_BYTES;
-        Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
-        Skein_Show_Final(256,&ctx->h,n,hashVal+i*SKEIN1024_BLOCK_BYTES);
-        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+        Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(256, &ctx->h, n, hashVal+i*SKEIN1024_BLOCK_BYTES);
+        memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
     }
     return SKEIN_SUCCESS;
 }
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index df92806c4ec4..a3f471be8db3 100755
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -31,7 +31,7 @@ int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size)
 {
     Skein_Assert(ctx && size, SKEIN_FAIL);
 
-    memset(ctx ,0, sizeof(struct skein_ctx));
+    memset(ctx , 0, sizeof(struct skein_ctx));
     ctx->skeinSize = size;
 
     return SKEIN_SUCCESS;
@@ -97,18 +97,18 @@ int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
     case Skein256:
         ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
                                 treeInfo,
-                                (const u8*)key, keyLen);
+                                (const u8 *)key, keyLen);
 
         break;
     case Skein512:
         ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
                                 treeInfo,
-                                (const u8*)key, keyLen);
+                                (const u8 *)key, keyLen);
         break;
     case Skein1024:
         ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
                                 treeInfo,
-                                (const u8*)key, keyLen);
+                                (const u8 *)key, keyLen);
 
         break;
     }
@@ -146,13 +146,13 @@ int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
 
     switch (ctx->skeinSize) {
     case Skein256:
-        ret = Skein_256_Update(&ctx->m.s256, (const u8*)msg, msgByteCnt);
+        ret = Skein_256_Update(&ctx->m.s256, (const u8 *)msg, msgByteCnt);
         break;
     case Skein512:
-        ret = Skein_512_Update(&ctx->m.s512, (const u8*)msg, msgByteCnt);
+        ret = Skein_512_Update(&ctx->m.s512, (const u8 *)msg, msgByteCnt);
         break;
     case Skein1024:
-        ret = Skein1024_Update(&ctx->m.s1024, (const u8*)msg, msgByteCnt);
+        ret = Skein1024_Update(&ctx->m.s1024, (const u8 *)msg, msgByteCnt);
         break;
     }
     return ret;
@@ -186,7 +186,7 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
      * Skein's real partial block buffer.
      * If this layout ever changes we have to adapt this as well.
      */
-    up = (u8*)ctx->m.s256.X + ctx->skeinSize / 8;
+    up = (u8 *)ctx->m.s256.X + ctx->skeinSize / 8;
 
     Skein_Set_Bit_Pad_Flag(ctx->m.h);                       /* set tweak flag for the skeinFinal call */
 
@@ -206,13 +206,13 @@ int skeinFinal(struct skein_ctx *ctx, u8 *hash)
 
     switch (ctx->skeinSize) {
     case Skein256:
-        ret = Skein_256_Final(&ctx->m.s256, (u8*)hash);
+        ret = Skein_256_Final(&ctx->m.s256, (u8 *)hash);
         break;
     case Skein512:
-        ret = Skein_512_Final(&ctx->m.s512, (u8*)hash);
+        ret = Skein_512_Final(&ctx->m.s512, (u8 *)hash);
         break;
     case Skein1024:
-        ret = Skein1024_Final(&ctx->m.s1024, (u8*)hash);
+        ret = Skein1024_Final(&ctx->m.s1024, (u8 *)hash);
         break;
     }
     return ret;
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 02e68dbab0d4..a4b1ec56ad83 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -147,16 +147,16 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
         blkPtr += SKEIN1024_BLOCK_BYTES;
 
         /* do the final "feedforward" xor, update context chaining vars */
-        ctx->X[ 0] = ctx->X[ 0] ^ w[ 0];
-        ctx->X[ 1] = ctx->X[ 1] ^ w[ 1];
-        ctx->X[ 2] = ctx->X[ 2] ^ w[ 2];
-        ctx->X[ 3] = ctx->X[ 3] ^ w[ 3];
-        ctx->X[ 4] = ctx->X[ 4] ^ w[ 4];
-        ctx->X[ 5] = ctx->X[ 5] ^ w[ 5];
-        ctx->X[ 6] = ctx->X[ 6] ^ w[ 6];
-        ctx->X[ 7] = ctx->X[ 7] ^ w[ 7];
-        ctx->X[ 8] = ctx->X[ 8] ^ w[ 8];
-        ctx->X[ 9] = ctx->X[ 9] ^ w[ 9];
+        ctx->X[0]  = ctx->X[0]  ^ w[0];
+        ctx->X[1]  = ctx->X[1]  ^ w[1];
+        ctx->X[2]  = ctx->X[2]  ^ w[2];
+        ctx->X[3]  = ctx->X[3]  ^ w[3];
+        ctx->X[4]  = ctx->X[4]  ^ w[4];
+        ctx->X[5]  = ctx->X[5]  ^ w[5];
+        ctx->X[6]  = ctx->X[6]  ^ w[6];
+        ctx->X[7]  = ctx->X[7]  ^ w[7];
+        ctx->X[8]  = ctx->X[8]  ^ w[8];
+        ctx->X[9]  = ctx->X[9]  ^ w[9];
         ctx->X[10] = ctx->X[10] ^ w[10];
         ctx->X[11] = ctx->X[11] ^ w[11];
         ctx->X[12] = ctx->X[12] ^ w[12];
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 179bde121380..791bacdd3d57 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -39,16 +39,15 @@
 
 /*****************************  Skein_256 ******************************/
 #if !(SKEIN_USE_ASM & 256)
-void Skein_256_Process_Block(struct skein_256_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
+void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd)
     { /* do it in C */
-    enum
-        {
+    enum {
         WCNT = SKEIN_256_STATE_WORDS
         };
 #undef  RCNT
 #define RCNT  (SKEIN_256_ROUNDS_TOTAL/8)
 
-#ifdef  SKEIN_LOOP                              /* configure how much to unroll the loop */
+#ifdef SKEIN_LOOP                              /* configure how much to unroll the loop */
 #define SKEIN_UNROLL_256 (((SKEIN_LOOP)/100)%10)
 #else
 #define SKEIN_UNROLL_256 (0)
@@ -63,8 +62,8 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx,const u8 *blkPtr,size_t b
 #else
     u64  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
 #endif
-    u64  X0,X1,X2,X3;                        /* local copy of context vars, for speed */
-    u64  w [WCNT];                           /* local copy of input block */
+    u64  X0, X1, X2, X3;                        /* local copy of context vars, for speed */
+    u64  w[WCNT];                           /* local copy of input block */
 #ifdef SKEIN_DEBUG
     const u64 *Xptr[4];                      /* use for debugging (help compiler put Xn in registers) */
     Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
@@ -85,95 +84,95 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx,const u8 *blkPtr,size_t b
 
         ts[2] = ts[0] ^ ts[1];
 
-        Skein_Get64_LSB_First(w,blkPtr,WCNT);   /* get input block in little-endian format */
+        Skein_Get64_LSB_First(w, blkPtr, WCNT);   /* get input block in little-endian format */
         DebugSaveTweak(ctx);
-        Skein_Show_Block(BLK_BITS,&ctx->h,ctx->X,blkPtr,w,ks,ts);
+        Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blkPtr, w, ks, ts);
 
         X0 = w[0] + ks[0];                      /* do the first full key injection */
         X1 = w[1] + ks[1] + ts[0];
         X2 = w[2] + ks[2] + ts[1];
         X3 = w[3] + ks[3];
 
-        Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INITIAL,Xptr);    /* show starting state values */
+        Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL, Xptr);    /* show starting state values */
 
         blkPtr += SKEIN_256_BLOCK_BYTES;
 
         /* run the rounds */
 
-#define Round256(p0,p1,p2,p3,ROT,rNum)                              \
-    X##p0 += X##p1; X##p1 = RotL_64(X##p1,ROT##_0); X##p1 ^= X##p0; \
-    X##p2 += X##p3; X##p3 = RotL_64(X##p3,ROT##_1); X##p3 ^= X##p2; \
+#define Round256(p0, p1, p2, p3, ROT, rNum)                              \
+    X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
+    X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
 
 #if SKEIN_UNROLL_256 == 0                       
-#define R256(p0,p1,p2,p3,ROT,rNum)           /* fully unrolled */   \
-    Round256(p0,p1,p2,p3,ROT,rNum)                                  \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,rNum,Xptr);
+#define R256(p0, p1, p2, p3, ROT, rNum)           /* fully unrolled */   \
+    Round256(p0, p1, p2, p3, ROT, rNum)                                  \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr);
 
 #define I256(R)                                                     \
     X0   += ks[((R)+1) % 5];    /* inject the key schedule value */ \
     X1   += ks[((R)+2) % 5] + ts[((R)+1) % 3];                      \
     X2   += ks[((R)+3) % 5] + ts[((R)+2) % 3];                      \
     X3   += ks[((R)+4) % 5] +     (R)+1;                            \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
 #else                                       /* looping version */
-#define R256(p0,p1,p2,p3,ROT,rNum)                                  \
-    Round256(p0,p1,p2,p3,ROT,rNum)                                  \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,4*(r-1)+rNum,Xptr);
+#define R256(p0, p1, p2, p3, ROT, rNum)                                  \
+    Round256(p0, p1, p2, p3, ROT, rNum)                                  \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr);
 
 #define I256(R)                                                     \
     X0   += ks[r+(R)+0];        /* inject the key schedule value */ \
     X1   += ks[r+(R)+1] + ts[r+(R)+0];                              \
     X2   += ks[r+(R)+2] + ts[r+(R)+1];                              \
-    X3   += ks[r+(R)+3] +    r+(R)   ;                              \
-    ks[r + (R)+4    ]   = ks[r+(R)-1];     /* rotate key schedule */\
-    ts[r + (R)+2    ]   = ts[r+(R)-1];                              \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
+    X3   += ks[r+(R)+3] +    r+(R);                              \
+    ks[r + (R) + 4]   = ks[r + (R) - 1];     /* rotate key schedule */\
+    ts[r + (R) + 2]   = ts[r + (R) - 1];                              \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
 
-    for (r=1;r < 2*RCNT;r+=2*SKEIN_UNROLL_256)  /* loop thru it */
+    for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_256)  /* loop thru it */
 #endif  
         {    
 #define R256_8_rounds(R)                  \
-        R256(0,1,2,3,R_256_0,8*(R) + 1);  \
-        R256(0,3,2,1,R_256_1,8*(R) + 2);  \
-        R256(0,1,2,3,R_256_2,8*(R) + 3);  \
-        R256(0,3,2,1,R_256_3,8*(R) + 4);  \
-        I256(2*(R));                      \
-        R256(0,1,2,3,R_256_4,8*(R) + 5);  \
-        R256(0,3,2,1,R_256_5,8*(R) + 6);  \
-        R256(0,1,2,3,R_256_6,8*(R) + 7);  \
-        R256(0,3,2,1,R_256_7,8*(R) + 8);  \
-        I256(2*(R)+1);
-
-        R256_8_rounds( 0);
+        R256(0, 1, 2, 3, R_256_0, 8 * (R) + 1);  \
+        R256(0, 3, 2, 1, R_256_1, 8 * (R) + 2);  \
+        R256(0, 1, 2, 3, R_256_2, 8 * (R) + 3);  \
+        R256(0, 3, 2, 1, R_256_3, 8 * (R) + 4);  \
+        I256(2 * (R));                      \
+        R256(0, 1, 2, 3, R_256_4, 8 * (R) + 5);  \
+        R256(0, 3, 2, 1, R_256_5, 8 * (R) + 6);  \
+        R256(0, 1, 2, 3, R_256_6, 8 * (R) + 7);  \
+        R256(0, 3, 2, 1, R_256_7, 8 * (R) + 8);  \
+        I256(2 * (R) + 1);
+
+        R256_8_rounds(0);
 
 #define R256_Unroll_R(NN) ((SKEIN_UNROLL_256 == 0 && SKEIN_256_ROUNDS_TOTAL/8 > (NN)) || (SKEIN_UNROLL_256 > (NN)))
 
-  #if   R256_Unroll_R( 1)
-        R256_8_rounds( 1);
+  #if   R256_Unroll_R(1)
+        R256_8_rounds(1);
   #endif
-  #if   R256_Unroll_R( 2)
-        R256_8_rounds( 2);
+  #if   R256_Unroll_R(2)
+        R256_8_rounds(2);
   #endif
-  #if   R256_Unroll_R( 3)
-        R256_8_rounds( 3);
+  #if   R256_Unroll_R(3)
+        R256_8_rounds(3);
   #endif
-  #if   R256_Unroll_R( 4)
-        R256_8_rounds( 4);
+  #if   R256_Unroll_R(4)
+        R256_8_rounds(4);
   #endif
-  #if   R256_Unroll_R( 5)
-        R256_8_rounds( 5);
+  #if   R256_Unroll_R(5)
+        R256_8_rounds(5);
   #endif
-  #if   R256_Unroll_R( 6)
-        R256_8_rounds( 6);
+  #if   R256_Unroll_R(6)
+        R256_8_rounds(6);
   #endif
-  #if   R256_Unroll_R( 7)
-        R256_8_rounds( 7);
+  #if   R256_Unroll_R(7)
+        R256_8_rounds(7);
   #endif
-  #if   R256_Unroll_R( 8)
-        R256_8_rounds( 8);
+  #if   R256_Unroll_R(8)
+        R256_8_rounds(8);
   #endif
-  #if   R256_Unroll_R( 9)
-        R256_8_rounds( 9);
+  #if   R256_Unroll_R(9)
+        R256_8_rounds(9);
   #endif
   #if   R256_Unroll_R(10)
         R256_8_rounds(10);
@@ -200,7 +199,7 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx,const u8 *blkPtr,size_t b
         ctx->X[2] = X2 ^ w[2];
         ctx->X[3] = X3 ^ w[3];
 
-        Skein_Show_Round(BLK_BITS,&ctx->h,SKEIN_RND_FEED_FWD,ctx->X);
+        Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
         ts[1] &= ~SKEIN_T1_FLAG_FIRST;
         }
@@ -224,16 +223,15 @@ unsigned int Skein_256_Unroll_Cnt(void)
 
 /*****************************  Skein_512 ******************************/
 #if !(SKEIN_USE_ASM & 512)
-void Skein_512_Process_Block(struct skein_512_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
+void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd)
     { /* do it in C */
-    enum
-        {
+    enum {
         WCNT = SKEIN_512_STATE_WORDS
         };
 #undef  RCNT
 #define RCNT  (SKEIN_512_ROUNDS_TOTAL/8)
 
-#ifdef  SKEIN_LOOP                              /* configure how much to unroll the loop */
+#ifdef SKEIN_LOOP                              /* configure how much to unroll the loop */
 #define SKEIN_UNROLL_512 (((SKEIN_LOOP)/10)%10)
 #else
 #define SKEIN_UNROLL_512 (0)
@@ -248,8 +246,8 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx,const u8 *blkPtr,size_t b
 #else
     u64  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
 #endif
-    u64  X0,X1,X2,X3,X4,X5,X6,X7;            /* local copy of vars, for speed */
-    u64  w [WCNT];                           /* local copy of input block */
+    u64  X0, X1, X2, X3, X4, X5, X6, X7;            /* local copy of vars,  for speed */
+    u64  w[WCNT];                           /* local copy of input block */
 #ifdef SKEIN_DEBUG
     const u64 *Xptr[8];                      /* use for debugging (help compiler put Xn in registers) */
     Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
@@ -277,9 +275,9 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx,const u8 *blkPtr,size_t b
 
         ts[2] = ts[0] ^ ts[1];
 
-        Skein_Get64_LSB_First(w,blkPtr,WCNT); /* get input block in little-endian format */
+        Skein_Get64_LSB_First(w, blkPtr, WCNT); /* get input block in little-endian format */
         DebugSaveTweak(ctx);
-        Skein_Show_Block(BLK_BITS,&ctx->h,ctx->X,blkPtr,w,ks,ts);
+        Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blkPtr, w, ks, ts);
 
         X0   = w[0] + ks[0];                    /* do the first full key injection */
         X1   = w[1] + ks[1];
@@ -292,92 +290,92 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx,const u8 *blkPtr,size_t b
 
         blkPtr += SKEIN_512_BLOCK_BYTES;
 
-        Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INITIAL,Xptr);
+        Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL, Xptr);
         /* run the rounds */
-#define Round512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)                  \
-    X##p0 += X##p1; X##p1 = RotL_64(X##p1,ROT##_0); X##p1 ^= X##p0; \
-    X##p2 += X##p3; X##p3 = RotL_64(X##p3,ROT##_1); X##p3 ^= X##p2; \
-    X##p4 += X##p5; X##p5 = RotL_64(X##p5,ROT##_2); X##p5 ^= X##p4; \
-    X##p6 += X##p7; X##p7 = RotL_64(X##p7,ROT##_3); X##p7 ^= X##p6; \
+#define Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)                  \
+    X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
+    X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
+    X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4; \
+    X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6; \
 
 #if SKEIN_UNROLL_512 == 0                       
-#define R512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)      /* unrolled */  \
-    Round512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)                      \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,rNum,Xptr);
+#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)      /* unrolled */  \
+    Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)                      \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr);
 
 #define I512(R)                                                     \
-    X0   += ks[((R)+1) % 9];   /* inject the key schedule value */  \
-    X1   += ks[((R)+2) % 9];                                        \
-    X2   += ks[((R)+3) % 9];                                        \
-    X3   += ks[((R)+4) % 9];                                        \
-    X4   += ks[((R)+5) % 9];                                        \
-    X5   += ks[((R)+6) % 9] + ts[((R)+1) % 3];                      \
-    X6   += ks[((R)+7) % 9] + ts[((R)+2) % 3];                      \
-    X7   += ks[((R)+8) % 9] +     (R)+1;                            \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
+    X0   += ks[((R) + 1) % 9];   /* inject the key schedule value */  \
+    X1   += ks[((R) + 2) % 9];                                        \
+    X2   += ks[((R) + 3) % 9];                                        \
+    X3   += ks[((R) + 4) % 9];                                        \
+    X4   += ks[((R) + 5) % 9];                                        \
+    X5   += ks[((R) + 6) % 9] + ts[((R) + 1) % 3];                      \
+    X6   += ks[((R) + 7) % 9] + ts[((R) + 2) % 3];                      \
+    X7   += ks[((R) + 8) % 9] +     (R) + 1;                            \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
 #else                                       /* looping version */
-#define R512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)                      \
-    Round512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)                      \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,4*(r-1)+rNum,Xptr);
+#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)                      \
+    Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)                      \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr);
 
 #define I512(R)                                                     \
-    X0   += ks[r+(R)+0];        /* inject the key schedule value */ \
-    X1   += ks[r+(R)+1];                                            \
-    X2   += ks[r+(R)+2];                                            \
-    X3   += ks[r+(R)+3];                                            \
-    X4   += ks[r+(R)+4];                                            \
-    X5   += ks[r+(R)+5] + ts[r+(R)+0];                              \
-    X6   += ks[r+(R)+6] + ts[r+(R)+1];                              \
-    X7   += ks[r+(R)+7] +    r+(R)   ;                              \
-    ks[r +       (R)+8] = ks[r+(R)-1];  /* rotate key schedule */   \
-    ts[r +       (R)+2] = ts[r+(R)-1];                              \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
-
-    for (r=1;r < 2*RCNT;r+=2*SKEIN_UNROLL_512)   /* loop thru it */
+    X0   += ks[r + (R) + 0];        /* inject the key schedule value */ \
+    X1   += ks[r + (R) + 1];                                            \
+    X2   += ks[r + (R) + 2];                                            \
+    X3   += ks[r + (R) + 3];                                            \
+    X4   += ks[r + (R) + 4];                                            \
+    X5   += ks[r + (R) + 5] + ts[r + (R) + 0];                              \
+    X6   += ks[r + (R) + 6] + ts[r + (R) + 1];                              \
+    X7   += ks[r + (R) + 7] +         r + (R);                              \
+    ks[r +         (R) + 8] = ks[r + (R) - 1];  /* rotate key schedule */   \
+    ts[r +         (R) + 2] = ts[r + (R) - 1];                              \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+
+    for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)   /* loop thru it */
 #endif                         /* end of looped code definitions */
         {
 #define R512_8_rounds(R)  /* do 8 full rounds */  \
-        R512(0,1,2,3,4,5,6,7,R_512_0,8*(R)+ 1);   \
-        R512(2,1,4,7,6,5,0,3,R_512_1,8*(R)+ 2);   \
-        R512(4,1,6,3,0,5,2,7,R_512_2,8*(R)+ 3);   \
-        R512(6,1,0,7,2,5,4,3,R_512_3,8*(R)+ 4);   \
-        I512(2*(R));                              \
-        R512(0,1,2,3,4,5,6,7,R_512_4,8*(R)+ 5);   \
-        R512(2,1,4,7,6,5,0,3,R_512_5,8*(R)+ 6);   \
-        R512(4,1,6,3,0,5,2,7,R_512_6,8*(R)+ 7);   \
-        R512(6,1,0,7,2,5,4,3,R_512_7,8*(R)+ 8);   \
-        I512(2*(R)+1);        /* and key injection */
-
-        R512_8_rounds( 0);
+        R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_0, 8 * (R) + 1);   \
+        R512(2, 1, 4, 7, 6, 5, 0, 3, R_512_1, 8 * (R) + 2);   \
+        R512(4, 1, 6, 3, 0, 5, 2, 7, R_512_2, 8 * (R) + 3);   \
+        R512(6, 1, 0, 7, 2, 5, 4, 3, R_512_3, 8 * (R) + 4);   \
+        I512(2 * (R));                              \
+        R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_4, 8 * (R) + 5);   \
+        R512(2, 1, 4, 7, 6, 5, 0, 3, R_512_5, 8 * (R) + 6);   \
+        R512(4, 1, 6, 3, 0, 5, 2, 7, R_512_6, 8 * (R) + 7);   \
+        R512(6, 1, 0, 7, 2, 5, 4, 3, R_512_7, 8 * (R) + 8);   \
+        I512(2 * (R) + 1);        /* and key injection */
+
+        R512_8_rounds(0);
 
 #define R512_Unroll_R(NN) ((SKEIN_UNROLL_512 == 0 && SKEIN_512_ROUNDS_TOTAL/8 > (NN)) || (SKEIN_UNROLL_512 > (NN)))
 
-  #if   R512_Unroll_R( 1)
-        R512_8_rounds( 1);
+  #if   R512_Unroll_R(1)
+        R512_8_rounds(1);
   #endif
-  #if   R512_Unroll_R( 2)
-        R512_8_rounds( 2);
+  #if   R512_Unroll_R(2)
+        R512_8_rounds(2);
   #endif
-  #if   R512_Unroll_R( 3)
-        R512_8_rounds( 3);
+  #if   R512_Unroll_R(3)
+        R512_8_rounds(3);
   #endif
-  #if   R512_Unroll_R( 4)
-        R512_8_rounds( 4);
+  #if   R512_Unroll_R(4)
+        R512_8_rounds(4);
   #endif
-  #if   R512_Unroll_R( 5)
-        R512_8_rounds( 5);
+  #if   R512_Unroll_R(5)
+        R512_8_rounds(5);
   #endif
-  #if   R512_Unroll_R( 6)
-        R512_8_rounds( 6);
+  #if   R512_Unroll_R(6)
+        R512_8_rounds(6);
   #endif
-  #if   R512_Unroll_R( 7)
-        R512_8_rounds( 7);
+  #if   R512_Unroll_R(7)
+        R512_8_rounds(7);
   #endif
-  #if   R512_Unroll_R( 8)
-        R512_8_rounds( 8);
+  #if   R512_Unroll_R(8)
+        R512_8_rounds(8);
   #endif
-  #if   R512_Unroll_R( 9)
-        R512_8_rounds( 9);
+  #if   R512_Unroll_R(9)
+        R512_8_rounds(9);
   #endif
   #if   R512_Unroll_R(10)
         R512_8_rounds(10);
@@ -408,7 +406,7 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx,const u8 *blkPtr,size_t b
         ctx->X[5] = X5 ^ w[5];
         ctx->X[6] = X6 ^ w[6];
         ctx->X[7] = X7 ^ w[7];
-        Skein_Show_Round(BLK_BITS,&ctx->h,SKEIN_RND_FEED_FWD,ctx->X);
+        Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
         ts[1] &= ~SKEIN_T1_FLAG_FIRST;
         }
@@ -432,16 +430,15 @@ unsigned int Skein_512_Unroll_Cnt(void)
 
 /*****************************  Skein1024 ******************************/
 #if !(SKEIN_USE_ASM & 1024)
-void Skein1024_Process_Block(struct skein1024_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
+void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd)
     { /* do it in C, always looping (unrolled is bigger AND slower!) */
-    enum
-        {
+    enum {
         WCNT = SKEIN1024_STATE_WORDS
         };
 #undef  RCNT
 #define RCNT  (SKEIN1024_ROUNDS_TOTAL/8)
 
-#ifdef  SKEIN_LOOP                              /* configure how much to unroll the loop */
+#ifdef SKEIN_LOOP                              /* configure how much to unroll the loop */
 #define SKEIN_UNROLL_1024 ((SKEIN_LOOP)%10)
 #else
 #define SKEIN_UNROLL_1024 (0)
@@ -457,14 +454,14 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx,const u8 *blkPtr,size_t b
     u64  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
 #endif
 
-    u64  X00,X01,X02,X03,X04,X05,X06,X07,    /* local copy of vars, for speed */
-            X08,X09,X10,X11,X12,X13,X14,X15;
-    u64  w [WCNT];                           /* local copy of input block */
+    u64  X00, X01, X02, X03, X04, X05, X06, X07,     /* local copy of vars, for speed */
+            X08, X09, X10, X11, X12, X13, X14, X15;
+    u64  w[WCNT];                            /* local copy of input block */
 #ifdef SKEIN_DEBUG
     const u64 *Xptr[16];                     /* use for debugging (help compiler put Xn in registers) */
-    Xptr[ 0] = &X00;  Xptr[ 1] = &X01;  Xptr[ 2] = &X02;  Xptr[ 3] = &X03;
-    Xptr[ 4] = &X04;  Xptr[ 5] = &X05;  Xptr[ 6] = &X06;  Xptr[ 7] = &X07;
-    Xptr[ 8] = &X08;  Xptr[ 9] = &X09;  Xptr[10] = &X10;  Xptr[11] = &X11;
+    Xptr[0]  = &X00;  Xptr[1]  = &X01;  Xptr[2]  = &X02;  Xptr[3]  = &X03;
+    Xptr[4]  = &X04;  Xptr[5]  = &X05;  Xptr[6]  = &X06;  Xptr[7]  = &X07;
+    Xptr[8]  = &X08;  Xptr[9]  = &X09;  Xptr[10] = &X10;  Xptr[11] = &X11;
     Xptr[12] = &X12;  Xptr[13] = &X13;  Xptr[14] = &X14;  Xptr[15] = &X15;
 #endif
 
@@ -476,43 +473,43 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx,const u8 *blkPtr,size_t b
         ts[0] += byteCntAdd;                    /* update processed length */
 
         /* precompute the key schedule for this block */
-        ks[ 0] = ctx->X[ 0];
-        ks[ 1] = ctx->X[ 1];
-        ks[ 2] = ctx->X[ 2];
-        ks[ 3] = ctx->X[ 3];
-        ks[ 4] = ctx->X[ 4];
-        ks[ 5] = ctx->X[ 5];
-        ks[ 6] = ctx->X[ 6];
-        ks[ 7] = ctx->X[ 7];
-        ks[ 8] = ctx->X[ 8];
-        ks[ 9] = ctx->X[ 9];
+        ks[0]  = ctx->X[0];
+        ks[1]  = ctx->X[1];
+        ks[2]  = ctx->X[2];
+        ks[3]  = ctx->X[3];
+        ks[4]  = ctx->X[4];
+        ks[5]  = ctx->X[5];
+        ks[6]  = ctx->X[6];
+        ks[7]  = ctx->X[7];
+        ks[8]  = ctx->X[8];
+        ks[9]  = ctx->X[9];
         ks[10] = ctx->X[10];
         ks[11] = ctx->X[11];
         ks[12] = ctx->X[12];
         ks[13] = ctx->X[13];
         ks[14] = ctx->X[14];
         ks[15] = ctx->X[15];
-        ks[16] = ks[ 0] ^ ks[ 1] ^ ks[ 2] ^ ks[ 3] ^
-                 ks[ 4] ^ ks[ 5] ^ ks[ 6] ^ ks[ 7] ^
-                 ks[ 8] ^ ks[ 9] ^ ks[10] ^ ks[11] ^
+        ks[16] =  ks[0] ^  ks[1] ^  ks[2] ^  ks[3] ^
+                  ks[4] ^  ks[5] ^  ks[6] ^  ks[7] ^
+                  ks[8] ^  ks[9] ^ ks[10] ^ ks[11] ^
                  ks[12] ^ ks[13] ^ ks[14] ^ ks[15] ^ SKEIN_KS_PARITY;
 
         ts[2]  = ts[0] ^ ts[1];
 
-        Skein_Get64_LSB_First(w,blkPtr,WCNT); /* get input block in little-endian format */
+        Skein_Get64_LSB_First(w, blkPtr, WCNT); /* get input block in little-endian format */
         DebugSaveTweak(ctx);
-        Skein_Show_Block(BLK_BITS,&ctx->h,ctx->X,blkPtr,w,ks,ts);
-
-        X00    = w[ 0] + ks[ 0];                 /* do the first full key injection */
-        X01    = w[ 1] + ks[ 1];
-        X02    = w[ 2] + ks[ 2];
-        X03    = w[ 3] + ks[ 3];
-        X04    = w[ 4] + ks[ 4];
-        X05    = w[ 5] + ks[ 5];
-        X06    = w[ 6] + ks[ 6];
-        X07    = w[ 7] + ks[ 7];
-        X08    = w[ 8] + ks[ 8];
-        X09    = w[ 9] + ks[ 9];
+        Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blkPtr, w, ks, ts);
+
+        X00    =  w[0] +  ks[0];                 /* do the first full key injection */
+        X01    =  w[1] +  ks[1];
+        X02    =  w[2] +  ks[2];
+        X03    =  w[3] +  ks[3];
+        X04    =  w[4] +  ks[4];
+        X05    =  w[5] +  ks[5];
+        X06    =  w[6] +  ks[6];
+        X07    =  w[7] +  ks[7];
+        X08    =  w[8] +  ks[8];
+        X09    =  w[9] +  ks[9];
         X10    = w[10] + ks[10];
         X11    = w[11] + ks[11];
         X12    = w[12] + ks[12];
@@ -520,112 +517,112 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx,const u8 *blkPtr,size_t b
         X14    = w[14] + ks[14] + ts[1];
         X15    = w[15] + ks[15];
 
-        Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INITIAL,Xptr);
+        Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL, Xptr);
 
-#define Round1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rNum) \
-    X##p0 += X##p1; X##p1 = RotL_64(X##p1,ROT##_0); X##p1 ^= X##p0;   \
-    X##p2 += X##p3; X##p3 = RotL_64(X##p3,ROT##_1); X##p3 ^= X##p2;   \
-    X##p4 += X##p5; X##p5 = RotL_64(X##p5,ROT##_2); X##p5 ^= X##p4;   \
-    X##p6 += X##p7; X##p7 = RotL_64(X##p7,ROT##_3); X##p7 ^= X##p6;   \
-    X##p8 += X##p9; X##p9 = RotL_64(X##p9,ROT##_4); X##p9 ^= X##p8;   \
-    X##pA += X##pB; X##pB = RotL_64(X##pB,ROT##_5); X##pB ^= X##pA;   \
-    X##pC += X##pD; X##pD = RotL_64(X##pD,ROT##_6); X##pD ^= X##pC;   \
-    X##pE += X##pF; X##pF = RotL_64(X##pF,ROT##_7); X##pF ^= X##pE;   \
+#define Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rNum) \
+    X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0;   \
+    X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2;   \
+    X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4;   \
+    X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6;   \
+    X##p8 += X##p9; X##p9 = RotL_64(X##p9, ROT##_4); X##p9 ^= X##p8;   \
+    X##pA += X##pB; X##pB = RotL_64(X##pB, ROT##_5); X##pB ^= X##pA;   \
+    X##pC += X##pD; X##pD = RotL_64(X##pD, ROT##_6); X##pD ^= X##pC;   \
+    X##pE += X##pF; X##pF = RotL_64(X##pF, ROT##_7); X##pF ^= X##pE;   \
 
 #if SKEIN_UNROLL_1024 == 0                      
-#define R1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rn) \
-    Round1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rn) \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,rn,Xptr);
-
-#define I1024(R)                                                      \
-    X00   += ks[((R)+ 1) % 17]; /* inject the key schedule value */   \
-    X01   += ks[((R)+ 2) % 17];                                       \
-    X02   += ks[((R)+ 3) % 17];                                       \
-    X03   += ks[((R)+ 4) % 17];                                       \
-    X04   += ks[((R)+ 5) % 17];                                       \
-    X05   += ks[((R)+ 6) % 17];                                       \
-    X06   += ks[((R)+ 7) % 17];                                       \
-    X07   += ks[((R)+ 8) % 17];                                       \
-    X08   += ks[((R)+ 9) % 17];                                       \
-    X09   += ks[((R)+10) % 17];                                       \
-    X10   += ks[((R)+11) % 17];                                       \
-    X11   += ks[((R)+12) % 17];                                       \
-    X12   += ks[((R)+13) % 17];                                       \
-    X13   += ks[((R)+14) % 17] + ts[((R)+1) % 3];                     \
-    X14   += ks[((R)+15) % 17] + ts[((R)+2) % 3];                     \
-    X15   += ks[((R)+16) % 17] +     (R)+1;                           \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr); 
+#define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
+    Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rn, Xptr);
+
+#define I1024(R)                                                        \
+    X00   += ks[((R) +  1) % 17]; /* inject the key schedule value */   \
+    X01   += ks[((R) +  2) % 17];                                       \
+    X02   += ks[((R) +  3) % 17];                                       \
+    X03   += ks[((R) +  4) % 17];                                       \
+    X04   += ks[((R) +  5) % 17];                                       \
+    X05   += ks[((R) +  6) % 17];                                       \
+    X06   += ks[((R) +  7) % 17];                                       \
+    X07   += ks[((R) +  8) % 17];                                       \
+    X08   += ks[((R) +  9) % 17];                                       \
+    X09   += ks[((R) + 10) % 17];                                       \
+    X10   += ks[((R) + 11) % 17];                                       \
+    X11   += ks[((R) + 12) % 17];                                       \
+    X12   += ks[((R) + 13) % 17];                                       \
+    X13   += ks[((R) + 14) % 17] + ts[((R) + 1) % 3];                   \
+    X14   += ks[((R) + 15) % 17] + ts[((R) + 2) % 3];                   \
+    X15   += ks[((R) + 16) % 17] +     (R) + 1;                         \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); 
 #else                                       /* looping version */
-#define R1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rn) \
-    Round1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rn) \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,4*(r-1)+rn,Xptr);
+#define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
+    Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
+    Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, Xptr);
 
 #define I1024(R)                                                      \
-    X00   += ks[r+(R)+ 0];    /* inject the key schedule value */     \
-    X01   += ks[r+(R)+ 1];                                            \
-    X02   += ks[r+(R)+ 2];                                            \
-    X03   += ks[r+(R)+ 3];                                            \
-    X04   += ks[r+(R)+ 4];                                            \
-    X05   += ks[r+(R)+ 5];                                            \
-    X06   += ks[r+(R)+ 6];                                            \
-    X07   += ks[r+(R)+ 7];                                            \
-    X08   += ks[r+(R)+ 8];                                            \
-    X09   += ks[r+(R)+ 9];                                            \
-    X10   += ks[r+(R)+10];                                            \
-    X11   += ks[r+(R)+11];                                            \
-    X12   += ks[r+(R)+12];                                            \
-    X13   += ks[r+(R)+13] + ts[r+(R)+0];                              \
-    X14   += ks[r+(R)+14] + ts[r+(R)+1];                              \
-    X15   += ks[r+(R)+15] +    r+(R)   ;                              \
-    ks[r  +       (R)+16] = ks[r+(R)-1];  /* rotate key schedule */   \
-    ts[r  +       (R)+ 2] = ts[r+(R)-1];                              \
-    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
-
-    for (r=1;r <= 2*RCNT;r+=2*SKEIN_UNROLL_1024)    /* loop thru it */
+    X00   += ks[r + (R) +  0];    /* inject the key schedule value */     \
+    X01   += ks[r + (R) +  1];                                            \
+    X02   += ks[r + (R) +  2];                                            \
+    X03   += ks[r + (R) +  3];                                            \
+    X04   += ks[r + (R) +  4];                                            \
+    X05   += ks[r + (R) +  5];                                            \
+    X06   += ks[r + (R) +  6];                                            \
+    X07   += ks[r + (R) +  7];                                            \
+    X08   += ks[r + (R) +  8];                                            \
+    X09   += ks[r + (R) +  9];                                            \
+    X10   += ks[r + (R) + 10];                                            \
+    X11   += ks[r + (R) + 11];                                            \
+    X12   += ks[r + (R) + 12];                                            \
+    X13   += ks[r + (R) + 13] + ts[r + (R) + 0];                          \
+    X14   += ks[r + (R) + 14] + ts[r + (R) + 1];                          \
+    X15   += ks[r + (R) + 15] +         r + (R);                          \
+    ks[r  +         (R) + 16] = ks[r + (R) - 1]; /* rotate key schedule */\
+    ts[r  +         (R) +  2] = ts[r + (R) - 1];                          \
+    Skein_Show_R_Ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+
+    for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)    /* loop thru it */
 #endif  
         {
 #define R1024_8_rounds(R)    /* do 8 full rounds */                               \
-        R1024(00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,R1024_0,8*(R) + 1); \
-        R1024(00,09,02,13,06,11,04,15,10,07,12,03,14,05,08,01,R1024_1,8*(R) + 2); \
-        R1024(00,07,02,05,04,03,06,01,12,15,14,13,08,11,10,09,R1024_2,8*(R) + 3); \
-        R1024(00,15,02,11,06,13,04,09,14,01,08,05,10,03,12,07,R1024_3,8*(R) + 4); \
+        R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, R1024_0, 8*(R) + 1); \
+        R1024(00, 09, 02, 13, 06, 11, 04, 15, 10, 07, 12, 03, 14, 05, 08, 01, R1024_1, 8*(R) + 2); \
+        R1024(00, 07, 02, 05, 04, 03, 06, 01, 12, 15, 14, 13, 08, 11, 10, 09, R1024_2, 8*(R) + 3); \
+        R1024(00, 15, 02, 11, 06, 13, 04, 09, 14, 01, 08, 05, 10, 03, 12, 07, R1024_3, 8*(R) + 4); \
         I1024(2*(R));                                                             \
-        R1024(00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,R1024_4,8*(R) + 5); \
-        R1024(00,09,02,13,06,11,04,15,10,07,12,03,14,05,08,01,R1024_5,8*(R) + 6); \
-        R1024(00,07,02,05,04,03,06,01,12,15,14,13,08,11,10,09,R1024_6,8*(R) + 7); \
-        R1024(00,15,02,11,06,13,04,09,14,01,08,05,10,03,12,07,R1024_7,8*(R) + 8); \
+        R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, R1024_4, 8*(R) + 5); \
+        R1024(00, 09, 02, 13, 06, 11, 04, 15, 10, 07, 12, 03, 14, 05, 08, 01, R1024_5, 8*(R) + 6); \
+        R1024(00, 07, 02, 05, 04, 03, 06, 01, 12, 15, 14, 13, 08, 11, 10, 09, R1024_6, 8*(R) + 7); \
+        R1024(00, 15, 02, 11, 06, 13, 04, 09, 14, 01, 08, 05, 10, 03, 12, 07, R1024_7, 8*(R) + 8); \
         I1024(2*(R)+1);
 
-        R1024_8_rounds( 0);
+        R1024_8_rounds(0);
 
 #define R1024_Unroll_R(NN) ((SKEIN_UNROLL_1024 == 0 && SKEIN1024_ROUNDS_TOTAL/8 > (NN)) || (SKEIN_UNROLL_1024 > (NN)))
 
-  #if   R1024_Unroll_R( 1)
-        R1024_8_rounds( 1);
+  #if   R1024_Unroll_R(1)
+        R1024_8_rounds(1);
   #endif
-  #if   R1024_Unroll_R( 2)
-        R1024_8_rounds( 2);
+  #if   R1024_Unroll_R(2)
+        R1024_8_rounds(2);
   #endif
-  #if   R1024_Unroll_R( 3)
-        R1024_8_rounds( 3);
+  #if   R1024_Unroll_R(3)
+        R1024_8_rounds(3);
   #endif
-  #if   R1024_Unroll_R( 4)
-        R1024_8_rounds( 4);
+  #if   R1024_Unroll_R(4)
+        R1024_8_rounds(4);
   #endif
-  #if   R1024_Unroll_R( 5)
-        R1024_8_rounds( 5);
+  #if   R1024_Unroll_R(5)
+        R1024_8_rounds(5);
   #endif
-  #if   R1024_Unroll_R( 6)
-        R1024_8_rounds( 6);
+  #if   R1024_Unroll_R(6)
+        R1024_8_rounds(6);
   #endif
-  #if   R1024_Unroll_R( 7)
-        R1024_8_rounds( 7);
+  #if   R1024_Unroll_R(7)
+        R1024_8_rounds(7);
   #endif
-  #if   R1024_Unroll_R( 8)
-        R1024_8_rounds( 8);
+  #if   R1024_Unroll_R(8)
+        R1024_8_rounds(8);
   #endif
-  #if   R1024_Unroll_R( 9)
-        R1024_8_rounds( 9);
+  #if   R1024_Unroll_R(9)
+        R1024_8_rounds(9);
   #endif
   #if   R1024_Unroll_R(10)
         R1024_8_rounds(10);
@@ -648,16 +645,16 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx,const u8 *blkPtr,size_t b
         }
         /* do the final "feedforward" xor, update context chaining vars */
 
-        ctx->X[ 0] = X00 ^ w[ 0];
-        ctx->X[ 1] = X01 ^ w[ 1];
-        ctx->X[ 2] = X02 ^ w[ 2];
-        ctx->X[ 3] = X03 ^ w[ 3];
-        ctx->X[ 4] = X04 ^ w[ 4];
-        ctx->X[ 5] = X05 ^ w[ 5];
-        ctx->X[ 6] = X06 ^ w[ 6];
-        ctx->X[ 7] = X07 ^ w[ 7];
-        ctx->X[ 8] = X08 ^ w[ 8];
-        ctx->X[ 9] = X09 ^ w[ 9];
+        ctx->X[0] = X00 ^ w[0];
+        ctx->X[1] = X01 ^ w[1];
+        ctx->X[2] = X02 ^ w[2];
+        ctx->X[3] = X03 ^ w[3];
+        ctx->X[4] = X04 ^ w[4];
+        ctx->X[5] = X05 ^ w[5];
+        ctx->X[6] = X06 ^ w[6];
+        ctx->X[7] = X07 ^ w[7];
+        ctx->X[8] = X08 ^ w[8];
+        ctx->X[9] = X09 ^ w[9];
         ctx->X[10] = X10 ^ w[10];
         ctx->X[11] = X11 ^ w[11];
         ctx->X[12] = X12 ^ w[12];
@@ -665,7 +662,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx,const u8 *blkPtr,size_t b
         ctx->X[14] = X14 ^ w[14];
         ctx->X[15] = X15 ^ w[15];
 
-        Skein_Show_Round(BLK_BITS,&ctx->h,SKEIN_RND_FEED_FWD,ctx->X);
+        Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
         
         ts[1] &= ~SKEIN_T1_FLAG_FIRST;
         blkPtr += SKEIN1024_BLOCK_BYTES;
-- 
1.9.0
