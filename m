From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH -stable] arm: crypto: reduce priority of bit-sliced AES cipher
Date: Fri, 17 Nov 2017 11:50:27 -0800
Message-ID: <20171117195027.88288-1-ebiggers@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: stable@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:37258 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934125AbdKQTv4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Nov 2017 14:51:56 -0500
Received: by mail-io0-f193.google.com with SMTP id v21so9918482ioi.4
        for <linux-crypto@vger.kernel.org>; Fri, 17 Nov 2017 11:51:56 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'd like the following patch to be applied to stable for versions
between 4.1 and 4.10 (inclusively).

This is a minimal fix for a bug where arm32 kernels can use a much
slower implementation of AES than is actually available, potentially
forcing vendors to disable encryption on their devices.

Min version is 4.1 because that was the first version to include the
aes-ce algorithms.

Max version is 4.10 because in 4.11, this bug was fixed incidentally as
part of a complete rewrite of the bit-sliced AES implementation.

---8<---

All the aes-bs (bit-sliced) and aes-ce (cryptographic extensions)
algorithms had a priority of 300.  This is undesirable because it means
an aes-bs algorithm may be used when an aes-ce algorithm is available.
The aes-ce algorithms have much better performance (up to 10x faster).

Fix it by decreasing the priority of the aes-bs algorithms to 250.

This was fixed upstream by commit cc477bf64573 ("crypto: arm/aes -
replace bit-sliced OpenSSL NEON code"), but it was just a small part of
a complete rewrite.  This patch just fixes the priority bug for older
kernels.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/aesbs-glue.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
index 0511a6cafe24..5d934a0039d7 100644
--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -363,7 +363,7 @@ static struct crypto_alg aesbs_algs[] = { {
 }, {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "cbc-aes-neonbs",
-	.cra_priority		= 300,
+	.cra_priority		= 250,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct async_helper_ctx),
@@ -383,7 +383,7 @@ static struct crypto_alg aesbs_algs[] = { {
 }, {
 	.cra_name		= "ctr(aes)",
 	.cra_driver_name	= "ctr-aes-neonbs",
-	.cra_priority		= 300,
+	.cra_priority		= 250,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct async_helper_ctx),
@@ -403,7 +403,7 @@ static struct crypto_alg aesbs_algs[] = { {
 }, {
 	.cra_name		= "xts(aes)",
 	.cra_driver_name	= "xts-aes-neonbs",
-	.cra_priority		= 300,
+	.cra_priority		= 250,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER|CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct async_helper_ctx),
-- 
2.15.0.448.gf294e3d99a-goog
