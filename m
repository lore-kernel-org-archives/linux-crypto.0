From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 16/21] staging: crypto: skein: fix brace placement errors
Date: Mon, 24 Mar 2014 01:49:13 +0000
Message-ID: <f128fadc06c86cd8af4dd4bf7d7908d714c18be6.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30512 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaCXBtq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:46 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skein.h    |  30 ++++-----
 drivers/staging/skein/include/skein_iv.h |  65 ++++++++----------
 drivers/staging/skein/skein.c            | 111 ++++++++++---------------------
 3 files changed, 74 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index f92dc40711d1..0a2abcecd2f7 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -37,12 +37,11 @@
 #define Skein_Get64_LSB_First(dst64, src08, wCnt) memcpy(dst64, src08, 8*(wCnt))
 #define Skein_Swap64(w64)  (w64)
 
-enum
-	{
+enum {
 	SKEIN_SUCCESS         =      0, /* return codes from Skein calls */
 	SKEIN_FAIL            =      1,
 	SKEIN_BAD_HASHLEN     =      2
-	};
+};
 
 #define  SKEIN_MODIFIER_WORDS   (2) /* number of modifier (tweak) words */
 
@@ -63,33 +62,29 @@ enum
 #define  SKEIN_512_BLOCK_BYTES  (8*SKEIN_512_STATE_WORDS)
 #define  SKEIN1024_BLOCK_BYTES  (8*SKEIN1024_STATE_WORDS)
 
-struct skein_ctx_hdr
-	{
+struct skein_ctx_hdr {
 	size_t  hashBitLen;		/* size of hash result, in bits */
 	size_t  bCnt;			/* current byte count in buffer b[] */
 	u64  T[SKEIN_MODIFIER_WORDS];	/* tweak: T[0]=byte cnt, T[1]=flags */
-	};
+};
 
-struct skein_256_ctx /* 256-bit Skein hash context structure */
-	{
+struct skein_256_ctx { /* 256-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
 	u64  X[SKEIN_256_STATE_WORDS];	/* chaining variables */
 	u8  b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
-	};
+};
 
-struct skein_512_ctx /* 512-bit Skein hash context structure */
-	{
+struct skein_512_ctx { /* 512-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
 	u64  X[SKEIN_512_STATE_WORDS];	/* chaining variables */
 	u8  b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
-	};
+};
 
-struct skein1024_ctx /* 1024-bit Skein hash context structure */
-	{
+struct skein1024_ctx { /* 1024-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
 	u64  X[SKEIN1024_STATE_WORDS];	/* chaining variables */
 	u8  b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
-	};
+};
 
 /*   Skein APIs for (incremental) "straight hashing" */
 int  Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen);
@@ -296,8 +291,7 @@ int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
 /*****************************************************************
 ** Skein block function constants (shared across Ref and Opt code)
 ******************************************************************/
-enum
-	{
+enum {
 	    /* Skein_256 round rotation constants */
 	R_256_0_0 = 14, R_256_0_1 = 16,
 	R_256_1_0 = 52, R_256_1_1 = 57,
@@ -335,7 +329,7 @@ enum
 	R1024_6_4 = 19, R1024_6_5 = 42, R1024_6_6 = 44, R1024_6_7 = 25,
 	R1024_7_0 =  9, R1024_7_1 = 48, R1024_7_2 = 35, R1024_7_3 = 52,
 	R1024_7_4 = 23, R1024_7_5 = 31, R1024_7_6 = 37, R1024_7_7 = 20
-	};
+};
 
 #ifndef SKEIN_ROUNDS
 #define SKEIN_256_ROUNDS_TOTAL (72)	/* # rounds for diff block sizes */
diff --git a/drivers/staging/skein/include/skein_iv.h b/drivers/staging/skein/include/skein_iv.h
index bbbba77c44d3..8dd5e4d88a1d 100644
--- a/drivers/staging/skein/include/skein_iv.h
+++ b/drivers/staging/skein/include/skein_iv.h
@@ -20,44 +20,39 @@
 #define MK_64 SKEIN_MK_64
 
 /* blkSize =  256 bits. hashSize =  128 bits */
-const u64 SKEIN_256_IV_128[] =
-	{
+const u64 SKEIN_256_IV_128[] = {
 	MK_64(0xE1111906, 0x964D7260),
 	MK_64(0x883DAAA7, 0x7C8D811C),
 	MK_64(0x10080DF4, 0x91960F7A),
 	MK_64(0xCCF7DDE5, 0xB45BC1C2)
-	};
+};
 
 /* blkSize =  256 bits. hashSize =  160 bits */
-const u64 SKEIN_256_IV_160[] =
-	{
+const u64 SKEIN_256_IV_160[] = {
 	MK_64(0x14202314, 0x72825E98),
 	MK_64(0x2AC4E9A2, 0x5A77E590),
 	MK_64(0xD47A5856, 0x8838D63E),
 	MK_64(0x2DD2E496, 0x8586AB7D)
-	};
+};
 
 /* blkSize =  256 bits. hashSize =  224 bits */
-const u64 SKEIN_256_IV_224[] =
-	{
+const u64 SKEIN_256_IV_224[] = {
 	MK_64(0xC6098A8C, 0x9AE5EA0B),
 	MK_64(0x876D5686, 0x08C5191C),
 	MK_64(0x99CB88D7, 0xD7F53884),
 	MK_64(0x384BDDB1, 0xAEDDB5DE)
-	};
+};
 
 /* blkSize =  256 bits. hashSize =  256 bits */
-const u64 SKEIN_256_IV_256[] =
-	{
+const u64 SKEIN_256_IV_256[] = {
 	MK_64(0xFC9DA860, 0xD048B449),
 	MK_64(0x2FCA6647, 0x9FA7D833),
 	MK_64(0xB33BC389, 0x6656840F),
 	MK_64(0x6A54E920, 0xFDE8DA69)
-	};
+};
 
 /* blkSize =  512 bits. hashSize =  128 bits */
-const u64 SKEIN_512_IV_128[] =
-	{
+const u64 SKEIN_512_IV_128[] = {
 	MK_64(0xA8BC7BF3, 0x6FBF9F52),
 	MK_64(0x1E9872CE, 0xBD1AF0AA),
 	MK_64(0x309B1790, 0xB32190D3),
@@ -66,11 +61,10 @@ const u64 SKEIN_512_IV_128[] =
 	MK_64(0x1A18EBEA, 0xD46A32E3),
 	MK_64(0xA2CC5B18, 0xCE84AA82),
 	MK_64(0x6982AB28, 0x9D46982D)
-	};
+};
 
 /* blkSize =  512 bits. hashSize =  160 bits */
-const u64 SKEIN_512_IV_160[] =
-	{
+const u64 SKEIN_512_IV_160[] = {
 	MK_64(0x28B81A2A, 0xE013BD91),
 	MK_64(0xC2F11668, 0xB5BDF78F),
 	MK_64(0x1760D8F3, 0xF6A56F12),
@@ -79,11 +73,10 @@ const u64 SKEIN_512_IV_160[] =
 	MK_64(0xD908922E, 0x63ED70B8),
 	MK_64(0xB8EC76FF, 0xECCB52FA),
 	MK_64(0x01A47BB8, 0xA3F27A6E)
-	};
+};
 
 /* blkSize =  512 bits. hashSize =  224 bits */
-const u64 SKEIN_512_IV_224[] =
-	{
+const u64 SKEIN_512_IV_224[] = {
 	MK_64(0xCCD06162, 0x48677224),
 	MK_64(0xCBA65CF3, 0xA92339EF),
 	MK_64(0x8CCD69D6, 0x52FF4B64),
@@ -92,11 +85,10 @@ const u64 SKEIN_512_IV_224[] =
 	MK_64(0x6776FE65, 0x75D4EB3D),
 	MK_64(0x99FBC70E, 0x997413E9),
 	MK_64(0x9E2CFCCF, 0xE1C41EF7)
-	};
+};
 
 /* blkSize =  512 bits. hashSize =  256 bits */
-const u64 SKEIN_512_IV_256[] =
-	{
+const u64 SKEIN_512_IV_256[] = {
 	MK_64(0xCCD044A1, 0x2FDB3E13),
 	MK_64(0xE8359030, 0x1A79A9EB),
 	MK_64(0x55AEA061, 0x4F816E6F),
@@ -105,11 +97,10 @@ const u64 SKEIN_512_IV_256[] =
 	MK_64(0xE7A436CD, 0xC4746251),
 	MK_64(0xC36FBAF9, 0x393AD185),
 	MK_64(0x3EEDBA18, 0x33EDFC13)
-	};
+};
 
 /* blkSize =  512 bits. hashSize =  384 bits */
-const u64 SKEIN_512_IV_384[] =
-	{
+const u64 SKEIN_512_IV_384[] = {
 	MK_64(0xA3F6C6BF, 0x3A75EF5F),
 	MK_64(0xB0FEF9CC, 0xFD84FAA4),
 	MK_64(0x9D77DD66, 0x3D770CFE),
@@ -118,11 +109,10 @@ const u64 SKEIN_512_IV_384[] =
 	MK_64(0x7ED7D434, 0xE5807407),
 	MK_64(0x548FC1AC, 0xD4EC44D6),
 	MK_64(0x266E1754, 0x6AA18FF8)
-	};
+};
 
 /* blkSize =  512 bits. hashSize =  512 bits */
-const u64 SKEIN_512_IV_512[] =
-	{
+const u64 SKEIN_512_IV_512[] = {
 	MK_64(0x4903ADFF, 0x749C51CE),
 	MK_64(0x0D95DE39, 0x9746DF03),
 	MK_64(0x8FD19341, 0x27C79BCE),
@@ -131,11 +121,10 @@ const u64 SKEIN_512_IV_512[] =
 	MK_64(0xEABE394C, 0xA9D5C3F4),
 	MK_64(0x991112C7, 0x1A75B523),
 	MK_64(0xAE18A40B, 0x660FCC33)
-	};
+};
 
 /* blkSize = 1024 bits. hashSize =  384 bits */
-const u64 SKEIN1024_IV_384[] =
-	{
+const u64 SKEIN1024_IV_384[] = {
 	MK_64(0x5102B6B8, 0xC1894A35),
 	MK_64(0xFEEBC9E3, 0xFE8AF11A),
 	MK_64(0x0C807F06, 0xE32BED71),
@@ -152,11 +141,10 @@ const u64 SKEIN1024_IV_384[] =
 	MK_64(0x3B5A6530, 0x0DBC6516),
 	MK_64(0x484B9CD2, 0x167BBCE1),
 	MK_64(0x2D136947, 0xD4CBAFEA)
-	};
+};
 
 /* blkSize = 1024 bits. hashSize =  512 bits */
-const u64 SKEIN1024_IV_512[] =
-	{
+const u64 SKEIN1024_IV_512[] = {
 	MK_64(0xCAEC0E5D, 0x7C1B1B18),
 	MK_64(0xA01B0E04, 0x5F03E802),
 	MK_64(0x33840451, 0xED912885),
@@ -173,11 +161,10 @@ const u64 SKEIN1024_IV_512[] =
 	MK_64(0x67070872, 0x5B749816),
 	MK_64(0xB9CD28FB, 0xF0581BD1),
 	MK_64(0x0E2940B8, 0x15804974)
-	};
+};
 
 /* blkSize = 1024 bits. hashSize = 1024 bits */
-const u64 SKEIN1024_IV_1024[] =
-	{
+const u64 SKEIN1024_IV_1024[] = {
 	MK_64(0xD593DA07, 0x41E72355),
 	MK_64(0x15B5E511, 0xAC73E00C),
 	MK_64(0x5180E5AE, 0xBAF2C4F0),
@@ -194,6 +181,6 @@ const u64 SKEIN1024_IV_1024[] =
 	MK_64(0x6572DD22, 0xF2B4969A),
 	MK_64(0x61FD3062, 0xD00A579A),
 	MK_64(0x1DE0536E, 0x8682E539)
-	};
+};
 
 #endif /* _SKEIN_IV_H_ */
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index ed603ee7b170..0d8c70c02c6f 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -31,8 +31,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 /* init the context for a straight hashing operation  */
 int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
 {
-	union
-	{
+	union {
 		u8  b[SKEIN_256_STATE_BYTES];
 		u64  w[SKEIN_256_STATE_WORDS];
 	} cfg;                              /* config block */
@@ -40,8 +39,7 @@ int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
 	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
 	ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
 
-	switch (hashBitLen)
-	{             /* use pre-computed values, where available */
+	switch (hashBitLen) { /* use pre-computed values, where available */
 	case  256:
 		memcpy(ctx->X, SKEIN_256_IV_256, sizeof(ctx->X));
 		break;
@@ -91,8 +89,7 @@ int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
 int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
 			u64 treeInfo, const u8 *key, size_t keyBytes)
 {
-	union
-	{
+	union {
 		u8  b[SKEIN_256_STATE_BYTES];
 		u64  w[SKEIN_256_STATE_WORDS];
 	} cfg; /* config block */
@@ -101,13 +98,10 @@ int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
 	Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
-	if (keyBytes == 0) /* is there a key? */
-	{
+	if (keyBytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
 		memset(ctx->X, 0, sizeof(ctx->X));
-	}
-	else /* here to pre-process a key */
-	{
+	} else { /* here to pre-process a key */
 		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
@@ -162,15 +156,12 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
 	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
-	if (msgByteCnt + ctx->h.bCnt > SKEIN_256_BLOCK_BYTES)
-	{
+	if (msgByteCnt + ctx->h.bCnt > SKEIN_256_BLOCK_BYTES) {
 		/* finish up any buffered message data */
-		if (ctx->h.bCnt)
-		{
+		if (ctx->h.bCnt) {
 			/* # bytes free in buffer b[] */
 			n = SKEIN_256_BLOCK_BYTES - ctx->h.bCnt;
-			if (n)
-			{
+			if (n) {
 				/* check on our logic here */
 				Skein_assert(n < msgByteCnt);
 				memcpy(&ctx->b[ctx->h.bCnt], msg, n);
@@ -187,8 +178,7 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
 		 * now process any remaining full blocks, directly from input
 		 * message data
 		 */
-		if (msgByteCnt > SKEIN_256_BLOCK_BYTES)
-		{
+		if (msgByteCnt > SKEIN_256_BLOCK_BYTES) {
 			/* number of full blocks to process */
 			n = (msgByteCnt-1) / SKEIN_256_BLOCK_BYTES;
 			Skein_256_Process_Block(ctx, msg, n,
@@ -200,8 +190,7 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
 	}
 
 	/* copy any remaining source message data bytes into b[] */
-	if (msgByteCnt)
-	{
+	if (msgByteCnt) {
 		Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES);
 		memcpy(&ctx->b[ctx->h.bCnt], msg, msgByteCnt);
 		ctx->h.bCnt += msgByteCnt;
@@ -238,8 +227,7 @@ int Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal)
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++)
-	{
+	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
@@ -268,8 +256,7 @@ int Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal)
 /* init the context for a straight hashing operation  */
 int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
 {
-	union
-	{
+	union {
 		u8  b[SKEIN_512_STATE_BYTES];
 		u64  w[SKEIN_512_STATE_WORDS];
 	} cfg;                              /* config block */
@@ -277,8 +264,7 @@ int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
 	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
 	ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
 
-	switch (hashBitLen)
-	{             /* use pre-computed values, where available */
+	switch (hashBitLen) { /* use pre-computed values, where available */
 	case  512:
 		memcpy(ctx->X, SKEIN_512_IV_512, sizeof(ctx->X));
 		break;
@@ -332,8 +318,7 @@ int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
 int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
 			u64 treeInfo, const u8 *key, size_t keyBytes)
 {
-	union
-	{
+	union {
 		u8  b[SKEIN_512_STATE_BYTES];
 		u64  w[SKEIN_512_STATE_WORDS];
 	} cfg;                              /* config block */
@@ -342,13 +327,10 @@ int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
 	Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
-	if (keyBytes == 0)                          /* is there a key? */
-	{
+	if (keyBytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
 		memset(ctx->X, 0, sizeof(ctx->X));
-	}
-	else /* here to pre-process a key */
-	{
+	} else { /* here to pre-process a key */
 		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
@@ -402,15 +384,12 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
 	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
-	if (msgByteCnt + ctx->h.bCnt > SKEIN_512_BLOCK_BYTES)
-	{
+	if (msgByteCnt + ctx->h.bCnt > SKEIN_512_BLOCK_BYTES) {
 		/* finish up any buffered message data */
-		if (ctx->h.bCnt)
-		{
+		if (ctx->h.bCnt) {
 			/* # bytes free in buffer b[] */
 			n = SKEIN_512_BLOCK_BYTES - ctx->h.bCnt;
-			if (n)
-			{
+			if (n) {
 				/* check on our logic here */
 				Skein_assert(n < msgByteCnt);
 				memcpy(&ctx->b[ctx->h.bCnt], msg, n);
@@ -427,8 +406,7 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
 		 * now process any remaining full blocks, directly from input
 		 * message data
 		 */
-		if (msgByteCnt > SKEIN_512_BLOCK_BYTES)
-		{
+		if (msgByteCnt > SKEIN_512_BLOCK_BYTES) {
 			/* number of full blocks to process */
 			n = (msgByteCnt-1) / SKEIN_512_BLOCK_BYTES;
 			Skein_512_Process_Block(ctx, msg, n,
@@ -440,8 +418,7 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
 	}
 
 	/* copy any remaining source message data bytes into b[] */
-	if (msgByteCnt)
-	{
+	if (msgByteCnt) {
 		Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES);
 		memcpy(&ctx->b[ctx->h.bCnt], msg, msgByteCnt);
 		ctx->h.bCnt += msgByteCnt;
@@ -478,8 +455,7 @@ int Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal)
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++)
-	{
+	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
@@ -508,8 +484,7 @@ int Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal)
 /* init the context for a straight hashing operation  */
 int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
 {
-	union
-	{
+	union {
 		u8  b[SKEIN1024_STATE_BYTES];
 		u64  w[SKEIN1024_STATE_WORDS];
 	} cfg;                              /* config block */
@@ -517,8 +492,7 @@ int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
 	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
 	ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
 
-	switch (hashBitLen)
-	{              /* use pre-computed values, where available */
+	switch (hashBitLen) { /* use pre-computed values, where available */
 	case  512:
 		memcpy(ctx->X, SKEIN1024_IV_512, sizeof(ctx->X));
 		break;
@@ -566,8 +540,7 @@ int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
 int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
 			u64 treeInfo, const u8 *key, size_t keyBytes)
 {
-	union
-	{
+	union {
 		u8  b[SKEIN1024_STATE_BYTES];
 		u64  w[SKEIN1024_STATE_WORDS];
 	} cfg;                              /* config block */
@@ -576,13 +549,10 @@ int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
 	Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
-	if (keyBytes == 0)                          /* is there a key? */
-	{
+	if (keyBytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
 		memset(ctx->X, 0, sizeof(ctx->X));
-	}
-	else /* here to pre-process a key */
-	{
+	} else { /* here to pre-process a key */
 		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
@@ -637,15 +607,12 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
 	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
-	if (msgByteCnt + ctx->h.bCnt > SKEIN1024_BLOCK_BYTES)
-	{
+	if (msgByteCnt + ctx->h.bCnt > SKEIN1024_BLOCK_BYTES) {
 		/* finish up any buffered message data */
-		if (ctx->h.bCnt)
-		{
+		if (ctx->h.bCnt) {
 			/* # bytes free in buffer b[] */
 			n = SKEIN1024_BLOCK_BYTES - ctx->h.bCnt;
-			if (n)
-			{
+			if (n) {
 				/* check on our logic here */
 				Skein_assert(n < msgByteCnt);
 				memcpy(&ctx->b[ctx->h.bCnt], msg, n);
@@ -662,8 +629,7 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
 		 * now process any remaining full blocks, directly from input
 		 * message data
 		 */
-		if (msgByteCnt > SKEIN1024_BLOCK_BYTES)
-		{
+		if (msgByteCnt > SKEIN1024_BLOCK_BYTES) {
 			/* number of full blocks to process */
 			n = (msgByteCnt-1) / SKEIN1024_BLOCK_BYTES;
 			Skein1024_Process_Block(ctx, msg, n,
@@ -675,8 +641,7 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
 	}
 
 	/* copy any remaining source message data bytes into b[] */
-	if (msgByteCnt)
-	{
+	if (msgByteCnt) {
 		Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES);
 		memcpy(&ctx->b[ctx->h.bCnt], msg, msgByteCnt);
 		ctx->h.bCnt += msgByteCnt;
@@ -713,8 +678,7 @@ int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++)
-	{
+	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
@@ -823,8 +787,7 @@ int Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal)
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++)
-	{
+	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
@@ -863,8 +826,7 @@ int Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal)
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++)
-	{
+	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
@@ -903,8 +865,7 @@ int Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal)
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++)
-	{
+	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
-- 
1.9.1
