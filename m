From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/2] crypto/algapi - use separate dst and src operands for __crypto_xor()
Date: Tue, 18 Jul 2017 10:19:11 +0100
Message-ID: <20170718091912.14104-2-ard.biesheuvel@linaro.org>
References: <20170718091912.14104-1-ard.biesheuvel@linaro.org>
Cc: ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170718091912.14104-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

In preparation of introducing crypto_xor_cpy(), which will use separate
operands for input and output, modify the __crypto_xor() implementation,
which it will share with the existing crypto_xor(), which provides the
actual functionality when not using the inline version.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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
