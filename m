From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH bugfix 1/2] crypto: arm64/sha1-ce - prevent asm code finalization in final() path
Date: Wed,  6 May 2015 15:54:31 +0200
Message-ID: <1430920472-20416-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:32871 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbEFNzB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 09:55:01 -0400
Received: by wgin8 with SMTP id n8so12556699wgi.0
        for <linux-crypto@vger.kernel.org>; Wed, 06 May 2015 06:55:00 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ensure that the asm code finalization path is not triggered when
invoked via final(), since it already takes care of that itself.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha1-ce-glue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 114e7cc5de8c..aefda9868627 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -74,6 +74,9 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 
 static int sha1_ce_final(struct shash_desc *desc, u8 *out)
 {
+	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
+
+	sctx->finalize = 0;
 	kernel_neon_begin_partial(16);
 	sha1_base_do_finalize(desc, (sha1_block_fn *)sha1_ce_transform);
 	kernel_neon_end();
-- 
1.9.1
