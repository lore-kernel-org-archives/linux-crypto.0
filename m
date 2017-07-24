From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 01/18] crypto/algapi - use separate dst and src operands for __crypto_xor()
Date: Mon, 24 Jul 2017 11:28:03 +0100
Message-ID: <20170724102820.16534-2-ard.biesheuvel@linaro.org>
References: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, dave.martin@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36236 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbdGXK2b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 06:28:31 -0400
Received: by mail-wm0-f43.google.com with SMTP id t201so14634211wmt.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jul 2017 03:28:30 -0700 (PDT)
In-Reply-To: <20170724102820.16534-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In preparation of introducing crypto_xor_cpy(), which will use separate
operands for input and output, modify the __crypto_xor() implementation,
which it will share with the existing crypto_xor(), which provides the
actual functionality when not using the inline version.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/algapi.c         | 25 ++++++++++++--------
 include/crypto/algapi.h |  4 ++--
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e4cc7615a139..aa699ff6c876 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -975,13 +975,15 @@ void crypto_inc(u8 *a, unsigned int size)
 }
 EXPORT_SYMBOL_GPL(crypto_inc);
 
-void __crypto_xor(u8 *dst, const u8 *src, unsigned int len)
+void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
 {
 	int relalign = 0;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
 		int size = sizeof(unsigned long);
-		int d = ((unsigned long)dst ^ (unsigned long)src) & (size - 1);
+		int d = (((unsigned long)dst ^ (unsigned long)src1) |
+			 ((unsigned long)dst ^ (unsigned long)src2)) &
+			(size - 1);
 
 		relalign = d ? 1 << __ffs(d) : size;
 
@@ -992,34 +994,37 @@ void __crypto_xor(u8 *dst, const u8 *src, unsigned int len)
 		 * process the remainder of the input using optimal strides.
 		 */
 		while (((unsigned long)dst & (relalign - 1)) && len > 0) {
-			*dst++ ^= *src++;
+			*dst++ = *src1++ ^ *src2++;
 			len--;
 		}
 	}
 
 	while (IS_ENABLED(CONFIG_64BIT) && len >= 8 && !(relalign & 7)) {
-		*(u64 *)dst ^= *(u64 *)src;
+		*(u64 *)dst = *(u64 *)src1 ^  *(u64 *)src2;
 		dst += 8;
-		src += 8;
+		src1 += 8;
+		src2 += 8;
 		len -= 8;
 	}
 
 	while (len >= 4 && !(relalign & 3)) {
-		*(u32 *)dst ^= *(u32 *)src;
+		*(u32 *)dst = *(u32 *)src1 ^ *(u32 *)src2;
 		dst += 4;
-		src += 4;
+		src1 += 4;
+		src2 += 4;
 		len -= 4;
 	}
 
 	while (len >= 2 && !(relalign & 1)) {
-		*(u16 *)dst ^= *(u16 *)src;
+		*(u16 *)dst = *(u16 *)src1 ^ *(u16 *)src2;
 		dst += 2;
-		src += 2;
+		src1 += 2;
+		src2 += 2;
 		len -= 2;
 	}
 
 	while (len--)
-		*dst++ ^= *src++;
+		*dst++ = *src1++ ^ *src2++;
 }
 EXPORT_SYMBOL_GPL(__crypto_xor);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 436c4c2683c7..fd547f946bf8 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -192,7 +192,7 @@ static inline unsigned int crypto_queue_len(struct crypto_queue *queue)
 }
 
 void crypto_inc(u8 *a, unsigned int size);
-void __crypto_xor(u8 *dst, const u8 *src, unsigned int size);
+void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int size);
 
 static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
 {
@@ -207,7 +207,7 @@ static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
 			size -= sizeof(unsigned long);
 		}
 	} else {
-		__crypto_xor(dst, src, size);
+		__crypto_xor(dst, dst, src, size);
 	}
 }
 
-- 
2.9.3
