From: Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH] crypto: Adds user space interface for ALG_SET_KEY_TYPE
Date: Fri, 7 Sep 2018 12:10:43 +0530
Message-ID: <1536302443-18380-1-git-send-email-kalyani.akula@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Cc: Kalyani Akula <kalyani.akula@xilinx.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kstewart@linuxfoundation.org>, <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>, <pombredanne@nexb.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <saratcha@xilinx.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

ALG_SET_KEY_TYPE requires caller to pass the key_type to be used
for AES encryption/decryption.

Sometimes the cipher key will be stored in the device's
hardware (eFuse, BBRAM etc).So,there is a need to specify the information
about the key-type to use it for Encrypt or Decrypt operations.

This patch implements the above requirement.


Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 crypto/af_alg.c             |  7 +++++++
 crypto/algif_skcipher.c     | 12 ++++++++++++
 crypto/blkcipher.c          |  9 +++++++++
 crypto/skcipher.c           | 18 ++++++++++++++++++
 include/crypto/if_alg.h     |  2 ++
 include/crypto/skcipher.h   | 12 +++++++++++-
 include/linux/crypto.h      | 12 ++++++++++++
 include/uapi/linux/if_alg.h |  1 +
 8 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index b053179..9ea6b86 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -261,6 +261,13 @@ static int alg_setsockopt(struct socket *sock, int lev=
el, int optname,
                if (!type->setauthsize)
                        goto unlock;
                err =3D type->setauthsize(ask->private, optlen);
+               break;
+       case ALG_SET_KEY_TYPE:
+               if (sock->state =3D=3D SS_CONNECTED)
+                       goto unlock;
+               if (!type->setkeytype)
+                       goto unlock;
+               err =3D type->setkeytype(ask->private, optval, optlen);
        }

 unlock:
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index cfdaab2..9164465 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -320,6 +320,17 @@ static int skcipher_setkey(void *private, const u8 *ke=
y, unsigned int keylen)
        return crypto_skcipher_setkey(private, key, keylen);
 }

+static int skcipher_setkeytype(void *private, const u8 *key,
+                              unsigned int keylen)
+{
+       struct skcipher_tfm *tfm =3D private;
+       int err;
+
+       err =3D crypto_skcipher_setkeytype(tfm->skcipher, key, keylen);
+
+       return err;
+}
+
 static void skcipher_sock_destruct(struct sock *sk)
 {
        struct alg_sock *ask =3D alg_sk(sk);
@@ -384,6 +395,7 @@ static int skcipher_accept_parent(void *private, struct=
 sock *sk)
        .bind           =3D       skcipher_bind,
        .release        =3D       skcipher_release,
        .setkey         =3D       skcipher_setkey,
+       .setkeytype     =3D       skcipher_setkeytype,
        .accept         =3D       skcipher_accept_parent,
        .accept_nokey   =3D       skcipher_accept_parent_nokey,
        .ops            =3D       &algif_skcipher_ops,
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index f93abf1..3ea0e7f 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -408,6 +408,14 @@ static int setkey(struct crypto_tfm *tfm, const u8 *ke=
y, unsigned int keylen)
        return cipher->setkey(tfm, key, keylen);
 }

+static int setkeytype(struct crypto_tfm *tfm, const u8 *key,
+                     unsigned int keylen)
+{
+       struct blkcipher_alg *cipher =3D &tfm->__crt_alg->cra_blkcipher;
+
+       return cipher->setkeytype(tfm, key, keylen);
+}
+
 static int async_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
                        unsigned int keylen)
 {
@@ -478,6 +486,7 @@ static int crypto_init_blkcipher_ops_sync(struct crypto=
_tfm *tfm)
        unsigned long addr;

        crt->setkey =3D setkey;
+       crt->setkeytype =3D setkeytype;
        crt->encrypt =3D alg->encrypt;
        crt->decrypt =3D alg->decrypt;

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 0bd8c6c..cb794dd 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -604,6 +604,23 @@ static int skcipher_setkey_blkcipher(struct crypto_skc=
ipher *tfm,
        return 0;
 }

+static int skcipher_setkeytype_blkcipher(struct crypto_skcipher *tfm,
+                                        const u8 *key, unsigned int keylen=
)
+{
+       struct crypto_blkcipher **ctx =3D crypto_skcipher_ctx(tfm);
+       struct crypto_blkcipher *blkcipher =3D *ctx;
+       int err;
+
+       crypto_blkcipher_clear_flags(blkcipher, ~0);
+       crypto_blkcipher_set_flags(blkcipher, crypto_skcipher_get_flags(tfm=
) &
+                       CRYPTO_TFM_REQ_MASK);
+       err =3D crypto_blkcipher_setkeytype(blkcipher, key, keylen);
+       crypto_skcipher_set_flags(tfm, crypto_blkcipher_get_flags(blkcipher=
) &
+                       CRYPTO_TFM_RES_MASK);
+
+       return err;
+}
+
 static int skcipher_crypt_blkcipher(struct skcipher_request *req,
                                    int (*crypt)(struct blkcipher_desc *,
                                                 struct scatterlist *,
@@ -670,6 +687,7 @@ static int crypto_init_skcipher_ops_blkcipher(struct cr=
ypto_tfm *tfm)
        tfm->exit =3D crypto_exit_skcipher_ops_blkcipher;

        skcipher->setkey =3D skcipher_setkey_blkcipher;
+       skcipher->setkeytype =3D skcipher_setkeytype_blkcipher;
        skcipher->encrypt =3D skcipher_encrypt_blkcipher;
        skcipher->decrypt =3D skcipher_decrypt_blkcipher;

diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 482461d..202298e 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -51,6 +51,8 @@ struct af_alg_type {
        void *(*bind)(const char *name, u32 type, u32 mask);
        void (*release)(void *private);
        int (*setkey)(void *private, const u8 *key, unsigned int keylen);
+       int (*setkeytype)(void *private, const u8 *keytype,
+                         unsigned int keylen);
        int (*accept)(void *private, struct sock *sk);
        int (*accept_nokey)(void *private, struct sock *sk);
        int (*setauthsize)(void *private, unsigned int authsize);
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 2f327f0..54f6752 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -54,7 +54,9 @@ struct skcipher_givcrypt_request {

 struct crypto_skcipher {
        int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
-                     unsigned int keylen);
+                       unsigned int keylen);
+       int (*setkeytype)(struct crypto_skcipher *tfm, const u8 *key,
+                         unsigned int keylen);
        int (*encrypt)(struct skcipher_request *req);
        int (*decrypt)(struct skcipher_request *req);

@@ -125,6 +127,8 @@ struct crypto_skcipher {
 struct skcipher_alg {
        int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
                      unsigned int keylen);
+       int (*setkeytype)(struct crypto_skcipher *tfm, const u8 *key,
+                         unsigned int keylen);
        int (*encrypt)(struct skcipher_request *req);
        int (*decrypt)(struct skcipher_request *req);
        int (*init)(struct crypto_skcipher *tfm);
@@ -401,6 +405,12 @@ static inline int crypto_skcipher_setkey(struct crypto=
_skcipher *tfm,
        return tfm->setkey(tfm, key, keylen);
 }

+static inline int crypto_skcipher_setkeytype(struct crypto_skcipher *tfm,
+                                            const u8 *key, unsigned int ke=
ylen)
+{
+       return tfm->setkeytype(tfm, key, keylen);
+}
+
 static inline unsigned int crypto_skcipher_default_keysize(
        struct crypto_skcipher *tfm)
 {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e8839d3..bda8380 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -292,6 +292,8 @@ struct ablkcipher_alg {
 struct blkcipher_alg {
        int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
                      unsigned int keylen);
+       int (*setkeytype)(struct crypto_tfm *tfm, const u8 *keytype,
+                         unsigned int keylen);
        int (*encrypt)(struct blkcipher_desc *desc,
                       struct scatterlist *dst, struct scatterlist *src,
                       unsigned int nbytes);
@@ -563,6 +565,8 @@ struct blkcipher_tfm {
        void *iv;
        int (*setkey)(struct crypto_tfm *tfm, const u8 *key,
                      unsigned int keylen);
+       int (*setkeytype)(struct crypto_tfm *tfm, const u8 *key,
+                         unsigned int keylen);
        int (*encrypt)(struct blkcipher_desc *desc, struct scatterlist *dst=
,
                       struct scatterlist *src, unsigned int nbytes);
        int (*decrypt)(struct blkcipher_desc *desc, struct scatterlist *dst=
,
@@ -1281,6 +1285,14 @@ static inline int crypto_blkcipher_setkey(struct cry=
pto_blkcipher *tfm,
                                                 key, keylen);
 }

+static inline int crypto_blkcipher_setkeytype(struct crypto_blkcipher *tfm=
,
+                                             const u8 *key,
+                                             unsigned int keylen)
+{
+       return crypto_blkcipher_crt(tfm)->setkeytype(crypto_blkcipher_tfm(t=
fm),
+                                                    key, keylen);
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
 #define ALG_SET_OP                     3
 #define ALG_SET_AEAD_ASSOCLEN          4
 #define ALG_SET_AEAD_AUTHSIZE          5
+#define ALG_SET_KEY_TYPE               6

 /* Operations */
 #define ALG_OP_DECRYPT                 0
--
1.9.5

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
