Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-25.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6970CC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 16:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389E02070E
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 16:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OmNQuPSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgGPQkt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 12:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgGPQkt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 12:40:49 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1142C061755
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 09:40:48 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id w18so3753883qvd.16
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2020 09:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m+sYktSOhdxlrCXVQKb7+bCbBIhiMAODTHL1sCLSf5s=;
        b=OmNQuPSo5EHv78a87N1ZZXhxhWkF3WDFnFeMtL9nMj6gvIZ9UzoNIupvHG91t1lPrr
         kLmpy6j8CqntUBXTsG8EQEzLOqU6VgI9X69GoQPUYeg/cFCs9j/1fRwRvEnKVe0FXXFi
         4UzbkHbTljFk0MFOV8WXGfO+7SdXU4KkludQQbsjXuoRg/+IdcIjxWq5dHnWyTAw8/ru
         wY6yPFxD/5jRcAwmh+THI45rG6KWT35tHVVQWoq8x9PlID/KJx57iSXsujgQzQVmHTsY
         mmy6i4eliVkuBT4QU+EXS7a/+U3SMMBIvUlRV7LjOUZmONPUoCZ1SDCWq5Jip5ZErRWD
         zdHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m+sYktSOhdxlrCXVQKb7+bCbBIhiMAODTHL1sCLSf5s=;
        b=reiF0nfuE1bbe8si0kHsENCUSWE88Ux2yhhHYX5yZwAgO4pZ1kTTrWNwxrG3LCZZ9C
         OvPc1ct2HMc/97nbvbf5V/gsB5DunsaW2G2aG6+au3Qfff69HFx1Z2hLuH3nuWu3S+TQ
         VXVnj+a0dQVCz2lSh6u5++uyKdic7dpfFeQJ78wHxUwkM4TrHPl0uKEA+8EjLVOoPqbH
         5dZyyEaO0jSIZjHxX4+wocDXQnkXBDLa1YsP15iKTBW6F1N9I94eVWnNaaCJf0ME8snp
         kO+k/FW/iY5PG/KHoriFOQigjV7u+T12x8H7+npWcekEb+esIuwQVijacpMyQocfyQap
         ucJQ==
X-Gm-Message-State: AOAM532ZZE1iuc7ljyp+17Ji/jeulH8zUrLQjscb84GMu6zwHr0XBasg
        cJCEir/nuClgCw22EaE27n00UX8f7deTM3wLFSqLMcBjj00DaR9EedK8nJIrFSrue1zaQRxs22Y
        puA9JGceZE4p9y0Tn6KoAS9BqwTjechTm2I35lgeAi7GsLt/6nFv4BWBBVqbSF+Qj3Ni97jf4
X-Google-Smtp-Source: ABdhPJxbSiHSZPhkF/pBoR2oxD8moy+zISzpA2u38seP45R196B0c6XVW/za+BFMVEf4lPJ6fN85wSymiQoU
X-Received: by 2002:a0c:b61d:: with SMTP id f29mr4964714qve.249.1594917647828;
 Thu, 16 Jul 2020 09:40:47 -0700 (PDT)
Date:   Thu, 16 Jul 2020 17:40:28 +0100
In-Reply-To: <CABvBcwY44BPa+TaDwxWaEogpg3Kdkq8o9cR5gSqNGF-o6d3jrw@mail.gmail.com>
Message-Id: <20200716164028.1805047-1-lenaptr@google.com>
Mime-Version: 1.0
References: <CABvBcwY44BPa+TaDwxWaEogpg3Kdkq8o9cR5gSqNGF-o6d3jrw@mail.gmail.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH v2] crypto: af_alg - add extra parameters for DRBG interface
From:   Elena Petrova <lenaptr@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Elena Petrova <lenaptr@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "=?UTF-8?q?Stephan=20M=C3=BCller?=" <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extending the userspace RNG interface:
  1. adding ALG_SET_DRBG_ENTROPY setsockopt option for entropy input;
  2. using sendmsg syscall for specifying the additional data.

Signed-off-by: Elena Petrova <lenaptr@google.com>
---

libkcapi patch for testing:
  https://github.com/Len0k/libkcapi/commit/6f095d270b982008f419078614c15caa592cb531

Updates in v2:
  1) Adding CONFIG_CRYPTO_CAVS_DRBG around setentropy.
  2) Requiring CAP_SYS_ADMIN for entropy reset.
  3) Locking for send and recv.
  4) Length checks added for send and setentropy; send and setentropy now return
     number of bytes accepted.
  5) Minor code style corrections.

 Documentation/crypto/userspace-if.rst |  17 +++-
 crypto/Kconfig                        |   8 ++
 crypto/af_alg.c                       |   8 ++
 crypto/algif_rng.c                    | 112 ++++++++++++++++++++++++--
 include/crypto/if_alg.h               |   3 +-
 include/uapi/linux/if_alg.h           |   1 +
 6 files changed, 139 insertions(+), 10 deletions(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index ff86befa61e0..c3695d2c7e0b 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -296,15 +296,23 @@ follows:
 
     struct sockaddr_alg sa = {
         .salg_family = AF_ALG,
-        .salg_type = "rng", /* this selects the symmetric cipher */
-        .salg_name = "drbg_nopr_sha256" /* this is the cipher name */
+        .salg_type = "rng", /* this selects the random number generator */
+        .salg_name = "drbg_nopr_sha256" /* this is the RNG name */
     };
 
 
 Depending on the RNG type, the RNG must be seeded. The seed is provided
 using the setsockopt interface to set the key. For example, the
 ansi_cprng requires a seed. The DRBGs do not require a seed, but may be
-seeded.
+seeded. The seed is also known as a *Personalization String* in DRBG800-90A
+standard.
+
+For the purpose of CAVS testing, the concatenation of *Entropy* and *Nonce*
+can be provided to the RNG via ALG_SET_DRBG_ENTROPY setsockopt interface. This
+requires a kernel built with CONFIG_CRYPTO_CAVS_DRBG, and CAP_SYS_ADMIN
+permission.
+
+*Additional Data* can be provided using the send()/sendmsg() system calls.
 
 Using the read()/recvmsg() system calls, random numbers can be obtained.
 The kernel generates at most 128 bytes in one call. If user space
@@ -377,6 +385,9 @@ mentioned optname:
    provided ciphertext is assumed to contain an authentication tag of
    the given size (see section about AEAD memory layout below).
 
+-  ALG_SET_DRBG_ENTROPY -- Setting the entropy of the random number generator.
+   This option is applicable to RNG cipher type only.
+
 User space API example
 ----------------------
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 091c0a0bbf26..8484617596d1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1896,6 +1896,14 @@ config CRYPTO_STATS
 config CRYPTO_HASH_INFO
 	bool
 
+config CRYPTO_CAVS_DRBG
+	tristate "Enable CAVS testing of DRBG"
+	depends on CRYPTO_USER_API_RNG && CRYPTO_DRBG
+	help
+	  This option enables the resetting of DRBG entropy via the user-space
+	  interface. This should only be enabled for CAVS testing. You should say
+	  no unless you know what this is.
+
 source "lib/crypto/Kconfig"
 source "drivers/crypto/Kconfig"
 source "crypto/asymmetric_keys/Kconfig"
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index b1cd3535c525..27d6248ca447 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -260,6 +260,14 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 		if (!type->setauthsize)
 			goto unlock;
 		err = type->setauthsize(ask->private, optlen);
+		break;
+	case ALG_SET_DRBG_ENTROPY:
+		if (sock->state == SS_CONNECTED)
+			goto unlock;
+		if (!type->setentropy)
+			goto unlock;
+
+		err = type->setentropy(ask->private, optval, optlen);
 	}
 
 unlock:
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 087c0ad09d38..8a3b0eb45a85 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -38,6 +38,7 @@
  * DAMAGE.
  */
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <crypto/rng.h>
 #include <linux/random.h>
@@ -53,8 +54,22 @@ struct rng_ctx {
 #define MAXSIZE 128
 	unsigned int len;
 	struct crypto_rng *drng;
+	u8 *addtl;
+	size_t addtl_len;
 };
 
+struct rng_parent_ctx {
+	struct crypto_rng *drng;
+	u8 *entropy;
+};
+
+static void rng_reset_addtl(struct rng_ctx *ctx)
+{
+	kzfree(ctx->addtl);
+	ctx->addtl = NULL;
+	ctx->addtl_len = 0;
+}
+
 static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		       int flags)
 {
@@ -65,6 +80,7 @@ static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	int genlen = 0;
 	u8 result[MAXSIZE];
 
+	lock_sock(sock->sk);
 	if (len == 0)
 		return 0;
 	if (len > MAXSIZE)
@@ -82,16 +98,45 @@ static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	 * seeding as they automatically seed. The X9.31 DRNG will return
 	 * an error if it was not seeded properly.
 	 */
-	genlen = crypto_rng_get_bytes(ctx->drng, result, len);
+	genlen = crypto_rng_generate(ctx->drng, ctx->addtl, ctx->addtl_len,
+				     result, len);
 	if (genlen < 0)
 		return genlen;
 
 	err = memcpy_to_msg(msg, result, len);
 	memzero_explicit(result, len);
+	rng_reset_addtl(ctx);
+	release_sock(sock->sk);
 
 	return err ? err : len;
 }
 
+static int rng_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+{
+	int err;
+	struct alg_sock *ask = alg_sk(sock->sk);
+	struct rng_ctx *ctx = ask->private;
+
+	lock_sock(sock->sk);
+	if (len > MAXSIZE)
+		len = MAXSIZE;
+
+	rng_reset_addtl(ctx);
+	ctx->addtl = kmalloc(len, GFP_KERNEL);
+	if (!ctx->addtl)
+		return -ENOMEM;
+
+	err = memcpy_from_msg(ctx->addtl, msg, len);
+	if (err) {
+		rng_reset_addtl(ctx);
+		return err;
+	}
+	ctx->addtl_len = len;
+	release_sock(sock->sk);
+
+	return len;
+}
+
 static struct proto_ops algif_rng_ops = {
 	.family		=	PF_ALG,
 
@@ -106,21 +151,41 @@ static struct proto_ops algif_rng_ops = {
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
 	.setsockopt	=	sock_no_setsockopt,
-	.sendmsg	=	sock_no_sendmsg,
 	.sendpage	=	sock_no_sendpage,
 
 	.release	=	af_alg_release,
 	.recvmsg	=	rng_recvmsg,
+	.sendmsg	=	rng_sendmsg,
 };
 
 static void *rng_bind(const char *name, u32 type, u32 mask)
 {
-	return crypto_alloc_rng(name, type, mask);
+	struct rng_parent_ctx *pctx;
+	struct crypto_rng *rng;
+
+	pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
+	if (!pctx)
+		return ERR_PTR(-ENOMEM);
+
+	rng = crypto_alloc_rng(name, type, mask);
+	if (IS_ERR(rng)) {
+		kfree(pctx);
+		return ERR_CAST(rng);
+	}
+
+	pctx->drng = rng;
+	return pctx;
 }
 
 static void rng_release(void *private)
 {
-	crypto_free_rng(private);
+	struct rng_parent_ctx *pctx = private;
+
+	if (unlikely(!pctx))
+		return;
+	crypto_free_rng(pctx->drng);
+	kzfree(pctx->entropy);
+	kzfree(pctx);
 }
 
 static void rng_sock_destruct(struct sock *sk)
@@ -128,6 +193,7 @@ static void rng_sock_destruct(struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct rng_ctx *ctx = ask->private;
 
+	rng_reset_addtl(ctx);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
@@ -135,6 +201,7 @@ static void rng_sock_destruct(struct sock *sk)
 static int rng_accept_parent(void *private, struct sock *sk)
 {
 	struct rng_ctx *ctx;
+	struct rng_parent_ctx *pctx = private;
 	struct alg_sock *ask = alg_sk(sk);
 	unsigned int len = sizeof(*ctx);
 
@@ -150,7 +217,9 @@ static int rng_accept_parent(void *private, struct sock *sk)
 	 * state of the RNG.
 	 */
 
-	ctx->drng = private;
+	ctx->drng = pctx->drng;
+	ctx->addtl = NULL;
+	ctx->addtl_len = 0;
 	ask->private = ctx;
 	sk->sk_destruct = rng_sock_destruct;
 
@@ -159,18 +228,49 @@ static int rng_accept_parent(void *private, struct sock *sk)
 
 static int rng_setkey(void *private, const u8 *seed, unsigned int seedlen)
 {
+	struct rng_parent_ctx *pctx = private;
 	/*
 	 * Check whether seedlen is of sufficient size is done in RNG
 	 * implementations.
 	 */
-	return crypto_rng_reset(private, seed, seedlen);
+	return crypto_rng_reset(pctx->drng, seed, seedlen);
+}
+
+#ifdef CONFIG_CRYPTO_CAVS_DRBG
+static int rng_setentropy(void *private, const u8 *entropy, unsigned int len)
+{
+	struct rng_parent_ctx *pctx = private;
+	u8 *kentropy = NULL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (pctx->entropy)
+		return -EINVAL;
+
+	if (len > MAXSIZE)
+		len = MAXSIZE;
+
+	if (len) {
+		kentropy = memdup_user(entropy, len);
+		if (IS_ERR(kentropy))
+			return PTR_ERR(kentropy);
+	}
+
+	crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
+	pctx->entropy = kentropy;
+	return len;
 }
+#endif
 
 static const struct af_alg_type algif_type_rng = {
 	.bind		=	rng_bind,
 	.release	=	rng_release,
 	.accept		=	rng_accept_parent,
 	.setkey		=	rng_setkey,
+#ifdef CONFIG_CRYPTO_CAVS_DRBG
+	.setentropy	=	rng_setentropy,
+#endif
 	.ops		=	&algif_rng_ops,
 	.name		=	"rng",
 	.owner		=	THIS_MODULE
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 56527c85d122..312fdb3469cf 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -46,6 +46,7 @@ struct af_alg_type {
 	void *(*bind)(const char *name, u32 type, u32 mask);
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
+	int (*setentropy)(void *private, const u8 *entropy, unsigned int len);
 	int (*accept)(void *private, struct sock *sk);
 	int (*accept_nokey)(void *private, struct sock *sk);
 	int (*setauthsize)(void *private, unsigned int authsize);
@@ -123,7 +124,7 @@ struct af_alg_async_req {
  * @tsgl_list:		Link to TX SGL
  * @iv:			IV for cipher operation
  * @aead_assoclen:	Length of AAD for AEAD cipher operations
- * @completion:		Work queue for synchronous operation
+ * @wait:		Wait on completion of async crypto ops
  * @used:		TX bytes sent to kernel. This variable is used to
  *			ensure that user space cannot cause the kernel
  *			to allocate too much memory in sendmsg operation.
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index bc2bcdec377b..60b7c2efd921 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -35,6 +35,7 @@ struct af_alg_iv {
 #define ALG_SET_OP			3
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
+#define ALG_SET_DRBG_ENTROPY		6
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
-- 
2.27.0.389.gc38d7665816-goog

