From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/35] crypto: sha256_generic - Add export/import support
Date: Wed, 15 Jul 2009 15:15:57 +0800
Message-ID: <E1MQyib-0004yM-RD@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53613 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752560AbZGOHP7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:15:59 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyic-0004oC-3L
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:15:58 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: sha256_generic - Add export/import support

This patch adds export/import support to sha256_generic.  The exported
type is defined by struct sha256_state, which is basically the entire
descriptor state of sha256_generic.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/sha256_generic.c |   37 +++++++++++++++++++++++++------------
 include/crypto/sha.h    |    6 ++++++
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index e58c71b..c48459e 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -25,12 +25,6 @@
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
 
-struct sha256_ctx {
-	u64 count;
-	u32 state[8];
-	u8 buf[128];
-};
-
 static inline u32 Ch(u32 x, u32 y, u32 z)
 {
 	return z ^ (x & (y ^ z));
@@ -222,7 +216,7 @@ static void sha256_transform(u32 *state, const u8 *input)
 
 static int sha224_init(struct shash_desc *desc)
 {
-	struct sha256_ctx *sctx = shash_desc_ctx(desc);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
 	sctx->state[0] = SHA224_H0;
 	sctx->state[1] = SHA224_H1;
 	sctx->state[2] = SHA224_H2;
@@ -238,7 +232,7 @@ static int sha224_init(struct shash_desc *desc)
 
 static int sha256_init(struct shash_desc *desc)
 {
-	struct sha256_ctx *sctx = shash_desc_ctx(desc);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
 	sctx->state[0] = SHA256_H0;
 	sctx->state[1] = SHA256_H1;
 	sctx->state[2] = SHA256_H2;
@@ -255,7 +249,7 @@ static int sha256_init(struct shash_desc *desc)
 static int sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	struct sha256_ctx *sctx = shash_desc_ctx(desc);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
 	unsigned int partial, done;
 	const u8 *src;
 
@@ -286,7 +280,7 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
 
 static int sha256_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha256_ctx *sctx = shash_desc_ctx(desc);
+	struct sha256_state *sctx = shash_desc_ctx(desc);
 	__be32 *dst = (__be32 *)out;
 	__be64 bits;
 	unsigned int index, pad_len;
@@ -326,12 +320,31 @@ static int sha224_final(struct shash_desc *desc, u8 *hash)
 	return 0;
 }
 
+static int sha256_export(struct shash_desc *desc, void *out)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+	return 0;
+}
+
+static int sha256_import(struct shash_desc *desc, const void *in)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+	return 0;
+}
+
 static struct shash_alg sha256 = {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_init,
 	.update		=	sha256_update,
 	.final		=	sha256_final,
-	.descsize	=	sizeof(struct sha256_ctx),
+	.export		=	sha256_export,
+	.import		=	sha256_import,
+	.descsize	=	sizeof(struct sha256_state),
+	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name=	"sha256-generic",
@@ -346,7 +359,7 @@ static struct shash_alg sha224 = {
 	.init		=	sha224_init,
 	.update		=	sha256_update,
 	.final		=	sha224_final,
-	.descsize	=	sizeof(struct sha256_ctx),
+	.descsize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name=	"sha224-generic",
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 922a248..88ef5eb 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -70,4 +70,10 @@ struct sha1_state {
 	u8 buffer[SHA1_BLOCK_SIZE];
 };
 
+struct sha256_state {
+	u64 count;
+	u32 state[SHA256_DIGEST_SIZE / 4];
+	u8 buf[SHA256_BLOCK_SIZE];
+};
+
 #endif
