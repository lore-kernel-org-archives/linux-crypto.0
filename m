From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/6] crypto: sha512-s390 - Add export/import support
Date: Wed, 22 Jul 2009 14:40:08 +0800
Message-ID: <E1MTVUm-0007k9-OZ@gondolin.me.apana.org.au>
References: <20090722063844.GA28998@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51385 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756488AbZGVGkK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 02:40:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MTVUn-0005yz-4L
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2009 16:40:09 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: sha512-s390 - Add export/import support
    
This patch adds export/import support to sha512-s390 (which includes
sha384-s390).  The exported type is defined by struct sha512_state,
which is basically the entire descriptor state of sha512_generic.

Since sha512-s390 only supports a 64-bit byte count the import
function will reject anything that exceeds that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/s390/crypto/sha512_s390.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index 83192bf..b4b3438 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -13,7 +13,10 @@
  *
  */
 #include <crypto/internal/hash.h>
+#include <crypto/sha.h>
+#include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
 #include "sha.h"
@@ -37,12 +40,42 @@ static int sha512_init(struct shash_desc *desc)
 	return 0;
 }
 
+static int sha512_export(struct shash_desc *desc, void *out)
+{
+	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
+	struct sha512_state *octx = out;
+
+	octx->count[0] = sctx->count;
+	octx->count[1] = 0;
+	memcpy(octx->state, sctx->state, sizeof(octx->state));
+	memcpy(octx->buf, sctx->buf, sizeof(octx->buf));
+	return 0;
+}
+
+static int sha512_import(struct shash_desc *desc, const u8 *in)
+{
+	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
+	struct sha512_state *ictx = in;
+
+	if (unlikely(ictx->count[1]))
+		return -ERANGE;
+	sctx->count = ictx->count[0];
+
+	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
+	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
+	sctx->func = KIMD_SHA_512;
+	return 0;
+}
+
 static struct shash_alg sha512_alg = {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_init,
 	.update		=	s390_sha_update,
 	.final		=	s390_sha_final,
+	.export		=	sha512_export,
+	.import		=	sha512_import,
 	.descsize	=	sizeof(struct s390_sha_ctx),
+	.statesize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_driver_name=	"sha512-s390",
@@ -78,7 +111,10 @@ static struct shash_alg sha384_alg = {
 	.init		=	sha384_init,
 	.update		=	s390_sha_update,
 	.final		=	s390_sha_final,
+	.export		=	sha512_export,
+	.import		=	sha512_import,
 	.descsize	=	sizeof(struct s390_sha_ctx),
+	.statesize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_driver_name=	"sha384-s390",
