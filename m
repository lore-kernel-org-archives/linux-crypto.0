From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 8/8] crypto: arm/aes-ce - fix for big endian
Date: Tue, 11 Oct 2016 19:15:20 +0100
Message-ID: <1476209720-21114-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: will.deacon@arm.com, catalin.marinas@arm.com,
        linux@arm.linux.org.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37894 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753147AbcJKSQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Oct 2016 14:16:09 -0400
Received: by mail-wm0-f45.google.com with SMTP id c78so873374wme.1
        for <linux-crypto@vger.kernel.org>; Tue, 11 Oct 2016 11:15:50 -0700 (PDT)
In-Reply-To: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES key schedule generation is mostly endian agnostic, with the
exception of the rotation and the incorporation of the round constant
at the start of each round. So implement a big endian specific version
of that part to make the whole routine big endian compatible.

Fixes: 86464859cc77 ("crypto: arm - AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-glue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index aef022a87c53..04410d9f5e72 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -88,8 +88,13 @@ static int ce_aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		u32 *rki = ctx->key_enc + (i * kwords);
 		u32 *rko = rki + kwords;
 
+#ifndef CONFIG_CPU_BIG_ENDIAN
 		rko[0] = ror32(ce_aes_sub(rki[kwords - 1]), 8);
 		rko[0] = rko[0] ^ rki[0] ^ rcon[i];
+#else
+		rko[0] = rol32(ce_aes_sub(rki[kwords - 1]), 8);
+		rko[0] = rko[0] ^ rki[0] ^ (rcon[i] << 24);
+#endif
 		rko[1] = rko[0] ^ rki[1];
 		rko[2] = rko[1] ^ rki[2];
 		rko[3] = rko[2] ^ rki[3];
-- 
2.7.4
