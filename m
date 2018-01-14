From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/3] crypto/generic: sha3 - fixes for alignment and big endian operation
Date: Sun, 14 Jan 2018 16:41:16 +0000
Message-ID: <20180114164118.18330-2-ard.biesheuvel@linaro.org>
References: <20180114164118.18330-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, steve.capper@linaro.org,
        jgarzik@redhat.com, arnd@arndb.de,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:44477 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbeANQlc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Jan 2018 11:41:32 -0500
Received: by mail-wm0-f66.google.com with SMTP id t74so1887731wme.3
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jan 2018 08:41:31 -0800 (PST)
In-Reply-To: <20180114164118.18330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ensure that the input is byte swabbed before injecting it into the
SHA3 transform. Use the get_unaligned() accessor for this so that
we don't perform unaligned access inadvertently on architectures
that do not support that.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/sha3_generic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 7e8ed96236ce..a68be626017c 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <crypto/sha3.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 #define KECCAK_ROUNDS 24
 
@@ -149,7 +150,7 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 			unsigned int i;
 
 			for (i = 0; i < sctx->rsizw; i++)
-				sctx->st[i] ^= ((u64 *) src)[i];
+				sctx->st[i] ^= get_unaligned_le64(src + 8 * i);
 			keccakf(sctx->st);
 
 			done += sctx->rsiz;
@@ -174,7 +175,7 @@ static int sha3_final(struct shash_desc *desc, u8 *out)
 	sctx->buf[sctx->rsiz - 1] |= 0x80;
 
 	for (i = 0; i < sctx->rsizw; i++)
-		sctx->st[i] ^= ((u64 *) sctx->buf)[i];
+		sctx->st[i] ^= get_unaligned_le64(sctx->buf + 8 * i);
 
 	keccakf(sctx->st);
 
-- 
2.11.0
