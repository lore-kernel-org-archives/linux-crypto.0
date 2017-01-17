From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 06/10] crypto: arm64/chacha20 - remove cra_alignmask
Date: Tue, 17 Jan 2017 15:22:33 +0000
Message-ID: <1484666557-31458-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1484666557-31458-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36892 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdAQPX4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 10:23:56 -0500
Received: by mail-wm0-f44.google.com with SMTP id c206so227924887wme.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2017 07:23:03 -0800 (PST)
In-Reply-To: <1484666557-31458-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the unnecessary alignmask: it is much more efficient to deal with
the misalignment in the core algorithm than relying on the crypto API to
copy the data to a suitably aligned buffer.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/chacha20-neon-glue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/crypto/chacha20-neon-glue.c b/arch/arm64/crypto/chacha20-neon-glue.c
index a7f2337d46cf..a7cd575ea223 100644
--- a/arch/arm64/crypto/chacha20-neon-glue.c
+++ b/arch/arm64/crypto/chacha20-neon-glue.c
@@ -93,7 +93,6 @@ static struct skcipher_alg alg = {
 	.base.cra_priority	= 300,
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct chacha20_ctx),
-	.base.cra_alignmask	= 1,
 	.base.cra_module	= THIS_MODULE,
 
 	.min_keysize		= CHACHA20_KEY_SIZE,
-- 
2.7.4
