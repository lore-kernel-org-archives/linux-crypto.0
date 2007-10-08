From: Jan Glauber <jan.glauber@de.ibm.com>
Subject: [RFC PATCH] header file for SHA definitions
Date: Mon, 08 Oct 2007 17:33:31 +0200
Message-ID: <1191857611.7760.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:27911 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbXJHPbv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Oct 2007 11:31:51 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.8/8.13.8) with ESMTP id l98FVofa476310
	for <linux-crypto@vger.kernel.org>; Mon, 8 Oct 2007 15:31:50 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l98FVodq2179206
	for <linux-crypto@vger.kernel.org>; Mon, 8 Oct 2007 17:31:50 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l98FVn3Z026125
	for <linux-crypto@vger.kernel.org>; Mon, 8 Oct 2007 17:31:49 +0200
Received: from [9.152.198.68] (dyn-9-152-198-68.boeblingen.de.ibm.com [9.152.198.68])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l98FVnvN026120
	for <linux-crypto@vger.kernel.org>; Mon, 8 Oct 2007 17:31:49 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

There are currently several SHA implementations that all define their own
initialization vectors and size values. Since this values are idential
move them to a header file under include/crypto.

The Patch should apply to cryptodev-2.6.

Signed-off-by: Jan Glauber <jang@de.ibm.com>
---
 arch/s390/crypto/sha1_s390.c   |   14 +++------
 arch/s390/crypto/sha256_s390.c |   20 +++++--------
 crypto/sha1_generic.c          |    8 +----
 crypto/sha256_generic.c        |   31 ++++++--------------
 crypto/sha512.c                |   63 ++++++++++++-----------------------------
 drivers/crypto/padlock-sha.c   |   36 ++++++++++-------------
 include/crypto/sha.h           |   53 ++++++++++++++++++++++++++++++++++
 7 files changed, 116 insertions(+), 109 deletions(-)

diff -urNp --exclude=.git --exclude=.pc cryptodev-2.6/arch/s390/crypto/sha1_s390.c cryptodev-2.6_xxx/arch/s390/crypto/sha1_s390.c
--- cryptodev-2.6/arch/s390/crypto/sha1_s390.c	2007-10-08 17:09:30.000000000 +0200
+++ cryptodev-2.6_xxx/arch/s390/crypto/sha1_s390.c	2007-10-08 17:10:43.000000000 +0200
@@ -26,12 +26,10 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
+#include <crypto/sha.h>
 
 #include "crypt_s390.h"
 
-#define SHA1_DIGEST_SIZE	20
-#define SHA1_BLOCK_SIZE		64
-
 struct s390_sha1_ctx {
 	u64 count;		/* message length */
 	u32 state[5];
@@ -42,11 +40,11 @@ static void sha1_init(struct crypto_tfm 
 {
 	struct s390_sha1_ctx *sctx = crypto_tfm_ctx(tfm);
 
-	sctx->state[0] = 0x67452301;
-	sctx->state[1] = 0xEFCDAB89;
-	sctx->state[2] = 0x98BADCFE;
-	sctx->state[3] = 0x10325476;
-	sctx->state[4] = 0xC3D2E1F0;
+	sctx->state[0] = SHA1_H0;
+	sctx->state[1] = SHA1_H1;
+	sctx->state[2] = SHA1_H2;
+	sctx->state[3] = SHA1_H3;
+	sctx->state[4] = SHA1_H4;
 	sctx->count = 0;
 }
 
diff -urNp --exclude=.git --exclude=.pc cryptodev-2.6/arch/s390/crypto/sha256_s390.c cryptodev-2.6_xxx/arch/s390/crypto/sha256_s390.c
--- cryptodev-2.6/arch/s390/crypto/sha256_s390.c	2007-10-08 17:09:30.000000000 +0200
+++ cryptodev-2.6_xxx/arch/s390/crypto/sha256_s390.c	2007-10-08 17:13:03.000000000 +0200
@@ -19,12 +19,10 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
+#include <crypto/sha.h>
 
 #include "crypt_s390.h"
 
-#define SHA256_DIGEST_SIZE	32
-#define SHA256_BLOCK_SIZE	64
-
 struct s390_sha256_ctx {
 	u64 count;		/* message length */
 	u32 state[8];
@@ -35,14 +33,14 @@ static void sha256_init(struct crypto_tf
 {
 	struct s390_sha256_ctx *sctx = crypto_tfm_ctx(tfm);
 
-	sctx->state[0] = 0x6a09e667;
-	sctx->state[1] = 0xbb67ae85;
-	sctx->state[2] = 0x3c6ef372;
-	sctx->state[3] = 0xa54ff53a;
-	sctx->state[4] = 0x510e527f;
-	sctx->state[5] = 0x9b05688c;
-	sctx->state[6] = 0x1f83d9ab;
-	sctx->state[7] = 0x5be0cd19;
+	sctx->state[0] = SHA256_H0;
+	sctx->state[1] = SHA256_H1;
+	sctx->state[2] = SHA256_H2;
+	sctx->state[3] = SHA256_H3;
+	sctx->state[4] = SHA256_H4;
+	sctx->state[5] = SHA256_H5;
+	sctx->state[6] = SHA256_H6;
+	sctx->state[7] = SHA256_H7;
 	sctx->count = 0;
 }
 
diff -urNp --exclude=.git --exclude=.pc cryptodev-2.6/crypto/sha1_generic.c cryptodev-2.6_xxx/crypto/sha1_generic.c
--- cryptodev-2.6/crypto/sha1_generic.c	2007-10-08 17:09:30.000000000 +0200
+++ cryptodev-2.6_xxx/crypto/sha1_generic.c	2007-10-08 17:10:43.000000000 +0200
@@ -22,12 +22,10 @@
 #include <linux/crypto.h>
 #include <linux/cryptohash.h>
 #include <linux/types.h>
+#include <crypto/sha.h>
 #include <asm/scatterlist.h>
 #include <asm/byteorder.h>
 
-#define SHA1_DIGEST_SIZE	20
-#define SHA1_HMAC_BLOCK_SIZE	64
-
 struct sha1_ctx {
         u64 count;
         u32 state[5];
@@ -39,7 +37,7 @@ static void sha1_init(struct crypto_tfm 
 	struct sha1_ctx *sctx = crypto_tfm_ctx(tfm);
 	static const struct sha1_ctx initstate = {
 	  0,
-	  { 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0 },
+	  { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
 	  { 0, }
 	};
 
@@ -111,7 +109,7 @@ static struct crypto_alg alg = {
 	.cra_name	=	"sha1",
 	.cra_driver_name=	"sha1-generic",
 	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	SHA1_HMAC_BLOCK_SIZE,
+	.cra_blocksize	=	SHA1_BLOCK_SIZE,
 	.cra_ctxsize	=	sizeof(struct sha1_ctx),
 	.cra_module	=	THIS_MODULE,
 	.cra_alignmask	=	3,
diff -urNp --exclude=.git --exclude=.pc cryptodev-2.6/crypto/sha256_generic.c cryptodev-2.6_xxx/crypto/sha256_generic.c
--- cryptodev-2.6/crypto/sha256_generic.c	2007-10-08 17:09:30.000000000 +0200
+++ cryptodev-2.6_xxx/crypto/sha256_generic.c	2007-10-08 17:10:43.000000000 +0200
@@ -21,12 +21,10 @@
 #include <linux/mm.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
+#include <crypto/sha.h>
 #include <asm/scatterlist.h>
 #include <asm/byteorder.h>
 
-#define SHA256_DIGEST_SIZE	32
-#define SHA256_HMAC_BLOCK_SIZE	64
-
 struct sha256_ctx {
 	u32 count[2];
 	u32 state[8];
@@ -48,15 +46,6 @@ static inline u32 Maj(u32 x, u32 y, u32 
 #define s0(x)       (ror32(x, 7) ^ ror32(x,18) ^ (x >> 3))
 #define s1(x)       (ror32(x,17) ^ ror32(x,19) ^ (x >> 10))
 
-#define H0         0x6a09e667
-#define H1         0xbb67ae85
-#define H2         0x3c6ef372
-#define H3         0xa54ff53a
-#define H4         0x510e527f
-#define H5         0x9b05688c
-#define H6         0x1f83d9ab
-#define H7         0x5be0cd19
-
 static inline void LOAD_OP(int I, u32 *W, const u8 *input)
 {
 	W[I] = __be32_to_cpu( ((__be32*)(input))[I] );
@@ -233,14 +222,14 @@ static void sha256_transform(u32 *state,
 static void sha256_init(struct crypto_tfm *tfm)
 {
 	struct sha256_ctx *sctx = crypto_tfm_ctx(tfm);
-	sctx->state[0] = H0;
-	sctx->state[1] = H1;
-	sctx->state[2] = H2;
-	sctx->state[3] = H3;
-	sctx->state[4] = H4;
-	sctx->state[5] = H5;
-	sctx->state[6] = H6;
-	sctx->state[7] = H7;
+	sctx->state[0] = SHA256_H0;
+	sctx->state[1] = SHA256_H1;
+	sctx->state[2] = SHA256_H2;
+	sctx->state[3] = SHA256_H3;
+	sctx->state[4] = SHA256_H4;
+	sctx->state[5] = SHA256_H5;
+	sctx->state[6] = SHA256_H6;
+	sctx->state[7] = SHA256_H7;
 	sctx->count[0] = sctx->count[1] = 0;
 }
 
@@ -311,7 +300,7 @@ static struct crypto_alg alg = {
 	.cra_name	=	"sha256",
 	.cra_driver_name=	"sha256-generic",
 	.cra_flags	=	CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	=	SHA256_HMAC_BLOCK_SIZE,
+	.cra_blocksize	=	SHA256_BLOCK_SIZE,
 	.cra_ctxsize	=	sizeof(struct sha256_ctx),
 	.cra_module	=	THIS_MODULE,
 	.cra_alignmask	=	3,
diff -urNp --exclude=.git --exclude=.pc cryptodev-2.6/crypto/sha512.c cryptodev-2.6_xxx/crypto/sha512.c
--- cryptodev-2.6/crypto/sha512.c	2007-10-08 17:09:30.000000000 +0200
+++ cryptodev-2.6_xxx/crypto/sha512.c	2007-10-08 17:11:24.000000000 +0200
@@ -13,20 +13,15 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/crypto.h>
 #include <linux/types.h>
+#include <crypto/sha.h>
 
 #include <asm/scatterlist.h>
 #include <asm/byteorder.h>
 
-#define SHA384_DIGEST_SIZE 48
-#define SHA512_DIGEST_SIZE 64
-#define SHA384_HMAC_BLOCK_SIZE 128
-#define SHA512_HMAC_BLOCK_SIZE 128
-
 struct sha512_ctx {
 	u64 state[8];
 	u32 count[4];
@@ -84,26 +79,6 @@ static const u64 sha512_K[80] = {
 #define s0(x)       (RORu64(x, 1) ^ RORu64(x, 8) ^ (x >> 7))
 #define s1(x)       (RORu64(x,19) ^ RORu64(x,61) ^ (x >> 6))
 
-/* H* initial state for SHA-512 */
-#define H0         0x6a09e667f3bcc908ULL
-#define H1         0xbb67ae8584caa73bULL
-#define H2         0x3c6ef372fe94f82bULL
-#define H3         0xa54ff53a5f1d36f1ULL
-#define H4         0x510e527fade682d1ULL
-#define H5         0x9b05688c2b3e6c1fULL
-#define H6         0x1f83d9abfb41bd6bULL
-#define H7         0x5be0cd19137e2179ULL
-
-/* H'* initial state for SHA-384 */
-#define HP0 0xcbbb9d5dc1059ed8ULL
-#define HP1 0x629a292a367cd507ULL
-#define HP2 0x9159015a3070dd17ULL
-#define HP3 0x152fecd8f70e5939ULL
-#define HP4 0x67332667ffc00b31ULL
-#define HP5 0x8eb44a8768581511ULL
-#define HP6 0xdb0c2e0d64f98fa7ULL
-#define HP7 0x47b5481dbefa4fa4ULL
-
 static inline void LOAD_OP(int I, u64 *W, const u8 *input)
 {
 	W[I] = __be64_to_cpu( ((__be64*)(input))[I] );
@@ -164,14 +139,14 @@ static void
 sha512_init(struct crypto_tfm *tfm)
 {
 	struct sha512_ctx *sctx = crypto_tfm_ctx(tfm);
-	sctx->state[0] = H0;
-	sctx->state[1] = H1;
-	sctx->state[2] = H2;
-	sctx->state[3] = H3;
-	sctx->state[4] = H4;
-	sctx->state[5] = H5;
-	sctx->state[6] = H6;
-	sctx->state[7] = H7;
+	sctx->state[0] = SHA512_H0;
+	sctx->state[1] = SHA512_H1;
+	sctx->state[2] = SHA512_H2;
+	sctx->state[3] = SHA512_H3;
+	sctx->state[4] = SHA512_H4;
+	sctx->state[5] = SHA512_H5;
+	sctx->state[6] = SHA512_H6;
+	sctx->state[7] = SHA512_H7;
 	sctx->count[0] = sctx->count[1] = sctx->count[2] = sctx->count[3] = 0;
 }
 
@@ -179,14 +154,14 @@ static void
 sha384_init(struct crypto_tfm *tfm)
 {
 	struct sha512_ctx *sctx = crypto_tfm_ctx(tfm);
-        sctx->state[0] = HP0;
-        sctx->state[1] = HP1;
-        sctx->state[2] = HP2;
-        sctx->state[3] = HP3;
-        sctx->state[4] = HP4;
-        sctx->state[5] = HP5;
-        sctx->state[6] = HP6;
-        sctx->state[7] = HP7;
+	sctx->state[0] = SHA384_H0;
+	sctx->state[1] = SHA384_H1;
+	sctx->state[2] = SHA384_H2;
+	sctx->state[3] = SHA384_H3;
+	sctx->state[4] = SHA384_H4;
+	sctx->state[5] = SHA384_H5;
+	sctx->state[6] = SHA384_H6;
+	sctx->state[7] = SHA384_H7;
         sctx->count[0] = sctx->count[1] = sctx->count[2] = sctx->count[3] = 0;
 }
 
@@ -275,7 +250,7 @@ static void sha384_final(struct crypto_t
 static struct crypto_alg sha512 = {
         .cra_name       = "sha512",
         .cra_flags      = CRYPTO_ALG_TYPE_DIGEST,
-        .cra_blocksize  = SHA512_HMAC_BLOCK_SIZE,
+	.cra_blocksize  = SHA512_BLOCK_SIZE,
         .cra_ctxsize    = sizeof(struct sha512_ctx),
         .cra_module     = THIS_MODULE,
 	.cra_alignmask	= 3,
@@ -291,7 +266,7 @@ static struct crypto_alg sha512 = {
 static struct crypto_alg sha384 = {
         .cra_name       = "sha384",
         .cra_flags      = CRYPTO_ALG_TYPE_DIGEST,
-        .cra_blocksize  = SHA384_HMAC_BLOCK_SIZE,
+	.cra_blocksize  = SHA384_BLOCK_SIZE,
         .cra_ctxsize    = sizeof(struct sha512_ctx),
 	.cra_alignmask	= 3,
         .cra_module     = THIS_MODULE,
diff -urNp --exclude=.git --exclude=.pc cryptodev-2.6/drivers/crypto/padlock-sha.c cryptodev-2.6_xxx/drivers/crypto/padlock-sha.c
--- cryptodev-2.6/drivers/crypto/padlock-sha.c	2007-10-08 17:09:30.000000000 +0200
+++ cryptodev-2.6_xxx/drivers/crypto/padlock-sha.c	2007-10-08 17:10:43.000000000 +0200
@@ -13,6 +13,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/sha.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -24,12 +25,7 @@
 #include "padlock.h"
 
 #define SHA1_DEFAULT_FALLBACK	"sha1-generic"
-#define SHA1_DIGEST_SIZE        20
-#define SHA1_HMAC_BLOCK_SIZE    64
-
 #define SHA256_DEFAULT_FALLBACK "sha256-generic"
-#define SHA256_DIGEST_SIZE      32
-#define SHA256_HMAC_BLOCK_SIZE  64
 
 struct padlock_sha_ctx {
 	char		*data;
@@ -107,11 +103,11 @@ static void padlock_do_sha1(const char *
 	char buf[128+16];
 	char *result = NEAREST_ALIGNED(buf);
 
-	((uint32_t *)result)[0] = 0x67452301;
-	((uint32_t *)result)[1] = 0xEFCDAB89;
-	((uint32_t *)result)[2] = 0x98BADCFE;
-	((uint32_t *)result)[3] = 0x10325476;
-	((uint32_t *)result)[4] = 0xC3D2E1F0;
+	((uint32_t *)result)[0] = SHA1_H0;
+	((uint32_t *)result)[1] = SHA1_H1;
+	((uint32_t *)result)[2] = SHA1_H2;
+	((uint32_t *)result)[3] = SHA1_H3;
+	((uint32_t *)result)[4] = SHA1_H4;
  
 	asm volatile (".byte 0xf3,0x0f,0xa6,0xc8" /* rep xsha1 */
 		      : "+S"(in), "+D"(result)
@@ -128,14 +124,14 @@ static void padlock_do_sha256(const char
 	char buf[128+16];
 	char *result = NEAREST_ALIGNED(buf);
 
-	((uint32_t *)result)[0] = 0x6A09E667;
-	((uint32_t *)result)[1] = 0xBB67AE85;
-	((uint32_t *)result)[2] = 0x3C6EF372;
-	((uint32_t *)result)[3] = 0xA54FF53A;
-	((uint32_t *)result)[4] = 0x510E527F;
-	((uint32_t *)result)[5] = 0x9B05688C;
-	((uint32_t *)result)[6] = 0x1F83D9AB;
-	((uint32_t *)result)[7] = 0x5BE0CD19;
+	((uint32_t *)result)[0] = SHA256_H0;
+	((uint32_t *)result)[1] = SHA256_H1;
+	((uint32_t *)result)[2] = SHA256_H2;
+	((uint32_t *)result)[3] = SHA256_H3;
+	((uint32_t *)result)[4] = SHA256_H4;
+	((uint32_t *)result)[5] = SHA256_H5;
+	((uint32_t *)result)[6] = SHA256_H6;
+	((uint32_t *)result)[7] = SHA256_H7;
 
 	asm volatile (".byte 0xf3,0x0f,0xa6,0xd0" /* rep xsha256 */
 		      : "+S"(in), "+D"(result)
@@ -215,7 +211,7 @@ static struct crypto_alg sha1_alg = {
 	.cra_priority		=	PADLOCK_CRA_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_DIGEST |
 					CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		=	SHA1_HMAC_BLOCK_SIZE,
+	.cra_blocksize		=	SHA1_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(sha1_alg.cra_list),
@@ -237,7 +233,7 @@ static struct crypto_alg sha256_alg = {
 	.cra_priority		=	PADLOCK_CRA_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_DIGEST |
 					CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		=	SHA256_HMAC_BLOCK_SIZE,
+	.cra_blocksize		=	SHA256_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(sha256_alg.cra_list),
diff -urNp --exclude=.git --exclude=.pc cryptodev-2.6/include/crypto/sha.h cryptodev-2.6_xxx/include/crypto/sha.h
--- cryptodev-2.6/include/crypto/sha.h	1970-01-01 01:00:00.000000000 +0100
+++ cryptodev-2.6_xxx/include/crypto/sha.h	2007-10-08 17:10:43.000000000 +0200
@@ -0,0 +1,53 @@
+/*
+ * Common values for SHA algorithms
+ */
+
+#ifndef _CRYPTO_SHA_H
+#define _CRYPTO_SHA_H
+
+#define SHA1_DIGEST_SIZE        20
+#define SHA1_BLOCK_SIZE         64
+
+#define SHA256_DIGEST_SIZE      32
+#define SHA256_BLOCK_SIZE       64
+
+#define SHA384_DIGEST_SIZE      48
+#define SHA384_BLOCK_SIZE       128
+
+#define SHA512_DIGEST_SIZE      64
+#define SHA512_BLOCK_SIZE       128
+
+#define SHA1_H0		0x67452301UL
+#define SHA1_H1		0xefcdab89UL
+#define SHA1_H2		0x98badcfeUL
+#define SHA1_H3		0x10325476UL
+#define SHA1_H4		0xc3d2e1f0UL
+
+#define SHA256_H0	0x6a09e667UL
+#define SHA256_H1	0xbb67ae85UL
+#define SHA256_H2	0x3c6ef372UL
+#define SHA256_H3	0xa54ff53aUL
+#define SHA256_H4	0x510e527fUL
+#define SHA256_H5	0x9b05688cUL
+#define SHA256_H6	0x1f83d9abUL
+#define SHA256_H7	0x5be0cd19UL
+
+#define SHA384_H0	0xcbbb9d5dc1059ed8ULL
+#define SHA384_H1	0x629a292a367cd507ULL
+#define SHA384_H2	0x9159015a3070dd17ULL
+#define SHA384_H3	0x152fecd8f70e5939ULL
+#define SHA384_H4	0x67332667ffc00b31ULL
+#define SHA384_H5	0x8eb44a8768581511ULL
+#define SHA384_H6	0xdb0c2e0d64f98fa7ULL
+#define SHA384_H7	0x47b5481dbefa4fa4ULL
+
+#define SHA512_H0	0x6a09e667f3bcc908ULL
+#define SHA512_H1	0xbb67ae8584caa73bULL
+#define SHA512_H2	0x3c6ef372fe94f82bULL
+#define SHA512_H3	0xa54ff53a5f1d36f1ULL
+#define SHA512_H4	0x510e527fade682d1ULL
+#define SHA512_H5	0x9b05688c2b3e6c1fULL
+#define SHA512_H6	0x1f83d9abfb41bd6bULL
+#define SHA512_H7	0x5be0cd19137e2179ULL
+
+#endif
