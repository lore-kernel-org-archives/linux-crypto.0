Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr700084.outbound.protection.outlook.com ([40.107.70.84]:23296
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729608AbfAQHCs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 02:02:48 -0500
From: Kalyani Akula <kalyani.akula@xilinx.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH 4/5] crypto: Adds user space interface for ALG_SET_KEY_TYPE
Date: Thu, 17 Jan 2019 12:32:20 +0530
Message-ID: <1547708541-23730-5-git-send-email-kalyani.akula@xilinx.com>
In-Reply-To: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com>
References: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ALG_SET_KEY_TYPE requires caller to pass the key_type to be used
for AES encryption/decryption.

Sometimes the cipher key will be stored in the
device's hardware. So, there is a need to specify
the information about the key to use for AES operations.

In Xilinx ZynqMP SoC, below key types are available

1. Device key, which is flashed in the HW.

2. PUF KEK, which can be regenerated using the
   helper data programmed in the HW.

3. User supplied key.

So to choose the AES key to be used, this patch adds key-type attribute.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 crypto/af_alg.c             |  7 +++++++
 crypto/algif_skcipher.c     |  7 +++++++
 crypto/blkcipher.c          |  9 +++++++++
 crypto/skcipher.c           | 18 ++++++++++++++++++
 include/crypto/if_alg.h     |  2 ++
 include/crypto/skcipher.h   | 10 ++++++++++
 include/linux/crypto.h      | 12 ++++++++++++
 include/uapi/linux/if_alg.h |  1 +
 8 files changed, 66 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 17eb09d..c3c0660 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -261,6 +261,13 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 		if (!type->setauthsize)
 			goto unlock;
 		err = type->setauthsize(ask->private, optlen);
+		break;
+	case ALG_SET_KEY_TYPE:
+		if (sock->state == SS_CONNECTED)
+			goto unlock;
+		if (!type->setkeytype)
+			goto unlock;
+		err = type->setkeytype(ask->private, optval, optlen);
 	}
 
 unlock:
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index cfdaab2..9911a56 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -320,6 +320,12 @@ static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 	return crypto_skcipher_setkey(private, key, keylen);
 }
 
+static int skcipher_setkeytype(void *private, const u8 *key,
+			       unsigned int keylen)
+{
+	return crypto_skcipher_setkeytype(private, key, keylen);
+}
+
 static void skcipher_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -384,6 +390,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 	.bind		=	skcipher_bind,
 	.release	=	skcipher_release,
 	.setkey		=	skcipher_setkey,
+	.setkeytype	=	skcipher_setkeytype,
 	.accept		=	skcipher_accept_parent,
 	.accept_nokey	=	skcipher_accept_parent_nokey,
 	.ops		=	&algif_skcipher_ops,
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index c5398bd..8922f58 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -408,6 +408,14 @@ static int setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 	return cipher->setkey(tfm, key, keylen);
 }
 
+static int setkeytype(struct crypto_tfm *tfm, const u8 *key,
+		      unsigned int keylen)
+{
+	struct blkcipher_alg *cipher = &tfm->__crt_alg->cra_blkcipher;
+
+	return cipher->setkeytype(tfm, key, keylen);
+}
+
 static int async_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			unsigned int keylen)
 {
@@ -478,6 +486,7 @@ static int crypto_init_blkcipher_ops_sync(struct crypto_tfm *tfm)
 	unsigned long addr;
 
 	crt->setkey = setkey;
+	crt->setkeytype = setkeytype;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
 
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 2a96929..6a2a0dd 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -605,6 +605,23 @@ static int skcipher_setkey_blkcipher(struct crypto_skcipher *tfm,
 	return 0;
 }
 
+static int skcipher_setkeytype_blkcipher(struct crypto_skcipher *tfm,
+					 const u8 *key, unsigned int keylen)
+{
+	struct crypto_blkcipher **ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_blkcipher *blkcipher = *ctx;
+	int err;
+
+	crypto_blkcipher_clear_flags(blkcipher, ~0);
+	crypto_blkcipher_set_flags(blkcipher, crypto_skcipher_get_flags(tfm) &
+			CRYPTO_TFM_REQ_MASK);
+	err = crypto_blkcipher_setkeytype(blkcipher, key, keylen);
+	crypto_skcipher_set_flags(tfm, crypto_blkcipher_get_flags(blkcipher) &
+			CRYPTO_TFM_RES_MASK);
+
+	return err;
+}
+
 static int skcipher_crypt_blkcipher(struct skcipher_request *req,
 				    int (*crypt)(struct blkcipher_desc *,
 						 struct scatterlist *,
@@ -671,6 +688,7 @@ static int crypto_init_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
 	tfm->exit = crypto_exit_skcipher_ops_blkcipher;
 
 	skcipher->setkey = skcipher_setkey_blkcipher;
+	skcipher->setkeytype = skcipher_setkeytype_blkcipher;
 	skcipher->encrypt = skcipher_encrypt_blkcipher;
 	skcipher->decrypt = skcipher_decrypt_blkcipher;
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 482461d..202298e 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -51,6 +51,8 @@ struct af_alg_type {
 	void *(*bind)(const char *name, u32 type, u32 mask);
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
+	int (*setkeytype)(void *private, const u8 *keytype,
+			  unsigned int keylen);
 	int (*accept)(void *private, struct sock *sk);
 	int (*accept_nokey)(void *private, struct sock *sk);
 	int (*setauthsize)(void *private, unsigned int authsize);
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index e555294..a6e1eda 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -42,6 +42,8 @@ struct skcipher_request {
 struct crypto_skcipher {
 	int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
 	              unsigned int keylen);
+	int (*setkeytype)(struct crypto_skcipher *tfm, const u8 *key,
+			  unsigned int keylen);
 	int (*encrypt)(struct skcipher_request *req);
 	int (*decrypt)(struct skcipher_request *req);
 
@@ -116,6 +118,8 @@ struct crypto_sync_skcipher {
 struct skcipher_alg {
 	int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
 	              unsigned int keylen);
+	int (*setkeytype)(struct crypto_skcipher *tfm, const u8 *key,
+			  unsigned int keylen);
 	int (*encrypt)(struct skcipher_request *req);
 	int (*decrypt)(struct skcipher_request *req);
 	int (*init)(struct crypto_skcipher *tfm);
@@ -444,6 +448,12 @@ static inline int crypto_sync_skcipher_setkey(struct crypto_sync_skcipher *tfm,
 	return crypto_skcipher_setkey(&tfm->base, key, keylen);
 }
 
+static inline int crypto_skcipher_setkeytype(struct crypto_skcipher *tfm,
+					     const u8 *key, unsigned int keylen)
+{
+	return tfm->setkeytype(tfm, key, keylen);
+}
+
 static inline unsigned int crypto_skcipher_default_keysize(
 	struct crypto_skcipher *tfm)
 {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 902ec17..a47c9a8 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -268,6 +268,8 @@ struct ablkcipher_alg {
 struct blkcipher_alg {
 	int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
 	              unsigned int keylen);
+	int (*setkeytype)(struct crypto_tfm *tfm, const u8 *keytype,
+			  unsigned int keylen);
 	int (*encrypt)(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes);
@@ -734,6 +736,8 @@ struct blkcipher_tfm {
 	void *iv;
 	int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
 		      unsigned int keylen);
+	int (*setkeytype)(struct crypto_tfm *tfm, const u8 *key,
+			  unsigned int keylen);
 	int (*encrypt)(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes);
 	int (*decrypt)(struct blkcipher_desc *desc, struct scatterlist *dst,
@@ -1466,6 +1470,14 @@ static inline int crypto_blkcipher_setkey(struct crypto_blkcipher *tfm,
 						 key, keylen);
 }
 
+static inline int crypto_blkcipher_setkeytype(struct crypto_blkcipher *tfm,
+					      const u8 *key,
+					      unsigned int keylen)
+{
+	return crypto_blkcipher_crt(tfm)->setkeytype(crypto_blkcipher_tfm(tfm),
+						     key, keylen);
+}
+
 /**
  * crypto_blkcipher_encrypt() - encrypt plaintext
  * @desc: reference to the block cipher handle with meta data
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index bc2bcde..aa31b18 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -35,6 +35,7 @@ struct af_alg_iv {
 #define ALG_SET_OP			3
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
+#define ALG_SET_KEY_TYPE		6
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
-- 
1.9.5
