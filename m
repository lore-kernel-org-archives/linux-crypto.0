From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 5/5] crypto: chacha20 - Fix keystream alignment for chacha20_block()
Date: Wed, 22 Nov 2017 11:51:39 -0800
Message-ID: <20171122195139.121269-6-ebiggers3@gmail.com>
References: <20171122195139.121269-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171122195139.121269-1-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When chacha20_block() outputs the keystream block, it uses 'u32' stores
directly.  However, the callers (crypto/chacha20_generic.c and
drivers/char/random.c) declare the keystream buffer as a 'u8' array,
which is not guaranteed to have the needed alignment.

Fix it by having both callers declare the keystream as a 'u32' array.
For now this is preferable to switching over to the unaligned access
macros because chacha20_block() is only being used in cases where we can
easily control the alignment (stack buffers).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/chacha20_generic.c |  6 +++---
 drivers/char/random.c     | 24 ++++++++++++------------
 include/crypto/chacha20.h |  3 ++-
 lib/chacha20.c            |  2 +-
 4 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
index bb4affbd591c..e451c3cb6a56 100644
--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -18,20 +18,20 @@
 static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
 			     unsigned int bytes)
 {
-	u8 stream[CHACHA20_BLOCK_SIZE];
+	u32 stream[CHACHA20_BLOCK_WORDS];
 
 	if (dst != src)
 		memcpy(dst, src, bytes);
 
 	while (bytes >= CHACHA20_BLOCK_SIZE) {
 		chacha20_block(state, stream);
-		crypto_xor(dst, stream, CHACHA20_BLOCK_SIZE);
+		crypto_xor(dst, (const u8 *)stream, CHACHA20_BLOCK_SIZE);
 		bytes -= CHACHA20_BLOCK_SIZE;
 		dst += CHACHA20_BLOCK_SIZE;
 	}
 	if (bytes) {
 		chacha20_block(state, stream);
-		crypto_xor(dst, stream, bytes);
+		crypto_xor(dst, (const u8 *)stream, bytes);
 	}
 }
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index ec42c8bb9b0d..11304bbc78cc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -431,9 +431,9 @@ static int crng_init = 0;
 static int crng_init_cnt = 0;
 #define CRNG_INIT_CNT_THRESH (2*CHACHA20_KEY_SIZE)
 static void _extract_crng(struct crng_state *crng,
-			  __u8 out[CHACHA20_BLOCK_SIZE]);
+			  __u32 out[CHACHA20_BLOCK_WORDS]);
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used);
+				    __u32 tmp[CHACHA20_BLOCK_WORDS], int used);
 static void process_random_ready_list(void);
 static void _get_random_bytes(void *buf, int nbytes);
 
@@ -817,7 +817,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	unsigned long	flags;
 	int		i, num;
 	union {
-		__u8	block[CHACHA20_BLOCK_SIZE];
+		__u32	block[CHACHA20_BLOCK_WORDS];
 		__u32	key[8];
 	} buf;
 
@@ -851,7 +851,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 }
 
 static void _extract_crng(struct crng_state *crng,
-			  __u8 out[CHACHA20_BLOCK_SIZE])
+			  __u32 out[CHACHA20_BLOCK_WORDS])
 {
 	unsigned long v, flags;
 
@@ -867,7 +867,7 @@ static void _extract_crng(struct crng_state *crng,
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
+static void extract_crng(__u32 out[CHACHA20_BLOCK_WORDS])
 {
 	struct crng_state *crng = NULL;
 
@@ -885,7 +885,7 @@ static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
  * enough) to mutate the CRNG key to provide backtracking protection.
  */
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+				    __u32 tmp[CHACHA20_BLOCK_WORDS], int used)
 {
 	unsigned long	flags;
 	__u32		*s, *d;
@@ -897,14 +897,14 @@ static void _crng_backtrack_protect(struct crng_state *crng,
 		used = 0;
 	}
 	spin_lock_irqsave(&crng->lock, flags);
-	s = (__u32 *) &tmp[used];
+	s = &tmp[used / sizeof(__u32)];
 	d = &crng->state[4];
 	for (i=0; i < 8; i++)
 		*d++ ^= *s++;
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void crng_backtrack_protect(__u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+static void crng_backtrack_protect(__u32 tmp[CHACHA20_BLOCK_WORDS], int used)
 {
 	struct crng_state *crng = NULL;
 
@@ -920,7 +920,7 @@ static void crng_backtrack_protect(__u8 tmp[CHACHA20_BLOCK_SIZE], int used)
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i = CHACHA20_BLOCK_SIZE;
-	__u8 tmp[CHACHA20_BLOCK_SIZE];
+	__u32 tmp[CHACHA20_BLOCK_WORDS];
 	int large_request = (nbytes > 256);
 
 	while (nbytes) {
@@ -1507,7 +1507,7 @@ static void _warn_unseeded_randomness(const char *func_name, void *caller,
  */
 static void _get_random_bytes(void *buf, int nbytes)
 {
-	__u8 tmp[CHACHA20_BLOCK_SIZE];
+	__u32 tmp[CHACHA20_BLOCK_WORDS];
 
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
@@ -2114,7 +2114,7 @@ u64 get_random_u64(void)
 	if (use_lock)
 		read_lock_irqsave(&batched_entropy_reset_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
-		extract_crng((u8 *)batch->entropy_u64);
+		extract_crng((__u32 *)batch->entropy_u64);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u64[batch->position++];
@@ -2144,7 +2144,7 @@ u32 get_random_u32(void)
 	if (use_lock)
 		read_lock_irqsave(&batched_entropy_reset_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
-		extract_crng((u8 *)batch->entropy_u32);
+		extract_crng(batch->entropy_u32);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u32[batch->position++];
diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
index caaa470389e0..b83d66073db0 100644
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -13,12 +13,13 @@
 #define CHACHA20_IV_SIZE	16
 #define CHACHA20_KEY_SIZE	32
 #define CHACHA20_BLOCK_SIZE	64
+#define CHACHA20_BLOCK_WORDS	(CHACHA20_BLOCK_SIZE / sizeof(u32))
 
 struct chacha20_ctx {
 	u32 key[8];
 };
 
-void chacha20_block(u32 *state, void *stream);
+void chacha20_block(u32 *state, u32 *stream);
 void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
 int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keysize);
diff --git a/lib/chacha20.c b/lib/chacha20.c
index 250ceed9ec9a..29d3801dee24 100644
--- a/lib/chacha20.c
+++ b/lib/chacha20.c
@@ -21,7 +21,7 @@ static inline u32 rotl32(u32 v, u8 n)
 	return (v << n) | (v >> (sizeof(v) * 8 - n));
 }
 
-extern void chacha20_block(u32 *state, void *stream)
+void chacha20_block(u32 *state, u32 *stream)
 {
 	u32 x[16], *out = stream;
 	int i;
-- 
2.15.0.448.gf294e3d99a-goog
