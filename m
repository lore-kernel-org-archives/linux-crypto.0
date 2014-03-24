From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 14/21] staging: crypto: skein: cleanup >80 character lines
Date: Mon, 24 Mar 2014 01:49:11 +0000
Message-ID: <855f5853dd09ee61d11c01004b86ee014b22219d.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
 Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
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
 drivers/staging/skein/include/skein.h        |  175 +-
 drivers/staging/skein/include/threefishApi.h |   16 +-
 drivers/staging/skein/skein.c                |  586 ++-
 drivers/staging/skein/skeinApi.c             |   58 +-
 drivers/staging/skein/skeinBlockNo3F.c       |   27 +-
 drivers/staging/skein/skein_block.c          |  427 +-
 drivers/staging/skein/threefish1024Block.c   | 6152 ++++++++++++++++++++------
 drivers/staging/skein/threefish256Block.c    | 1398 ++++--
 drivers/staging/skein/threefish512Block.c    | 2775 +++++++++---
 drivers/staging/skein/threefishApi.c         |   13 +-
 10 files changed, 8919 insertions(+), 2708 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index dd9a210cf5dd..f92dc40711d1 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -39,12 +39,12 @@
 
 enum
 	{
-	SKEIN_SUCCESS         =      0,          /* return codes from Skein calls */
+	SKEIN_SUCCESS         =      0, /* return codes from Skein calls */
 	SKEIN_FAIL            =      1,
 	SKEIN_BAD_HASHLEN     =      2
 	};
 
-#define  SKEIN_MODIFIER_WORDS   (2)          /* number of modifier (tweak) words */
+#define  SKEIN_MODIFIER_WORDS   (2) /* number of modifier (tweak) words */
 
 #define  SKEIN_256_STATE_WORDS  (4)
 #define  SKEIN_512_STATE_WORDS  (8)
@@ -65,30 +65,30 @@ enum
 
 struct skein_ctx_hdr
 	{
-	size_t  hashBitLen;                      /* size of hash result, in bits */
-	size_t  bCnt;                            /* current byte count in buffer b[] */
-	u64  T[SKEIN_MODIFIER_WORDS];         /* tweak words: T[0]=byte cnt, T[1]=flags */
+	size_t  hashBitLen;		/* size of hash result, in bits */
+	size_t  bCnt;			/* current byte count in buffer b[] */
+	u64  T[SKEIN_MODIFIER_WORDS];	/* tweak: T[0]=byte cnt, T[1]=flags */
 	};
 
-struct skein_256_ctx                               /*  256-bit Skein hash context structure */
+struct skein_256_ctx /* 256-bit Skein hash context structure */
 	{
-	struct skein_ctx_hdr h;                      /* common header context variables */
-	u64  X[SKEIN_256_STATE_WORDS];        /* chaining variables */
-	u8  b[SKEIN_256_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
+	struct skein_ctx_hdr h;		/* common header context variables */
+	u64  X[SKEIN_256_STATE_WORDS];	/* chaining variables */
+	u8  b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 	};
 
-struct skein_512_ctx                             /*  512-bit Skein hash context structure */
+struct skein_512_ctx /* 512-bit Skein hash context structure */
 	{
-	struct skein_ctx_hdr h;                      /* common header context variables */
-	u64  X[SKEIN_512_STATE_WORDS];        /* chaining variables */
-	u8  b[SKEIN_512_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
+	struct skein_ctx_hdr h;		/* common header context variables */
+	u64  X[SKEIN_512_STATE_WORDS];	/* chaining variables */
+	u8  b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 	};
 
-struct skein1024_ctx                              /* 1024-bit Skein hash context structure */
+struct skein1024_ctx /* 1024-bit Skein hash context structure */
 	{
-	struct skein_ctx_hdr h;                      /* common header context variables */
-	u64  X[SKEIN1024_STATE_WORDS];        /* chaining variables */
-	u8  b[SKEIN1024_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
+	struct skein_ctx_hdr h;		/* common header context variables */
+	u64  X[SKEIN1024_STATE_WORDS];	/* chaining variables */
+	u8  b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 	};
 
 /*   Skein APIs for (incremental) "straight hashing" */
@@ -96,9 +96,12 @@ int  Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen);
 int  Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen);
 int  Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen);
 
-int  Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCnt);
-int  Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt);
-int  Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt);
+int  Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
+			size_t msgByteCnt);
+int  Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
+			size_t msgByteCnt);
+int  Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
+			size_t msgByteCnt);
 
 int  Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal);
 int  Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal);
@@ -118,9 +121,12 @@ int  Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal);
 **              to precompute the MAC IV, then a copy of the context saved and
 **              reused for each new MAC computation.
 **/
-int  Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
-int  Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
-int  Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
+			u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
+			u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
+			u64 treeInfo, const u8 *key, size_t keyBytes);
 
 /*
 **   Skein APIs for MAC and tree hash:
@@ -149,13 +155,13 @@ int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
 ******************************************************************/
 
 /* tweak word T[1]: bit field starting positions */
-#define SKEIN_T1_BIT(BIT)       ((BIT) - 64)            /* offset 64 because it's the second word  */
+#define SKEIN_T1_BIT(BIT)       ((BIT) - 64)      /* second word  */
 
-#define SKEIN_T1_POS_TREE_LVL   SKEIN_T1_BIT(112)       /* bits 112..118: level in hash tree       */
-#define SKEIN_T1_POS_BIT_PAD    SKEIN_T1_BIT(119)       /* bit  119     : partial final input byte */
-#define SKEIN_T1_POS_BLK_TYPE   SKEIN_T1_BIT(120)       /* bits 120..125: type field               */
-#define SKEIN_T1_POS_FIRST      SKEIN_T1_BIT(126)       /* bits 126     : first block flag         */
-#define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127)       /* bit  127     : final block flag         */
+#define SKEIN_T1_POS_TREE_LVL   SKEIN_T1_BIT(112) /* 112..118 hash tree level */
+#define SKEIN_T1_POS_BIT_PAD    SKEIN_T1_BIT(119) /* 119 part. final in byte */
+#define SKEIN_T1_POS_BLK_TYPE   SKEIN_T1_BIT(120) /* 120..125 type field `*/
+#define SKEIN_T1_POS_FIRST      SKEIN_T1_BIT(126) /* 126      first blk flag */
+#define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127) /* 127      final blk flag */
 
 /* tweak word T[1]: flag bit definition(s) */
 #define SKEIN_T1_FLAG_FIRST     (((u64)  1) << SKEIN_T1_POS_FIRST)
@@ -167,34 +173,37 @@ int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
 #define SKEIN_T1_TREE_LEVEL(n)  (((u64) (n)) << SKEIN_T1_POS_TREE_LVL)
 
 /* tweak word T[1]: block type field */
-#define SKEIN_BLK_TYPE_KEY       (0)                    /* key, for MAC and KDF */
-#define SKEIN_BLK_TYPE_CFG       (4)                    /* configuration block */
-#define SKEIN_BLK_TYPE_PERS      (8)                    /* personalization string */
-#define SKEIN_BLK_TYPE_PK       (12)                    /* public key (for digital signature hashing) */
-#define SKEIN_BLK_TYPE_KDF      (16)                    /* key identifier for KDF */
-#define SKEIN_BLK_TYPE_NONCE    (20)                    /* nonce for PRNG */
-#define SKEIN_BLK_TYPE_MSG      (48)                    /* message processing */
-#define SKEIN_BLK_TYPE_OUT      (63)                    /* output stage */
-#define SKEIN_BLK_TYPE_MASK     (63)                    /* bit field mask */
-
-#define SKEIN_T1_BLK_TYPE(T)   (((u64) (SKEIN_BLK_TYPE_##T)) << SKEIN_T1_POS_BLK_TYPE)
-#define SKEIN_T1_BLK_TYPE_KEY   SKEIN_T1_BLK_TYPE(KEY)  /* key, for MAC and KDF */
-#define SKEIN_T1_BLK_TYPE_CFG   SKEIN_T1_BLK_TYPE(CFG)  /* configuration block */
-#define SKEIN_T1_BLK_TYPE_PERS  SKEIN_T1_BLK_TYPE(PERS) /* personalization string */
-#define SKEIN_T1_BLK_TYPE_PK    SKEIN_T1_BLK_TYPE(PK)   /* public key (for digital signature hashing) */
-#define SKEIN_T1_BLK_TYPE_KDF   SKEIN_T1_BLK_TYPE(KDF)  /* key identifier for KDF */
+#define SKEIN_BLK_TYPE_KEY       (0) /* key, for MAC and KDF */
+#define SKEIN_BLK_TYPE_CFG       (4) /* configuration block */
+#define SKEIN_BLK_TYPE_PERS      (8) /* personalization string */
+#define SKEIN_BLK_TYPE_PK       (12) /* pubkey (for digital sigs) */
+#define SKEIN_BLK_TYPE_KDF      (16) /* key identifier for KDF */
+#define SKEIN_BLK_TYPE_NONCE    (20) /* nonce for PRNG */
+#define SKEIN_BLK_TYPE_MSG      (48) /* message processing */
+#define SKEIN_BLK_TYPE_OUT      (63) /* output stage */
+#define SKEIN_BLK_TYPE_MASK     (63) /* bit field mask */
+
+#define SKEIN_T1_BLK_TYPE(T)   (((u64) (SKEIN_BLK_TYPE_##T)) << \
+					SKEIN_T1_POS_BLK_TYPE)
+#define SKEIN_T1_BLK_TYPE_KEY   SKEIN_T1_BLK_TYPE(KEY)  /* for MAC and KDF */
+#define SKEIN_T1_BLK_TYPE_CFG   SKEIN_T1_BLK_TYPE(CFG)  /* config block */
+#define SKEIN_T1_BLK_TYPE_PERS  SKEIN_T1_BLK_TYPE(PERS) /* personalization */
+#define SKEIN_T1_BLK_TYPE_PK    SKEIN_T1_BLK_TYPE(PK)   /* pubkey (for sigs) */
+#define SKEIN_T1_BLK_TYPE_KDF   SKEIN_T1_BLK_TYPE(KDF)  /* key ident for KDF */
 #define SKEIN_T1_BLK_TYPE_NONCE SKEIN_T1_BLK_TYPE(NONCE)/* nonce for PRNG */
 #define SKEIN_T1_BLK_TYPE_MSG   SKEIN_T1_BLK_TYPE(MSG)  /* message processing */
 #define SKEIN_T1_BLK_TYPE_OUT   SKEIN_T1_BLK_TYPE(OUT)  /* output stage */
 #define SKEIN_T1_BLK_TYPE_MASK  SKEIN_T1_BLK_TYPE(MASK) /* field bit mask */
 
-#define SKEIN_T1_BLK_TYPE_CFG_FINAL       (SKEIN_T1_BLK_TYPE_CFG | SKEIN_T1_FLAG_FINAL)
-#define SKEIN_T1_BLK_TYPE_OUT_FINAL       (SKEIN_T1_BLK_TYPE_OUT | SKEIN_T1_FLAG_FINAL)
+#define SKEIN_T1_BLK_TYPE_CFG_FINAL    (SKEIN_T1_BLK_TYPE_CFG | \
+					SKEIN_T1_FLAG_FINAL)
+#define SKEIN_T1_BLK_TYPE_OUT_FINAL    (SKEIN_T1_BLK_TYPE_OUT | \
+					SKEIN_T1_FLAG_FINAL)
 
 #define SKEIN_VERSION           (1)
 
 #ifndef SKEIN_ID_STRING_LE      /* allow compile-time personalization */
-#define SKEIN_ID_STRING_LE      (0x33414853)            /* "SHA3" (little-endian)*/
+#define SKEIN_ID_STRING_LE      (0x33414853) /* "SHA3" (little-endian)*/
 #endif
 
 #define SKEIN_MK_64(hi32, lo32)  ((lo32) + (((u64) (hi32)) << 32))
@@ -208,23 +217,29 @@ int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
 #define SKEIN_CFG_TREE_NODE_SIZE_POS  (8)
 #define SKEIN_CFG_TREE_MAX_LEVEL_POS  (16)
 
-#define SKEIN_CFG_TREE_LEAF_SIZE_MSK  (((u64) 0xFF) << SKEIN_CFG_TREE_LEAF_SIZE_POS)
-#define SKEIN_CFG_TREE_NODE_SIZE_MSK  (((u64) 0xFF) << SKEIN_CFG_TREE_NODE_SIZE_POS)
-#define SKEIN_CFG_TREE_MAX_LEVEL_MSK  (((u64) 0xFF) << SKEIN_CFG_TREE_MAX_LEVEL_POS)
+#define SKEIN_CFG_TREE_LEAF_SIZE_MSK (((u64)0xFF) << \
+					SKEIN_CFG_TREE_LEAF_SIZE_POS)
+#define SKEIN_CFG_TREE_NODE_SIZE_MSK (((u64)0xFF) << \
+					SKEIN_CFG_TREE_NODE_SIZE_POS)
+#define SKEIN_CFG_TREE_MAX_LEVEL_MSK (((u64)0xFF) << \
+					SKEIN_CFG_TREE_MAX_LEVEL_POS)
 
 #define SKEIN_CFG_TREE_INFO(leaf, node, maxLvl)                   \
 	((((u64)(leaf))   << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
 	 (((u64)(node))   << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
 	 (((u64)(maxLvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS))
 
-#define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0, 0, 0) /* use as treeInfo in InitExt() call for sequential processing */
+/* use as treeInfo in InitExt() call for sequential processing */
+#define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0, 0, 0)
 
 /*
 **   Skein macros for getting/setting tweak words, etc.
 **   These are useful for partial input bytes, hash tree init/update, etc.
 **/
 #define Skein_Get_Tweak(ctxPtr, TWK_NUM)          ((ctxPtr)->h.T[TWK_NUM])
-#define Skein_Set_Tweak(ctxPtr, TWK_NUM, tVal)    {(ctxPtr)->h.T[TWK_NUM] = (tVal); }
+#define Skein_Set_Tweak(ctxPtr, TWK_NUM, tVal) { \
+		(ctxPtr)->h.T[TWK_NUM] = (tVal); \
+	}
 
 #define Skein_Get_T0(ctxPtr)     Skein_Get_Tweak(ctxPtr, 0)
 #define Skein_Get_T1(ctxPtr)     Skein_Get_Tweak(ctxPtr, 1)
@@ -241,14 +256,26 @@ int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
 #define Skein_Set_Type(ctxPtr, BLK_TYPE)         \
 	Skein_Set_T1(ctxPtr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
 
-/* set up for starting with a new type: h.T[0]=0; h.T[1] = NEW_TYPE; h.bCnt=0; */
-#define Skein_Start_New_Type(ctxPtr, BLK_TYPE)   \
-	{ Skein_Set_T0_T1(ctxPtr, 0, SKEIN_T1_FLAG_FIRST | SKEIN_T1_BLK_TYPE_##BLK_TYPE); (ctxPtr)->h.bCnt = 0; }
+/*
+ * setup for starting with a new type:
+ * h.T[0]=0; h.T[1] = NEW_TYPE; h.bCnt=0;
+ */
+#define Skein_Start_New_Type(ctxPtr, BLK_TYPE) { \
+		Skein_Set_T0_T1(ctxPtr, 0, SKEIN_T1_FLAG_FIRST | \
+				SKEIN_T1_BLK_TYPE_##BLK_TYPE); \
+		(ctxPtr)->h.bCnt = 0; \
+	}
 
-#define Skein_Clear_First_Flag(hdr)      { (hdr).T[1] &= ~SKEIN_T1_FLAG_FIRST;       }
-#define Skein_Set_Bit_Pad_Flag(hdr)      { (hdr).T[1] |=  SKEIN_T1_FLAG_BIT_PAD;     }
+#define Skein_Clear_First_Flag(hdr) { \
+		(hdr).T[1] &= ~SKEIN_T1_FLAG_FIRST; \
+	}
+#define Skein_Set_Bit_Pad_Flag(hdr) { \
+		(hdr).T[1] |=  SKEIN_T1_FLAG_BIT_PAD; \
+	}
 
-#define Skein_Set_Tree_Level(hdr, height) { (hdr).T[1] |= SKEIN_T1_TREE_LEVEL(height); }
+#define Skein_Set_Tree_Level(hdr, height) { \
+		(hdr).T[1] |= SKEIN_T1_TREE_LEVEL(height); \
+	}
 
 /*****************************************************************
 ** "Internal" Skein definitions for debugging and error checking
@@ -263,7 +290,7 @@ int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
 #define Skein_Show_Key(bits, ctx, key, keyBytes)
 #endif
 
-#define Skein_Assert(x, retCode)/* default: ignore all Asserts, for performance */
+#define Skein_Assert(x, retCode)/* ignore all Asserts, for performance */
 #define Skein_assert(x)
 
 /*****************************************************************
@@ -292,21 +319,29 @@ enum
 	R_512_7_0 =  8, R_512_7_1 = 35, R_512_7_2 = 56, R_512_7_3 = 22,
 
 	    /* Skein1024 round rotation constants */
-	R1024_0_0 = 24, R1024_0_1 = 13, R1024_0_2 =  8, R1024_0_3 = 47, R1024_0_4 =  8, R1024_0_5 = 17, R1024_0_6 = 22, R1024_0_7 = 37,
-	R1024_1_0 = 38, R1024_1_1 = 19, R1024_1_2 = 10, R1024_1_3 = 55, R1024_1_4 = 49, R1024_1_5 = 18, R1024_1_6 = 23, R1024_1_7 = 52,
-	R1024_2_0 = 33, R1024_2_1 =  4, R1024_2_2 = 51, R1024_2_3 = 13, R1024_2_4 = 34, R1024_2_5 = 41, R1024_2_6 = 59, R1024_2_7 = 17,
-	R1024_3_0 =  5, R1024_3_1 = 20, R1024_3_2 = 48, R1024_3_3 = 41, R1024_3_4 = 47, R1024_3_5 = 28, R1024_3_6 = 16, R1024_3_7 = 25,
-	R1024_4_0 = 41, R1024_4_1 =  9, R1024_4_2 = 37, R1024_4_3 = 31, R1024_4_4 = 12, R1024_4_5 = 47, R1024_4_6 = 44, R1024_4_7 = 30,
-	R1024_5_0 = 16, R1024_5_1 = 34, R1024_5_2 = 56, R1024_5_3 = 51, R1024_5_4 =  4, R1024_5_5 = 53, R1024_5_6 = 42, R1024_5_7 = 41,
-	R1024_6_0 = 31, R1024_6_1 = 44, R1024_6_2 = 47, R1024_6_3 = 46, R1024_6_4 = 19, R1024_6_5 = 42, R1024_6_6 = 44, R1024_6_7 = 25,
-	R1024_7_0 =  9, R1024_7_1 = 48, R1024_7_2 = 35, R1024_7_3 = 52, R1024_7_4 = 23, R1024_7_5 = 31, R1024_7_6 = 37, R1024_7_7 = 20
+	R1024_0_0 = 24, R1024_0_1 = 13, R1024_0_2 =  8, R1024_0_3 = 47,
+	R1024_0_4 =  8, R1024_0_5 = 17, R1024_0_6 = 22, R1024_0_7 = 37,
+	R1024_1_0 = 38, R1024_1_1 = 19, R1024_1_2 = 10, R1024_1_3 = 55,
+	R1024_1_4 = 49, R1024_1_5 = 18, R1024_1_6 = 23, R1024_1_7 = 52,
+	R1024_2_0 = 33, R1024_2_1 =  4, R1024_2_2 = 51, R1024_2_3 = 13,
+	R1024_2_4 = 34, R1024_2_5 = 41, R1024_2_6 = 59, R1024_2_7 = 17,
+	R1024_3_0 =  5, R1024_3_1 = 20, R1024_3_2 = 48, R1024_3_3 = 41,
+	R1024_3_4 = 47, R1024_3_5 = 28, R1024_3_6 = 16, R1024_3_7 = 25,
+	R1024_4_0 = 41, R1024_4_1 =  9, R1024_4_2 = 37, R1024_4_3 = 31,
+	R1024_4_4 = 12, R1024_4_5 = 47, R1024_4_6 = 44, R1024_4_7 = 30,
+	R1024_5_0 = 16, R1024_5_1 = 34, R1024_5_2 = 56, R1024_5_3 = 51,
+	R1024_5_4 =  4, R1024_5_5 = 53, R1024_5_6 = 42, R1024_5_7 = 41,
+	R1024_6_0 = 31, R1024_6_1 = 44, R1024_6_2 = 47, R1024_6_3 = 46,
+	R1024_6_4 = 19, R1024_6_5 = 42, R1024_6_6 = 44, R1024_6_7 = 25,
+	R1024_7_0 =  9, R1024_7_1 = 48, R1024_7_2 = 35, R1024_7_3 = 52,
+	R1024_7_4 = 23, R1024_7_5 = 31, R1024_7_6 = 37, R1024_7_7 = 20
 	};
 
 #ifndef SKEIN_ROUNDS
-#define SKEIN_256_ROUNDS_TOTAL (72)          /* number of rounds for the different block sizes */
+#define SKEIN_256_ROUNDS_TOTAL (72)	/* # rounds for diff block sizes */
 #define SKEIN_512_ROUNDS_TOTAL (72)
 #define SKEIN1024_ROUNDS_TOTAL (80)
-#else                                        /* allow command-line define in range 8*(5..14)   */
+#else			/* allow command-line define in range 8*(5..14)   */
 #define SKEIN_256_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/100) + 5) % 10) + 5))
 #define SKEIN_512_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/10)  + 5) % 10) + 5))
 #define SKEIN1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS)     + 5) % 10) + 5))
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index 5d92bbff8c9f..e81675d7eac9 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -72,7 +72,9 @@ struct threefish_key {
  * @param tweak
  *     Pointer to the two tweak words (word has 64 bits).
  */
-void threefishSetKey(struct threefish_key *keyCtx, enum threefish_size stateSize, u64 *keyData, u64 *tweak);
+void threefishSetKey(struct threefish_key *keyCtx,
+			enum threefish_size stateSize,
+			u64 *keyData, u64 *tweak);
 
 /**
  * Encrypt Threefisch block (bytes).
@@ -108,7 +110,8 @@ void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
  * @param out
  *     Pointer to cipher buffer.
  */
-void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in, u64 *out);
+void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
+				u64 *out);
 
 /**
  * Decrypt Threefisch block (bytes).
@@ -144,14 +147,17 @@ void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
  * @param out
  *     Pointer to plaintext buffer.
  */
-void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in, u64 *out);
+void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in,
+				u64 *out);
 
 void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
 void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output);
+void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input,
+			u64 *output);
 void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
 void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output);
+void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input,
+			u64 *output);
 /**
  * @}
  */
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 3f0f32806181..ed603ee7b170 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -16,9 +16,12 @@
 
 /*****************************************************************/
 /* External function to process blkCnt (nonzero) full block(s) of data. */
-void    Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd);
-void    Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd);
-void    Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd);
+void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd);
+void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd);
+void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd);
 
 /*****************************************************************/
 /*     256-bit Skein                                             */
@@ -53,20 +56,28 @@ int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
 		break;
 	default:
 		/* here if there is no precomputed IV value available */
-		/* build/process the config block, type == CONFIG (could be precomputed) */
-		Skein_Start_New_Type(ctx, CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
-
-		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);  /* set the schema, version */
-		cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
+		/*
+		 * build/process the config block, type == CONFIG (could be
+		 * precomputed)
+		 */
+		/* set tweaks: T0=0; T1=CFG | FINAL */
+		Skein_Start_New_Type(ctx, CFG_FINAL);
+
+		/* set the schema, version */
+		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+		/* hash result length in bits */
+		cfg.w[1] = Skein_Swap64(hashBitLen);
 		cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
-		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
+		/* zero pad config block */
+		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
 
 		/* compute the initial chaining values from config block */
-		memset(ctx->X, 0, sizeof(ctx->X));            /* zero the chaining variables */
+		/* zero the chaining variables */
+		memset(ctx->X, 0, sizeof(ctx->X));
 		Skein_256_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
-	/* The chaining vars ctx->X are now initialized for the given hashBitLen. */
+	/* The chaining vars ctx->X are now initialized for hashBitLen. */
 	/* Set up to process the data message portion of the hash (default) */
 	Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
 
@@ -75,42 +86,58 @@ int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
-/* [identical to Skein_256_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes)
+/* [identical to Skein_256_Init() when keyBytes == 0 && \
+ *	treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
+			u64 treeInfo, const u8 *key, size_t keyBytes)
 {
 	union
 	{
 		u8  b[SKEIN_256_STATE_BYTES];
 		u64  w[SKEIN_256_STATE_WORDS];
-	} cfg;                              /* config block */
+	} cfg; /* config block */
 
 	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
 	Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
-	if (keyBytes == 0)                          /* is there a key? */
+	if (keyBytes == 0) /* is there a key? */
 	{
-		memset(ctx->X, 0, sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
+		/* no key: use all zeroes as key for config block */
+		memset(ctx->X, 0, sizeof(ctx->X));
 	}
-	else                                        /* here to pre-process a key */
+	else /* here to pre-process a key */
 	{
 		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
-		ctx->h.hashBitLen = 8*sizeof(ctx->X);     /* set output hash bit count = state size */
-		Skein_Start_New_Type(ctx, KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
-		memset(ctx->X, 0, sizeof(ctx->X));        /* zero the initial chaining variables */
-		Skein_256_Update(ctx, key, keyBytes);     /* hash the key */
-		Skein_256_Final_Pad(ctx, cfg.b);         /* put result into cfg.b[] */
-		memcpy(ctx->X, cfg.b, sizeof(cfg.b));     /* copy over into ctx->X[] */
+		/* set output hash bit count = state size */
+		ctx->h.hashBitLen = 8*sizeof(ctx->X);
+		/* set tweaks: T0 = 0; T1 = KEY type */
+		Skein_Start_New_Type(ctx, KEY);
+		/* zero the initial chaining variables */
+		memset(ctx->X, 0, sizeof(ctx->X));
+		/* hash the key */
+		Skein_256_Update(ctx, key, keyBytes);
+		/* put result into cfg.b[] */
+		Skein_256_Final_Pad(ctx, cfg.b);
+		/* copy over into ctx->X[] */
+		memcpy(ctx->X, cfg.b, sizeof(cfg.b));
 	}
-	/* build/process the config block, type == CONFIG (could be precomputed for each key) */
-	ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
+	/*
+	 * build/process the config block, type == CONFIG (could be
+	 * precomputed for each key)
+	 */
+	/* output hash bit count */
+	ctx->h.hashBitLen = hashBitLen;
 	Skein_Start_New_Type(ctx, CFG_FINAL);
 
-	memset(&cfg.w, 0, sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
+	/* pre-pad cfg.w[] with zeroes */
+	memset(&cfg.w, 0, sizeof(cfg.w));
 	cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
-	cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
-	cfg.w[2] = Skein_Swap64(treeInfo);          /* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+	/* hash result length in bits */
+	cfg.w[1] = Skein_Swap64(hashBitLen);
+	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+	cfg.w[2] = Skein_Swap64(treeInfo);
 
 	Skein_Show_Key(256, &ctx->h, key, keyBytes);
 
@@ -126,35 +153,46 @@ int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen, u64 treeInfo
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCnt)
+int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
+			size_t msgByteCnt)
 {
 	size_t n;
 
-	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
 	if (msgByteCnt + ctx->h.bCnt > SKEIN_256_BLOCK_BYTES)
 	{
-		if (ctx->h.bCnt)                              /* finish up any buffered message data */
+		/* finish up any buffered message data */
+		if (ctx->h.bCnt)
 		{
-			n = SKEIN_256_BLOCK_BYTES - ctx->h.bCnt;  /* # bytes free in buffer b[] */
+			/* # bytes free in buffer b[] */
+			n = SKEIN_256_BLOCK_BYTES - ctx->h.bCnt;
 			if (n)
 			{
-				Skein_assert(n < msgByteCnt);         /* check on our logic here */
+				/* check on our logic here */
+				Skein_assert(n < msgByteCnt);
 				memcpy(&ctx->b[ctx->h.bCnt], msg, n);
 				msgByteCnt  -= n;
 				msg         += n;
 				ctx->h.bCnt += n;
 			}
 			Skein_assert(ctx->h.bCnt == SKEIN_256_BLOCK_BYTES);
-			Skein_256_Process_Block(ctx, ctx->b, 1, SKEIN_256_BLOCK_BYTES);
+			Skein_256_Process_Block(ctx, ctx->b, 1,
+						SKEIN_256_BLOCK_BYTES);
 			ctx->h.bCnt = 0;
 		}
-		/* now process any remaining full blocks, directly from input message data */
+		/*
+		 * now process any remaining full blocks, directly from input
+		 * message data
+		 */
 		if (msgByteCnt > SKEIN_256_BLOCK_BYTES)
 		{
-			n = (msgByteCnt-1) / SKEIN_256_BLOCK_BYTES;   /* number of full blocks to process */
-			Skein_256_Process_Block(ctx, msg, n, SKEIN_256_BLOCK_BYTES);
+			/* number of full blocks to process */
+			n = (msgByteCnt-1) / SKEIN_256_BLOCK_BYTES;
+			Skein_256_Process_Block(ctx, msg, n,
+						SKEIN_256_BLOCK_BYTES);
 			msgByteCnt -= n * SKEIN_256_BLOCK_BYTES;
 			msg        += n * SKEIN_256_BLOCK_BYTES;
 		}
@@ -178,31 +216,46 @@ int Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN_256_STATE_WORDS];
-	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
-	if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)            /* zero pad b[] if necessary */
-		memset(&ctx->b[ctx->h.bCnt], 0, SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
+	/* tag as the final block */
+	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.bCnt], 0,
+			SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
 
-	Skein_256_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);  /* process the final block */
+	/* process the final block */
+	Skein_256_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
 
 	/* now output the result */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;             /* total number of output bytes */
+	/* total number of output bytes */
+	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
-	memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-	memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++)
 	{
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
-		Skein_256_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
-		n = byteCnt - i*SKEIN_256_BLOCK_BYTES;   /* number of output bytes left to go */
+		/* run "counter mode" */
+		Skein_256_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byteCnt - i*SKEIN_256_BLOCK_BYTES;
 		if (n >= SKEIN_256_BLOCK_BYTES)
 			n  = SKEIN_256_BLOCK_BYTES;
-		Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
-		Skein_Show_Final(256, &ctx->h, n, hashVal+i*SKEIN_256_BLOCK_BYTES);
-		memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
+		/* "output" the ctr mode bytes */
+		Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES, ctx->X,
+				      n);
+		Skein_Show_Final(256, &ctx->h, n,
+				 hashVal+i*SKEIN_256_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->X, X, sizeof(X));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -240,21 +293,32 @@ int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
 		break;
 	default:
 		/* here if there is no precomputed IV value available */
-		/* build/process the config block, type == CONFIG (could be precomputed) */
-		Skein_Start_New_Type(ctx, CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
-
-		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);  /* set the schema, version */
-		cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
+		/*
+		 * build/process the config block, type == CONFIG (could be
+		 * precomputed)
+		 */
+		/* set tweaks: T0=0; T1=CFG | FINAL */
+		Skein_Start_New_Type(ctx, CFG_FINAL);
+
+		/* set the schema, version */
+		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+		/* hash result length in bits */
+		cfg.w[1] = Skein_Swap64(hashBitLen);
 		cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
-		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
+		/* zero pad config block */
+		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
 
 		/* compute the initial chaining values from config block */
-		memset(ctx->X, 0, sizeof(ctx->X));            /* zero the chaining variables */
+		/* zero the chaining variables */
+		memset(ctx->X, 0, sizeof(ctx->X));
 		Skein_512_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
 
-	/* The chaining vars ctx->X are now initialized for the given hashBitLen. */
+	/*
+	 * The chaining vars ctx->X are now initialized for the given
+	 * hashBitLen.
+	 */
 	/* Set up to process the data message portion of the hash (default) */
 	Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
 
@@ -263,8 +327,10 @@ int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
-/* [identical to Skein_512_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes)
+/* [identical to Skein_512_Init() when keyBytes == 0 && \
+ *	treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
+			u64 treeInfo, const u8 *key, size_t keyBytes)
 {
 	union
 	{
@@ -278,27 +344,40 @@ int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen, u64 treeInfo
 	/* compute the initial chaining values ctx->X[], based on key */
 	if (keyBytes == 0)                          /* is there a key? */
 	{
-		memset(ctx->X, 0, sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
+		/* no key: use all zeroes as key for config block */
+		memset(ctx->X, 0, sizeof(ctx->X));
 	}
-	else                                        /* here to pre-process a key */
+	else /* here to pre-process a key */
 	{
 		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
-		ctx->h.hashBitLen = 8*sizeof(ctx->X);     /* set output hash bit count = state size */
-		Skein_Start_New_Type(ctx, KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
-		memset(ctx->X, 0, sizeof(ctx->X));        /* zero the initial chaining variables */
-		Skein_512_Update(ctx, key, keyBytes);     /* hash the key */
-		Skein_512_Final_Pad(ctx, cfg.b);         /* put result into cfg.b[] */
-		memcpy(ctx->X, cfg.b, sizeof(cfg.b));     /* copy over into ctx->X[] */
+		/* set output hash bit count = state size */
+		ctx->h.hashBitLen = 8*sizeof(ctx->X);
+		/* set tweaks: T0 = 0; T1 = KEY type */
+		Skein_Start_New_Type(ctx, KEY);
+		/* zero the initial chaining variables */
+		memset(ctx->X, 0, sizeof(ctx->X));
+		/* hash the key */
+		Skein_512_Update(ctx, key, keyBytes);
+		/* put result into cfg.b[] */
+		Skein_512_Final_Pad(ctx, cfg.b);
+		/* copy over into ctx->X[] */
+		memcpy(ctx->X, cfg.b, sizeof(cfg.b));
 	}
-	/* build/process the config block, type == CONFIG (could be precomputed for each key) */
+	/*
+	 * build/process the config block, type == CONFIG (could be
+	 * precomputed for each key)
+	 */
 	ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
 	Skein_Start_New_Type(ctx, CFG_FINAL);
 
-	memset(&cfg.w, 0, sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
+	/* pre-pad cfg.w[] with zeroes */
+	memset(&cfg.w, 0, sizeof(cfg.w));
 	cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
-	cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
-	cfg.w[2] = Skein_Swap64(treeInfo);          /* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+	/* hash result length in bits */
+	cfg.w[1] = Skein_Swap64(hashBitLen);
+	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+	cfg.w[2] = Skein_Swap64(treeInfo);
 
 	Skein_Show_Key(512, &ctx->h, key, keyBytes);
 
@@ -314,35 +393,46 @@ int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen, u64 treeInfo
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt)
+int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
+			size_t msgByteCnt)
 {
 	size_t n;
 
-	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
 	if (msgByteCnt + ctx->h.bCnt > SKEIN_512_BLOCK_BYTES)
 	{
-		if (ctx->h.bCnt)                              /* finish up any buffered message data */
+		/* finish up any buffered message data */
+		if (ctx->h.bCnt)
 		{
-			n = SKEIN_512_BLOCK_BYTES - ctx->h.bCnt;  /* # bytes free in buffer b[] */
+			/* # bytes free in buffer b[] */
+			n = SKEIN_512_BLOCK_BYTES - ctx->h.bCnt;
 			if (n)
 			{
-				Skein_assert(n < msgByteCnt);         /* check on our logic here */
+				/* check on our logic here */
+				Skein_assert(n < msgByteCnt);
 				memcpy(&ctx->b[ctx->h.bCnt], msg, n);
 				msgByteCnt  -= n;
 				msg         += n;
 				ctx->h.bCnt += n;
 			}
 			Skein_assert(ctx->h.bCnt == SKEIN_512_BLOCK_BYTES);
-			Skein_512_Process_Block(ctx, ctx->b, 1, SKEIN_512_BLOCK_BYTES);
+			Skein_512_Process_Block(ctx, ctx->b, 1,
+						SKEIN_512_BLOCK_BYTES);
 			ctx->h.bCnt = 0;
 		}
-		/* now process any remaining full blocks, directly from input message data */
+		/*
+		 * now process any remaining full blocks, directly from input
+		 * message data
+		 */
 		if (msgByteCnt > SKEIN_512_BLOCK_BYTES)
 		{
-			n = (msgByteCnt-1) / SKEIN_512_BLOCK_BYTES;   /* number of full blocks to process */
-			Skein_512_Process_Block(ctx, msg, n, SKEIN_512_BLOCK_BYTES);
+			/* number of full blocks to process */
+			n = (msgByteCnt-1) / SKEIN_512_BLOCK_BYTES;
+			Skein_512_Process_Block(ctx, msg, n,
+						SKEIN_512_BLOCK_BYTES);
 			msgByteCnt -= n * SKEIN_512_BLOCK_BYTES;
 			msg        += n * SKEIN_512_BLOCK_BYTES;
 		}
@@ -366,31 +456,46 @@ int Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN_512_STATE_WORDS];
-	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
-	if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)            /* zero pad b[] if necessary */
-		memset(&ctx->b[ctx->h.bCnt], 0, SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
+	/* tag as the final block */
+	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.bCnt], 0,
+			SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
 
-	Skein_512_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);  /* process the final block */
+	/* process the final block */
+	Skein_512_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
 
 	/* now output the result */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;             /* total number of output bytes */
+	/* total number of output bytes */
+	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
-	memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-	memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++)
 	{
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
-		Skein_512_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
-		n = byteCnt - i*SKEIN_512_BLOCK_BYTES;   /* number of output bytes left to go */
+		/* run "counter mode" */
+		Skein_512_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byteCnt - i*SKEIN_512_BLOCK_BYTES;
 		if (n >= SKEIN_512_BLOCK_BYTES)
 			n  = SKEIN_512_BLOCK_BYTES;
-		Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
-		Skein_Show_Final(512, &ctx->h, n, hashVal+i*SKEIN_512_BLOCK_BYTES);
-		memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
+		/* "output" the ctr mode bytes */
+		Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES, ctx->X,
+				      n);
+		Skein_Show_Final(512, &ctx->h, n,
+				 hashVal+i*SKEIN_512_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->X, X, sizeof(X));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -425,21 +530,29 @@ int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
 		break;
 	default:
 		/* here if there is no precomputed IV value available */
-		/* build/process the config block, type == CONFIG (could be precomputed) */
-		Skein_Start_New_Type(ctx, CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
-
-		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);  /* set the schema, version */
-		cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
+		/*
+		 * build/process the config block, type == CONFIG
+		 * (could be precomputed)
+		 */
+		/* set tweaks: T0=0; T1=CFG | FINAL */
+		Skein_Start_New_Type(ctx, CFG_FINAL);
+
+		/* set the schema, version */
+		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+		/* hash result length in bits */
+		cfg.w[1] = Skein_Swap64(hashBitLen);
 		cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
-		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
+		/* zero pad config block */
+		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
 
 		/* compute the initial chaining values from config block */
-		memset(ctx->X, 0, sizeof(ctx->X));            /* zero the chaining variables */
+		/* zero the chaining variables */
+		memset(ctx->X, 0, sizeof(ctx->X));
 		Skein1024_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
 
-	/* The chaining vars ctx->X are now initialized for the given hashBitLen. */
+	/* The chaining vars ctx->X are now initialized for the hashBitLen. */
 	/* Set up to process the data message portion of the hash (default) */
 	Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
 
@@ -448,8 +561,10 @@ int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
-/* [identical to Skein1024_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes)
+/* [identical to Skein1024_Init() when keyBytes == 0 && \
+ *	treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
+			u64 treeInfo, const u8 *key, size_t keyBytes)
 {
 	union
 	{
@@ -463,27 +578,41 @@ int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen, u64 treeInfo
 	/* compute the initial chaining values ctx->X[], based on key */
 	if (keyBytes == 0)                          /* is there a key? */
 	{
-		memset(ctx->X, 0, sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
+		/* no key: use all zeroes as key for config block */
+		memset(ctx->X, 0, sizeof(ctx->X));
 	}
-	else                                        /* here to pre-process a key */
+	else /* here to pre-process a key */
 	{
 		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
-		ctx->h.hashBitLen = 8*sizeof(ctx->X);     /* set output hash bit count = state size */
-		Skein_Start_New_Type(ctx, KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
-		memset(ctx->X, 0, sizeof(ctx->X));        /* zero the initial chaining variables */
-		Skein1024_Update(ctx, key, keyBytes);     /* hash the key */
-		Skein1024_Final_Pad(ctx, cfg.b);         /* put result into cfg.b[] */
-		memcpy(ctx->X, cfg.b, sizeof(cfg.b));     /* copy over into ctx->X[] */
+		/* set output hash bit count = state size */
+		ctx->h.hashBitLen = 8*sizeof(ctx->X);
+		/* set tweaks: T0 = 0; T1 = KEY type */
+		Skein_Start_New_Type(ctx, KEY);
+		/* zero the initial chaining variables */
+		memset(ctx->X, 0, sizeof(ctx->X));
+		/* hash the key */
+		Skein1024_Update(ctx, key, keyBytes);
+		/* put result into cfg.b[] */
+		Skein1024_Final_Pad(ctx, cfg.b);
+		/* copy over into ctx->X[] */
+		memcpy(ctx->X, cfg.b, sizeof(cfg.b));
 	}
-	/* build/process the config block, type == CONFIG (could be precomputed for each key) */
-	ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
+	/*
+	 * build/process the config block, type == CONFIG (could be
+	 * precomputed for each key)
+	 */
+	/* output hash bit count */
+	ctx->h.hashBitLen = hashBitLen;
 	Skein_Start_New_Type(ctx, CFG_FINAL);
 
-	memset(&cfg.w, 0, sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
+	/* pre-pad cfg.w[] with zeroes */
+	memset(&cfg.w, 0, sizeof(cfg.w));
 	cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
-	cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
-	cfg.w[2] = Skein_Swap64(treeInfo);          /* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+	/* hash result length in bits */
+	cfg.w[1] = Skein_Swap64(hashBitLen);
+	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+	cfg.w[2] = Skein_Swap64(treeInfo);
 
 	Skein_Show_Key(1024, &ctx->h, key, keyBytes);
 
@@ -499,35 +628,46 @@ int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen, u64 treeInfo
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt)
+int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
+			size_t msgByteCnt)
 {
 	size_t n;
 
-	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
 	if (msgByteCnt + ctx->h.bCnt > SKEIN1024_BLOCK_BYTES)
 	{
-		if (ctx->h.bCnt)                              /* finish up any buffered message data */
+		/* finish up any buffered message data */
+		if (ctx->h.bCnt)
 		{
-			n = SKEIN1024_BLOCK_BYTES - ctx->h.bCnt;  /* # bytes free in buffer b[] */
+			/* # bytes free in buffer b[] */
+			n = SKEIN1024_BLOCK_BYTES - ctx->h.bCnt;
 			if (n)
 			{
-				Skein_assert(n < msgByteCnt);         /* check on our logic here */
+				/* check on our logic here */
+				Skein_assert(n < msgByteCnt);
 				memcpy(&ctx->b[ctx->h.bCnt], msg, n);
 				msgByteCnt  -= n;
 				msg         += n;
 				ctx->h.bCnt += n;
 			}
 			Skein_assert(ctx->h.bCnt == SKEIN1024_BLOCK_BYTES);
-			Skein1024_Process_Block(ctx, ctx->b, 1, SKEIN1024_BLOCK_BYTES);
+			Skein1024_Process_Block(ctx, ctx->b, 1,
+						SKEIN1024_BLOCK_BYTES);
 			ctx->h.bCnt = 0;
 		}
-		/* now process any remaining full blocks, directly from input message data */
+		/*
+		 * now process any remaining full blocks, directly from input
+		 * message data
+		 */
 		if (msgByteCnt > SKEIN1024_BLOCK_BYTES)
 		{
-			n = (msgByteCnt-1) / SKEIN1024_BLOCK_BYTES;   /* number of full blocks to process */
-			Skein1024_Process_Block(ctx, msg, n, SKEIN1024_BLOCK_BYTES);
+			/* number of full blocks to process */
+			n = (msgByteCnt-1) / SKEIN1024_BLOCK_BYTES;
+			Skein1024_Process_Block(ctx, msg, n,
+						SKEIN1024_BLOCK_BYTES);
 			msgByteCnt -= n * SKEIN1024_BLOCK_BYTES;
 			msg        += n * SKEIN1024_BLOCK_BYTES;
 		}
@@ -551,31 +691,46 @@ int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN1024_STATE_WORDS];
-	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
 
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
-	if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)            /* zero pad b[] if necessary */
-		memset(&ctx->b[ctx->h.bCnt], 0, SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
+	/* tag as the final block */
+	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.bCnt], 0,
+			SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
 
-	Skein1024_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);  /* process the final block */
+	/* process the final block */
+	Skein1024_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
 
 	/* now output the result */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;             /* total number of output bytes */
+	/* total number of output bytes */
+	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
-	memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-	memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++)
 	{
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
-		Skein1024_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
-		n = byteCnt - i*SKEIN1024_BLOCK_BYTES;   /* number of output bytes left to go */
+		/* run "counter mode" */
+		Skein1024_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byteCnt - i*SKEIN1024_BLOCK_BYTES;
 		if (n >= SKEIN1024_BLOCK_BYTES)
 			n  = SKEIN1024_BLOCK_BYTES;
-		Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
-		Skein_Show_Final(1024, &ctx->h, n, hashVal+i*SKEIN1024_BLOCK_BYTES);
-		memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
+		/* "output" the ctr mode bytes */
+		Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES, ctx->X,
+				      n);
+		Skein_Show_Final(1024, &ctx->h, n,
+				 hashVal+i*SKEIN1024_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->X, X, sizeof(X));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -587,14 +742,20 @@ int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
 /* finalize the hash computation and output the block, no OUTPUT stage */
 int Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal)
 {
-	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;        /* tag as the final block */
-	if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)   /* zero pad b[] if necessary */
-		memset(&ctx->b[ctx->h.bCnt], 0, SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
-	Skein_256_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);    /* process the final block */
+	/* tag as the final block */
+	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.bCnt], 0,
+			SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
+	/* process the final block */
+	Skein_256_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
 
-	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_256_BLOCK_BYTES);   /* "output" the state bytes */
+	/* "output" the state bytes */
+	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_256_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -603,14 +764,20 @@ int Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal)
 /* finalize the hash computation and output the block, no OUTPUT stage */
 int Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal)
 {
-	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;        /* tag as the final block */
-	if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)   /* zero pad b[] if necessary */
-		memset(&ctx->b[ctx->h.bCnt], 0, SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
-	Skein_512_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);    /* process the final block */
+	/* tag as the final block */
+	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.bCnt], 0,
+			SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
+	/* process the final block */
+	Skein_512_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
 
-	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_512_BLOCK_BYTES);   /* "output" the state bytes */
+	/* "output" the state bytes */
+	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_512_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -619,14 +786,20 @@ int Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal)
 /* finalize the hash computation and output the block, no OUTPUT stage */
 int Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal)
 {
-	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
 
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;        /* tag as the final block */
-	if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)   /* zero pad b[] if necessary */
-		memset(&ctx->b[ctx->h.bCnt], 0, SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
-	Skein1024_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);    /* process the final block */
+	/* tag as the final block */
+	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	/* zero pad b[] if necessary */
+	if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.bCnt], 0,
+			SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
+	/* process the final block */
+	Skein1024_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
 
-	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN1024_BLOCK_BYTES);   /* "output" the state bytes */
+	/* "output" the state bytes */
+	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN1024_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -638,25 +811,36 @@ int Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN_256_STATE_WORDS];
-	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* now output the result */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;    /* total number of output bytes */
+	/* total number of output bytes */
+	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
-	memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-	memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++)
 	{
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
-		Skein_256_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
-		n = byteCnt - i*SKEIN_256_BLOCK_BYTES;   /* number of output bytes left to go */
+		/* run "counter mode" */
+		Skein_256_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byteCnt - i*SKEIN_256_BLOCK_BYTES;
 		if (n >= SKEIN_256_BLOCK_BYTES)
 			n  = SKEIN_256_BLOCK_BYTES;
-		Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
-		Skein_Show_Final(256, &ctx->h, n, hashVal+i*SKEIN_256_BLOCK_BYTES);
-		memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
+		/* "output" the ctr mode bytes */
+		Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES, ctx->X,
+				      n);
+		Skein_Show_Final(256, &ctx->h, n,
+				 hashVal+i*SKEIN_256_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->X, X, sizeof(X));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -667,25 +851,36 @@ int Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN_512_STATE_WORDS];
-	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* now output the result */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;    /* total number of output bytes */
+	/* total number of output bytes */
+	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
-	memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-	memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++)
 	{
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
-		Skein_512_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
-		n = byteCnt - i*SKEIN_512_BLOCK_BYTES;   /* number of output bytes left to go */
+		/* run "counter mode" */
+		Skein_512_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byteCnt - i*SKEIN_512_BLOCK_BYTES;
 		if (n >= SKEIN_512_BLOCK_BYTES)
 			n  = SKEIN_512_BLOCK_BYTES;
-		Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
-		Skein_Show_Final(256, &ctx->h, n, hashVal+i*SKEIN_512_BLOCK_BYTES);
-		memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
+		/* "output" the ctr mode bytes */
+		Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES, ctx->X,
+				      n);
+		Skein_Show_Final(256, &ctx->h, n,
+				 hashVal+i*SKEIN_512_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->X, X, sizeof(X));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -696,25 +891,36 @@ int Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN1024_STATE_WORDS];
-	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);    /* catch uninitialized context */
+	/* catch uninitialized context */
+	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* now output the result */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;    /* total number of output bytes */
+	/* total number of output bytes */
+	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
-	memset(ctx->b, 0, sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
-	memcpy(X, ctx->X, sizeof(X));       /* keep a local copy of counter mode "key" */
+	/* zero out b[], so it can hold the counter */
+	memset(ctx->b, 0, sizeof(ctx->b));
+	/* keep a local copy of counter mode "key" */
+	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++)
 	{
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i); /* build the counter block */
+		/* build the counter block */
+		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
-		Skein1024_Process_Block(ctx, ctx->b, 1, sizeof(u64)); /* run "counter mode" */
-		n = byteCnt - i*SKEIN1024_BLOCK_BYTES;   /* number of output bytes left to go */
+		/* run "counter mode" */
+		Skein1024_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		/* number of output bytes left to go */
+		n = byteCnt - i*SKEIN1024_BLOCK_BYTES;
 		if (n >= SKEIN1024_BLOCK_BYTES)
 			n  = SKEIN1024_BLOCK_BYTES;
-		Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES, ctx->X, n);   /* "output" the ctr mode bytes */
-		Skein_Show_Final(256, &ctx->h, n, hashVal+i*SKEIN1024_BLOCK_BYTES);
-		memcpy(ctx->X, X, sizeof(X));   /* restore the counter mode key for next time */
+		/* "output" the ctr mode bytes */
+		Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES, ctx->X,
+				      n);
+		Skein_Show_Final(256, &ctx->h, n,
+				 hashVal+i*SKEIN1024_BLOCK_BYTES);
+		/* restore the counter mode key for next time */
+		memcpy(ctx->X, X, sizeof(X));
 	}
 	return SKEIN_SUCCESS;
 }
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index 3ebb1d60ef93..f0015d5b10f5 100644
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -46,9 +46,9 @@ int skeinInit(struct skein_ctx *ctx, size_t hashBitLen)
 
 	Skein_Assert(ctx, SKEIN_FAIL);
 	/*
-	 * The following two lines rely of the fact that the real Skein contexts are
-	 * a union in out context and thus have tha maximum memory available.
-	 * The beauty of C :-) .
+	 * The following two lines rely of the fact that the real Skein
+	 * contexts are a union in out context and thus have tha maximum
+	 * memory available.  The beauty of C :-) .
 	 */
 	X = ctx->m.s256.X;
 	Xlen = ctx->skeinSize/8;
@@ -72,7 +72,10 @@ int skeinInit(struct skein_ctx *ctx, size_t hashBitLen)
 	}
 
 	if (ret == SKEIN_SUCCESS) {
-		/* Save chaining variables for this combination of size and hashBitLen */
+		/*
+		 * Save chaining variables for this combination of size and
+		 * hashBitLen
+		 */
 		memcpy(ctx->XSave, X, Xlen);
 	}
 	return ret;
@@ -113,7 +116,10 @@ int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
 		break;
 	}
 	if (ret == SKEIN_SUCCESS) {
-		/* Save chaining variables for this combination of key, keyLen, hashBitLen */
+		/*
+		 * Save chaining variables for this combination of key,
+		 * keyLen, hashBitLen
+		 */
 		memcpy(ctx->XSave, X, Xlen);
 	}
 	return ret;
@@ -125,9 +131,9 @@ void skeinReset(struct skein_ctx *ctx)
 	u64 *X = NULL;
 
 	/*
-	 * The following two lines rely of the fact that the real Skein contexts are
-	 * a union in out context and thus have tha maximum memory available.
-	 * The beautiy of C :-) .
+	 * The following two lines rely of the fact that the real Skein
+	 * contexts are a union in out context and thus have tha maximum
+	 * memory available.  The beautiy of C :-) .
 	 */
 	X = ctx->m.s256.X;
 	Xlen = ctx->skeinSize/8;
@@ -146,13 +152,16 @@ int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
 
 	switch (ctx->skeinSize) {
 	case Skein256:
-		ret = Skein_256_Update(&ctx->m.s256, (const u8 *)msg, msgByteCnt);
+		ret = Skein_256_Update(&ctx->m.s256, (const u8 *)msg,
+					msgByteCnt);
 		break;
 	case Skein512:
-		ret = Skein_512_Update(&ctx->m.s512, (const u8 *)msg, msgByteCnt);
+		ret = Skein_512_Update(&ctx->m.s512, (const u8 *)msg,
+					msgByteCnt);
 		break;
 	case Skein1024:
-		ret = Skein1024_Update(&ctx->m.s1024, (const u8 *)msg, msgByteCnt);
+		ret = Skein1024_Update(&ctx->m.s1024, (const u8 *)msg,
+					msgByteCnt);
 		break;
 	}
 	return ret;
@@ -164,15 +173,19 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
 {
 	/*
 	 * I've used the bit pad implementation from skein_test.c (see NIST CD)
-	 * and modified it to use the convenience functions and added some pointer
-	 * arithmetic.
+	 * and modified it to use the convenience functions and added some
+	 * pointer arithmetic.
 	 */
 	size_t length;
 	u8 mask;
 	u8 *up;
 
-	/* only the final Update() call is allowed do partial bytes, else assert an error */
-	Skein_Assert((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 || msgBitCnt == 0, SKEIN_FAIL);
+	/*
+	 * only the final Update() call is allowed do partial bytes, else
+	 * assert an error
+	 */
+	Skein_Assert((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 ||
+			msgBitCnt == 0, SKEIN_FAIL);
 
 	/* if number of bits is a multiple of bytes - that's easy */
 	if ((msgBitCnt & 0x7) == 0) {
@@ -188,13 +201,18 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
 	 */
 	up = (u8 *)ctx->m.s256.X + ctx->skeinSize / 8;
 
-	Skein_Set_Bit_Pad_Flag(ctx->m.h);                       /* set tweak flag for the skeinFinal call */
+	/* set tweak flag for the skeinFinal call */
+	Skein_Set_Bit_Pad_Flag(ctx->m.h);
 
 	/* now "pad" the final partial byte the way NIST likes */
-	length = ctx->m.h.bCnt;                                 /* get the bCnt value (same location for all block sizes) */
-	Skein_assert(length != 0);                              /* internal sanity check: there IS a partial byte in the buffer! */
-	mask = (u8) (1u << (7 - (msgBitCnt & 7)));         /* partial byte bit mask */
-	up[length-1]  = (u8)((up[length-1] & (0-mask))|mask);   /* apply bit padding on final byte (in the buffer) */
+	/* get the bCnt value (same location for all block sizes) */
+	length = ctx->m.h.bCnt;
+	/* internal sanity check: there IS a partial byte in the buffer! */
+	Skein_assert(length != 0);
+	/* partial byte bit mask */
+	mask = (u8) (1u << (7 - (msgBitCnt & 7)));
+	/* apply bit padding on final byte (in the buffer) */
+	up[length-1]  = (u8)((up[length-1] & (0-mask))|mask);
 
 	return SKEIN_SUCCESS;
 }
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 376cd63d8f83..69176389fef9 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -11,10 +11,10 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 	struct threefish_key key;
 	u64 tweak[2];
 	int i;
-	u64  w[SKEIN_256_STATE_WORDS];           /* local copy of input block */
+	u64  w[SKEIN_256_STATE_WORDS]; /* local copy of input block */
 	u64 words[3];
 
-	Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
 	tweak[0] = ctx->h.T[0];
 	tweak[1] = ctx->h.T[1];
 
@@ -36,13 +36,14 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 
 		threefishSetKey(&key, Threefish256, ctx->X, tweak);
 
-		Skein_Get64_LSB_First(w, blkPtr, SKEIN_256_STATE_WORDS);   /* get input block in little-endian format */
+		/* get input block in little-endian format */
+		Skein_Get64_LSB_First(w, blkPtr, SKEIN_256_STATE_WORDS);
 
 		threefishEncryptBlockWords(&key, w, ctx->X);
 
 		blkPtr += SKEIN_256_BLOCK_BYTES;
 
-		/* do the final "feedforward" xor, update context chaining vars */
+		/* do the final "feedforward" xor, update ctx chaining vars */
 		ctx->X[0] = ctx->X[0] ^ w[0];
 		ctx->X[1] = ctx->X[1] ^ w[1];
 		ctx->X[2] = ctx->X[2] ^ w[2];
@@ -62,9 +63,9 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 	u64 tweak[2];
 	int i;
 	u64 words[3];
-	u64  w[SKEIN_512_STATE_WORDS];           /* local copy of input block */
+	u64  w[SKEIN_512_STATE_WORDS]; /* local copy of input block */
 
-	Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
 	tweak[0] = ctx->h.T[0];
 	tweak[1] = ctx->h.T[1];
 
@@ -86,13 +87,14 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 
 		threefishSetKey(&key, Threefish512, ctx->X, tweak);
 
-		Skein_Get64_LSB_First(w, blkPtr, SKEIN_512_STATE_WORDS);   /* get input block in little-endian format */
+		/* get input block in little-endian format */
+		Skein_Get64_LSB_First(w, blkPtr, SKEIN_512_STATE_WORDS);
 
 		threefishEncryptBlockWords(&key, w, ctx->X);
 
 		blkPtr += SKEIN_512_BLOCK_BYTES;
 
-		/* do the final "feedforward" xor, update context chaining vars */
+		/* do the final "feedforward" xor, update ctx chaining vars */
 		ctx->X[0] = ctx->X[0] ^ w[0];
 		ctx->X[1] = ctx->X[1] ^ w[1];
 		ctx->X[2] = ctx->X[2] ^ w[2];
@@ -116,9 +118,9 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 	u64 tweak[2];
 	int i;
 	u64 words[3];
-	u64  w[SKEIN1024_STATE_WORDS];           /* local copy of input block */
+	u64  w[SKEIN1024_STATE_WORDS]; /* local copy of input block */
 
-	Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
 	tweak[0] = ctx->h.T[0];
 	tweak[1] = ctx->h.T[1];
 
@@ -140,13 +142,14 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 
 		threefishSetKey(&key, Threefish1024, ctx->X, tweak);
 
-		Skein_Get64_LSB_First(w, blkPtr, SKEIN1024_STATE_WORDS);   /* get input block in little-endian format */
+		/* get input block in little-endian format */
+		Skein_Get64_LSB_First(w, blkPtr, SKEIN1024_STATE_WORDS);
 
 		threefishEncryptBlockWords(&key, w, ctx->X);
 
 		blkPtr += SKEIN1024_BLOCK_BYTES;
 
-		/* do the final "feedforward" xor, update context chaining vars */
+		/* do the final "feedforward" xor, update ctx chaining vars */
 		ctx->X[0]  = ctx->X[0]  ^ w[0];
 		ctx->X[1]  = ctx->X[1]  ^ w[1];
 		ctx->X[2]  = ctx->X[2]  ^ w[2];
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index d315f547feae..780b4936f783 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -18,14 +18,14 @@
 #include <skein.h>
 
 #ifndef SKEIN_USE_ASM
-#define SKEIN_USE_ASM   (0)                     /* default is all C code (no ASM) */
+#define SKEIN_USE_ASM   (0) /* default is all C code (no ASM) */
 #endif
 
 #ifndef SKEIN_LOOP
-#define SKEIN_LOOP 001                          /* default: unroll 256 and 512, but not 1024 */
+#define SKEIN_LOOP 001 /* default: unroll 256 and 512, but not 1024 */
 #endif
 
-#define BLK_BITS        (WCNT*64)               /* some useful definitions for code here */
+#define BLK_BITS        (WCNT*64) /* some useful definitions for code here */
 #define KW_TWK_BASE     (0)
 #define KW_KEY_BASE     (3)
 #define ks              (kw + KW_KEY_BASE)
@@ -39,7 +39,8 @@
 
 /*****************************  Skein_256 ******************************/
 #if !(SKEIN_USE_ASM & 256)
-void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd)
+void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd)
 	{ /* do it in C */
 	enum {
 		WCNT = SKEIN_256_STATE_WORDS
@@ -47,7 +48,7 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t
 #undef  RCNT
 #define RCNT  (SKEIN_256_ROUNDS_TOTAL/8)
 
-#ifdef SKEIN_LOOP                              /* configure how much to unroll the loop */
+#ifdef SKEIN_LOOP /* configure how much to unroll the loop */
 #define SKEIN_UNROLL_256 (((SKEIN_LOOP)/100)%10)
 #else
 #define SKEIN_UNROLL_256 (0)
@@ -55,25 +56,28 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t
 
 #if SKEIN_UNROLL_256
 #if (RCNT % SKEIN_UNROLL_256)
-#error "Invalid SKEIN_UNROLL_256"               /* sanity check on unroll count */
+#error "Invalid SKEIN_UNROLL_256" /* sanity check on unroll count */
 #endif
 	size_t  r;
-	u64  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
+	u64  kw[WCNT+4+RCNT*2]; /* key schedule: chaining vars + tweak + "rot"*/
 #else
-	u64  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
+	u64  kw[WCNT+4]; /* key schedule words : chaining vars + tweak */
 #endif
-	u64  X0, X1, X2, X3;                        /* local copy of context vars, for speed */
-	u64  w[WCNT];                           /* local copy of input block */
+	u64  X0, X1, X2, X3; /* local copy of context vars, for speed */
+	u64  w[WCNT]; /* local copy of input block */
 #ifdef SKEIN_DEBUG
-	const u64 *Xptr[4];                      /* use for debugging (help compiler put Xn in registers) */
+	const u64 *Xptr[4]; /* use for debugging (help cc put Xn in regs) */
 	Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
 #endif
-	Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
 	ts[0] = ctx->h.T[0];
 	ts[1] = ctx->h.T[1];
 	do  {
-		/* this implementation only supports 2**64 input bytes (no carry out here) */
-		ts[0] += byteCntAdd;                    /* update processed length */
+		/*
+		 * this implementation only supports 2**64 input bytes
+		 * (no carry out here)
+		 */
+		ts[0] += byteCntAdd; /* update processed length */
 
 		/* precompute the key schedule for this block */
 		ks[0] = ctx->X[0];
@@ -84,16 +88,19 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t
 
 		ts[2] = ts[0] ^ ts[1];
 
-		Skein_Get64_LSB_First(w, blkPtr, WCNT);   /* get input block in little-endian format */
+		/* get input block in little-endian format */
+		Skein_Get64_LSB_First(w, blkPtr, WCNT);
 		DebugSaveTweak(ctx);
 		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blkPtr, w, ks, ts);
 
-		X0 = w[0] + ks[0];                      /* do the first full key injection */
+		X0 = w[0] + ks[0]; /* do the first full key injection */
 		X1 = w[1] + ks[1] + ts[0];
 		X2 = w[2] + ks[2] + ts[1];
 		X3 = w[3] + ks[3];
 
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL, Xptr);    /* show starting state values */
+		/* show starting state values */
+		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
+				 Xptr);
 
 		blkPtr += SKEIN_256_BLOCK_BYTES;
 
@@ -104,31 +111,34 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t
 	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
 
 #if SKEIN_UNROLL_256 == 0
-#define R256(p0, p1, p2, p3, ROT, rNum)           /* fully unrolled */   \
-	Round256(p0, p1, p2, p3, ROT, rNum)                                  \
+#define R256(p0, p1, p2, p3, ROT, rNum) /* fully unrolled */ \
+	Round256(p0, p1, p2, p3, ROT, rNum) \
 	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr);
 
-#define I256(R)                                                     \
-	X0   += ks[((R)+1) % 5];    /* inject the key schedule value */ \
-	X1   += ks[((R)+2) % 5] + ts[((R)+1) % 3];                      \
-	X2   += ks[((R)+3) % 5] + ts[((R)+2) % 3];                      \
-	X3   += ks[((R)+4) % 5] +     (R)+1;                            \
+#define I256(R) \
+	/* inject the key schedule value */ \
+	X0   += ks[((R)+1) % 5]; \
+	X1   += ks[((R)+2) % 5] + ts[((R)+1) % 3]; \
+	X2   += ks[((R)+3) % 5] + ts[((R)+2) % 3]; \
+	X3   += ks[((R)+4) % 5] +     (R)+1;       \
 	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
-#else                                       /* looping version */
-#define R256(p0, p1, p2, p3, ROT, rNum)                                  \
-	Round256(p0, p1, p2, p3, ROT, rNum)                                  \
+#else /* looping version */
+#define R256(p0, p1, p2, p3, ROT, rNum) \
+	Round256(p0, p1, p2, p3, ROT, rNum) \
 	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr);
 
-#define I256(R)                                                     \
-	X0   += ks[r+(R)+0];        /* inject the key schedule value */ \
-	X1   += ks[r+(R)+1] + ts[r+(R)+0];                              \
-	X2   += ks[r+(R)+2] + ts[r+(R)+1];                              \
-	X3   += ks[r+(R)+3] +    r+(R);                              \
-	ks[r + (R) + 4]   = ks[r + (R) - 1];     /* rotate key schedule */\
-	ts[r + (R) + 2]   = ts[r + (R) - 1];                              \
+#define I256(R) \
+	/* inject the key schedule value */ \
+	X0   += ks[r+(R)+0]; \
+	X1   += ks[r+(R)+1] + ts[r+(R)+0]; \
+	X2   += ks[r+(R)+2] + ts[r+(R)+1]; \
+	X3   += ks[r+(R)+3] +    r+(R);    \
+	/* rotate key schedule */ \
+	ks[r + (R) + 4]   = ks[r + (R) - 1]; \
+	ts[r + (R) + 2]   = ts[r + (R) - 1]; \
 	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
 
-	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_256)  /* loop thru it */
+	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_256)
 #endif
 		{
 #define R256_8_rounds(R)                  \
@@ -145,7 +155,10 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t
 
 		R256_8_rounds(0);
 
-#define R256_Unroll_R(NN) ((SKEIN_UNROLL_256 == 0 && SKEIN_256_ROUNDS_TOTAL/8 > (NN)) || (SKEIN_UNROLL_256 > (NN)))
+#define R256_Unroll_R(NN) \
+	((SKEIN_UNROLL_256 == 0 && \
+	  SKEIN_256_ROUNDS_TOTAL/8 > (NN)) || \
+	 (SKEIN_UNROLL_256 > (NN)))
 
 	#if   R256_Unroll_R(1)
 		R256_8_rounds(1);
@@ -193,7 +206,7 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t
 #error  "need more unrolling in Skein_256_Process_Block"
 	#endif
 		}
-		/* do the final "feedforward" xor, update context chaining vars */
+		/* do the final "feedforward" xor, update context chaining */
 		ctx->X[0] = X0 ^ w[0];
 		ctx->X[1] = X1 ^ w[1];
 		ctx->X[2] = X2 ^ w[2];
@@ -223,7 +236,8 @@ unsigned int Skein_256_Unroll_Cnt(void)
 
 /*****************************  Skein_512 ******************************/
 #if !(SKEIN_USE_ASM & 512)
-void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd)
+void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
+				size_t blkCnt, size_t byteCntAdd)
 { /* do it in C */
 	enum {
 		WCNT = SKEIN_512_STATE_WORDS
@@ -231,7 +245,7 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t
 #undef  RCNT
 #define RCNT  (SKEIN_512_ROUNDS_TOTAL/8)
 
-#ifdef SKEIN_LOOP                              /* configure how much to unroll the loop */
+#ifdef SKEIN_LOOP /* configure how much to unroll the loop */
 #define SKEIN_UNROLL_512 (((SKEIN_LOOP)/10)%10)
 #else
 #define SKEIN_UNROLL_512 (0)
@@ -239,27 +253,30 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t
 
 #if SKEIN_UNROLL_512
 #if (RCNT % SKEIN_UNROLL_512)
-#error "Invalid SKEIN_UNROLL_512"               /* sanity check on unroll count */
+#error "Invalid SKEIN_UNROLL_512" /* sanity check on unroll count */
 #endif
 	size_t  r;
-	u64  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
+	u64  kw[WCNT+4+RCNT*2]; /* key sched: chaining vars + tweak + "rot"*/
 #else
-	u64  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
+	u64  kw[WCNT+4]; /* key schedule words : chaining vars + tweak */
 #endif
-	u64  X0, X1, X2, X3, X4, X5, X6, X7;            /* local copy of vars,  for speed */
-	u64  w[WCNT];                           /* local copy of input block */
+	u64  X0, X1, X2, X3, X4, X5, X6, X7; /* local copies, for speed */
+	u64  w[WCNT]; /* local copy of input block */
 #ifdef SKEIN_DEBUG
-	const u64 *Xptr[8];                      /* use for debugging (help compiler put Xn in registers) */
+	const u64 *Xptr[8]; /* use for debugging (help cc put Xn in regs) */
 	Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
 	Xptr[4] = &X4;  Xptr[5] = &X5;  Xptr[6] = &X6;  Xptr[7] = &X7;
 #endif
 
-	Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
 	ts[0] = ctx->h.T[0];
 	ts[1] = ctx->h.T[1];
 	do  {
-		/* this implementation only supports 2**64 input bytes (no carry out here) */
-		ts[0] += byteCntAdd;                    /* update processed length */
+		/*
+		 * this implementation only supports 2**64 input bytes
+		 * (no carry out here)
+		 */
+		ts[0] += byteCntAdd; /* update processed length */
 
 		/* precompute the key schedule for this block */
 		ks[0] = ctx->X[0];
@@ -275,11 +292,12 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t
 
 		ts[2] = ts[0] ^ ts[1];
 
-		Skein_Get64_LSB_First(w, blkPtr, WCNT); /* get input block in little-endian format */
+		/* get input block in little-endian format */
+		Skein_Get64_LSB_First(w, blkPtr, WCNT);
 		DebugSaveTweak(ctx);
 		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blkPtr, w, ks, ts);
 
-		X0   = w[0] + ks[0];                    /* do the first full key injection */
+		X0   = w[0] + ks[0]; /* do the first full key injection */
 		X1   = w[1] + ks[1];
 		X2   = w[2] + ks[2];
 		X3   = w[3] + ks[3];
@@ -290,65 +308,72 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t
 
 		blkPtr += SKEIN_512_BLOCK_BYTES;
 
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL, Xptr);
+		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
+				 Xptr);
 		/* run the rounds */
-#define Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)                  \
-		X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
-		X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
-		X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4; \
-		X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6; \
+#define Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
+	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
+	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
+	X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4; \
+	X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6; \
 
 #if SKEIN_UNROLL_512 == 0
-#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)      /* unrolled */  \
-		Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)                      \
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr);
-
-#define I512(R)                                                     \
-		X0   += ks[((R) + 1) % 9];   /* inject the key schedule value */  \
-		X1   += ks[((R) + 2) % 9];                                        \
-		X2   += ks[((R) + 3) % 9];                                        \
-		X3   += ks[((R) + 4) % 9];                                        \
-		X4   += ks[((R) + 5) % 9];                                        \
-		X5   += ks[((R) + 6) % 9] + ts[((R) + 1) % 3];                      \
-		X6   += ks[((R) + 7) % 9] + ts[((R) + 2) % 3];                      \
-		X7   += ks[((R) + 8) % 9] +     (R) + 1;                            \
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
-#else                                       /* looping version */
-#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)                      \
-		Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)                      \
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr);
-
-#define I512(R)                                                     \
-		X0   += ks[r + (R) + 0];        /* inject the key schedule value */ \
-		X1   += ks[r + (R) + 1];                                            \
-		X2   += ks[r + (R) + 2];                                            \
-		X3   += ks[r + (R) + 3];                                            \
-		X4   += ks[r + (R) + 4];                                            \
-		X5   += ks[r + (R) + 5] + ts[r + (R) + 0];                              \
-		X6   += ks[r + (R) + 6] + ts[r + (R) + 1];                              \
-		X7   += ks[r + (R) + 7] +         r + (R);                              \
-		ks[r +         (R) + 8] = ks[r + (R) - 1];  /* rotate key schedule */   \
-		ts[r +         (R) + 2] = ts[r + (R) - 1];                              \
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
-
-		for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)   /* loop thru it */
-#endif                         /* end of looped code definitions */
+#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) /* unrolled */ \
+	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr);
+
+#define I512(R) \
+	/* inject the key schedule value */ \
+	X0   += ks[((R) + 1) % 9]; \
+	X1   += ks[((R) + 2) % 9]; \
+	X2   += ks[((R) + 3) % 9]; \
+	X3   += ks[((R) + 4) % 9]; \
+	X4   += ks[((R) + 5) % 9]; \
+	X5   += ks[((R) + 6) % 9] + ts[((R) + 1) % 3]; \
+	X6   += ks[((R) + 7) % 9] + ts[((R) + 2) % 3]; \
+	X7   += ks[((R) + 8) % 9] +     (R) + 1;       \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+#else /* looping version */
+#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
+	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr);
+
+#define I512(R) \
+	/* inject the key schedule value */ \
+	X0   += ks[r + (R) + 0]; \
+	X1   += ks[r + (R) + 1]; \
+	X2   += ks[r + (R) + 2]; \
+	X3   += ks[r + (R) + 3]; \
+	X4   += ks[r + (R) + 4]; \
+	X5   += ks[r + (R) + 5] + ts[r + (R) + 0]; \
+	X6   += ks[r + (R) + 6] + ts[r + (R) + 1]; \
+	X7   += ks[r + (R) + 7] +         r + (R); \
+	/* rotate key schedule */ \
+	ks[r +         (R) + 8] = ks[r + (R) - 1]; \
+	ts[r +         (R) + 2] = ts[r + (R) - 1]; \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+
+		for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
+#endif /* end of looped code definitions */
 		{
 #define R512_8_rounds(R)  /* do 8 full rounds */  \
-			R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_0, 8 * (R) + 1);   \
-			R512(2, 1, 4, 7, 6, 5, 0, 3, R_512_1, 8 * (R) + 2);   \
-			R512(4, 1, 6, 3, 0, 5, 2, 7, R_512_2, 8 * (R) + 3);   \
-			R512(6, 1, 0, 7, 2, 5, 4, 3, R_512_3, 8 * (R) + 4);   \
-			I512(2 * (R));                              \
-			R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_4, 8 * (R) + 5);   \
-			R512(2, 1, 4, 7, 6, 5, 0, 3, R_512_5, 8 * (R) + 6);   \
-			R512(4, 1, 6, 3, 0, 5, 2, 7, R_512_6, 8 * (R) + 7);   \
-			R512(6, 1, 0, 7, 2, 5, 4, 3, R_512_7, 8 * (R) + 8);   \
-			I512(2 * (R) + 1);        /* and key injection */
+		R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_0, 8 * (R) + 1);   \
+		R512(2, 1, 4, 7, 6, 5, 0, 3, R_512_1, 8 * (R) + 2);   \
+		R512(4, 1, 6, 3, 0, 5, 2, 7, R_512_2, 8 * (R) + 3);   \
+		R512(6, 1, 0, 7, 2, 5, 4, 3, R_512_3, 8 * (R) + 4);   \
+		I512(2 * (R));                              \
+		R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_4, 8 * (R) + 5);   \
+		R512(2, 1, 4, 7, 6, 5, 0, 3, R_512_5, 8 * (R) + 6);   \
+		R512(4, 1, 6, 3, 0, 5, 2, 7, R_512_6, 8 * (R) + 7);   \
+		R512(6, 1, 0, 7, 2, 5, 4, 3, R_512_7, 8 * (R) + 8);   \
+		I512(2 * (R) + 1);        /* and key injection */
 
 			R512_8_rounds(0);
 
-#define R512_Unroll_R(NN) ((SKEIN_UNROLL_512 == 0 && SKEIN_512_ROUNDS_TOTAL/8 > (NN)) || (SKEIN_UNROLL_512 > (NN)))
+#define R512_Unroll_R(NN) \
+		((SKEIN_UNROLL_512 == 0 && \
+		  SKEIN_512_ROUNDS_TOTAL/8 > (NN)) || \
+		 (SKEIN_UNROLL_512 > (NN)))
 
 	#if   R512_Unroll_R(1)
 			R512_8_rounds(1);
@@ -397,7 +422,7 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t
 	#endif
 		}
 
-		/* do the final "feedforward" xor, update context chaining vars */
+		/* do the final "feedforward" xor, update context chaining */
 		ctx->X[0] = X0 ^ w[0];
 		ctx->X[1] = X1 ^ w[1];
 		ctx->X[2] = X2 ^ w[2];
@@ -430,7 +455,8 @@ unsigned int Skein_512_Unroll_Cnt(void)
 
 /*****************************  Skein1024 ******************************/
 #if !(SKEIN_USE_ASM & 1024)
-void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t blkCnt, size_t byteCntAdd)
+void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, \
+				size_t blkCnt, size_t byteCntAdd)
 { /* do it in C, always looping (unrolled is bigger AND slower!) */
 	enum {
 		WCNT = SKEIN1024_STATE_WORDS
@@ -438,7 +464,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t
 #undef  RCNT
 #define RCNT  (SKEIN1024_ROUNDS_TOTAL/8)
 
-#ifdef SKEIN_LOOP                              /* configure how much to unroll the loop */
+#ifdef SKEIN_LOOP /* configure how much to unroll the loop */
 #define SKEIN_UNROLL_1024 ((SKEIN_LOOP)%10)
 #else
 #define SKEIN_UNROLL_1024 (0)
@@ -446,31 +472,35 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t
 
 #if (SKEIN_UNROLL_1024 != 0)
 #if (RCNT % SKEIN_UNROLL_1024)
-#error "Invalid SKEIN_UNROLL_1024"              /* sanity check on unroll count */
+#error "Invalid SKEIN_UNROLL_1024" /* sanity check on unroll count */
 #endif
 	size_t  r;
-	u64  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
+	u64  kw[WCNT+4+RCNT*2]; /* key sched: chaining vars + tweak + "rot" */
 #else
-	u64  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
+	u64  kw[WCNT+4]; /* key schedule words : chaining vars + tweak */
 #endif
 
-	u64  X00, X01, X02, X03, X04, X05, X06, X07,     /* local copy of vars, for speed */
-		X08, X09, X10, X11, X12, X13, X14, X15;
-	u64  w[WCNT];                            /* local copy of input block */
+	/* local copy of vars, for speed */
+	u64  X00, X01, X02, X03, X04, X05, X06, X07,
+	     X08, X09, X10, X11, X12, X13, X14, X15;
+	u64  w[WCNT]; /* local copy of input block */
 #ifdef SKEIN_DEBUG
-	const u64 *Xptr[16];                     /* use for debugging (help compiler put Xn in registers) */
+	const u64 *Xptr[16]; /* use for debugging (help cc put Xn in regs) */
 	Xptr[0]  = &X00;  Xptr[1]  = &X01;  Xptr[2]  = &X02;  Xptr[3]  = &X03;
 	Xptr[4]  = &X04;  Xptr[5]  = &X05;  Xptr[6]  = &X06;  Xptr[7]  = &X07;
 	Xptr[8]  = &X08;  Xptr[9]  = &X09;  Xptr[10] = &X10;  Xptr[11] = &X11;
 	Xptr[12] = &X12;  Xptr[13] = &X13;  Xptr[14] = &X14;  Xptr[15] = &X15;
 #endif
 
-	Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
 	ts[0] = ctx->h.T[0];
 	ts[1] = ctx->h.T[1];
 	do  {
-		/* this implementation only supports 2**64 input bytes (no carry out here) */
-		ts[0] += byteCntAdd;                    /* update processed length */
+		/*
+		 * this implementation only supports 2**64 input bytes
+		 * (no carry out here)
+		 */
+		ts[0] += byteCntAdd; /* update processed length */
 
 		/* precompute the key schedule for this block */
 		ks[0]  = ctx->X[0];
@@ -496,11 +526,12 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t
 
 		ts[2]  = ts[0] ^ ts[1];
 
-		Skein_Get64_LSB_First(w, blkPtr, WCNT); /* get input block in little-endian format */
+		/* get input block in little-endian format */
+		Skein_Get64_LSB_First(w, blkPtr, WCNT);
 		DebugSaveTweak(ctx);
 		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blkPtr, w, ks, ts);
 
-		X00    =  w[0] +  ks[0];                 /* do the first full key injection */
+		X00    =  w[0] +  ks[0]; /* do the first full key injection */
 		X01    =  w[1] +  ks[1];
 		X02    =  w[2] +  ks[2];
 		X03    =  w[3] +  ks[3];
@@ -517,85 +548,105 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t
 		X14    = w[14] + ks[14] + ts[1];
 		X15    = w[15] + ks[15];
 
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL, Xptr);
+		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
+				 Xptr);
 
-#define Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rNum) \
-		X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0;   \
-		X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2;   \
-		X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4;   \
-		X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6;   \
-		X##p8 += X##p9; X##p9 = RotL_64(X##p9, ROT##_4); X##p9 ^= X##p8;   \
-		X##pA += X##pB; X##pB = RotL_64(X##pB, ROT##_5); X##pB ^= X##pA;   \
-		X##pC += X##pD; X##pD = RotL_64(X##pD, ROT##_6); X##pD ^= X##pC;   \
-		X##pE += X##pF; X##pF = RotL_64(X##pF, ROT##_7); X##pF ^= X##pE;   \
+#define Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
+			pF, ROT, rNum) \
+	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0;   \
+	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2;   \
+	X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4;   \
+	X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6;   \
+	X##p8 += X##p9; X##p9 = RotL_64(X##p9, ROT##_4); X##p9 ^= X##p8;   \
+	X##pA += X##pB; X##pB = RotL_64(X##pB, ROT##_5); X##pB ^= X##pA;   \
+	X##pC += X##pD; X##pD = RotL_64(X##pD, ROT##_6); X##pD ^= X##pC;   \
+	X##pE += X##pF; X##pF = RotL_64(X##pF, ROT##_7); X##pF ^= X##pE;   \
 
 #if SKEIN_UNROLL_1024 == 0
-#define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
-		Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rn, Xptr);
-
-#define I1024(R)                                                        \
-		X00   += ks[((R) +  1) % 17]; /* inject the key schedule value */   \
-		X01   += ks[((R) +  2) % 17];                                       \
-		X02   += ks[((R) +  3) % 17];                                       \
-		X03   += ks[((R) +  4) % 17];                                       \
-		X04   += ks[((R) +  5) % 17];                                       \
-		X05   += ks[((R) +  6) % 17];                                       \
-		X06   += ks[((R) +  7) % 17];                                       \
-		X07   += ks[((R) +  8) % 17];                                       \
-		X08   += ks[((R) +  9) % 17];                                       \
-		X09   += ks[((R) + 10) % 17];                                       \
-		X10   += ks[((R) + 11) % 17];                                       \
-		X11   += ks[((R) + 12) % 17];                                       \
-		X12   += ks[((R) + 13) % 17];                                       \
-		X13   += ks[((R) + 14) % 17] + ts[((R) + 1) % 3];                   \
-		X14   += ks[((R) + 15) % 17] + ts[((R) + 2) % 3];                   \
-		X15   += ks[((R) + 16) % 17] +     (R) + 1;                         \
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
-#else                                       /* looping version */
-#define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
-		Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, Xptr);
-
-#define I1024(R)                                                      \
-		X00   += ks[r + (R) +  0];    /* inject the key schedule value */     \
-		X01   += ks[r + (R) +  1];                                            \
-		X02   += ks[r + (R) +  2];                                            \
-		X03   += ks[r + (R) +  3];                                            \
-		X04   += ks[r + (R) +  4];                                            \
-		X05   += ks[r + (R) +  5];                                            \
-		X06   += ks[r + (R) +  6];                                            \
-		X07   += ks[r + (R) +  7];                                            \
-		X08   += ks[r + (R) +  8];                                            \
-		X09   += ks[r + (R) +  9];                                            \
-		X10   += ks[r + (R) + 10];                                            \
-		X11   += ks[r + (R) + 11];                                            \
-		X12   += ks[r + (R) + 12];                                            \
-		X13   += ks[r + (R) + 13] + ts[r + (R) + 0];                          \
-		X14   += ks[r + (R) + 14] + ts[r + (R) + 1];                          \
-		X15   += ks[r + (R) + 15] +         r + (R);                          \
-		ks[r  +         (R) + 16] = ks[r + (R) - 1]; /* rotate key schedule */\
-		ts[r  +         (R) +  2] = ts[r + (R) - 1];                          \
-		Skein_Show_R_Ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
-
-		for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)    /* loop thru it */
+#define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
+		ROT, rn) \
+	Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
+			pF, ROT, rn) \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rn, Xptr);
+
+#define I1024(R) \
+	/* inject the key schedule value */ \
+	X00   += ks[((R) +  1) % 17]; \
+	X01   += ks[((R) +  2) % 17]; \
+	X02   += ks[((R) +  3) % 17]; \
+	X03   += ks[((R) +  4) % 17]; \
+	X04   += ks[((R) +  5) % 17]; \
+	X05   += ks[((R) +  6) % 17]; \
+	X06   += ks[((R) +  7) % 17]; \
+	X07   += ks[((R) +  8) % 17]; \
+	X08   += ks[((R) +  9) % 17]; \
+	X09   += ks[((R) + 10) % 17]; \
+	X10   += ks[((R) + 11) % 17]; \
+	X11   += ks[((R) + 12) % 17]; \
+	X12   += ks[((R) + 13) % 17]; \
+	X13   += ks[((R) + 14) % 17] + ts[((R) + 1) % 3]; \
+	X14   += ks[((R) + 15) % 17] + ts[((R) + 2) % 3]; \
+	X15   += ks[((R) + 16) % 17] +     (R) + 1;       \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+#else /* looping version */
+#define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
+		ROT, rn) \
+	Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
+			pF, ROT, rn) \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, Xptr);
+
+#define I1024(R) \
+	/* inject the key schedule value */ \
+	X00   += ks[r + (R) +  0]; \
+	X01   += ks[r + (R) +  1]; \
+	X02   += ks[r + (R) +  2]; \
+	X03   += ks[r + (R) +  3]; \
+	X04   += ks[r + (R) +  4]; \
+	X05   += ks[r + (R) +  5]; \
+	X06   += ks[r + (R) +  6]; \
+	X07   += ks[r + (R) +  7]; \
+	X08   += ks[r + (R) +  8]; \
+	X09   += ks[r + (R) +  9]; \
+	X10   += ks[r + (R) + 10]; \
+	X11   += ks[r + (R) + 11]; \
+	X12   += ks[r + (R) + 12]; \
+	X13   += ks[r + (R) + 13] + ts[r + (R) + 0]; \
+	X14   += ks[r + (R) + 14] + ts[r + (R) + 1]; \
+	X15   += ks[r + (R) + 15] +         r + (R); \
+	/* rotate key schedule */ \
+	ks[r  +         (R) + 16] = ks[r + (R) - 1]; \
+	ts[r  +         (R) +  2] = ts[r + (R) - 1]; \
+	Skein_Show_R_Ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+
+		for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
 #endif
 		{
-#define R1024_8_rounds(R)    /* do 8 full rounds */                               \
-			R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, R1024_0, 8*(R) + 1); \
-			R1024(00, 09, 02, 13, 06, 11, 04, 15, 10, 07, 12, 03, 14, 05, 08, 01, R1024_1, 8*(R) + 2); \
-			R1024(00, 07, 02, 05, 04, 03, 06, 01, 12, 15, 14, 13, 08, 11, 10, 09, R1024_2, 8*(R) + 3); \
-			R1024(00, 15, 02, 11, 06, 13, 04, 09, 14, 01, 08, 05, 10, 03, 12, 07, R1024_3, 8*(R) + 4); \
-			I1024(2*(R));                                                             \
-			R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, R1024_4, 8*(R) + 5); \
-			R1024(00, 09, 02, 13, 06, 11, 04, 15, 10, 07, 12, 03, 14, 05, 08, 01, R1024_5, 8*(R) + 6); \
-			R1024(00, 07, 02, 05, 04, 03, 06, 01, 12, 15, 14, 13, 08, 11, 10, 09, R1024_6, 8*(R) + 7); \
-			R1024(00, 15, 02, 11, 06, 13, 04, 09, 14, 01, 08, 05, 10, 03, 12, 07, R1024_7, 8*(R) + 8); \
-			I1024(2*(R)+1);
+#define R1024_8_rounds(R) \
+	R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, \
+		R1024_0, 8*(R) + 1); \
+	R1024(00, 09, 02, 13, 06, 11, 04, 15, 10, 07, 12, 03, 14, 05, 08, 01, \
+		R1024_1, 8*(R) + 2); \
+	R1024(00, 07, 02, 05, 04, 03, 06, 01, 12, 15, 14, 13, 08, 11, 10, 09, \
+		R1024_2, 8*(R) + 3); \
+	R1024(00, 15, 02, 11, 06, 13, 04, 09, 14, 01, 08, 05, 10, 03, 12, 07, \
+		R1024_3, 8*(R) + 4); \
+	I1024(2*(R)); \
+	R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, \
+		R1024_4, 8*(R) + 5); \
+	R1024(00, 09, 02, 13, 06, 11, 04, 15, 10, 07, 12, 03, 14, 05, 08, 01, \
+		R1024_5, 8*(R) + 6); \
+	R1024(00, 07, 02, 05, 04, 03, 06, 01, 12, 15, 14, 13, 08, 11, 10, 09, \
+		R1024_6, 8*(R) + 7); \
+	R1024(00, 15, 02, 11, 06, 13, 04, 09, 14, 01, 08, 05, 10, 03, 12, 07, \
+		R1024_7, 8*(R) + 8); \
+	I1024(2*(R)+1);
 
 			R1024_8_rounds(0);
 
-#define R1024_Unroll_R(NN) ((SKEIN_UNROLL_1024 == 0 && SKEIN1024_ROUNDS_TOTAL/8 > (NN)) || (SKEIN_UNROLL_1024 > (NN)))
+#define R1024_Unroll_R(NN) \
+		((SKEIN_UNROLL_1024 == 0 && \
+		  SKEIN1024_ROUNDS_TOTAL/8 > (NN)) || \
+		 (SKEIN_UNROLL_1024 > (NN)))
 
 	#if   R1024_Unroll_R(1)
 			R1024_8_rounds(1);
@@ -643,7 +694,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t
 #error  "need more unrolling in Skein_1024_Process_Block"
   #endif
 		}
-		/* do the final "feedforward" xor, update context chaining vars */
+		/* do the final "feedforward" xor, update context chaining */
 
 		ctx->X[0] = X00 ^ w[0];
 		ctx->X[1] = X01 ^ w[1];
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish1024Block.c
index 1730a3120a0f..fe7517b2008c 100644
--- a/drivers/staging/skein/threefish1024Block.c
+++ b/drivers/staging/skein/threefish1024Block.c
@@ -24,646 +24,2085 @@ void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
 	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
 	  t2 = keyCtx->tweak[2];
 
-	b1 += k1; b0 += b1 + k0; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k3; b2 += b3 + k2; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k5; b4 += b5 + k4; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k7; b6 += b7 + k6; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k9; b8 += b9 + k8; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k11; b10 += b11 + k10; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k13 + t0; b12 += b13 + k12; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k15; b14 += b15 + k14 + t1; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k2; b0 += b1 + k1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k4; b2 += b3 + k3; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k6; b4 += b5 + k5; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k8; b6 += b7 + k7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k10; b8 += b9 + k9; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k12; b10 += b11 + k11; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k14 + t1; b12 += b13 + k13; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k16 + 1; b14 += b15 + k15 + t2; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-	b1 += k3; b0 += b1 + k2; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k5; b2 += b3 + k4; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k7; b4 += b5 + k6; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k9; b6 += b7 + k8; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k11; b8 += b9 + k10; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k13; b10 += b11 + k12; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k15 + t2; b12 += b13 + k14; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k0 + 2; b14 += b15 + k16 + t0; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k4; b0 += b1 + k3; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k6; b2 += b3 + k5; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k8; b4 += b5 + k7; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k10; b6 += b7 + k9; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k12; b8 += b9 + k11; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k14; b10 += b11 + k13; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k16 + t0; b12 += b13 + k15; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k1 + 3; b14 += b15 + k0 + t1; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-	b1 += k5; b0 += b1 + k4; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k7; b2 += b3 + k6; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k9; b4 += b5 + k8; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k11; b6 += b7 + k10; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k13; b8 += b9 + k12; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k15; b10 += b11 + k14; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k0 + t1; b12 += b13 + k16; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k2 + 4; b14 += b15 + k1 + t2; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k6; b0 += b1 + k5; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k8; b2 += b3 + k7; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k10; b4 += b5 + k9; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k12; b6 += b7 + k11; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k14; b8 += b9 + k13; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k16; b10 += b11 + k15; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k1 + t2; b12 += b13 + k0; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k3 + 5; b14 += b15 + k2 + t0; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-	b1 += k7; b0 += b1 + k6; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k9; b2 += b3 + k8; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k11; b4 += b5 + k10; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k13; b6 += b7 + k12; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k15; b8 += b9 + k14; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k0; b10 += b11 + k16; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k2 + t0; b12 += b13 + k1; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k4 + 6; b14 += b15 + k3 + t1; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k8; b0 += b1 + k7; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k10; b2 += b3 + k9; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k12; b4 += b5 + k11; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k14; b6 += b7 + k13; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k16; b8 += b9 + k15; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k1; b10 += b11 + k0; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k3 + t1; b12 += b13 + k2; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k5 + 7; b14 += b15 + k4 + t2; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-	b1 += k9; b0 += b1 + k8; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k11; b2 += b3 + k10; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k13; b4 += b5 + k12; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k15; b6 += b7 + k14; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k0; b8 += b9 + k16; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k2; b10 += b11 + k1; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k4 + t2; b12 += b13 + k3; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k6 + 8; b14 += b15 + k5 + t0; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k10; b0 += b1 + k9; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k12; b2 += b3 + k11; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k14; b4 += b5 + k13; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k16; b6 += b7 + k15; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k1; b8 += b9 + k0; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k3; b10 += b11 + k2; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k5 + t0; b12 += b13 + k4; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k7 + 9; b14 += b15 + k6 + t1; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-	b1 += k11; b0 += b1 + k10; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k13; b2 += b3 + k12; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k15; b4 += b5 + k14; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k0; b6 += b7 + k16; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k2; b8 += b9 + k1; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k4; b10 += b11 + k3; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k6 + t1; b12 += b13 + k5; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k8 + 10; b14 += b15 + k7 + t2; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k12; b0 += b1 + k11; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k14; b2 += b3 + k13; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k16; b4 += b5 + k15; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k1; b6 += b7 + k0; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k3; b8 += b9 + k2; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k5; b10 += b11 + k4; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k7 + t2; b12 += b13 + k6; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k9 + 11; b14 += b15 + k8 + t0; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-	b1 += k13; b0 += b1 + k12; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k15; b2 += b3 + k14; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k0; b4 += b5 + k16; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k2; b6 += b7 + k1; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k4; b8 += b9 + k3; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k6; b10 += b11 + k5; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k8 + t0; b12 += b13 + k7; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k10 + 12; b14 += b15 + k9 + t1; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k14; b0 += b1 + k13; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k16; b2 += b3 + k15; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k1; b4 += b5 + k0; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k3; b6 += b7 + k2; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k5; b8 += b9 + k4; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k7; b10 += b11 + k6; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k9 + t1; b12 += b13 + k8; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k11 + 13; b14 += b15 + k10 + t2; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-	b1 += k15; b0 += b1 + k14; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k0; b2 += b3 + k16; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k2; b4 += b5 + k1; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k4; b6 += b7 + k3; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k6; b8 += b9 + k5; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k8; b10 += b11 + k7; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k10 + t2; b12 += b13 + k9; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k12 + 14; b14 += b15 + k11 + t0; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k16; b0 += b1 + k15; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k1; b2 += b3 + k0; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k3; b4 += b5 + k2; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k5; b6 += b7 + k4; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k7; b8 += b9 + k6; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k9; b10 += b11 + k8; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k11 + t0; b12 += b13 + k10; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k13 + 15; b14 += b15 + k12 + t1; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-	b1 += k0; b0 += b1 + k16; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k2; b2 += b3 + k1; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k4; b4 += b5 + k3; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k6; b6 += b7 + k5; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k8; b8 += b9 + k7; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k10; b10 += b11 + k9; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k12 + t1; b12 += b13 + k11; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k14 + 16; b14 += b15 + k13 + t2; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k1; b0 += b1 + k0; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k3; b2 += b3 + k2; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k5; b4 += b5 + k4; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k7; b6 += b7 + k6; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k9; b8 += b9 + k8; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k11; b10 += b11 + k10; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k13 + t2; b12 += b13 + k12; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k15 + 17; b14 += b15 + k14 + t0; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
-	b1 += k2; b0 += b1 + k1; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
-	b3 += k4; b2 += b3 + k3; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
-	b5 += k6; b4 += b5 + k5; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
-	b7 += k8; b6 += b7 + k7; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
-	b9 += k10; b8 += b9 + k9; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
-	b11 += k12; b10 += b11 + k11; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
-	b13 += k14 + t0; b12 += b13 + k13; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
-	b15 += k16 + 18; b14 += b15 + k15 + t1; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
-	b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
-	b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
-	b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
-	b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
-	b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
-	b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
-	b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
-	b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
-	b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
-	b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
-	b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
-	b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
-	b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
-	b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
-	b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
-	b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
-	b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
-	b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
-	b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
-	b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
-	b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
-	b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
-	b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
-	b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
-	b1 += k3; b0 += b1 + k2; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
-	b3 += k5; b2 += b3 + k4; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
-	b5 += k7; b4 += b5 + k6; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
-	b7 += k9; b6 += b7 + k8; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
-	b9 += k11; b8 += b9 + k10; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
-	b11 += k13; b10 += b11 + k12; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
-	b13 += k15 + t1; b12 += b13 + k14; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
-	b15 += k0 + 19; b14 += b15 + k16 + t2; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
-	b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
-	b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
-	b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
-	b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
-	b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
-	b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
-	b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
-	b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
-	b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
-	b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
-	b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
-	b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
-	b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
-	b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
-	b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
-	b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
-	b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
-	b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
-	b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
-	b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
-	b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
-	b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
-	b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
-	b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+	b1 += k1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k5;
+	b4 += b5 + k4;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k7;
+	b6 += b7 + k6;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k9;
+	b8 += b9 + k8;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k11;
+	b10 += b11 + k10;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k13 + t0;
+	b12 += b13 + k12;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k15;
+	b14 += b15 + k14 + t1;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k4;
+	b2 += b3 + k3;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k6;
+	b4 += b5 + k5;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k8;
+	b6 += b7 + k7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k10;
+	b8 += b9 + k9;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k12;
+	b10 += b11 + k11;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k14 + t1;
+	b12 += b13 + k13;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k16 + 1;
+	b14 += b15 + k15 + t2;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k3;
+	b0 += b1 + k2;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k5;
+	b2 += b3 + k4;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k7;
+	b4 += b5 + k6;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k9;
+	b6 += b7 + k8;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k11;
+	b8 += b9 + k10;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k13;
+	b10 += b11 + k12;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k15 + t2;
+	b12 += b13 + k14;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k0 + 2;
+	b14 += b15 + k16 + t0;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k4;
+	b0 += b1 + k3;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k6;
+	b2 += b3 + k5;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k8;
+	b4 += b5 + k7;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k10;
+	b6 += b7 + k9;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k12;
+	b8 += b9 + k11;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k14;
+	b10 += b11 + k13;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k16 + t0;
+	b12 += b13 + k15;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k1 + 3;
+	b14 += b15 + k0 + t1;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k5;
+	b0 += b1 + k4;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k7;
+	b2 += b3 + k6;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k9;
+	b4 += b5 + k8;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k11;
+	b6 += b7 + k10;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k13;
+	b8 += b9 + k12;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k15;
+	b10 += b11 + k14;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k0 + t1;
+	b12 += b13 + k16;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k2 + 4;
+	b14 += b15 + k1 + t2;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k6;
+	b0 += b1 + k5;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k8;
+	b2 += b3 + k7;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k10;
+	b4 += b5 + k9;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k12;
+	b6 += b7 + k11;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k14;
+	b8 += b9 + k13;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k16;
+	b10 += b11 + k15;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k1 + t2;
+	b12 += b13 + k0;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k3 + 5;
+	b14 += b15 + k2 + t0;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k7;
+	b0 += b1 + k6;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k9;
+	b2 += b3 + k8;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k11;
+	b4 += b5 + k10;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k13;
+	b6 += b7 + k12;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k15;
+	b8 += b9 + k14;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k0;
+	b10 += b11 + k16;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k2 + t0;
+	b12 += b13 + k1;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k4 + 6;
+	b14 += b15 + k3 + t1;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k8;
+	b0 += b1 + k7;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k10;
+	b2 += b3 + k9;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k12;
+	b4 += b5 + k11;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k14;
+	b6 += b7 + k13;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k16;
+	b8 += b9 + k15;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k1;
+	b10 += b11 + k0;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k3 + t1;
+	b12 += b13 + k2;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k5 + 7;
+	b14 += b15 + k4 + t2;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k9;
+	b0 += b1 + k8;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k11;
+	b2 += b3 + k10;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k13;
+	b4 += b5 + k12;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k15;
+	b6 += b7 + k14;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k0;
+	b8 += b9 + k16;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k2;
+	b10 += b11 + k1;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k4 + t2;
+	b12 += b13 + k3;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k6 + 8;
+	b14 += b15 + k5 + t0;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k10;
+	b0 += b1 + k9;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k12;
+	b2 += b3 + k11;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k14;
+	b4 += b5 + k13;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k16;
+	b6 += b7 + k15;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k1;
+	b8 += b9 + k0;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k3;
+	b10 += b11 + k2;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k5 + t0;
+	b12 += b13 + k4;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k7 + 9;
+	b14 += b15 + k6 + t1;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k11;
+	b0 += b1 + k10;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k13;
+	b2 += b3 + k12;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k15;
+	b4 += b5 + k14;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k0;
+	b6 += b7 + k16;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k2;
+	b8 += b9 + k1;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k4;
+	b10 += b11 + k3;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k6 + t1;
+	b12 += b13 + k5;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k8 + 10;
+	b14 += b15 + k7 + t2;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k12;
+	b0 += b1 + k11;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k14;
+	b2 += b3 + k13;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k16;
+	b4 += b5 + k15;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k1;
+	b6 += b7 + k0;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k3;
+	b8 += b9 + k2;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k5;
+	b10 += b11 + k4;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k7 + t2;
+	b12 += b13 + k6;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k9 + 11;
+	b14 += b15 + k8 + t0;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k13;
+	b0 += b1 + k12;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k15;
+	b2 += b3 + k14;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k0;
+	b4 += b5 + k16;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k2;
+	b6 += b7 + k1;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k4;
+	b8 += b9 + k3;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k6;
+	b10 += b11 + k5;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k8 + t0;
+	b12 += b13 + k7;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k10 + 12;
+	b14 += b15 + k9 + t1;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k14;
+	b0 += b1 + k13;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k16;
+	b2 += b3 + k15;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k1;
+	b4 += b5 + k0;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k3;
+	b6 += b7 + k2;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k5;
+	b8 += b9 + k4;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k7;
+	b10 += b11 + k6;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k9 + t1;
+	b12 += b13 + k8;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k11 + 13;
+	b14 += b15 + k10 + t2;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k15;
+	b0 += b1 + k14;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k0;
+	b2 += b3 + k16;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k2;
+	b4 += b5 + k1;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k4;
+	b6 += b7 + k3;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k6;
+	b8 += b9 + k5;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k8;
+	b10 += b11 + k7;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k10 + t2;
+	b12 += b13 + k9;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k12 + 14;
+	b14 += b15 + k11 + t0;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k16;
+	b0 += b1 + k15;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k1;
+	b2 += b3 + k0;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k3;
+	b4 += b5 + k2;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k5;
+	b6 += b7 + k4;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k7;
+	b8 += b9 + k6;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k9;
+	b10 += b11 + k8;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k11 + t0;
+	b12 += b13 + k10;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k13 + 15;
+	b14 += b15 + k12 + t1;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k0;
+	b0 += b1 + k16;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k2;
+	b2 += b3 + k1;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k4;
+	b4 += b5 + k3;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k6;
+	b6 += b7 + k5;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k8;
+	b8 += b9 + k7;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k10;
+	b10 += b11 + k9;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k12 + t1;
+	b12 += b13 + k11;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k14 + 16;
+	b14 += b15 + k13 + t2;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k5;
+	b4 += b5 + k4;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k7;
+	b6 += b7 + k6;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k9;
+	b8 += b9 + k8;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k11;
+	b10 += b11 + k10;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k13 + t2;
+	b12 += b13 + k12;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k15 + 17;
+	b14 += b15 + k14 + t0;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+	b1 += k2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+
+	b3 += k4;
+	b2 += b3 + k3;
+	b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+
+	b5 += k6;
+	b4 += b5 + k5;
+	b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+
+	b7 += k8;
+	b6 += b7 + k7;
+	b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+
+	b9 += k10;
+	b8 += b9 + k9;
+	b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+
+	b11 += k12;
+	b10 += b11 + k11;
+	b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+
+	b13 += k14 + t0;
+	b12 += b13 + k13;
+	b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+
+	b15 += k16 + 18;
+	b14 += b15 + k15 + t1;
+	b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+
+	b1 += k3;
+	b0 += b1 + k2;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+
+	b3 += k5;
+	b2 += b3 + k4;
+	b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+
+	b5 += k7;
+	b4 += b5 + k6;
+	b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+
+	b7 += k9;
+	b6 += b7 + k8;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+
+	b9 += k11;
+	b8 += b9 + k10;
+	b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+
+	b11 += k13;
+	b10 += b11 + k12;
+	b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+
+	b13 += k15 + t1;
+	b12 += b13 + k14;
+	b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+
+	b15 += k0 + 19;
+	b14 += b15 + k16 + t2;
+	b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+
+	b0 += b9;
+	b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+
+	b2 += b13;
+	b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+
+	b6 += b11;
+	b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+
+	b4 += b15;
+	b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+
+	b10 += b7;
+	b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+
+	b12 += b3;
+	b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+
+	b14 += b5;
+	b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+
+	b8 += b1;
+	b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+
+	b0 += b7;
+	b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+
+	b6 += b1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+
+	b12 += b15;
+	b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+
+	b14 += b13;
+	b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+
+	b8 += b11;
+	b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+
+	b10 += b9;
+	b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+
+	b0 += b15;
+	b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+
+	b2 += b11;
+	b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+
+	b6 += b13;
+	b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+
+	b4 += b9;
+	b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+
+	b14 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+
+	b8 += b5;
+	b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+
+	b10 += b3;
+	b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+
+	b12 += b7;
+	b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
 
 	output[0] = b0 + k3;
 	output[1] = b1 + k4;
@@ -683,685 +2122,2764 @@ void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
 	output[15] = b15 + k1 + 20;
 }
 
-void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
-{
-	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7],
-	  b8 = input[8], b9 = input[9],
-	  b10 = input[10], b11 = input[11],
-	  b12 = input[12], b13 = input[13],
-	  b14 = input[14], b15 = input[15];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8], k9 = keyCtx->key[9],
-	  k10 = keyCtx->key[10], k11 = keyCtx->key[11],
-	  k12 = keyCtx->key[12], k13 = keyCtx->key[13],
-	  k14 = keyCtx->key[14], k15 = keyCtx->key[15],
-	  k16 = keyCtx->key[16];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
-	u64 tmp;
+void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
+{
+	u64 b0 = input[0], b1 = input[1],
+	  b2 = input[2], b3 = input[3],
+	  b4 = input[4], b5 = input[5],
+	  b6 = input[6], b7 = input[7],
+	  b8 = input[8], b9 = input[9],
+	  b10 = input[10], b11 = input[11],
+	  b12 = input[12], b13 = input[13],
+	  b14 = input[14], b15 = input[15];
+	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+	  k8 = keyCtx->key[8], k9 = keyCtx->key[9],
+	  k10 = keyCtx->key[10], k11 = keyCtx->key[11],
+	  k12 = keyCtx->key[12], k13 = keyCtx->key[13],
+	  k14 = keyCtx->key[14], k15 = keyCtx->key[15],
+	  k16 = keyCtx->key[16];
+	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+	  t2 = keyCtx->tweak[2];
+	u64 tmp;
+
+	b0 -= k3;
+	b1 -= k4;
+	b2 -= k5;
+	b3 -= k6;
+	b4 -= k7;
+	b5 -= k8;
+	b6 -= k9;
+	b7 -= k10;
+	b8 -= k11;
+	b9 -= k12;
+	b10 -= k13;
+	b11 -= k14;
+	b12 -= k15;
+	b13 -= k16 + t2;
+	b14 -= k0 + t0;
+	b15 -= k1 + 20;
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k16 + t2;
+	b15 -= k0 + 19;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k14;
+	b13 -= k15 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k12;
+	b11 -= k13;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k10;
+	b9 -= k11;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k8;
+	b7 -= k9;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k6;
+	b5 -= k7;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k4;
+	b3 -= k5;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k2;
+	b1 -= k3;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k15 + t1;
+	b15 -= k16 + 18;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k13;
+	b13 -= k14 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k11;
+	b11 -= k12;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k9;
+	b9 -= k10;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k7;
+	b7 -= k8;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k5;
+	b5 -= k6;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k3;
+	b3 -= k4;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k1;
+	b1 -= k2;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k14 + t0;
+	b15 -= k15 + 17;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k12;
+	b13 -= k13 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k10;
+	b11 -= k11;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k8;
+	b9 -= k9;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k6;
+	b7 -= k7;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k4;
+	b5 -= k5;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k2;
+	b3 -= k3;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k0;
+	b1 -= k1;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k13 + t2;
+	b15 -= k14 + 16;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k11;
+	b13 -= k12 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k9;
+	b11 -= k10;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k7;
+	b9 -= k8;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k5;
+	b7 -= k6;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k3;
+	b5 -= k4;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k1;
+	b3 -= k2;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k16;
+	b1 -= k0;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k12 + t1;
+	b15 -= k13 + 15;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k10;
+	b13 -= k11 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k8;
+	b11 -= k9;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k6;
+	b9 -= k7;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k4;
+	b7 -= k5;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k2;
+	b5 -= k3;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k0;
+	b3 -= k1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k15;
+	b1 -= k16;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k11 + t0;
+	b15 -= k12 + 14;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k9;
+	b13 -= k10 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k7;
+	b11 -= k8;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k5;
+	b9 -= k6;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k3;
+	b7 -= k4;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k1;
+	b5 -= k2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k16;
+	b3 -= k0;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k14;
+	b1 -= k15;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k10 + t2;
+	b15 -= k11 + 13;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k8;
+	b13 -= k9 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k6;
+	b11 -= k7;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k4;
+	b9 -= k5;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k2;
+	b7 -= k3;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k0;
+	b5 -= k1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k15;
+	b3 -= k16;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k13;
+	b1 -= k14;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k9 + t1;
+	b15 -= k10 + 12;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k7;
+	b13 -= k8 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k5;
+	b11 -= k6;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k3;
+	b9 -= k4;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k1;
+	b7 -= k2;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k16;
+	b5 -= k0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k14;
+	b3 -= k15;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k12;
+	b1 -= k13;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k8 + t0;
+	b15 -= k9 + 11;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k6;
+	b13 -= k7 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k4;
+	b11 -= k5;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k2;
+	b9 -= k3;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k0;
+	b7 -= k1;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k15;
+	b5 -= k16;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k13;
+	b3 -= k14;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k11;
+	b1 -= k12;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k7 + t2;
+	b15 -= k8 + 10;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k5;
+	b13 -= k6 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k3;
+	b11 -= k4;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k1;
+	b9 -= k2;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k16;
+	b7 -= k0;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k14;
+	b5 -= k15;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k12;
+	b3 -= k13;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k10;
+	b1 -= k11;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k6 + t1;
+	b15 -= k7 + 9;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k4;
+	b13 -= k5 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k2;
+	b11 -= k3;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k0;
+	b9 -= k1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k15;
+	b7 -= k16;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k13;
+	b5 -= k14;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k11;
+	b3 -= k12;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k9;
+	b1 -= k10;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k5 + t0;
+	b15 -= k6 + 8;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k3;
+	b13 -= k4 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k1;
+	b11 -= k2;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k16;
+	b9 -= k0;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k14;
+	b7 -= k15;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k12;
+	b5 -= k13;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k10;
+	b3 -= k11;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k8;
+	b1 -= k9;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k4 + t2;
+	b15 -= k5 + 7;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k2;
+	b13 -= k3 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k0;
+	b11 -= k1;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k15;
+	b9 -= k16;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k13;
+	b7 -= k14;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k11;
+	b5 -= k12;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k9;
+	b3 -= k10;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k7;
+	b1 -= k8;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
 
-	b0 -= k3;
-	b1 -= k4;
-	b2 -= k5;
-	b3 -= k6;
-	b4 -= k7;
-	b5 -= k8;
-	b6 -= k9;
-	b7 -= k10;
-	b8 -= k11;
-	b9 -= k12;
-	b10 -= k13;
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k3 + t1;
+	b15 -= k4 + 6;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k1;
+	b13 -= k2 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k16;
+	b11 -= k0;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k14;
+	b9 -= k15;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k12;
+	b7 -= k13;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k10;
+	b5 -= k11;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k8;
+	b3 -= k9;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k6;
+	b1 -= k7;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k2 + t0;
+	b15 -= k3 + 5;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k0;
+	b13 -= k1 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k15;
+	b11 -= k16;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k13;
+	b9 -= k14;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k11;
+	b7 -= k12;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k9;
+	b5 -= k10;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k7;
+	b3 -= k8;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k5;
+	b1 -= k6;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k1 + t2;
+	b15 -= k2 + 4;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k16;
+	b13 -= k0 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k14;
+	b11 -= k15;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k12;
+	b9 -= k13;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k10;
+	b7 -= k11;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k8;
+	b5 -= k9;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k6;
+	b3 -= k7;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k4;
+	b1 -= k5;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k0 + t1;
+	b15 -= k1 + 3;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k15;
+	b13 -= k16 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k13;
 	b11 -= k14;
-	b12 -= k15;
-	b13 -= k16 + t2;
-	b14 -= k0 + t0;
-	b15 -= k1 + 20;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k16 + t2; b15 -= k0 + 19;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k14; b13 -= k15 + t1;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k12; b11 -= k13;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k10; b9 -= k11;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k8; b7 -= k9;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k6; b5 -= k7;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k4; b3 -= k5;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k2; b1 -= k3;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k15 + t1; b15 -= k16 + 18;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k13; b13 -= k14 + t0;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k11; b11 -= k12;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k9; b9 -= k10;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k7; b7 -= k8;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k5; b5 -= k6;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k3; b3 -= k4;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k1; b1 -= k2;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k14 + t0; b15 -= k15 + 17;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k12; b13 -= k13 + t2;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k10; b11 -= k11;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k8; b9 -= k9;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k6; b7 -= k7;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k4; b5 -= k5;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k2; b3 -= k3;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k0; b1 -= k1;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k13 + t2; b15 -= k14 + 16;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k11; b13 -= k12 + t1;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k9; b11 -= k10;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k7; b9 -= k8;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k5; b7 -= k6;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k3; b5 -= k4;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k1; b3 -= k2;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k16; b1 -= k0;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k12 + t1; b15 -= k13 + 15;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k10; b13 -= k11 + t0;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k8; b11 -= k9;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k6; b9 -= k7;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k4; b7 -= k5;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k2; b5 -= k3;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k0; b3 -= k1;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k15; b1 -= k16;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k11 + t0; b15 -= k12 + 14;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k9; b13 -= k10 + t2;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k7; b11 -= k8;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k5; b9 -= k6;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k3; b7 -= k4;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k1; b5 -= k2;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k16; b3 -= k0;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k14; b1 -= k15;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k10 + t2; b15 -= k11 + 13;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k8; b13 -= k9 + t1;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k6; b11 -= k7;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k4; b9 -= k5;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k2; b7 -= k3;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k0; b5 -= k1;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k15; b3 -= k16;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k13; b1 -= k14;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k9 + t1; b15 -= k10 + 12;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k7; b13 -= k8 + t0;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k5; b11 -= k6;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k3; b9 -= k4;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k1; b7 -= k2;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k16; b5 -= k0;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k14; b3 -= k15;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k12; b1 -= k13;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k8 + t0; b15 -= k9 + 11;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k6; b13 -= k7 + t2;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k4; b11 -= k5;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k2; b9 -= k3;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k0; b7 -= k1;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k15; b5 -= k16;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k13; b3 -= k14;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k11; b1 -= k12;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k7 + t2; b15 -= k8 + 10;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k5; b13 -= k6 + t1;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k3; b11 -= k4;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k1; b9 -= k2;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k16; b7 -= k0;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k14; b5 -= k15;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k12; b3 -= k13;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k10; b1 -= k11;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k6 + t1; b15 -= k7 + 9;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k4; b13 -= k5 + t0;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k2; b11 -= k3;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k0; b9 -= k1;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k15; b7 -= k16;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k13; b5 -= k14;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k11; b3 -= k12;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k9; b1 -= k10;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k5 + t0; b15 -= k6 + 8;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k3; b13 -= k4 + t2;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k1; b11 -= k2;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k16; b9 -= k0;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k14; b7 -= k15;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k12; b5 -= k13;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k10; b3 -= k11;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k8; b1 -= k9;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k4 + t2; b15 -= k5 + 7;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k2; b13 -= k3 + t1;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k0; b11 -= k1;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k15; b9 -= k16;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k13; b7 -= k14;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k11; b5 -= k12;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k9; b3 -= k10;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k7; b1 -= k8;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k3 + t1; b15 -= k4 + 6;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k1; b13 -= k2 + t0;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k16; b11 -= k0;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k14; b9 -= k15;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k12; b7 -= k13;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k10; b5 -= k11;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k8; b3 -= k9;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k6; b1 -= k7;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k2 + t0; b15 -= k3 + 5;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k0; b13 -= k1 + t2;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k15; b11 -= k16;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k13; b9 -= k14;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k11; b7 -= k12;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k9; b5 -= k10;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k7; b3 -= k8;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k5; b1 -= k6;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k1 + t2; b15 -= k2 + 4;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k16; b13 -= k0 + t1;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k14; b11 -= k15;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k12; b9 -= k13;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k10; b7 -= k11;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k8; b5 -= k9;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k6; b3 -= k7;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k4; b1 -= k5;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k0 + t1; b15 -= k1 + 3;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k15; b13 -= k16 + t0;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k13; b11 -= k14;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k11; b9 -= k12;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k9; b7 -= k10;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k7; b5 -= k8;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k5; b3 -= k6;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k3; b1 -= k4;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k16 + t0; b15 -= k0 + 2;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k14; b13 -= k15 + t2;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k12; b11 -= k13;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k10; b9 -= k11;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k8; b7 -= k9;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k6; b5 -= k7;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k4; b3 -= k5;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k2; b1 -= k3;
-	tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k15 + t2; b15 -= k16 + 1;
-	tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k13; b13 -= k14 + t1;
-	tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k11; b11 -= k12;
-	tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k9; b9 -= k10;
-	tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k7; b7 -= k8;
-	tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k5; b5 -= k6;
-	tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k3; b3 -= k4;
-	tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k1; b1 -= k2;
-	tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
-	tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
-	tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
-	tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
-	tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
-	tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
-	tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
-	tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
-	tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
-	tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
-	tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
-	tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
-	tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
-	tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
-	tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
-	tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
-	tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
-	tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
-	tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
-	tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
-	tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
-	tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
-	tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k14 + t1; b15 -= k15;
-	tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k12; b13 -= k13 + t0;
-	tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k10; b11 -= k11;
-	tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k8; b9 -= k9;
-	tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k6; b7 -= k7;
-	tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k4; b5 -= k5;
-	tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k2; b3 -= k3;
-	tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k0; b1 -= k1;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k11;
+	b9 -= k12;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k9;
+	b7 -= k10;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k7;
+	b5 -= k8;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k5;
+	b3 -= k6;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k3;
+	b1 -= k4;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k16 + t0;
+	b15 -= k0 + 2;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k14;
+	b13 -= k15 + t2;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k12;
+	b11 -= k13;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k10;
+	b9 -= k11;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k8;
+	b7 -= k9;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k6;
+	b5 -= k7;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k4;
+	b3 -= k5;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k2;
+	b1 -= k3;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 20) | (tmp << (64 - 20));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 37) | (tmp << (64 - 37));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 31) | (tmp << (64 - 31));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 52) | (tmp << (64 - 52));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 35) | (tmp << (64 - 35));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 48) | (tmp << (64 - 48));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 25) | (tmp << (64 - 25));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 44) | (tmp << (64 - 44));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 19) | (tmp << (64 - 19));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 47) | (tmp << (64 - 47));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 44) | (tmp << (64 - 44));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 42) | (tmp << (64 - 42));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 53) | (tmp << (64 - 53));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 4) | (tmp << (64 - 4));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 56) | (tmp << (64 - 56));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 34) | (tmp << (64 - 34));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 16) | (tmp << (64 - 16));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 30) | (tmp << (64 - 30));
+	b14 -= b15 + k15 + t2;
+	b15 -= k16 + 1;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 44) | (tmp << (64 - 44));
+	b12 -= b13 + k13;
+	b13 -= k14 + t1;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 47) | (tmp << (64 - 47));
+	b10 -= b11 + k11;
+	b11 -= k12;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 12) | (tmp << (64 - 12));
+	b8 -= b9 + k9;
+	b9 -= k10;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 31) | (tmp << (64 - 31));
+	b6 -= b7 + k7;
+	b7 -= k8;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 37) | (tmp << (64 - 37));
+	b4 -= b5 + k5;
+	b5 -= k6;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 9) | (tmp << (64 - 9));
+	b2 -= b3 + k3;
+	b3 -= k4;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 41) | (tmp << (64 - 41));
+	b0 -= b1 + k1;
+	b1 -= k2;
+
+	tmp = b7 ^ b12;
+	b7 = (tmp >> 25) | (tmp << (64 - 25));
+	b12 -= b7;
+
+	tmp = b3 ^ b10;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b10 -= b3;
+
+	tmp = b5 ^ b8;
+	b5 = (tmp >> 28) | (tmp << (64 - 28));
+	b8 -= b5;
+
+	tmp = b1 ^ b14;
+	b1 = (tmp >> 47) | (tmp << (64 - 47));
+	b14 -= b1;
+
+	tmp = b9 ^ b4;
+	b9 = (tmp >> 41) | (tmp << (64 - 41));
+	b4 -= b9;
+
+	tmp = b13 ^ b6;
+	b13 = (tmp >> 48) | (tmp << (64 - 48));
+	b6 -= b13;
+
+	tmp = b11 ^ b2;
+	b11 = (tmp >> 20) | (tmp << (64 - 20));
+	b2 -= b11;
+
+	tmp = b15 ^ b0;
+	b15 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b15;
+
+	tmp = b9 ^ b10;
+	b9 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b9;
+
+	tmp = b11 ^ b8;
+	b11 = (tmp >> 59) | (tmp << (64 - 59));
+	b8 -= b11;
+
+	tmp = b13 ^ b14;
+	b13 = (tmp >> 41) | (tmp << (64 - 41));
+	b14 -= b13;
+
+	tmp = b15 ^ b12;
+	b15 = (tmp >> 34) | (tmp << (64 - 34));
+	b12 -= b15;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b6 -= b1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 51) | (tmp << (64 - 51));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 4) | (tmp << (64 - 4));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 33) | (tmp << (64 - 33));
+	b0 -= b7;
+
+	tmp = b1 ^ b8;
+	b1 = (tmp >> 52) | (tmp << (64 - 52));
+	b8 -= b1;
+
+	tmp = b5 ^ b14;
+	b5 = (tmp >> 23) | (tmp << (64 - 23));
+	b14 -= b5;
+
+	tmp = b3 ^ b12;
+	b3 = (tmp >> 18) | (tmp << (64 - 18));
+	b12 -= b3;
+
+	tmp = b7 ^ b10;
+	b7 = (tmp >> 49) | (tmp << (64 - 49));
+	b10 -= b7;
+
+	tmp = b15 ^ b4;
+	b15 = (tmp >> 55) | (tmp << (64 - 55));
+	b4 -= b15;
+
+	tmp = b11 ^ b6;
+	b11 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b11;
+
+	tmp = b13 ^ b2;
+	b13 = (tmp >> 19) | (tmp << (64 - 19));
+	b2 -= b13;
+
+	tmp = b9 ^ b0;
+	b9 = (tmp >> 38) | (tmp << (64 - 38));
+	b0 -= b9;
+
+	tmp = b15 ^ b14;
+	b15 = (tmp >> 37) | (tmp << (64 - 37));
+	b14 -= b15 + k14 + t1;
+	b15 -= k15;
+
+	tmp = b13 ^ b12;
+	b13 = (tmp >> 22) | (tmp << (64 - 22));
+	b12 -= b13 + k12;
+	b13 -= k13 + t0;
+
+	tmp = b11 ^ b10;
+	b11 = (tmp >> 17) | (tmp << (64 - 17));
+	b10 -= b11 + k10;
+	b11 -= k11;
+
+	tmp = b9 ^ b8;
+	b9 = (tmp >> 8) | (tmp << (64 - 8));
+	b8 -= b9 + k8;
+	b9 -= k9;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 47) | (tmp << (64 - 47));
+	b6 -= b7 + k6;
+	b7 -= k7;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 8) | (tmp << (64 - 8));
+	b4 -= b5 + k4;
+	b5 -= k5;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b3 + k2;
+	b3 -= k3;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 24) | (tmp << (64 - 24));
+	b0 -= b1 + k0;
+	b1 -= k1;
 
 	output[15] = b15;
 	output[14] = b14;
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish256Block.c
index da3b8357e47f..2ae746a641ae 100644
--- a/drivers/staging/skein/threefish256Block.c
+++ b/drivers/staging/skein/threefish256Block.c
@@ -12,158 +12,481 @@ void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
 	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
 	  t2 = keyCtx->tweak[2];
 
-	b1 += k1 + t0; b0 += b1 + k0; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-	b3 += k3; b2 += b3 + k2 + t1; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-	b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-	b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-	b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-	b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-	b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-	b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-	b1 += k2 + t1; b0 += b1 + k1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-	b3 += k4 + 1; b2 += b3 + k3 + t2; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-	b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-	b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-	b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-	b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-	b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-	b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-	b1 += k3 + t2; b0 += b1 + k2; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-	b3 += k0 + 2; b2 += b3 + k4 + t0; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-	b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-	b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-	b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-	b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-	b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-	b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-	b1 += k4 + t0; b0 += b1 + k3; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-	b3 += k1 + 3; b2 += b3 + k0 + t1; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-	b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-	b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-	b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-	b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-	b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-	b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-	b1 += k0 + t1; b0 += b1 + k4; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-	b3 += k2 + 4; b2 += b3 + k1 + t2; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-	b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-	b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-	b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-	b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-	b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-	b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-	b1 += k1 + t2; b0 += b1 + k0; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-	b3 += k3 + 5; b2 += b3 + k2 + t0; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-	b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-	b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-	b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-	b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-	b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-	b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-	b1 += k2 + t0; b0 += b1 + k1; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-	b3 += k4 + 6; b2 += b3 + k3 + t1; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-	b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-	b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-	b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-	b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-	b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-	b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-	b1 += k3 + t1; b0 += b1 + k2; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-	b3 += k0 + 7; b2 += b3 + k4 + t2; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-	b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-	b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-	b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-	b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-	b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-	b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-	b1 += k4 + t2; b0 += b1 + k3; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-	b3 += k1 + 8; b2 += b3 + k0 + t0; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-	b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-	b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-	b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-	b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-	b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-	b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-	b1 += k0 + t0; b0 += b1 + k4; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-	b3 += k2 + 9; b2 += b3 + k1 + t1; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-	b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-	b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-	b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-	b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-	b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-	b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-	b1 += k1 + t1; b0 += b1 + k0; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-	b3 += k3 + 10; b2 += b3 + k2 + t2; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-	b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-	b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-	b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-	b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-	b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-	b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-	b1 += k2 + t2; b0 += b1 + k1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-	b3 += k4 + 11; b2 += b3 + k3 + t0; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-	b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-	b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-	b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-	b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-	b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-	b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-	b1 += k3 + t0; b0 += b1 + k2; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-	b3 += k0 + 12; b2 += b3 + k4 + t1; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-	b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-	b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-	b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-	b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-	b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-	b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-	b1 += k4 + t1; b0 += b1 + k3; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-	b3 += k1 + 13; b2 += b3 + k0 + t2; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-	b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-	b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-	b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-	b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-	b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-	b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-	b1 += k0 + t2; b0 += b1 + k4; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-	b3 += k2 + 14; b2 += b3 + k1 + t0; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-	b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-	b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-	b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-	b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-	b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-	b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-	b1 += k1 + t0; b0 += b1 + k0; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-	b3 += k3 + 15; b2 += b3 + k2 + t1; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-	b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-	b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-	b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-	b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-	b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-	b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
-
-	b1 += k2 + t1; b0 += b1 + k1; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
-	b3 += k4 + 16; b2 += b3 + k3 + t2; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
-	b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
-	b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
-	b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
-	b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
-	b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
-	b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
-	b1 += k3 + t2; b0 += b1 + k2; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
-	b3 += k0 + 17; b2 += b3 + k4 + t0; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
-	b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
-	b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
-	b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
-	b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
-	b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
-	b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+	b1 += k1 + t0;
+	b0 += b1 + k0;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2 + t1;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k2 + t1;
+	b0 += b1 + k1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k4 + 1;
+	b2 += b3 + k3 + t2;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k3 + t2;
+	b0 += b1 + k2;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k0 + 2;
+	b2 += b3 + k4 + t0;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k4 + t0;
+	b0 += b1 + k3;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k1 + 3;
+	b2 += b3 + k0 + t1;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k0 + t1;
+	b0 += b1 + k4;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k2 + 4;
+	b2 += b3 + k1 + t2;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k1 + t2;
+	b0 += b1 + k0;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k3 + 5;
+	b2 += b3 + k2 + t0;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k2 + t0;
+	b0 += b1 + k1;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k4 + 6;
+	b2 += b3 + k3 + t1;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k3 + t1;
+	b0 += b1 + k2;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k0 + 7;
+	b2 += b3 + k4 + t2;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k4 + t2;
+	b0 += b1 + k3;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k1 + 8;
+	b2 += b3 + k0 + t0;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k0 + t0;
+	b0 += b1 + k4;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k2 + 9;
+	b2 += b3 + k1 + t1;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k1 + t1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k3 + 10;
+	b2 += b3 + k2 + t2;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k2 + t2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k4 + 11;
+	b2 += b3 + k3 + t0;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k3 + t0;
+	b0 += b1 + k2;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k0 + 12;
+	b2 += b3 + k4 + t1;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k4 + t1;
+	b0 += b1 + k3;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k1 + 13;
+	b2 += b3 + k0 + t2;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k0 + t2;
+	b0 += b1 + k4;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k2 + 14;
+	b2 += b3 + k1 + t0;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k1 + t0;
+	b0 += b1 + k0;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k3 + 15;
+	b2 += b3 + k2 + t1;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+
+	b1 += k2 + t1;
+	b0 += b1 + k1;
+	b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+
+	b3 += k4 + 16;
+	b2 += b3 + k3 + t2;
+	b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+
+	b1 += k3 + t2;
+	b0 += b1 + k2;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+
+	b3 += k0 + 17;
+	b2 += b3 + k4 + t0;
+	b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+
+	b0 += b1;
+	b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+
+	b2 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+
+	b0 += b3;
+	b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+
+	b2 += b1;
+	b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
 
 	output[0] = b0 + k3;
 	output[1] = b1 + k4 + t0;
@@ -187,158 +510,625 @@ void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
 	b1 -= k4 + t0;
 	b2 -= k0 + t1;
 	b3 -= k1 + 18;
-	tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k2; b1 -= k3 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k4 + t0; b3 -= k0 + 17;
-	tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k1; b1 -= k2 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k3 + t2; b3 -= k4 + 16;
-
-	tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k0; b1 -= k1 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k2 + t1; b3 -= k3 + 15;
-	tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k4; b1 -= k0 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k1 + t0; b3 -= k2 + 14;
-
-	tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k3; b1 -= k4 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k0 + t2; b3 -= k1 + 13;
-	tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k2; b1 -= k3 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k4 + t1; b3 -= k0 + 12;
-
-	tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k1; b1 -= k2 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k3 + t0; b3 -= k4 + 11;
-	tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k0; b1 -= k1 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k2 + t2; b3 -= k3 + 10;
-
-	tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k4; b1 -= k0 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k1 + t1; b3 -= k2 + 9;
-	tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k3; b1 -= k4 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k0 + t0; b3 -= k1 + 8;
-
-	tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k2; b1 -= k3 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k4 + t2; b3 -= k0 + 7;
-	tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k1; b1 -= k2 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k3 + t1; b3 -= k4 + 6;
-
-	tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k0; b1 -= k1 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k2 + t0; b3 -= k3 + 5;
-	tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k4; b1 -= k0 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k1 + t2; b3 -= k2 + 4;
-
-	tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k3; b1 -= k4 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k0 + t1; b3 -= k1 + 3;
-	tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k2; b1 -= k3 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k4 + t0; b3 -= k0 + 2;
-
-	tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k1; b1 -= k2 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k3 + t2; b3 -= k4 + 1;
-	tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
-	tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
-	tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
-	tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
-	tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k0; b1 -= k1 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k2 + t1; b3 -= k3;
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k2;
+	b1 -= k3 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k4 + t0;
+	b3 -= k0 + 17;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k1;
+	b1 -= k2 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k3 + t2;
+	b3 -= k4 + 16;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k0;
+	b1 -= k1 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k2 + t1;
+	b3 -= k3 + 15;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k4;
+	b1 -= k0 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k1 + t0;
+	b3 -= k2 + 14;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k3;
+	b1 -= k4 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k0 + t2;
+	b3 -= k1 + 13;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k2;
+	b1 -= k3 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k4 + t1;
+	b3 -= k0 + 12;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k1;
+	b1 -= k2 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k3 + t0;
+	b3 -= k4 + 11;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k0;
+	b1 -= k1 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k2 + t2;
+	b3 -= k3 + 10;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k4;
+	b1 -= k0 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k1 + t1;
+	b3 -= k2 + 9;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k3;
+	b1 -= k4 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k0 + t0;
+	b3 -= k1 + 8;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k2;
+	b1 -= k3 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k4 + t2;
+	b3 -= k0 + 7;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k1;
+	b1 -= k2 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k3 + t1;
+	b3 -= k4 + 6;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k0;
+	b1 -= k1 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k2 + t0;
+	b3 -= k3 + 5;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k4;
+	b1 -= k0 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k1 + t2;
+	b3 -= k2 + 4;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k3;
+	b1 -= k4 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k0 + t1;
+	b3 -= k1 + 3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k2;
+	b1 -= k3 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k4 + t0;
+	b3 -= k0 + 2;
+
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 32) | (tmp << (64 - 32));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 32) | (tmp << (64 - 32));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 58) | (tmp << (64 - 58));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 12) | (tmp << (64 - 12));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b0 -= b1 + k1;
+	b1 -= k2 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b3 + k3 + t2;
+	b3 -= k4 + 1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 5) | (tmp << (64 - 5));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 37) | (tmp << (64 - 37));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 23) | (tmp << (64 - 23));
+	b0 -= b1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 40) | (tmp << (64 - 40));
+	b2 -= b3;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 52) | (tmp << (64 - 52));
+	b0 -= b3;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 57) | (tmp << (64 - 57));
+	b2 -= b1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 14) | (tmp << (64 - 14));
+	b0 -= b1 + k0;
+	b1 -= k1 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 16) | (tmp << (64 - 16));
+	b2 -= b3 + k2 + t1;
+	b3 -= k3;
 
 	output[0] = b0;
 	output[1] = b1;
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish512Block.c
index dc96ba279720..f428fd6e1719 100644
--- a/drivers/staging/skein/threefish512Block.c
+++ b/drivers/staging/skein/threefish512Block.c
@@ -16,294 +16,941 @@ void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
 	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
 	  t2 = keyCtx->tweak[2];
 
-	b1 += k1; b0 += b1 + k0; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-	b3 += k3; b2 += b3 + k2; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-	b5 += k5 + t0; b4 += b5 + k4; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-	b7 += k7; b6 += b7 + k6 + t1; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-	b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-	b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-	b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-	b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-	b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-	b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-	b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-	b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-	b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-	b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-	b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-	b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-	b1 += k2; b0 += b1 + k1; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-	b3 += k4; b2 += b3 + k3; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-	b5 += k6 + t1; b4 += b5 + k5; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-	b7 += k8 + 1; b6 += b7 + k7 + t2; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-	b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-	b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-	b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-	b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-	b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-	b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-	b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-	b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-	b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-	b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-	b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-	b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-	b1 += k3; b0 += b1 + k2; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-	b3 += k5; b2 += b3 + k4; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-	b5 += k7 + t2; b4 += b5 + k6; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-	b7 += k0 + 2; b6 += b7 + k8 + t0; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-	b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-	b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-	b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-	b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-	b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-	b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-	b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-	b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-	b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-	b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-	b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-	b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-	b1 += k4; b0 += b1 + k3; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-	b3 += k6; b2 += b3 + k5; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-	b5 += k8 + t0; b4 += b5 + k7; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-	b7 += k1 + 3; b6 += b7 + k0 + t1; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-	b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-	b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-	b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-	b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-	b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-	b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-	b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-	b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-	b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-	b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-	b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-	b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-	b1 += k5; b0 += b1 + k4; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-	b3 += k7; b2 += b3 + k6; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-	b5 += k0 + t1; b4 += b5 + k8; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-	b7 += k2 + 4; b6 += b7 + k1 + t2; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-	b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-	b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-	b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-	b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-	b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-	b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-	b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-	b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-	b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-	b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-	b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-	b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-	b1 += k6; b0 += b1 + k5; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-	b3 += k8; b2 += b3 + k7; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-	b5 += k1 + t2; b4 += b5 + k0; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-	b7 += k3 + 5; b6 += b7 + k2 + t0; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-	b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-	b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-	b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-	b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-	b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-	b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-	b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-	b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-	b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-	b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-	b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-	b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-	b1 += k7; b0 += b1 + k6; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-	b3 += k0; b2 += b3 + k8; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-	b5 += k2 + t0; b4 += b5 + k1; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-	b7 += k4 + 6; b6 += b7 + k3 + t1; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-	b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-	b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-	b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-	b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-	b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-	b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-	b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-	b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-	b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-	b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-	b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-	b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-	b1 += k8; b0 += b1 + k7; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-	b3 += k1; b2 += b3 + k0; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-	b5 += k3 + t1; b4 += b5 + k2; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-	b7 += k5 + 7; b6 += b7 + k4 + t2; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-	b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-	b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-	b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-	b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-	b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-	b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-	b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-	b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-	b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-	b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-	b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-	b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-	b1 += k0; b0 += b1 + k8; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-	b3 += k2; b2 += b3 + k1; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-	b5 += k4 + t2; b4 += b5 + k3; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-	b7 += k6 + 8; b6 += b7 + k5 + t0; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-	b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-	b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-	b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-	b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-	b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-	b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-	b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-	b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-	b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-	b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-	b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-	b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-	b1 += k1; b0 += b1 + k0; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-	b3 += k3; b2 += b3 + k2; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-	b5 += k5 + t0; b4 += b5 + k4; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-	b7 += k7 + 9; b6 += b7 + k6 + t1; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-	b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-	b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-	b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-	b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-	b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-	b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-	b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-	b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-	b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-	b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-	b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-	b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-	b1 += k2; b0 += b1 + k1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-	b3 += k4; b2 += b3 + k3; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-	b5 += k6 + t1; b4 += b5 + k5; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-	b7 += k8 + 10; b6 += b7 + k7 + t2; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-	b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-	b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-	b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-	b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-	b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-	b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-	b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-	b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-	b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-	b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-	b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-	b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-	b1 += k3; b0 += b1 + k2; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-	b3 += k5; b2 += b3 + k4; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-	b5 += k7 + t2; b4 += b5 + k6; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-	b7 += k0 + 11; b6 += b7 + k8 + t0; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-	b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-	b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-	b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-	b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-	b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-	b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-	b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-	b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-	b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-	b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-	b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-	b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-	b1 += k4; b0 += b1 + k3; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-	b3 += k6; b2 += b3 + k5; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-	b5 += k8 + t0; b4 += b5 + k7; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-	b7 += k1 + 12; b6 += b7 + k0 + t1; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-	b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-	b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-	b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-	b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-	b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-	b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-	b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-	b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-	b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-	b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-	b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-	b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-	b1 += k5; b0 += b1 + k4; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-	b3 += k7; b2 += b3 + k6; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-	b5 += k0 + t1; b4 += b5 + k8; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-	b7 += k2 + 13; b6 += b7 + k1 + t2; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-	b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-	b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-	b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-	b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-	b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-	b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-	b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-	b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-	b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-	b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-	b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-	b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-	b1 += k6; b0 += b1 + k5; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-	b3 += k8; b2 += b3 + k7; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-	b5 += k1 + t2; b4 += b5 + k0; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-	b7 += k3 + 14; b6 += b7 + k2 + t0; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-	b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-	b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-	b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-	b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-	b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-	b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-	b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-	b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-	b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-	b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-	b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-	b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-	b1 += k7; b0 += b1 + k6; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-	b3 += k0; b2 += b3 + k8; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-	b5 += k2 + t0; b4 += b5 + k1; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-	b7 += k4 + 15; b6 += b7 + k3 + t1; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-	b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-	b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-	b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-	b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-	b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-	b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-	b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-	b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-	b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-	b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-	b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-	b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
-	b1 += k8; b0 += b1 + k7; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
-	b3 += k1; b2 += b3 + k0; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
-	b5 += k3 + t1; b4 += b5 + k2; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
-	b7 += k5 + 16; b6 += b7 + k4 + t2; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
-	b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
-	b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
-	b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
-	b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
-	b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
-	b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
-	b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
-	b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
-	b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
-	b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
-	b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
-	b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
-	b1 += k0; b0 += b1 + k8; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
-	b3 += k2; b2 += b3 + k1; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
-	b5 += k4 + t2; b4 += b5 + k3; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
-	b7 += k6 + 17; b6 += b7 + k5 + t0; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
-	b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
-	b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
-	b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
-	b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
-	b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
-	b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
-	b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
-	b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
-	b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
-	b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
-	b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
-	b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+	b1 += k1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k5 + t0;
+	b4 += b5 + k4;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k7;
+	b6 += b7 + k6 + t1;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k4;
+	b2 += b3 + k3;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k6 + t1;
+	b4 += b5 + k5;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k8 + 1;
+	b6 += b7 + k7 + t2;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k3;
+	b0 += b1 + k2;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k5;
+	b2 += b3 + k4;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k7 + t2;
+	b4 += b5 + k6;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k0 + 2;
+	b6 += b7 + k8 + t0;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k4;
+	b0 += b1 + k3;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k6;
+	b2 += b3 + k5;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k8 + t0;
+	b4 += b5 + k7;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k1 + 3;
+	b6 += b7 + k0 + t1;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k5;
+	b0 += b1 + k4;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k7;
+	b2 += b3 + k6;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k0 + t1;
+	b4 += b5 + k8;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k2 + 4;
+	b6 += b7 + k1 + t2;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k6;
+	b0 += b1 + k5;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k8;
+	b2 += b3 + k7;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k1 + t2;
+	b4 += b5 + k0;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k3 + 5;
+	b6 += b7 + k2 + t0;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k7;
+	b0 += b1 + k6;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k0;
+	b2 += b3 + k8;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k2 + t0;
+	b4 += b5 + k1;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k4 + 6;
+	b6 += b7 + k3 + t1;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k8;
+	b0 += b1 + k7;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k1;
+	b2 += b3 + k0;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k3 + t1;
+	b4 += b5 + k2;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k5 + 7;
+	b6 += b7 + k4 + t2;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k0;
+	b0 += b1 + k8;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k2;
+	b2 += b3 + k1;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k4 + t2;
+	b4 += b5 + k3;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k6 + 8;
+	b6 += b7 + k5 + t0;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k1;
+	b0 += b1 + k0;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k3;
+	b2 += b3 + k2;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k5 + t0;
+	b4 += b5 + k4;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k7 + 9;
+	b6 += b7 + k6 + t1;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k2;
+	b0 += b1 + k1;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k4;
+	b2 += b3 + k3;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k6 + t1;
+	b4 += b5 + k5;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k8 + 10;
+	b6 += b7 + k7 + t2;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k3;
+	b0 += b1 + k2;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k5;
+	b2 += b3 + k4;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k7 + t2;
+	b4 += b5 + k6;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k0 + 11;
+	b6 += b7 + k8 + t0;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k4;
+	b0 += b1 + k3;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k6;
+	b2 += b3 + k5;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k8 + t0;
+	b4 += b5 + k7;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k1 + 12;
+	b6 += b7 + k0 + t1;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k5;
+	b0 += b1 + k4;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k7;
+	b2 += b3 + k6;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k0 + t1;
+	b4 += b5 + k8;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k2 + 13;
+	b6 += b7 + k1 + t2;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k6;
+	b0 += b1 + k5;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k8;
+	b2 += b3 + k7;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k1 + t2;
+	b4 += b5 + k0;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k3 + 14;
+	b6 += b7 + k2 + t0;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k7;
+	b0 += b1 + k6;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k0;
+	b2 += b3 + k8;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k2 + t0;
+	b4 += b5 + k1;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k4 + 15;
+	b6 += b7 + k3 + t1;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+	b1 += k8;
+	b0 += b1 + k7;
+	b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+
+	b3 += k1;
+	b2 += b3 + k0;
+	b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+
+	b5 += k3 + t1;
+	b4 += b5 + k2;
+	b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+
+	b7 += k5 + 16;
+	b6 += b7 + k4 + t2;
+	b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+
+	b1 += k0;
+	b0 += b1 + k8;
+	b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+
+	b3 += k2;
+	b2 += b3 + k1;
+	b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+
+	b5 += k4 + t2;
+	b4 += b5 + k3;
+	b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+
+	b7 += k6 + 17;
+	b6 += b7 + k5 + t0;
+	b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+
+	b2 += b1;
+	b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+
+	b4 += b7;
+	b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+
+	b6 += b5;
+	b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+
+	b0 += b3;
+	b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+
+	b4 += b1;
+	b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+
+	b6 += b3;
+	b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+
+	b0 += b5;
+	b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+
+	b2 += b7;
+	b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+
+	b6 += b1;
+	b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+
+	b0 += b7;
+	b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+
+	b2 += b5;
+	b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+
+	b4 += b3;
+	b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
 
 	output[0] = b0 + k0;
 	output[1] = b1 + k1;
@@ -315,318 +962,1254 @@ void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
 	output[7] = b7 + k7 + 18;
 }
 
-void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
-{
-	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
+void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
+{
+	u64 b0 = input[0], b1 = input[1],
+	  b2 = input[2], b3 = input[3],
+	  b4 = input[4], b5 = input[5],
+	  b6 = input[6], b7 = input[7];
+	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+	  k8 = keyCtx->key[8];
+	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+	  t2 = keyCtx->tweak[2];
+
+	u64 tmp;
+
+	b0 -= k0;
+	b1 -= k1;
+	b2 -= k2;
+	b3 -= k3;
+	b4 -= k4;
+	b5 -= k5 + t0;
+	b6 -= k6 + t1;
+	b7 -= k7 + 18;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k5 + t0;
+	b7 -= k6 + 17;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k3;
+	b5 -= k4 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k1;
+	b3 -= k2;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k8;
+	b1 -= k0;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k4 + t2;
+	b7 -= k5 + 16;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k2;
+	b5 -= k3 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k0;
+	b3 -= k1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k7;
+	b1 -= k8;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k3 + t1;
+	b7 -= k4 + 15;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k1;
+	b5 -= k2 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k8;
+	b3 -= k0;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k6;
+	b1 -= k7;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
 
-	u64 tmp;
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
 
-	b0 -= k0;
-	b1 -= k1;
-	b2 -= k2;
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k2 + t0;
+	b7 -= k3 + 14;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k0;
+	b5 -= k1 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k7;
+	b3 -= k8;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k5;
+	b1 -= k6;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k1 + t2;
+	b7 -= k2 + 13;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k8;
+	b5 -= k0 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k6;
+	b3 -= k7;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k4;
+	b1 -= k5;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k0 + t1;
+	b7 -= k1 + 12;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k7;
+	b5 -= k8 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k5;
+	b3 -= k6;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k3;
+	b1 -= k4;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k8 + t0;
+	b7 -= k0 + 11;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k6;
+	b5 -= k7 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k4;
+	b3 -= k5;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k2;
+	b1 -= k3;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k7 + t2;
+	b7 -= k8 + 10;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k5;
+	b5 -= k6 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k3;
+	b3 -= k4;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k1;
+	b1 -= k2;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k6 + t1;
+	b7 -= k7 + 9;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k4;
+	b5 -= k5 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k2;
 	b3 -= k3;
-	b4 -= k4;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k0;
+	b1 -= k1;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k5 + t0;
+	b7 -= k6 + 8;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k3;
+	b5 -= k4 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k1;
+	b3 -= k2;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k8;
+	b1 -= k0;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k4 + t2;
+	b7 -= k5 + 7;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k2;
+	b5 -= k3 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k0;
+	b3 -= k1;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k7;
+	b1 -= k8;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k3 + t1;
+	b7 -= k4 + 6;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k1;
+	b5 -= k2 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k8;
+	b3 -= k0;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k6;
+	b1 -= k7;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k2 + t0;
+	b7 -= k3 + 5;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k0;
+	b5 -= k1 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k7;
+	b3 -= k8;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k5;
+	b1 -= k6;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k1 + t2;
+	b7 -= k2 + 4;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k8;
+	b5 -= k0 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k6;
+	b3 -= k7;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k4;
+	b1 -= k5;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k0 + t1;
+	b7 -= k1 + 3;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k7;
+	b5 -= k8 + t0;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k5;
+	b3 -= k6;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k3;
+	b1 -= k4;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k8 + t0;
+	b7 -= k0 + 2;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k6;
+	b5 -= k7 + t2;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k4;
+	b3 -= k5;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k2;
+	b1 -= k3;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 22) | (tmp << (64 - 22));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 56) | (tmp << (64 - 56));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 35) | (tmp << (64 - 35));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 8) | (tmp << (64 - 8));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 43) | (tmp << (64 - 43));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 29) | (tmp << (64 - 29));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 25) | (tmp << (64 - 25));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 17) | (tmp << (64 - 17));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 10) | (tmp << (64 - 10));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 50) | (tmp << (64 - 50));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 13) | (tmp << (64 - 13));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 24) | (tmp << (64 - 24));
+	b6 -= b7 + k7 + t2;
+	b7 -= k8 + 1;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 34) | (tmp << (64 - 34));
+	b4 -= b5 + k5;
+	b5 -= k6 + t1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 30) | (tmp << (64 - 30));
+	b2 -= b3 + k3;
+	b3 -= k4;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 39) | (tmp << (64 - 39));
+	b0 -= b1 + k1;
+	b1 -= k2;
+
+	tmp = b3 ^ b4;
+	b3 = (tmp >> 56) | (tmp << (64 - 56));
+	b4 -= b3;
+
+	tmp = b5 ^ b2;
+	b5 = (tmp >> 54) | (tmp << (64 - 54));
+	b2 -= b5;
+
+	tmp = b7 ^ b0;
+	b7 = (tmp >> 9) | (tmp << (64 - 9));
+	b0 -= b7;
+
+	tmp = b1 ^ b6;
+	b1 = (tmp >> 44) | (tmp << (64 - 44));
+	b6 -= b1;
+
+	tmp = b7 ^ b2;
+	b7 = (tmp >> 39) | (tmp << (64 - 39));
+	b2 -= b7;
+
+	tmp = b5 ^ b0;
+	b5 = (tmp >> 36) | (tmp << (64 - 36));
+	b0 -= b5;
+
+	tmp = b3 ^ b6;
+	b3 = (tmp >> 49) | (tmp << (64 - 49));
+	b6 -= b3;
+
+	tmp = b1 ^ b4;
+	b1 = (tmp >> 17) | (tmp << (64 - 17));
+	b4 -= b1;
+
+	tmp = b3 ^ b0;
+	b3 = (tmp >> 42) | (tmp << (64 - 42));
+	b0 -= b3;
+
+	tmp = b5 ^ b6;
+	b5 = (tmp >> 14) | (tmp << (64 - 14));
+	b6 -= b5;
+
+	tmp = b7 ^ b4;
+	b7 = (tmp >> 27) | (tmp << (64 - 27));
+	b4 -= b7;
+
+	tmp = b1 ^ b2;
+	b1 = (tmp >> 33) | (tmp << (64 - 33));
+	b2 -= b1;
+
+	tmp = b7 ^ b6;
+	b7 = (tmp >> 37) | (tmp << (64 - 37));
+	b6 -= b7 + k6 + t1;
+	b7 -= k7;
+
+	tmp = b5 ^ b4;
+	b5 = (tmp >> 19) | (tmp << (64 - 19));
+	b4 -= b5 + k4;
 	b5 -= k5 + t0;
-	b6 -= k6 + t1;
-	b7 -= k7 + 18;
-	tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k5 + t0; b7 -= k6 + 17;
-	tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k3; b5 -= k4 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k1; b3 -= k2;
-	tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k8; b1 -= k0;
-	tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k4 + t2; b7 -= k5 + 16;
-	tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k2; b5 -= k3 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k0; b3 -= k1;
-	tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k7; b1 -= k8;
-	tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k3 + t1; b7 -= k4 + 15;
-	tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k1; b5 -= k2 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k8; b3 -= k0;
-	tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k6; b1 -= k7;
-	tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k2 + t0; b7 -= k3 + 14;
-	tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k0; b5 -= k1 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k7; b3 -= k8;
-	tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k5; b1 -= k6;
-	tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k1 + t2; b7 -= k2 + 13;
-	tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k8; b5 -= k0 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k6; b3 -= k7;
-	tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k4; b1 -= k5;
-	tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k0 + t1; b7 -= k1 + 12;
-	tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k7; b5 -= k8 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k5; b3 -= k6;
-	tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k3; b1 -= k4;
-	tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k8 + t0; b7 -= k0 + 11;
-	tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k6; b5 -= k7 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k4; b3 -= k5;
-	tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k2; b1 -= k3;
-	tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k7 + t2; b7 -= k8 + 10;
-	tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k5; b5 -= k6 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k3; b3 -= k4;
-	tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k1; b1 -= k2;
-	tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k6 + t1; b7 -= k7 + 9;
-	tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k4; b5 -= k5 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k2; b3 -= k3;
-	tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k0; b1 -= k1;
-	tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k5 + t0; b7 -= k6 + 8;
-	tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k3; b5 -= k4 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k1; b3 -= k2;
-	tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k8; b1 -= k0;
-	tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k4 + t2; b7 -= k5 + 7;
-	tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k2; b5 -= k3 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k0; b3 -= k1;
-	tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k7; b1 -= k8;
-	tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k3 + t1; b7 -= k4 + 6;
-	tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k1; b5 -= k2 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k8; b3 -= k0;
-	tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k6; b1 -= k7;
-	tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k2 + t0; b7 -= k3 + 5;
-	tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k0; b5 -= k1 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k7; b3 -= k8;
-	tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k5; b1 -= k6;
-	tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k1 + t2; b7 -= k2 + 4;
-	tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k8; b5 -= k0 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k6; b3 -= k7;
-	tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k4; b1 -= k5;
-	tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k0 + t1; b7 -= k1 + 3;
-	tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k7; b5 -= k8 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k5; b3 -= k6;
-	tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k3; b1 -= k4;
-	tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k8 + t0; b7 -= k0 + 2;
-	tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k6; b5 -= k7 + t2;
-	tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k4; b3 -= k5;
-	tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k2; b1 -= k3;
-	tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k7 + t2; b7 -= k8 + 1;
-	tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k5; b5 -= k6 + t1;
-	tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k3; b3 -= k4;
-	tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k1; b1 -= k2;
-	tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
-	tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
-	tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
-	tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
-	tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
-	tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
-	tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
-	tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
-	tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
-	tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
-	tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
-	tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
-	tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k6 + t1; b7 -= k7;
-	tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k4; b5 -= k5 + t0;
-	tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k2; b3 -= k3;
-	tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k0; b1 -= k1;
+
+	tmp = b3 ^ b2;
+	b3 = (tmp >> 36) | (tmp << (64 - 36));
+	b2 -= b3 + k2;
+	b3 -= k3;
+
+	tmp = b1 ^ b0;
+	b1 = (tmp >> 46) | (tmp << (64 - 46));
+	b0 -= b1 + k0;
+	b1 -= k1;
 
 	output[0] = b0;
 	output[1] = b1;
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index e8ce06a9122f..1e70f66b7032 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -3,8 +3,9 @@
 #include <linux/string.h>
 #include <threefishApi.h>
 
-void threefishSetKey(struct threefish_key *keyCtx, enum threefish_size stateSize,
-		     u64 *keyData, u64 *tweak)
+void threefishSetKey(struct threefish_key *keyCtx,
+			enum threefish_size stateSize,
+			u64 *keyData, u64 *tweak)
 {
 	int keyWords = stateSize / 64;
 	int i;
@@ -28,9 +29,9 @@ void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
 	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
 	u64 cipher[SKEIN_MAX_STATE_WORDS];
 
-	Skein_Get64_LSB_First(plain, in, keyCtx->stateSize / 64);   /* bytes to words */
+	Skein_Get64_LSB_First(plain, in, keyCtx->stateSize / 64);
 	threefishEncryptBlockWords(keyCtx, plain, cipher);
-	Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);  /* words to bytes */
+	Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);
 }
 
 void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
@@ -55,9 +56,9 @@ void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
 	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
 	u64 cipher[SKEIN_MAX_STATE_WORDS];
 
-	Skein_Get64_LSB_First(cipher, in, keyCtx->stateSize / 64);  /* bytes to words */
+	Skein_Get64_LSB_First(cipher, in, keyCtx->stateSize / 64);
 	threefishDecryptBlockWords(keyCtx, cipher, plain);
-	Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);   /* words to bytes */
+	Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);
 }
 
 void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in,
-- 
1.9.1
