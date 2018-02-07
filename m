From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v2 4/4] crypto: add CRYPTO_TFM_REQ_PARALLEL flag
Date: Wed, 07 Feb 2018 08:44:04 +0100
Message-ID: <3375426.msL1YKqpVq@positron.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <20180201102519.000044c1@huawei.com> <1842104.0gXuQuQB9D@positron.chronox.de>
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
Received: from mail.eperm.de ([89.247.134.16]:59332 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751146AbeBGHpI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Feb 2018 02:45:08 -0500
In-Reply-To: <1842104.0gXuQuQB9D@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Crypto drivers may implement a streamlined serialization support for AIO
requests that is reported by the CRYPTO_TFM_REQ_PARALLEL flag to the
crypto user. When the user decides that he wants to send multiple AIO
requests concurrently and wants the crypto driver to handle the
serialization, the caller has to set CRYPTO_TFM_REQ_PARALLEL to notify
the crypto driver.

Only when this flag is enabled, the crypto driver shall apply its
serialization logic for handling IV updates between requests. If this
flag is not provided, the serialization logic shall not be applied by
the driver as the caller decides that it does not need it (because no
parallel AIO requests are sent) or that it performs its own
serialization.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c     | 15 ++++++++++++---
 crypto/algif_skcipher.c | 15 ++++++++++++---
 include/linux/crypto.h  |  1 +
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 3970ad7f6fd0..da010405eea0 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -66,13 +66,22 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
 	struct aead_tfm *aeadc = pask->private;
-	struct crypto_aead *tfm = aeadc->aead;
-	unsigned int ivsize = crypto_aead_ivsize(tfm);
+	struct crypto_aead *aead = aeadc->aead;
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	unsigned int ivsize = crypto_aead_ivsize(aead);
+	int ret = af_alg_sendmsg(sock, msg, size, ivsize);
+
+	if (ret < 0)
+		return ret;
 
-	return af_alg_sendmsg(sock, msg, size, ivsize);
+	if (ctx->iiv == ALG_IIV_USE)
+		tfm->crt_flags |= CRYPTO_TFM_REQ_PARALLEL;
+
+	return ret;
 }
 
 static int crypto_aead_copy_sgl(struct crypto_skcipher *null_tfm,
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index aee602a3ec24..225546666cf7 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -43,12 +43,21 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
-	struct crypto_skcipher *tfm = pask->private;
-	unsigned ivsize = crypto_skcipher_ivsize(tfm);
+	struct crypto_skcipher *skc = pask->private;
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(skc);
+	unsigned int ivsize = crypto_skcipher_ivsize(skc);
+	int ret = af_alg_sendmsg(sock, msg, size, ivsize);
+
+	if (ret < 0)
+		return ret;
 
-	return af_alg_sendmsg(sock, msg, size, ivsize);
+	if (ctx->iiv == ALG_IIV_USE)
+		tfm->crt_flags |= CRYPTO_TFM_REQ_PARALLEL;
+
+	return ret;
 }
 
 static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 4860aa2c9be4..95c9d6e8fb70 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -133,6 +133,7 @@
 #define CRYPTO_TFM_REQ_WEAK_KEY		0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
+#define CRYPTO_TFM_REQ_PARALLEL		0x00000800
 #define CRYPTO_TFM_RES_WEAK_KEY		0x00100000
 #define CRYPTO_TFM_RES_BAD_KEY_LEN   	0x00200000
 #define CRYPTO_TFM_RES_BAD_KEY_SCHED 	0x00400000
-- 
2.14.3
