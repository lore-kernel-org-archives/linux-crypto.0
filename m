From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 04/10] crypto: arm64/aes-ce-ccm - remove cra_alignmask
Date: Mon, 23 Jan 2017 14:05:20 +0000
Message-ID: <1485180326-25612-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1485180326-25612-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34925 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdAWOFl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:05:41 -0500
Received: by mail-wm0-f54.google.com with SMTP id r126so134568044wmr.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2017 06:05:40 -0800 (PST)
In-Reply-To: <1485180326-25612-1-git-send-email-ard.biesheuvel@linaro.org>
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
