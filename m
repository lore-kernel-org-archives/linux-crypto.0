From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/6] crypto: sha512 - Export struct sha512_state
Date: Wed, 22 Jul 2009 14:40:06 +0800
Message-ID: <E1MTVUk-0007jr-Il@gondolin.me.apana.org.au>
References: <20090722063844.GA28998@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51383 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753223AbZGVGkH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 02:40:07 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MTVUk-0005yr-Sp
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2009 16:40:06 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: sha512 - Export struct sha512_state

This patch renames struct sha512_ctx and exports it as struct
sha512_state so that other sha512 implementations can use it
as the reference structure for exporting their state.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/sha512_generic.c |   20 +++++++-------------
 include/crypto/sha.h    |    6 ++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 3bea38d..4fe95eb 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -21,12 +21,6 @@
 #include <linux/percpu.h>
 #include <asm/byteorder.h>
 
-struct sha512_ctx {
-	u64 state[8];
-	u32 count[4];
-	u8 buf[128];
-};
-
 static DEFINE_PER_CPU(u64[80], msg_schedule);
 
 static inline u64 Ch(u64 x, u64 y, u64 z)
@@ -141,7 +135,7 @@ sha512_transform(u64 *state, const u8 *input)
 static int
 sha512_init(struct shash_desc *desc)
 {
-	struct sha512_ctx *sctx = shash_desc_ctx(desc);
+	struct sha512_state *sctx = shash_desc_ctx(desc);
 	sctx->state[0] = SHA512_H0;
 	sctx->state[1] = SHA512_H1;
 	sctx->state[2] = SHA512_H2;
@@ -158,7 +152,7 @@ sha512_init(struct shash_desc *desc)
 static int
 sha384_init(struct shash_desc *desc)
 {
-	struct sha512_ctx *sctx = shash_desc_ctx(desc);
+	struct sha512_state *sctx = shash_desc_ctx(desc);
 	sctx->state[0] = SHA384_H0;
 	sctx->state[1] = SHA384_H1;
 	sctx->state[2] = SHA384_H2;
@@ -175,7 +169,7 @@ sha384_init(struct shash_desc *desc)
 static int
 sha512_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 {
-	struct sha512_ctx *sctx = shash_desc_ctx(desc);
+	struct sha512_state *sctx = shash_desc_ctx(desc);
 
 	unsigned int i, index, part_len;
 
@@ -214,7 +208,7 @@ sha512_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 static int
 sha512_final(struct shash_desc *desc, u8 *hash)
 {
-	struct sha512_ctx *sctx = shash_desc_ctx(desc);
+	struct sha512_state *sctx = shash_desc_ctx(desc);
         static u8 padding[128] = { 0x80, };
 	__be64 *dst = (__be64 *)hash;
 	__be32 bits[4];
@@ -240,7 +234,7 @@ sha512_final(struct shash_desc *desc, u8 *hash)
 		dst[i] = cpu_to_be64(sctx->state[i]);
 
 	/* Zeroize sensitive information. */
-	memset(sctx, 0, sizeof(struct sha512_ctx));
+	memset(sctx, 0, sizeof(struct sha512_state));
 
 	return 0;
 }
@@ -262,7 +256,7 @@ static struct shash_alg sha512 = {
 	.init		=	sha512_init,
 	.update		=	sha512_update,
 	.final		=	sha512_final,
-	.descsize	=	sizeof(struct sha512_ctx),
+	.descsize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
@@ -276,7 +270,7 @@ static struct shash_alg sha384 = {
 	.init		=	sha384_init,
 	.update		=	sha512_update,
 	.final		=	sha384_final,
-	.descsize	=	sizeof(struct sha512_ctx),
+	.descsize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 88ef5eb..45b25cc 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -76,4 +76,10 @@ struct sha256_state {
 	u8 buf[SHA256_BLOCK_SIZE];
 };
 
+struct sha512_state {
+	u64 state[8];
+	u32 count[4];
+	u8 buf[128];
+};
+
 #endif
