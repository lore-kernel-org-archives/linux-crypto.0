From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/35] crypto: sha1-s390 - Add export/import support
Date: Wed, 15 Jul 2009 15:15:58 +0800
Message-ID: <E1MQyic-0004yV-Tn@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53615 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752552AbZGOHQB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:01 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyid-0004oQ-9N
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:15:59 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: sha1-s390 - Add export/import support

This patch adds export/import support to sha1-s390.  The exported
type is defined by struct sha1_state, which is basically the entire
descriptor state of sha1_generic.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/s390/crypto/sha1_s390.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
index e85ba34..2c5ec79 100644
--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -46,12 +46,38 @@ static int sha1_init(struct shash_desc *desc)
 	return 0;
 }
 
+static int sha1_export(struct shash_desc *desc, void *out)
+{
+	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
+	struct sha1_state *octx = out;
+
+	octx->count = sctx->count;
+	memcpy(octx->state, sctx->state, sizeof(octx->state));
+	memcpy(octx->buffer, sctx->buf, sizeof(octx->buffer));
+	return 0;
+}
+
+static int sha1_import(struct shash_desc *desc, const u8 *in)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	struct sha1_state *ictx = in;
+
+	sctx->count = ictx->count;
+	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
+	memcpy(sctx->buf, ictx->buffer, sizeof(ictx->buffer));
+	sctx->func = KIMD_SHA_1;
+	return 0;
+}
+
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_init,
 	.update		=	s390_sha_update,
 	.final		=	s390_sha_final,
+	.export		=	sha1_export,
+	.import		=	sha1_import,
 	.descsize	=	sizeof(struct s390_sha_ctx),
+	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-s390",
