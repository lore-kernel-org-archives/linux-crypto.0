From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 03/19] crypto: md4 - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:21:46 +0100
Message-ID: <1266538908-3178-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/lrw.c |    6 ++++--
 crypto/md4.c |   14 +++++++-------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 358f80b..d3ee7c6 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -258,8 +258,10 @@ static struct crypto_instance *alloc(struct rtattr **tb)
 	inst->alg.cra_priority = alg->cra_priority;
 	inst->alg.cra_blocksize = alg->cra_blocksize;
 
-	if (alg->cra_alignmask < 7) inst->alg.cra_alignmask = 7;
-	else inst->alg.cra_alignmask = alg->cra_alignmask;
+	if (alg->cra_alignmask < 7)
+		inst->alg.cra_alignmask = 7;
+	else
+		inst->alg.cra_alignmask = alg->cra_alignmask;
 	inst->alg.cra_type = &crypto_blkcipher_type;
 
 	if (!(alg->cra_blocksize % 4))
diff --git a/crypto/md4.c b/crypto/md4.c
index 7fca1f5..ad47518 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API.
  *
  * MD4 Message Digest Algorithm (RFC1320).
@@ -59,9 +59,9 @@ static inline u32 H(u32 x, u32 y, u32 z)
 	return x ^ y ^ z;
 }
 
-#define ROUND1(a,b,c,d,k,s) (a = lshift(a + F(b,c,d) + k, s))
-#define ROUND2(a,b,c,d,k,s) (a = lshift(a + G(b,c,d) + k + (u32)0x5A827999,s))
-#define ROUND3(a,b,c,d,k,s) (a = lshift(a + H(b,c,d) + k + (u32)0x6ED9EBA1,s))
+#define ROUND1(a, b, c, d, k, s) (a = lshift(a + F(b, c, d) + k, s))
+#define ROUND2(a, b, c, d, k, s) (a = lshift(a + G(b, c, d) + k + (u32)0x5A827999, s))
+#define ROUND3(a, b, c, d, k, s) (a = lshift(a + H(b, c, d) + k + (u32)0x6ED9EBA1, s))
 
 /* XXX: this stuff can be optimized */
 static inline void le32_to_cpu_array(u32 *buf, unsigned int words)
@@ -106,7 +106,7 @@ static void md4_transform(u32 *hash, u32 const *in)
 	ROUND1(c, d, a, b, in[14], 11);
 	ROUND1(b, c, d, a, in[15], 19);
 
-	ROUND2(a, b, c, d,in[ 0], 3);
+	ROUND2(a, b, c, d, in[0], 3);
 	ROUND2(d, a, b, c, in[4], 5);
 	ROUND2(c, d, a, b, in[8], 9);
 	ROUND2(b, c, d, a, in[12], 13);
@@ -123,7 +123,7 @@ static void md4_transform(u32 *hash, u32 const *in)
 	ROUND2(c, d, a, b, in[11], 9);
 	ROUND2(b, c, d, a, in[15], 13);
 
-	ROUND3(a, b, c, d,in[ 0], 3);
+	ROUND3(a, b, c, d, in[0], 3);
 	ROUND3(d, a, b, c, in[8], 9);
 	ROUND3(c, d, a, b, in[4], 11);
 	ROUND3(b, c, d, a, in[12], 15);
@@ -206,7 +206,7 @@ static int md4_final(struct shash_desc *desc, u8 *out)
 
 	*p++ = 0x80;
 	if (padding < 0) {
-		memset(p, 0x00, padding + sizeof (u64));
+		memset(p, 0x00, padding + sizeof(u64));
 		md4_transform_helper(mctx);
 		p = (char *)mctx->block;
 		padding = 56;
-- 
1.6.6.1
