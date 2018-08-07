From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v8 8/9] crypto: shash: Remove VLA usage in unaligned hashing
Date: Tue,  7 Aug 2018 14:18:42 -0700
Message-ID: <20180807211843.47586-9-keescook@chromium.org>
References: <20180807211843.47586-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        qat-linux@intel.com, l
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807211843.47586-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this uses
the newly defined max alignment to perform unaligned hashing to avoid
VLAs, and drops the helper function while adding sanity checks on the
resulting buffer sizes. Additionally, the __aligned_largest macro is
removed since this helper was the only user.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/shash.c               | 27 ++++++++++++++++-----------
 include/linux/compiler-gcc.h |  1 -
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 86d76b5c626c..d21f04d70dce 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -73,13 +73,6 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_shash_setkey);
 
-static inline unsigned int shash_align_buffer_size(unsigned len,
-						   unsigned long mask)
-{
-	typedef u8 __aligned_largest u8_aligned;
-	return len + (mask & ~(__alignof__(u8_aligned) - 1));
-}
-
 static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
 				  unsigned int len)
 {
@@ -88,11 +81,17 @@ static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
 	unsigned int unaligned_len = alignmask + 1 -
 				     ((unsigned long)data & alignmask);
-	u8 ubuf[shash_align_buffer_size(unaligned_len, alignmask)]
-		__aligned_largest;
+	/*
+	 * We cannot count on __aligned() working for large values:
+	 * https://patchwork.kernel.org/patch/9507697/
+	 */
+	u8 ubuf[MAX_ALGAPI_ALIGNMASK * 2];
 	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
 	int err;
 
+	if (WARN_ON(buf + unaligned_len > ubuf + sizeof(ubuf)))
+		return -EINVAL;
+
 	if (unaligned_len > len)
 		unaligned_len = len;
 
@@ -124,11 +123,17 @@ static int shash_final_unaligned(struct shash_desc *desc, u8 *out)
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned int ds = crypto_shash_digestsize(tfm);
-	u8 ubuf[shash_align_buffer_size(ds, alignmask)]
-		__aligned_largest;
+	/*
+	 * We cannot count on __aligned() working for large values:
+	 * https://patchwork.kernel.org/patch/9507697/
+	 */
+	u8 ubuf[MAX_ALGAPI_ALIGNMASK + HASH_MAX_DIGESTSIZE];
 	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
 	int err;
 
+	if (WARN_ON(buf + ds > ubuf + sizeof(ubuf)))
+		return -EINVAL;
+
 	err = shash->final(desc, buf);
 	if (err)
 		goto out;
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index f1a7492a5cc8..1f1cdef36a82 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -125,7 +125,6 @@
  */
 #define __pure			__attribute__((pure))
 #define __aligned(x)		__attribute__((aligned(x)))
-#define __aligned_largest	__attribute__((aligned))
 #define __printf(a, b)		__attribute__((format(printf, a, b)))
 #define __scanf(a, b)		__attribute__((format(scanf, a, b)))
 #define __attribute_const__	__attribute__((__const__))
-- 
2.17.1
