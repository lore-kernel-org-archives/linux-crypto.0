From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] md5: remove from lib and only live in crypto
Date: Thu, 16 Mar 2017 15:18:57 +0100
Message-ID: <20170316141857.20910-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:33999 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbdCPOTM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 10:19:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The md5_transform function is no longer used any where in the tree,
except for the crypto api's actual implementation of md5, so we can drop
the function from lib and put it as a static function of the crypto
file, where it belongs. There should be no new users of md5_transform,
anyway, since there are more modern ways of doing what it once achieved.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
In the last patch like this, we managed to get rid of halfmd4 from this
file. In this series we get rid of md5, now that the patches have landed
that remove such improper md5 usage from the kernel. When a final
dependency on the (dead) sha1 is removed, then cryptohash.h will be removed
all together. This patch is for the md5 removal.


 crypto/md5.c               | 95 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/cryptohash.h |  5 ---
 lib/Makefile               |  2 +-
 lib/md5.c                  | 95 ----------------------------------------------
 4 files changed, 95 insertions(+), 102 deletions(-)
 delete mode 100644 lib/md5.c

diff --git a/crypto/md5.c b/crypto/md5.c
index 2355a7c25c45..f7ae1a48225b 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -21,9 +21,11 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/types.h>
-#include <linux/cryptohash.h>
 #include <asm/byteorder.h>
 
+#define MD5_DIGEST_WORDS 4
+#define MD5_MESSAGE_BYTES 64
+
 const u8 md5_zero_message_hash[MD5_DIGEST_SIZE] = {
 	0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
 	0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
@@ -47,6 +49,97 @@ static inline void cpu_to_le32_array(u32 *buf, unsigned int words)
 	}
 }
 
+#define F1(x, y, z)	(z ^ (x & (y ^ z)))
+#define F2(x, y, z)	F1(z, x, y)
+#define F3(x, y, z)	(x ^ y ^ z)
+#define F4(x, y, z)	(y ^ (x | ~z))
+
+#define MD5STEP(f, w, x, y, z, in, s) \
+	(w += f(x, y, z) + in, w = (w<<s | w>>(32-s)) + x)
+
+static void md5_transform(__u32 *hash, __u32 const *in)
+{
+	u32 a, b, c, d;
+
+	a = hash[0];
+	b = hash[1];
+	c = hash[2];
+	d = hash[3];
+
+	MD5STEP(F1, a, b, c, d, in[0] + 0xd76aa478, 7);
+	MD5STEP(F1, d, a, b, c, in[1] + 0xe8c7b756, 12);
+	MD5STEP(F1, c, d, a, b, in[2] + 0x242070db, 17);
+	MD5STEP(F1, b, c, d, a, in[3] + 0xc1bdceee, 22);
+	MD5STEP(F1, a, b, c, d, in[4] + 0xf57c0faf, 7);
+	MD5STEP(F1, d, a, b, c, in[5] + 0x4787c62a, 12);
+	MD5STEP(F1, c, d, a, b, in[6] + 0xa8304613, 17);
+	MD5STEP(F1, b, c, d, a, in[7] + 0xfd469501, 22);
+	MD5STEP(F1, a, b, c, d, in[8] + 0x698098d8, 7);
+	MD5STEP(F1, d, a, b, c, in[9] + 0x8b44f7af, 12);
+	MD5STEP(F1, c, d, a, b, in[10] + 0xffff5bb1, 17);
+	MD5STEP(F1, b, c, d, a, in[11] + 0x895cd7be, 22);
+	MD5STEP(F1, a, b, c, d, in[12] + 0x6b901122, 7);
+	MD5STEP(F1, d, a, b, c, in[13] + 0xfd987193, 12);
+	MD5STEP(F1, c, d, a, b, in[14] + 0xa679438e, 17);
+	MD5STEP(F1, b, c, d, a, in[15] + 0x49b40821, 22);
+
+	MD5STEP(F2, a, b, c, d, in[1] + 0xf61e2562, 5);
+	MD5STEP(F2, d, a, b, c, in[6] + 0xc040b340, 9);
+	MD5STEP(F2, c, d, a, b, in[11] + 0x265e5a51, 14);
+	MD5STEP(F2, b, c, d, a, in[0] + 0xe9b6c7aa, 20);
+	MD5STEP(F2, a, b, c, d, in[5] + 0xd62f105d, 5);
+	MD5STEP(F2, d, a, b, c, in[10] + 0x02441453, 9);
+	MD5STEP(F2, c, d, a, b, in[15] + 0xd8a1e681, 14);
+	MD5STEP(F2, b, c, d, a, in[4] + 0xe7d3fbc8, 20);
+	MD5STEP(F2, a, b, c, d, in[9] + 0x21e1cde6, 5);
+	MD5STEP(F2, d, a, b, c, in[14] + 0xc33707d6, 9);
+	MD5STEP(F2, c, d, a, b, in[3] + 0xf4d50d87, 14);
+	MD5STEP(F2, b, c, d, a, in[8] + 0x455a14ed, 20);
+	MD5STEP(F2, a, b, c, d, in[13] + 0xa9e3e905, 5);
+	MD5STEP(F2, d, a, b, c, in[2] + 0xfcefa3f8, 9);
+	MD5STEP(F2, c, d, a, b, in[7] + 0x676f02d9, 14);
+	MD5STEP(F2, b, c, d, a, in[12] + 0x8d2a4c8a, 20);
+
+	MD5STEP(F3, a, b, c, d, in[5] + 0xfffa3942, 4);
+	MD5STEP(F3, d, a, b, c, in[8] + 0x8771f681, 11);
+	MD5STEP(F3, c, d, a, b, in[11] + 0x6d9d6122, 16);
+	MD5STEP(F3, b, c, d, a, in[14] + 0xfde5380c, 23);
+	MD5STEP(F3, a, b, c, d, in[1] + 0xa4beea44, 4);
+	MD5STEP(F3, d, a, b, c, in[4] + 0x4bdecfa9, 11);
+	MD5STEP(F3, c, d, a, b, in[7] + 0xf6bb4b60, 16);
+	MD5STEP(F3, b, c, d, a, in[10] + 0xbebfbc70, 23);
+	MD5STEP(F3, a, b, c, d, in[13] + 0x289b7ec6, 4);
+	MD5STEP(F3, d, a, b, c, in[0] + 0xeaa127fa, 11);
+	MD5STEP(F3, c, d, a, b, in[3] + 0xd4ef3085, 16);
+	MD5STEP(F3, b, c, d, a, in[6] + 0x04881d05, 23);
+	MD5STEP(F3, a, b, c, d, in[9] + 0xd9d4d039, 4);
+	MD5STEP(F3, d, a, b, c, in[12] + 0xe6db99e5, 11);
+	MD5STEP(F3, c, d, a, b, in[15] + 0x1fa27cf8, 16);
+	MD5STEP(F3, b, c, d, a, in[2] + 0xc4ac5665, 23);
+
+	MD5STEP(F4, a, b, c, d, in[0] + 0xf4292244, 6);
+	MD5STEP(F4, d, a, b, c, in[7] + 0x432aff97, 10);
+	MD5STEP(F4, c, d, a, b, in[14] + 0xab9423a7, 15);
+	MD5STEP(F4, b, c, d, a, in[5] + 0xfc93a039, 21);
+	MD5STEP(F4, a, b, c, d, in[12] + 0x655b59c3, 6);
+	MD5STEP(F4, d, a, b, c, in[3] + 0x8f0ccc92, 10);
+	MD5STEP(F4, c, d, a, b, in[10] + 0xffeff47d, 15);
+	MD5STEP(F4, b, c, d, a, in[1] + 0x85845dd1, 21);
+	MD5STEP(F4, a, b, c, d, in[8] + 0x6fa87e4f, 6);
+	MD5STEP(F4, d, a, b, c, in[15] + 0xfe2ce6e0, 10);
+	MD5STEP(F4, c, d, a, b, in[6] + 0xa3014314, 15);
+	MD5STEP(F4, b, c, d, a, in[13] + 0x4e0811a1, 21);
+	MD5STEP(F4, a, b, c, d, in[4] + 0xf7537e82, 6);
+	MD5STEP(F4, d, a, b, c, in[11] + 0xbd3af235, 10);
+	MD5STEP(F4, c, d, a, b, in[2] + 0x2ad7d2bb, 15);
+	MD5STEP(F4, b, c, d, a, in[9] + 0xeb86d391, 21);
+
+	hash[0] += a;
+	hash[1] += b;
+	hash[2] += c;
+	hash[3] += d;
+}
+
 static inline void md5_transform_helper(struct md5_state *ctx)
 {
 	le32_to_cpu_array(ctx->block, sizeof(ctx->block) / sizeof(u32));
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index 3252799832cf..df4d3e943d28 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -10,9 +10,4 @@
 void sha_init(__u32 *buf);
 void sha_transform(__u32 *digest, const char *data, __u32 *W);
 
-#define MD5_DIGEST_WORDS 4
-#define MD5_MESSAGE_BYTES 64
-
-void md5_transform(__u32 *hash, __u32 const *in);
-
 #endif
diff --git a/lib/Makefile b/lib/Makefile
index 320ac46a8725..acbc16bed9af 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -19,7 +19,7 @@ KCOV_INSTRUMENT_dynamic_debug.o := n
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o \
-	 sha1.o chacha20.o md5.o irq_regs.o argv_split.o \
+	 sha1.o chacha20.o irq_regs.o argv_split.o \
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o \
diff --git a/lib/md5.c b/lib/md5.c
deleted file mode 100644
index bb0cd01d356d..000000000000
--- a/lib/md5.c
+++ /dev/null
@@ -1,95 +0,0 @@
-#include <linux/compiler.h>
-#include <linux/export.h>
-#include <linux/cryptohash.h>
-
-#define F1(x, y, z)	(z ^ (x & (y ^ z)))
-#define F2(x, y, z)	F1(z, x, y)
-#define F3(x, y, z)	(x ^ y ^ z)
-#define F4(x, y, z)	(y ^ (x | ~z))
-
-#define MD5STEP(f, w, x, y, z, in, s) \
-	(w += f(x, y, z) + in, w = (w<<s | w>>(32-s)) + x)
-
-void md5_transform(__u32 *hash, __u32 const *in)
-{
-	u32 a, b, c, d;
-
-	a = hash[0];
-	b = hash[1];
-	c = hash[2];
-	d = hash[3];
-
-	MD5STEP(F1, a, b, c, d, in[0] + 0xd76aa478, 7);
-	MD5STEP(F1, d, a, b, c, in[1] + 0xe8c7b756, 12);
-	MD5STEP(F1, c, d, a, b, in[2] + 0x242070db, 17);
-	MD5STEP(F1, b, c, d, a, in[3] + 0xc1bdceee, 22);
-	MD5STEP(F1, a, b, c, d, in[4] + 0xf57c0faf, 7);
-	MD5STEP(F1, d, a, b, c, in[5] + 0x4787c62a, 12);
-	MD5STEP(F1, c, d, a, b, in[6] + 0xa8304613, 17);
-	MD5STEP(F1, b, c, d, a, in[7] + 0xfd469501, 22);
-	MD5STEP(F1, a, b, c, d, in[8] + 0x698098d8, 7);
-	MD5STEP(F1, d, a, b, c, in[9] + 0x8b44f7af, 12);
-	MD5STEP(F1, c, d, a, b, in[10] + 0xffff5bb1, 17);
-	MD5STEP(F1, b, c, d, a, in[11] + 0x895cd7be, 22);
-	MD5STEP(F1, a, b, c, d, in[12] + 0x6b901122, 7);
-	MD5STEP(F1, d, a, b, c, in[13] + 0xfd987193, 12);
-	MD5STEP(F1, c, d, a, b, in[14] + 0xa679438e, 17);
-	MD5STEP(F1, b, c, d, a, in[15] + 0x49b40821, 22);
-
-	MD5STEP(F2, a, b, c, d, in[1] + 0xf61e2562, 5);
-	MD5STEP(F2, d, a, b, c, in[6] + 0xc040b340, 9);
-	MD5STEP(F2, c, d, a, b, in[11] + 0x265e5a51, 14);
-	MD5STEP(F2, b, c, d, a, in[0] + 0xe9b6c7aa, 20);
-	MD5STEP(F2, a, b, c, d, in[5] + 0xd62f105d, 5);
-	MD5STEP(F2, d, a, b, c, in[10] + 0x02441453, 9);
-	MD5STEP(F2, c, d, a, b, in[15] + 0xd8a1e681, 14);
-	MD5STEP(F2, b, c, d, a, in[4] + 0xe7d3fbc8, 20);
-	MD5STEP(F2, a, b, c, d, in[9] + 0x21e1cde6, 5);
-	MD5STEP(F2, d, a, b, c, in[14] + 0xc33707d6, 9);
-	MD5STEP(F2, c, d, a, b, in[3] + 0xf4d50d87, 14);
-	MD5STEP(F2, b, c, d, a, in[8] + 0x455a14ed, 20);
-	MD5STEP(F2, a, b, c, d, in[13] + 0xa9e3e905, 5);
-	MD5STEP(F2, d, a, b, c, in[2] + 0xfcefa3f8, 9);
-	MD5STEP(F2, c, d, a, b, in[7] + 0x676f02d9, 14);
-	MD5STEP(F2, b, c, d, a, in[12] + 0x8d2a4c8a, 20);
-
-	MD5STEP(F3, a, b, c, d, in[5] + 0xfffa3942, 4);
-	MD5STEP(F3, d, a, b, c, in[8] + 0x8771f681, 11);
-	MD5STEP(F3, c, d, a, b, in[11] + 0x6d9d6122, 16);
-	MD5STEP(F3, b, c, d, a, in[14] + 0xfde5380c, 23);
-	MD5STEP(F3, a, b, c, d, in[1] + 0xa4beea44, 4);
-	MD5STEP(F3, d, a, b, c, in[4] + 0x4bdecfa9, 11);
-	MD5STEP(F3, c, d, a, b, in[7] + 0xf6bb4b60, 16);
-	MD5STEP(F3, b, c, d, a, in[10] + 0xbebfbc70, 23);
-	MD5STEP(F3, a, b, c, d, in[13] + 0x289b7ec6, 4);
-	MD5STEP(F3, d, a, b, c, in[0] + 0xeaa127fa, 11);
-	MD5STEP(F3, c, d, a, b, in[3] + 0xd4ef3085, 16);
-	MD5STEP(F3, b, c, d, a, in[6] + 0x04881d05, 23);
-	MD5STEP(F3, a, b, c, d, in[9] + 0xd9d4d039, 4);
-	MD5STEP(F3, d, a, b, c, in[12] + 0xe6db99e5, 11);
-	MD5STEP(F3, c, d, a, b, in[15] + 0x1fa27cf8, 16);
-	MD5STEP(F3, b, c, d, a, in[2] + 0xc4ac5665, 23);
-
-	MD5STEP(F4, a, b, c, d, in[0] + 0xf4292244, 6);
-	MD5STEP(F4, d, a, b, c, in[7] + 0x432aff97, 10);
-	MD5STEP(F4, c, d, a, b, in[14] + 0xab9423a7, 15);
-	MD5STEP(F4, b, c, d, a, in[5] + 0xfc93a039, 21);
-	MD5STEP(F4, a, b, c, d, in[12] + 0x655b59c3, 6);
-	MD5STEP(F4, d, a, b, c, in[3] + 0x8f0ccc92, 10);
-	MD5STEP(F4, c, d, a, b, in[10] + 0xffeff47d, 15);
-	MD5STEP(F4, b, c, d, a, in[1] + 0x85845dd1, 21);
-	MD5STEP(F4, a, b, c, d, in[8] + 0x6fa87e4f, 6);
-	MD5STEP(F4, d, a, b, c, in[15] + 0xfe2ce6e0, 10);
-	MD5STEP(F4, c, d, a, b, in[6] + 0xa3014314, 15);
-	MD5STEP(F4, b, c, d, a, in[13] + 0x4e0811a1, 21);
-	MD5STEP(F4, a, b, c, d, in[4] + 0xf7537e82, 6);
-	MD5STEP(F4, d, a, b, c, in[11] + 0xbd3af235, 10);
-	MD5STEP(F4, c, d, a, b, in[2] + 0x2ad7d2bb, 15);
-	MD5STEP(F4, b, c, d, a, in[9] + 0xeb86d391, 21);
-
-	hash[0] += a;
-	hash[1] += b;
-	hash[2] += c;
-	hash[3] += d;
-}
-EXPORT_SYMBOL(md5_transform);
-- 
2.11.1
