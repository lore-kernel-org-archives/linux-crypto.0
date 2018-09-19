From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 08/23] libceph: Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:45 -0700
Message-ID: <20180919021100.3380-9-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        ceph-devel@vger.kernel.org,
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

Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: "Yan, Zheng" <zyan@redhat.com>
Cc: Sage Weil <sage@redhat.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ceph/crypto.c | 12 ++++++------
 net/ceph/crypto.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 02172c408ff2..5d6724cee38f 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -46,9 +46,9 @@ static int set_secret(struct ceph_crypto_key *key, void *buf)
 		goto fail;
 	}
 
-	/* crypto_alloc_skcipher() allocates with GFP_KERNEL */
+	/* crypto_alloc_sync_skcipher() allocates with GFP_KERNEL */
 	noio_flag = memalloc_noio_save();
-	key->tfm = crypto_alloc_skcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC);
+	key->tfm = crypto_alloc_sync_skcipher("cbc(aes)", 0, 0);
 	memalloc_noio_restore(noio_flag);
 	if (IS_ERR(key->tfm)) {
 		ret = PTR_ERR(key->tfm);
@@ -56,7 +56,7 @@ static int set_secret(struct ceph_crypto_key *key, void *buf)
 		goto fail;
 	}
 
-	ret = crypto_skcipher_setkey(key->tfm, key->key, key->len);
+	ret = crypto_sync_skcipher_setkey(key->tfm, key->key, key->len);
 	if (ret)
 		goto fail;
 
@@ -136,7 +136,7 @@ void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
 	if (key) {
 		kfree(key->key);
 		key->key = NULL;
-		crypto_free_skcipher(key->tfm);
+		crypto_free_sync_skcipher(key->tfm);
 		key->tfm = NULL;
 	}
 }
@@ -216,7 +216,7 @@ static void teardown_sgtable(struct sg_table *sgt)
 static int ceph_aes_crypt(const struct ceph_crypto_key *key, bool encrypt,
 			  void *buf, int buf_len, int in_len, int *pout_len)
 {
-	SKCIPHER_REQUEST_ON_STACK(req, key->tfm);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, key->tfm);
 	struct sg_table sgt;
 	struct scatterlist prealloc_sg;
 	char iv[AES_BLOCK_SIZE] __aligned(8);
@@ -232,7 +232,7 @@ static int ceph_aes_crypt(const struct ceph_crypto_key *key, bool encrypt,
 		return ret;
 
 	memcpy(iv, aes_iv, AES_BLOCK_SIZE);
-	skcipher_request_set_tfm(req, key->tfm);
+	skcipher_request_set_sync_tfm(req, key->tfm);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sgt.sgl, sgt.sgl, crypt_len, iv);
 
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index bb45c7d43739..96ef4d860bc9 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -13,7 +13,7 @@ struct ceph_crypto_key {
 	struct ceph_timespec created;
 	int len;
 	void *key;
-	struct crypto_skcipher *tfm;
+	struct crypto_sync_skcipher *tfm;
 };
 
 int ceph_crypto_key_clone(struct ceph_crypto_key *dst,
-- 
2.17.1
