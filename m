From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/35] crypto: sha1_generic - Add export/import support
Date: Wed, 15 Jul 2009 15:15:55 +0800
Message-ID: <E1MQyiZ-0004y4-Lm@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53611 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752525AbZGOHP5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:15:57 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyiZ-0004o5-W0
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:15:56 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: sha1_generic - Add export/import support

This patch adds export/import support to sha1_generic.  The exported
type is defined by struct sha1_state, which is basically the entire
descriptor state of sha1_generic.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/sha1_generic.c |   41 +++++++++++++++++++++++++----------------
 include/crypto/sha.h  |    8 ++++++++
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 9efef20..0416091 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -25,31 +25,21 @@
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
 
-struct sha1_ctx {
-        u64 count;
-        u32 state[5];
-        u8 buffer[64];
-};
-
 static int sha1_init(struct shash_desc *desc)
 {
-	struct sha1_ctx *sctx = shash_desc_ctx(desc);
+	struct sha1_state *sctx = shash_desc_ctx(desc);
 
-	static const struct sha1_ctx initstate = {
-	  0,
-	  { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	  { 0, }
+	*sctx = (struct sha1_state){
+		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
 	};
 
-	*sctx = initstate;
-
 	return 0;
 }
 
 static int sha1_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
-	struct sha1_ctx *sctx = shash_desc_ctx(desc);
+	struct sha1_state *sctx = shash_desc_ctx(desc);
 	unsigned int partial, done;
 	const u8 *src;
 
@@ -85,7 +75,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 /* Add padding and return the message digest. */
 static int sha1_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha1_ctx *sctx = shash_desc_ctx(desc);
+	struct sha1_state *sctx = shash_desc_ctx(desc);
 	__be32 *dst = (__be32 *)out;
 	u32 i, index, padlen;
 	__be64 bits;
@@ -111,12 +101,31 @@ static int sha1_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
+static int sha1_export(struct shash_desc *desc, void *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+	return 0;
+}
+
+static int sha1_import(struct shash_desc *desc, const void *in)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+	return 0;
+}
+
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_init,
 	.update		=	sha1_update,
 	.final		=	sha1_final,
-	.descsize	=	sizeof(struct sha1_ctx),
+	.export		=	sha1_export,
+	.import		=	sha1_import,
+	.descsize	=	sizeof(struct sha1_state),
+	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-generic",
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index c0ccc2b..922a248 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -5,6 +5,8 @@
 #ifndef _CRYPTO_SHA_H
 #define _CRYPTO_SHA_H
 
+#include <linux/types.h>
+
 #define SHA1_DIGEST_SIZE        20
 #define SHA1_BLOCK_SIZE         64
 
@@ -62,4 +64,10 @@
 #define SHA512_H6	0x1f83d9abfb41bd6bULL
 #define SHA512_H7	0x5be0cd19137e2179ULL
 
+struct sha1_state {
+	u64 count;
+	u32 state[SHA1_DIGEST_SIZE / 4];
+	u8 buffer[SHA1_BLOCK_SIZE];
+};
+
 #endif
