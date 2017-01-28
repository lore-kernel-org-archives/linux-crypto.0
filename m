From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 04/10] crypto: arm64/aes-ce-ccm - remove cra_alignmask
Date: Sat, 28 Jan 2017 23:25:33 +0000
Message-ID: <1485645939-17126-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1485645939-17126-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38057 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752007AbdA1X0C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Jan 2017 18:26:02 -0500
Received: by mail-wm0-f48.google.com with SMTP id r126so35379319wmr.1
        for <linux-crypto@vger.kernel.org>; Sat, 28 Jan 2017 15:26:01 -0800 (PST)
In-Reply-To: <1485645939-17126-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the unnecessary alignmask: it is much more efficient to deal with
the misalignment in the core algorithm than relying on the crypto API to
copy the data to a suitably aligned buffer.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index cc5515dac74a..6a7dbc7c83a6 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -258,7 +258,6 @@ static struct aead_alg ccm_aes_alg = {
 		.cra_priority		= 300,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_alignmask		= 7,
 		.cra_module		= THIS_MODULE,
 	},
 	.ivsize		= AES_BLOCK_SIZE,
-- 
2.7.4
