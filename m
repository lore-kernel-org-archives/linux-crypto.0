From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/2] crypto: algapi - annotate expected branch behavior in crypto_inc()
Date: Tue, 14 Feb 2017 21:51:02 +0000
Message-ID: <1487109062-3419-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1487109062-3419-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38081 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752651AbdBNVv3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 16:51:29 -0500
Received: by mail-wm0-f52.google.com with SMTP id r141so27800353wmg.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2017 13:51:28 -0800 (PST)
In-Reply-To: <1487109062-3419-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To prevent unnecessary branching, mark the exit condition of the
primary loop as likely(), given that a carry in a 32-bit counter
occurs very rarely.

On arm64, the resulting code is emitted by GCC as

     9a8:   cmp     w1, #0x3
     9ac:   add     x3, x0, w1, uxtw
     9b0:   b.ls    9e0 <crypto_inc+0x38>
     9b4:   ldr     w2, [x3,#-4]!
     9b8:   rev     w2, w2
     9bc:   add     w2, w2, #0x1
     9c0:   rev     w4, w2
     9c4:   str     w4, [x3]
     9c8:   cbz     w2, 9d0 <crypto_inc+0x28>
     9cc:   ret

where the two remaining branch conditions (one for size < 4 and one for
the carry) are statically predicted as non-taken, resulting in optimal
execution in the vast majority of cases.

Also, replace the open coded alignment test with IS_ALIGNED().

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v2: no change

 crypto/algapi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 6b52e8f0b95f..9eed4ef9c971 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -963,11 +963,11 @@ void crypto_inc(u8 *a, unsigned int size)
 	u32 c;
 
 	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
-	    !((unsigned long)b & (__alignof__(*b) - 1)))
+	    IS_ALIGNED((unsigned long)b, __alignof__(*b)))
 		for (; size >= 4; size -= 4) {
 			c = be32_to_cpu(*--b) + 1;
 			*b = cpu_to_be32(c);
-			if (c)
+			if (likely(c))
 				return;
 		}
 
-- 
2.7.4
