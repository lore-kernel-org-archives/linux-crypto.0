From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v3 3/4] crypto: AF_ALG - allow driver to serialize IV access
Date: Fri, 09 Feb 2018 23:04:19 +0100
Message-ID: <6275858.xaVr4mir3Q@positron.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <1842104.0gXuQuQB9D@positron.chronox.de> <2808558.OTeCt0oKkL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Harsh Jain <harsh@chelsio.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:27847 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753006AbeBIWOa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Feb 2018 17:14:30 -0500
In-Reply-To: <2808558.OTeCt0oKkL@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The mutex in AF_ALG to serialize access to the IV ensures full
serialization of requests sent to the crypto driver.

However, the hardware may implement serialization to the IV such that
preparation work without touching the IV can already happen while the IV
is processed by another operation. This may speed up the AIO processing.

The following ASCII art demonstrates this.

AF_ALG mutex handling implements the following logic:

[REQUEST 1 from userspace]   [REQUEST 2 from userspace]
             |                            |
     [AF_ALG/SOCKET]               [AF_ALG/SOCKET]
             |                            |
NOTHING BLOCKING (lock mutex)             |
             |                     Queued on Mutex
 [BUILD / MAP HW DESCS]                   |
             |                            |
   [Place in HW Queue]                    |
             |                            |
         [Process]                        |
             |                            |
        [Interrupt]                       |
             |                            |
 [Respond and update IV]                  |
             |                            |
        [unlock mutex]       Nothing Blocking (lock mutex)
             |                            |
    Don't care beyond here.       [BUILD / MAP HW DESCS]
                                          |
                                  [Place in HW Queue]
                                          |
                                      [Process]
                                          |
                                     [Interrupt]
                                          |
                                [Respond and update IV]
                                          |
                                Don't care beyond here.

A crypto driver may implement the following serialization:

[REQUEST 1 from userspace]   [REQUEST 2 from userspace]
             |                            |
      [AF_ALG/SOCKET]              [AF_ALG/SOCKET]
             |                            |
  [BUILD / MAP HW DESCS]         [BUILD / MAP HW DESCS]
             |                            |
    NOTHING BLOCKING         IV in flight (enqueue sw queue)
             |                            |
   [Place in HW Queue]                    |
             |                            |
         [Process]                        |
             |                            |
        [Interrupt]                       |
             |                            |
 [Respond and update IV]     Nothing Blocking (dequeue sw queue)
             |                            |
  Don't care beyond here.          [Place in HW Queue]
                                          |
                                      [Process]
                                          |
                                     [Interrupt]
                                          |
                                [Respond and update IV]
                                          |
                                Don't care beyond here.

If the driver implements its own serialization (i.e. AF_ALG does not
serialize the access to the IV), the crypto implementation must set the
flag CRYPTO_ALG_SERIALIZES_IV_ACCESS.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 13 ++++++++-----
 crypto/algif_aead.c     |  1 +
 crypto/algif_skcipher.c |  1 +
 include/crypto/if_alg.h | 13 +++++++++++++
 include/linux/crypto.h  | 15 +++++++++++++++
 5 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 7f80dcfc12a6..56b4da65025a 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1247,8 +1247,10 @@ int af_alg_get_iv(struct sock *sk, struct af_alg_async_req *areq)
 		return 0;
 
 	/* No inline IV, use ctx IV buffer and lock it */
-	if (ctx->iiv == ALG_IV_SERIAL_PROCESSING)
-		return mutex_lock_interruptible(&ctx->ivlock);
+	if (ctx->iiv == ALG_IV_SERIAL_PROCESSING) {
+		return (ctx->lock_iv) ?
+				mutex_lock_interruptible(&ctx->ivlock) : 0;
+	}
 
 	/* Inline IV handling: There must be the IV data present. */
 	if (ctx->used < ctx->ivlen || list_empty(&ctx->tsgl_list))
@@ -1280,12 +1282,13 @@ void af_alg_put_iv(struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
 
-	/* To resemble af_alg_get_iv, do not merge the two branches. */
 	if (!ctx->ivlen)
 		return;
 
-	if (ctx->iiv == ALG_IV_SERIAL_PROCESSING)
-		mutex_unlock(&ctx->ivlock);
+	if (ctx->iiv == ALG_IV_SERIAL_PROCESSING) {
+		if (ctx->lock_iv)
+			mutex_unlock(&ctx->ivlock);
+	}
 }
 EXPORT_SYMBOL_GPL(af_alg_put_iv);
 
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 4c425effc5a5..619147792cc9 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -565,6 +565,7 @@ static int aead_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	ctx->lock_iv = af_alg_lock_iv(crypto_aead_tfm(aead));
 	ctx->iiv = ALG_IV_PROCESSING_UNDEF;
 	ctx->aead_assoclen = 0;
 	crypto_init_wait(&ctx->wait);
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index f2a671b6ddf3..cf27dda6a181 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -368,6 +368,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	ctx->lock_iv = af_alg_lock_iv(crypto_skcipher_tfm(tfm));
 	ctx->iiv = ALG_IV_PROCESSING_UNDEF;
 	crypto_init_wait(&ctx->wait);
 
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index ef114b72813a..4b48a48464c3 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -154,6 +154,7 @@ struct af_alg_async_req {
  *			SG?
  * @enc:		Cryptographic operation to be performed when
  *			recvmsg is invoked.
+ * @lock_iv:		Shall IV be locked?
  * @iiv:		Use inline IV: first part of TX data is IV
  * @len:		Length of memory allocated for this data structure.
  */
@@ -173,6 +174,7 @@ struct af_alg_ctx {
 	bool more;
 	bool merge;
 	bool enc;
+	bool lock_iv;
 	int iiv;
 
 	unsigned int len;
@@ -251,6 +253,17 @@ static inline bool af_alg_readable(struct sock *sk)
 	return PAGE_SIZE <= af_alg_rcvbuf(sk);
 }
 
+/**
+ * Shall access to the ctx->iv be serialized using a mutex?
+ *
+ * @tfm TFM of to be used for cipher operation
+ * @return true => lock, false => do not lock
+ */
+static inline bool af_alg_lock_iv(struct crypto_tfm *tfm)
+{
+	return !(crypto_tfm_alg_flags(tfm) & CRYPTO_ALG_SERIALIZES_IV_ACCESS);
+}
+
 int af_alg_alloc_tsgl(struct sock *sk);
 unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
 void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7e6e84cf6383..4860aa2c9be4 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -112,6 +112,16 @@
  */
 #define CRYPTO_ALG_OPTIONAL_KEY		0x00004000
 
+/*
+ * Set if the algorithm implementation provides its own serialization
+ * of IV accesses. This prevents the AF_ALG interface to serialize
+ * cipher requests. This flag allows the implementation to implement
+ * a more streamlined IV serialization logic, such as only serializing
+ * the submission of a request to hardware whereas the preparation steps
+ * for sending data to hardware are not serialized.
+ */
+#define CRYPTO_ALG_SERIALIZES_IV_ACCESS	0x00008000
+
 /*
  * Transform masks and values (for crt_flags).
  */
@@ -674,6 +684,11 @@ static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
 }
 
+static inline u32 crypto_tfm_alg_flags(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags;
+}
+
 static inline unsigned int crypto_tfm_alg_blocksize(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_blocksize;
-- 
2.14.3
