From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm64/crc32: bring in line with generic CRC32
Date: Mon,  4 May 2015 11:00:16 +0200
Message-ID: <1430730017-3712-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: yazen.ghannam@linaro.org, steve.capper@linaro.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33344 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbbEDJAq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 05:00:46 -0400
Received: by wief7 with SMTP id f7so72723218wie.0
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2015 02:00:45 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The arm64 CRC32 (not CRC32c) implementation was not quite doing
the same thing as the generic one. Fix that.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crc32-arm64.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/crc32-arm64.c b/arch/arm64/crypto/crc32-arm64.c
index 9499199924ae..6a37c3c6b11d 100644
--- a/arch/arm64/crypto/crc32-arm64.c
+++ b/arch/arm64/crypto/crc32-arm64.c
@@ -147,13 +147,21 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
+	put_unaligned_le32(ctx->crc, out);
+	return 0;
+}
+
+static int chksumc_final(struct shash_desc *desc, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
 	put_unaligned_le32(~ctx->crc, out);
 	return 0;
 }
 
 static int __chksum_finup(u32 crc, const u8 *data, unsigned int len, u8 *out)
 {
-	put_unaligned_le32(~crc32_arm64_le_hw(crc, data, len), out);
+	put_unaligned_le32(crc32_arm64_le_hw(crc, data, len), out);
 	return 0;
 }
 
@@ -199,6 +207,14 @@ static int crc32_cra_init(struct crypto_tfm *tfm)
 {
 	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
 
+	mctx->key = 0;
+	return 0;
+}
+
+static int crc32c_cra_init(struct crypto_tfm *tfm)
+{
+	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
+
 	mctx->key = ~0;
 	return 0;
 }
@@ -229,7 +245,7 @@ static struct shash_alg crc32c_alg = {
 	.setkey			=	chksum_setkey,
 	.init			=	chksum_init,
 	.update			=	chksumc_update,
-	.final			=	chksum_final,
+	.final			=	chksumc_final,
 	.finup			=	chksumc_finup,
 	.digest			=	chksumc_digest,
 	.descsize		=	sizeof(struct chksum_desc_ctx),
@@ -241,7 +257,7 @@ static struct shash_alg crc32c_alg = {
 		.cra_alignmask		=	0,
 		.cra_ctxsize		=	sizeof(struct chksum_ctx),
 		.cra_module		=	THIS_MODULE,
-		.cra_init		=	crc32_cra_init,
+		.cra_init		=	crc32c_cra_init,
 	}
 };
 
-- 
1.9.1
