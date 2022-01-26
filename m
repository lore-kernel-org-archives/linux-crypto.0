Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A58C63682
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 07:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbiAZHH3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 02:07:29 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.171]:35719 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiAZHH1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 02:07:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643180841;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ZQa8P93DtFLN6+4nH7jW0EHewAPOjepwRaiJ8WzIXws=;
    b=XPP9f6e0cCx6MwnBcD/cKjyhO31Kenlv06tI2Yof1Gfr/YODuTSePmRJJevxIq3G+k
    WLG4utZEleCRjs746Qgu+G+nxORIdZy2Js8nrYh60PTMUdDmDx8IgOHl2EUR7VVy4djH
    KltfoEw7tlDa4QaV5s1Gc5bNtu2PwijHPYHbPeIPsYiFNMQBi9qKgAOypTFAvt1SNLj5
    Q7qYpIwkPwAwukPgZNajuEGaoy672K6DGx0Yzkoj5VyzF+4dO/FbYs9g4dDoKjP7xtv+
    cqNpTyjyjtoc/WVv8f4x++powiEOXVqHPLivkipwi43i1d+8Ott80NKpwt9Q4huzoIWq
    mQsA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvScdWrN"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0Q77LiuR
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 26 Jan 2022 08:07:21 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>,
        Elena Petrova <lenaptr@google.com>
Subject: [PATCH 2/7] crypto: AF_ALG - remove ALG_SET_DRBG_ENTROPY interface
Date:   Wed, 26 Jan 2022 08:03:43 +0100
Message-ID: <2434090.Hq7AAxBmiT@positron.chronox.de>
In-Reply-To: <2486550.t9SDvczpPo@positron.chronox.de>
References: <2486550.t9SDvczpPo@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ALG_SET_DRBG_ENTROPY was added to test the DRBG implementation
provided with the kernel crypto API. This interface was used to set a
"test entropy" string to bypass the DRBG-internal seeding mechanism.

Since the DRBG-internal seeding mechanism is completely removed, the
special bypass is not needed any more. The entropy string for the DRBG
can be set with the crypto_rng_reset() function that is invoked with the
ALG_SET_KEY interface.

The change enables the sendmsg implementation in AF_ALG RNG for a
general use. The sendmsg allows user space to set the input data to the
crypto_rng_generate function call.

The change still allows the full testing of the DRBG which was verified
with libkcapi version 1.5.0 covering the following aspects:

- Hash DRBG with SHA-1, SHA-256, SHA-384, SHA-512

- HMAC DRBG with SHA-1, SHA-256, SHA-384, SHA-512

- CTR DRBG with AES-128, AES-192, AES-256

- reseeding, but without additional information

- no reseeding, but with additional information

The limitation of the test is defined with algif_rng.c:MAXSIZE which
restricts the allowed output size for testing to 128 bytes.

CC: Elena Petrova <lenaptr@google.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig                |  9 -----
 crypto/af_alg.c               |  7 ----
 crypto/algif_rng.c            | 75 +----------------------------------
 include/crypto/if_alg.h       |  1 -
 include/crypto/internal/rng.h |  6 ---
 include/crypto/rng.h          |  4 --
 include/uapi/linux/if_alg.h   |  2 +-
 7 files changed, 3 insertions(+), 101 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 442765219c37..a0de01ab6f0c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1879,15 +1879,6 @@ config CRYPTO_USER_API_RNG
 	  This option enables the user-spaces interface for random
 	  number generator algorithms.
 
-config CRYPTO_USER_API_RNG_CAVP
-	bool "Enable CAVP testing of DRBG"
-	depends on CRYPTO_USER_API_RNG && CRYPTO_DRBG
-	help
-	  This option enables extra API for CAVP testing via the user-space
-	  interface: resetting of DRBG entropy, and providing Additional Data.
-	  This should only be enabled for CAVP testing. You should say
-	  no unless you know what this is.
-
 config CRYPTO_USER_API_AEAD
 	tristate "User-space interface for AEAD cipher algorithms"
 	depends on NET
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index e1ea18536a5f..6e5222fd10e2 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -259,13 +259,6 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 			goto unlock;
 		err = type->setauthsize(ask->private, optlen);
 		break;
-	case ALG_SET_DRBG_ENTROPY:
-		if (sock->state == SS_CONNECTED)
-			goto unlock;
-		if (!type->setentropy)
-			goto unlock;
-
-		err = type->setentropy(ask->private, optval, optlen);
 	}
 
 unlock:
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index b204f1427542..4fade9456990 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -110,16 +110,6 @@ static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct rng_ctx *ctx = ask->private;
-
-	return _rng_recvmsg(ctx->drng, msg, len, NULL, 0);
-}
-
-static int rng_test_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
-			    int flags)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct rng_ctx *ctx = ask->private;
 	int ret;
 
 	lock_sock(sock->sk);
@@ -130,7 +120,7 @@ static int rng_test_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	return ret;
 }
 
-static int rng_test_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+static int rng_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	int err;
 	struct alg_sock *ask = alg_sk(sock->sk);
@@ -173,30 +163,11 @@ static struct proto_ops algif_rng_ops = {
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
-	.sendmsg	=	sock_no_sendmsg,
 	.sendpage	=	sock_no_sendpage,
 
 	.release	=	af_alg_release,
 	.recvmsg	=	rng_recvmsg,
-};
-
-static struct proto_ops __maybe_unused algif_rng_test_ops = {
-	.family		=	PF_ALG,
-
-	.connect	=	sock_no_connect,
-	.socketpair	=	sock_no_socketpair,
-	.getname	=	sock_no_getname,
-	.ioctl		=	sock_no_ioctl,
-	.listen		=	sock_no_listen,
-	.shutdown	=	sock_no_shutdown,
-	.mmap		=	sock_no_mmap,
-	.bind		=	sock_no_bind,
-	.accept		=	sock_no_accept,
-	.sendpage	=	sock_no_sendpage,
-
-	.release	=	af_alg_release,
-	.recvmsg	=	rng_test_recvmsg,
-	.sendmsg	=	rng_test_sendmsg,
+	.sendmsg	=	rng_sendmsg,
 };
 
 static void *rng_bind(const char *name, u32 type, u32 mask)
@@ -225,7 +196,6 @@ static void rng_release(void *private)
 	if (unlikely(!pctx))
 		return;
 	crypto_free_rng(pctx->drng);
-	kfree_sensitive(pctx->entropy);
 	kfree_sensitive(pctx);
 }
 
@@ -264,13 +234,6 @@ static int rng_accept_parent(void *private, struct sock *sk)
 	ask->private = ctx;
 	sk->sk_destruct = rng_sock_destruct;
 
-	/*
-	 * Non NULL pctx->entropy means that CAVP test has been initiated on
-	 * this socket, replace proto_ops algif_rng_ops with algif_rng_test_ops.
-	 */
-	if (IS_ENABLED(CONFIG_CRYPTO_USER_API_RNG_CAVP) && pctx->entropy)
-		sk->sk_socket->ops = &algif_rng_test_ops;
-
 	return 0;
 }
 
@@ -284,45 +247,11 @@ static int rng_setkey(void *private, const u8 *seed, unsigned int seedlen)
 	return crypto_rng_reset(pctx->drng, seed, seedlen);
 }
 
-static int __maybe_unused rng_setentropy(void *private, sockptr_t entropy,
-					 unsigned int len)
-{
-	struct rng_parent_ctx *pctx = private;
-	u8 *kentropy = NULL;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	if (pctx->entropy)
-		return -EINVAL;
-
-	if (len > MAXSIZE)
-		return -EMSGSIZE;
-
-	if (len) {
-		kentropy = memdup_sockptr(entropy, len);
-		if (IS_ERR(kentropy))
-			return PTR_ERR(kentropy);
-	}
-
-	if (crypto_rng_alg(pctx->drng)->set_ent)
-		crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
-	/*
-	 * Since rng doesn't perform any memory management for the entropy
-	 * buffer, save kentropy pointer to pctx now to free it after use.
-	 */
-	pctx->entropy = kentropy;
-	return 0;
-}
-
 static const struct af_alg_type algif_type_rng = {
 	.bind		=	rng_bind,
 	.release	=	rng_release,
 	.accept		=	rng_accept_parent,
 	.setkey		=	rng_setkey,
-#ifdef CONFIG_CRYPTO_USER_API_RNG_CAVP
-	.setentropy	=	rng_setentropy,
-#endif
 	.ops		=	&algif_rng_ops,
 	.name		=	"rng",
 	.owner		=	THIS_MODULE
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index a5db86670bdf..ee6412314f8f 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -46,7 +46,6 @@ struct af_alg_type {
 	void *(*bind)(const char *name, u32 type, u32 mask);
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
-	int (*setentropy)(void *private, sockptr_t entropy, unsigned int len);
 	int (*accept)(void *private, struct sock *sk);
 	int (*accept_nokey)(void *private, struct sock *sk);
 	int (*setauthsize)(void *private, unsigned int authsize);
diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
index e0711b6a597f..bf6da44f9e82 100644
--- a/include/crypto/internal/rng.h
+++ b/include/crypto/internal/rng.h
@@ -31,10 +31,4 @@ static inline void *crypto_rng_ctx(struct crypto_rng *tfm)
 	return crypto_tfm_ctx(&tfm->base);
 }
 
-static inline void crypto_rng_set_entropy(struct crypto_rng *tfm,
-					  const u8 *data, unsigned int len)
-{
-	crypto_rng_alg(tfm)->set_ent(tfm, data, len);
-}
-
 #endif
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 17bb3673d3c1..85312ea12274 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -28,8 +28,6 @@ struct crypto_rng;
  *		up a new state, the seed must be provided by the
  *		consumer while invoking this function. The required
  *		size of the seed is defined with @seedsize .
- * @set_ent:	Set entropy that would otherwise be obtained from
- *		entropy source.  Internal use only.
  * @seedsize:	The seed size required for a random number generator
  *		initialization defined with this variable. Some
  *		random number generators does not require a seed
@@ -43,8 +41,6 @@ struct rng_alg {
 			const u8 *src, unsigned int slen,
 			u8 *dst, unsigned int dlen);
 	int (*seed)(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
-	void (*set_ent)(struct crypto_rng *tfm, const u8 *data,
-			unsigned int len);
 
 	unsigned int seedsize;
 
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index dc52a11ba6d1..e8d676350c8f 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -51,7 +51,7 @@ struct af_alg_iv {
 #define ALG_SET_OP			3
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
-#define ALG_SET_DRBG_ENTROPY		6
+#define ALG_SET_DRBG_ENTROPY		6 /* Not implemented any more */
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
-- 
2.33.1




