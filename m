From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 09/23] ppp: mppe: Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:46 -0700
Message-ID: <20180919021100.3380-10-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919021100.3380-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
replaces struct crypto_skcipher and SKCIPHER_REQUEST_ON_STACK() usage
with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
which uses a fixed stack size.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-ppp@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ppp/ppp_mppe.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index a205750b431b..7ccdc62c6052 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -95,7 +95,7 @@ static inline void sha_pad_init(struct sha_pad *shapad)
  * State for an MPPE (de)compressor.
  */
 struct ppp_mppe_state {
-	struct crypto_skcipher *arc4;
+	struct crypto_sync_skcipher *arc4;
 	struct shash_desc *sha1;
 	unsigned char *sha1_digest;
 	unsigned char master_key[MPPE_MAX_KEY_LEN];
@@ -155,15 +155,15 @@ static void get_new_key_from_sha(struct ppp_mppe_state * state)
 static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
 {
 	struct scatterlist sg_in[1], sg_out[1];
-	SKCIPHER_REQUEST_ON_STACK(req, state->arc4);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, state->arc4);
 
-	skcipher_request_set_tfm(req, state->arc4);
+	skcipher_request_set_sync_tfm(req, state->arc4);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 
 	get_new_key_from_sha(state);
 	if (!initial_key) {
-		crypto_skcipher_setkey(state->arc4, state->sha1_digest,
-				       state->keylen);
+		crypto_sync_skcipher_setkey(state->arc4, state->sha1_digest,
+					    state->keylen);
 		sg_init_table(sg_in, 1);
 		sg_init_table(sg_out, 1);
 		setup_sg(sg_in, state->sha1_digest, state->keylen);
@@ -181,7 +181,8 @@ static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
 		state->session_key[1] = 0x26;
 		state->session_key[2] = 0x9e;
 	}
-	crypto_skcipher_setkey(state->arc4, state->session_key, state->keylen);
+	crypto_sync_skcipher_setkey(state->arc4, state->session_key,
+				    state->keylen);
 	skcipher_request_zero(req);
 }
 
@@ -203,7 +204,7 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 		goto out;
 
 
-	state->arc4 = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	state->arc4 = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(state->arc4)) {
 		state->arc4 = NULL;
 		goto out_free;
@@ -250,7 +251,7 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 		crypto_free_shash(state->sha1->tfm);
 		kzfree(state->sha1);
 	}
-	crypto_free_skcipher(state->arc4);
+	crypto_free_sync_skcipher(state->arc4);
 	kfree(state);
 out:
 	return NULL;
@@ -266,7 +267,7 @@ static void mppe_free(void *arg)
 		kfree(state->sha1_digest);
 		crypto_free_shash(state->sha1->tfm);
 		kzfree(state->sha1);
-		crypto_free_skcipher(state->arc4);
+		crypto_free_sync_skcipher(state->arc4);
 		kfree(state);
 	}
 }
@@ -366,7 +367,7 @@ mppe_compress(void *arg, unsigned char *ibuf, unsigned char *obuf,
 	      int isize, int osize)
 {
 	struct ppp_mppe_state *state = (struct ppp_mppe_state *) arg;
-	SKCIPHER_REQUEST_ON_STACK(req, state->arc4);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, state->arc4);
 	int proto;
 	int err;
 	struct scatterlist sg_in[1], sg_out[1];
@@ -426,7 +427,7 @@ mppe_compress(void *arg, unsigned char *ibuf, unsigned char *obuf,
 	setup_sg(sg_in, ibuf, isize);
 	setup_sg(sg_out, obuf, osize);
 
-	skcipher_request_set_tfm(req, state->arc4);
+	skcipher_request_set_sync_tfm(req, state->arc4);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg_in, sg_out, isize, NULL);
 	err = crypto_skcipher_encrypt(req);
@@ -480,7 +481,7 @@ mppe_decompress(void *arg, unsigned char *ibuf, int isize, unsigned char *obuf,
 		int osize)
 {
 	struct ppp_mppe_state *state = (struct ppp_mppe_state *) arg;
-	SKCIPHER_REQUEST_ON_STACK(req, state->arc4);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, state->arc4);
 	unsigned ccount;
 	int flushed = MPPE_BITS(ibuf) & MPPE_BIT_FLUSHED;
 	struct scatterlist sg_in[1], sg_out[1];
@@ -615,7 +616,7 @@ mppe_decompress(void *arg, unsigned char *ibuf, int isize, unsigned char *obuf,
 	setup_sg(sg_in, ibuf, 1);
 	setup_sg(sg_out, obuf, 1);
 
-	skcipher_request_set_tfm(req, state->arc4);
+	skcipher_request_set_sync_tfm(req, state->arc4);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg_in, sg_out, 1, NULL);
 	if (crypto_skcipher_decrypt(req)) {
-- 
2.17.1
