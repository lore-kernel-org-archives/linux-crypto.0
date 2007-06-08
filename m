From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: [PATCH 1/3] [CRYPTO] Move sha_init() into cryptohash.h
Date: Fri, 08 Jun 2007 17:42:48 -0400
Message-ID: <20070608214248.23949.55429.stgit@dev>
References: <20070608214242.23949.30350.stgit@dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from JACKFRUIT.SRV.CS.CMU.EDU ([128.2.201.16]:53561 "EHLO
	jackfruit.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbXFHWJT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jun 2007 18:09:19 -0400
In-Reply-To: <20070608214242.23949.30350.stgit@dev>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Make sha_init() a static inline in cryptohash.h rather than an (unexported)
function in lib/sha1.c, in preparation for making sha1.c optional.  This
also allows some cleanups:

- Modular code can now use sha_init() rather than reimplementing it

- The optimized implementation of SHA-1 for ARM no longer needs to
reimplement sha_init() in assembly

Signed-off-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>
---

 arch/arm/lib/sha1.S          |   16 ----------------
 arch/s390/crypto/sha1_s390.c |    6 +-----
 drivers/crypto/padlock-sha.c |    8 ++------
 include/linux/cryptohash.h   |   14 +++++++++++++-
 lib/sha1.c                   |   14 --------------
 5 files changed, 16 insertions(+), 42 deletions(-)

diff --git a/arch/arm/lib/sha1.S b/arch/arm/lib/sha1.S
index ff6ece4..5be800c 100644
--- a/arch/arm/lib/sha1.S
+++ b/arch/arm/lib/sha1.S
@@ -188,19 +188,3 @@ ENTRY(sha_transform)
 .L_sha_K:
 	.word	0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6
 
-
-/*
- * void sha_init(__u32 *buf)
- */
-
-.L_sha_initial_digest:
-	.word	0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0
-
-ENTRY(sha_init)
-
-	str	lr, [sp, #-4]!
-	adr	r1, .L_sha_initial_digest
-	ldmia	r1, {r1, r2, r3, ip, lr}
-	stmia	r0, {r1, r2, r3, ip, lr}
-	ldr	pc, [sp], #4
-
diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
index af4460e..fed9a2e 100644
--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -42,11 +42,7 @@ static void sha1_init(struct crypto_tfm *tfm)
 {
 	struct s390_sha1_ctx *sctx = crypto_tfm_ctx(tfm);
 
-	sctx->state[0] = 0x67452301;
-	sctx->state[1] = 0xEFCDAB89;
-	sctx->state[2] = 0x98BADCFE;
-	sctx->state[3] = 0x10325476;
-	sctx->state[4] = 0xC3D2E1F0;
+	sha_init(sctx->state);
 	sctx->count = 0;
 }
 
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index a781fd2..b47d708 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -107,12 +107,8 @@ static void padlock_do_sha1(const char *in, char *out, int count)
 	char buf[128+16];
 	char *result = NEAREST_ALIGNED(buf);
 
-	((uint32_t *)result)[0] = 0x67452301;
-	((uint32_t *)result)[1] = 0xEFCDAB89;
-	((uint32_t *)result)[2] = 0x98BADCFE;
-	((uint32_t *)result)[3] = 0x10325476;
-	((uint32_t *)result)[4] = 0xC3D2E1F0;
- 
+	sha_init((uint32_t *)result);
+
 	asm volatile (".byte 0xf3,0x0f,0xa6,0xc8" /* rep xsha1 */
 		      : "+S"(in), "+D"(result)
 		      : "c"(count), "a"(0));
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index c118b2a..a172401 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -4,7 +4,19 @@
 #define SHA_DIGEST_WORDS 5
 #define SHA_WORKSPACE_WORDS 80
 
-void sha_init(__u32 *buf);
+/**
+ * sha_init - initialize the vectors for a SHA1 digest
+ * @buf: vector to initialize
+ */
+static inline void sha_init(__u32 *buf)
+{
+	buf[0] = 0x67452301;
+	buf[1] = 0xefcdab89;
+	buf[2] = 0x98badcfe;
+	buf[3] = 0x10325476;
+	buf[4] = 0xc3d2e1f0;
+}
+
 void sha_transform(__u32 *digest, const char *data, __u32 *W);
 
 __u32 half_md4_transform(__u32 buf[4], __u32 const in[8]);
diff --git a/lib/sha1.c b/lib/sha1.c
index 4c45fd5..815816f 100644
--- a/lib/sha1.c
+++ b/lib/sha1.c
@@ -79,17 +79,3 @@ void sha_transform(__u32 *digest, const char *in, __u32 *W)
 	digest[4] += e;
 }
 EXPORT_SYMBOL(sha_transform);
-
-/**
- * sha_init - initialize the vectors for a SHA1 digest
- * @buf: vector to initialize
- */
-void sha_init(__u32 *buf)
-{
-	buf[0] = 0x67452301;
-	buf[1] = 0xefcdab89;
-	buf[2] = 0x98badcfe;
-	buf[3] = 0x10325476;
-	buf[4] = 0xc3d2e1f0;
-}
-
