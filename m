From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4/4] crypto: arm64/aes-ce-ctr: fix skcipher conversion
Date: Tue, 29 Nov 2016 13:05:33 +0000
Message-ID: <1480424733-10797-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1480424733-10797-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f169.google.com ([209.85.210.169]:34835 "EHLO
        mail-wj0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933366AbcK2NFq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 08:05:46 -0500
Received: by mail-wj0-f169.google.com with SMTP id v7so144534489wjy.2
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2016 05:05:46 -0800 (PST)
In-Reply-To: <1480424733-10797-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix a missing statement that got lost in the skcipher conversion of
the CTR transform.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 5c43b92b3714..4e3f8adb1793 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -206,6 +206,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 				(u8 *)ctx->key_enc, rounds, blocks, walk.iv,
 				first);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		first = 0;
 	}
 	if (walk.nbytes) {
 		u8 __aligned(8) tail[AES_BLOCK_SIZE];
-- 
2.7.4
