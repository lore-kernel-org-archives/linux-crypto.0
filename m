From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 04/23] mac802154: Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:41 -0700
Message-ID: <20180919021100.3380-5-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
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

Cc: Alexander Aring <alex.aring@gmail.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: linux-wpan@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/mac802154/llsec.c | 16 ++++++++--------
 net/mac802154/llsec.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
index 2fb703d70803..7e29f88dbf6a 100644
--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -146,18 +146,18 @@ llsec_key_alloc(const struct ieee802154_llsec_key *template)
 			goto err_tfm;
 	}
 
-	key->tfm0 = crypto_alloc_skcipher("ctr(aes)", 0, CRYPTO_ALG_ASYNC);
+	key->tfm0 = crypto_alloc_sync_skcipher("ctr(aes)", 0, 0);
 	if (IS_ERR(key->tfm0))
 		goto err_tfm;
 
-	if (crypto_skcipher_setkey(key->tfm0, template->key,
+	if (crypto_sync_skcipher_setkey(key->tfm0, template->key,
 				   IEEE802154_LLSEC_KEY_SIZE))
 		goto err_tfm0;
 
 	return key;
 
 err_tfm0:
-	crypto_free_skcipher(key->tfm0);
+	crypto_free_sync_skcipher(key->tfm0);
 err_tfm:
 	for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
 		if (key->tfm[i])
@@ -177,7 +177,7 @@ static void llsec_key_release(struct kref *ref)
 	for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
 		crypto_free_aead(key->tfm[i]);
 
-	crypto_free_skcipher(key->tfm0);
+	crypto_free_sync_skcipher(key->tfm0);
 	kzfree(key);
 }
 
@@ -622,7 +622,7 @@ llsec_do_encrypt_unauth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 {
 	u8 iv[16];
 	struct scatterlist src;
-	SKCIPHER_REQUEST_ON_STACK(req, key->tfm0);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, key->tfm0);
 	int err, datalen;
 	unsigned char *data;
 
@@ -632,7 +632,7 @@ llsec_do_encrypt_unauth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 	datalen = skb_tail_pointer(skb) - data;
 	sg_init_one(&src, data, datalen);
 
-	skcipher_request_set_tfm(req, key->tfm0);
+	skcipher_request_set_sync_tfm(req, key->tfm0);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &src, &src, datalen, iv);
 	err = crypto_skcipher_encrypt(req);
@@ -840,7 +840,7 @@ llsec_do_decrypt_unauth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 	unsigned char *data;
 	int datalen;
 	struct scatterlist src;
-	SKCIPHER_REQUEST_ON_STACK(req, key->tfm0);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, key->tfm0);
 	int err;
 
 	llsec_geniv(iv, dev_addr, &hdr->sec);
@@ -849,7 +849,7 @@ llsec_do_decrypt_unauth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 
 	sg_init_one(&src, data, datalen);
 
-	skcipher_request_set_tfm(req, key->tfm0);
+	skcipher_request_set_sync_tfm(req, key->tfm0);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &src, &src, datalen, iv);
 
diff --git a/net/mac802154/llsec.h b/net/mac802154/llsec.h
index 6f3b658e3279..8be46d74dc39 100644
--- a/net/mac802154/llsec.h
+++ b/net/mac802154/llsec.h
@@ -29,7 +29,7 @@ struct mac802154_llsec_key {
 
 	/* one tfm for each authsize (4/8/16) */
 	struct crypto_aead *tfm[3];
-	struct crypto_skcipher *tfm0;
+	struct crypto_sync_skcipher *tfm0;
 
 	struct kref ref;
 };
-- 
2.17.1
