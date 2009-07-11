From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/10] crypto: sha256-s390 - Add export/import support
Date: Sat, 11 Jul 2009 18:23:13 +0800
Message-ID: <E1MPZjd-0003qW-7x@gondolin.me.apana.org.au>
References: <20090711101958.GA14642@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54388 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753751AbZGKKXP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Jul 2009 06:23:15 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MPZjd-000653-J7
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2009 20:23:13 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: sha256-s390 - Add export/import support

This patch adds export/import support to sha256-s390.  The exported
type is defined by struct sha256_state, which is basically the entire
descriptor state of sha256_generic.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/s390/crypto/sha256_s390.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/s390/crypto/sha256_s390.c b/arch/s390/crypto/sha256_s390.c
index f9fefc5..943a669 100644
--- a/arch/s390/crypto/sha256_s390.c
+++ b/arch/s390/crypto/sha256_s390.c
@@ -42,12 +42,38 @@ static int sha256_init(struct shash_desc *desc)
 	return 0;
 }
 
+static int sha256_export(struct shash_desc *desc, void *out)
+{
+	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
+	struct sha256_state *octx = out;
+
+	octx->count = sctx->count;
+	memcpy(octx->state, sctx->state, sizeof(octx->state));
+	memcpy(octx->buf, sctx->buf, sizeof(octx->buf));
+	return 0;
+}
+
+static int sha256_import(struct shash_desc *desc, const u8 *in)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct sha256_state *ictx = in;
+
+	sctx->count = ictx->count;
+	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
+	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
+	sctx->func = KIMD_SHA_256;
+	return 0;
+}
+
 static struct shash_alg alg = {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_init,
 	.update		=	s390_sha_update,
 	.final		=	s390_sha_final,
+	.export		=	sha256_export,
+	.import		=	sha256_import,
 	.descsize	=	sizeof(struct s390_sha_ctx),
+	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name=	"sha256-s390",
