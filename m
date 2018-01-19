From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/8] crypto/generic: sha3 - fixes for alignment and big endian operation
Date: Fri, 19 Jan 2018 12:04:33 +0000
Message-ID: <20180119120440.31556-2-ard.biesheuvel@linaro.org>
References: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38046 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbeASMFP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 07:05:15 -0500
Received: by mail-wr0-f196.google.com with SMTP id x1so1372877wrb.5
        for <linux-crypto@vger.kernel.org>; Fri, 19 Jan 2018 04:05:15 -0800 (PST)
In-Reply-To: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ensure that the input is byte swabbed before injecting it into the
SHA3 transform. Use the get_unaligned() accessor for this so that
we don't perform unaligned access inadvertently on architectures
that do not support that.

Cc: <stable@vger.kernel.org>
Fixes: 53964b9ee63b7075 ("crypto: sha3 - Add SHA-3 hash algorithm")
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
