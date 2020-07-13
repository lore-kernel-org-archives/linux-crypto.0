Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337B2C433E3
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 16:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B05020771
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 16:49:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VuLk10wD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbgGMQtH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMQtH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 12:49:07 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA7EC061755
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2020 09:49:06 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id g187so137891wme.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2020 09:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LzeJsg0t61Zs/SoUo0pQVy9mxhqC9p8TJ+3WDcwe25s=;
        b=VuLk10wDEvuCcEAafDEVY8CUgV4F+8wNzwh7ghHeur0cdebPAahCem0O9qnLq52W9E
         g061MDqoGQCegJKFegN/kEVzxBmpxb6UtZy5PmmfjgfVPnVS8yHpEaquHapzHPVjOKah
         Oj64kZisYfod0HLjY6yOLBaunf8bcYQ61QM0cSTeT572nfQr7OJwTeq1Sikp/H3j/HWI
         OWM5OjWcYNYQgm7T9hGGqzX3P1M2WGq/sFJY4n8LcCpfnewKZyO/5Nc5a/n+8MpRYrf+
         e/QShmwIhmfeHA8R4zxnYuCLENKXOPon63CWfsYOng6v65qbsppxHgMy9XRjvZi/5RPv
         xF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LzeJsg0t61Zs/SoUo0pQVy9mxhqC9p8TJ+3WDcwe25s=;
        b=QVI8yOIfrckhr40Ki6SfNaWOYQ6PM8fiMiTNxEKYLvEjBhQe9w5//VkkgE5kR4rGiX
         qlPQQkEBiSRfrMD/99pv6/urRfXri51vS03EjYm1XkF1a6qR+2kH+YN9ybkfQBESYVxv
         rSItjVdNz5v9hPtV1zBVyaOCmzl487QpzxwETBqE7gv6v9NxWkOv2HJaCV9OfztcTApH
         cjQVRJMBN6Ihhpot2ffu+gEfvb92DO8Njk53BgCy7xyRHG1uR3dr7/xrdO01zdE+Fajb
         q9vVsY62gxg7Z/foeLVAk0Ppd52BYmoN10ijRyGuLNoq7UEY94OfMNuvxnuWa8aIgS+S
         RMWg==
X-Gm-Message-State: AOAM531GQRptKCuhGd7P+BnwnyPKSHMmefCKJWGKZq2AzoDtX7NLI01x
        tcSHYNWJ9077lyv8MkZKRRygoEzE42NFW3qHj4AZOi/Pl1XOsSIvEIeijuRmCnr0iv3HKtufY/l
        wmkeGnM6+PaXHuBjh7Kn7JT+fLeAXnoa3ngKSvqE05/NpIcsWxg4qjRNLSPquYm3C5f5WAgvS
X-Google-Smtp-Source: ABdhPJzD8Az4kMtwG8//t0Awkw/5nuSY6jXBD0BRDJ8fz085ZhwWwq1V5IO0QEqUnL3pgTbP36ue7uRm3EoW
X-Received: by 2002:a1c:cc09:: with SMTP id h9mr97815wmb.1.1594658944757; Mon,
 13 Jul 2020 09:49:04 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:48:57 +0100
In-Reply-To: <20200713164857.1031117-1-lenaptr@google.com>
Message-Id: <20200713164857.1031117-2-lenaptr@google.com>
Mime-Version: 1.0
References: <20200713164857.1031117-1-lenaptr@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 1/1] crypto: af_alg - add extra parameters for DRBG interface
From:   Elena Petrova <lenaptr@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Elena Petrova <lenaptr@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
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
 Documentation/crypto/userspace-if.rst | 14 +++-
 crypto/af_alg.c                       |  8 +++
 crypto/algif_rng.c                    | 99 +++++++++++++++++++++++++--
 include/crypto/if_alg.h               |  3 +-
 include/uapi/linux/if_alg.h           |  1 +
 5 files changed, 115 insertions(+), 10 deletions(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index ff86befa61e0..9ee9e93e9207 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -296,15 +296,20 @@ follows:
 
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
+can be provided to the RNG via ALG_SET_DRBG_ENTROPY setsockopt interface.
+*Additional Data* can be provided using the send()/sendmsg() system calls.
 
 Using the read()/recvmsg() system calls, random numbers can be obtained.
 The kernel generates at most 128 bytes in one call. If user space
@@ -377,6 +382,9 @@ mentioned optname:
    provided ciphertext is assumed to contain an authentication tag of
    the given size (see section about AEAD memory layout below).
 
+-  ALG_SET_DRBG_ENTROPY -- Setting the entropy of the random number generator.
+   This option is applicable to RNG cipher type only.
+
 User space API example
 ----------------------
 
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
index 087c0ad09d38..c3d1667db367 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -53,8 +53,24 @@ struct rng_ctx {
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
+static void reset_addtl(struct rng_ctx *ctx)
+{
+	if (ctx->addtl) {
+		kzfree(ctx->addtl);
+		ctx->addtl = NULL;
+	}
+	ctx->addtl_len = 0;
+}
+
 static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		       int flags)
 {
@@ -82,16 +98,39 @@ static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
+	reset_addtl(ctx);
 
 	return err ? err : len;
 }
 
+static int rng_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+{
+	int err;
+	struct alg_sock *ask = alg_sk(sock->sk);
+	struct rng_ctx *ctx = ask->private;
+
+	reset_addtl(ctx);
+	ctx->addtl = kzalloc(len, GFP_KERNEL);
+	if (!ctx->addtl)
+		return -ENOMEM;
+
+	err = memcpy_from_msg(ctx->addtl, msg, len);
+	if (err) {
+		reset_addtl(ctx);
+		return err;
+	}
+	ctx->addtl_len = len;
+
+	return 0;
+}
+
 static struct proto_ops algif_rng_ops = {
 	.family		=	PF_ALG,
 
@@ -106,21 +145,40 @@ static struct proto_ops algif_rng_ops = {
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
+	void *err_ptr;
+
+	pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
+	if (!pctx)
+		return ERR_PTR(-ENOMEM);
+
+	pctx->drng = crypto_alloc_rng(name, type, mask);
+	if (!IS_ERR(pctx->drng))
+		return pctx;
+
+	err_ptr = pctx->drng;
+	kfree(pctx);
+	return err_ptr;
 }
 
 static void rng_release(void *private)
 {
-	crypto_free_rng(private);
+	struct rng_parent_ctx *pctx = private;
+	if (unlikely(!pctx))
+		return;
+	crypto_free_rng(pctx->drng);
+	if (pctx->entropy)
+		kzfree(pctx->entropy);
+	kzfree(pctx);
 }
 
 static void rng_sock_destruct(struct sock *sk)
@@ -128,6 +186,7 @@ static void rng_sock_destruct(struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct rng_ctx *ctx = ask->private;
 
+	reset_addtl(ctx);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
@@ -135,6 +194,7 @@ static void rng_sock_destruct(struct sock *sk)
 static int rng_accept_parent(void *private, struct sock *sk)
 {
 	struct rng_ctx *ctx;
+	struct rng_parent_ctx *pctx = private;
 	struct alg_sock *ask = alg_sk(sk);
 	unsigned int len = sizeof(*ctx);
 
@@ -150,7 +210,9 @@ static int rng_accept_parent(void *private, struct sock *sk)
 	 * state of the RNG.
 	 */
 
-	ctx->drng = private;
+	ctx->drng = pctx->drng;
+	ctx->addtl = NULL;
+	ctx->addtl_len = 0;
 	ask->private = ctx;
 	sk->sk_destruct = rng_sock_destruct;
 
@@ -159,11 +221,35 @@ static int rng_accept_parent(void *private, struct sock *sk)
 
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
+static int rng_setentropy(void *private, const u8 *entropy, unsigned int len)
+{
+	struct rng_parent_ctx *pctx = private;
+	u8 *kentropy = NULL;
+
+	if (pctx->entropy)
+		return -EINVAL;
+
+	if (entropy && len) {
+		kentropy = kzalloc(len, GFP_KERNEL);
+		if (!kentropy)
+			return -ENOMEM;
+		if (copy_from_user(kentropy, entropy, len)) {
+			kzfree(kentropy);
+			return -EFAULT;
+		}
+	}
+
+	crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
+	pctx->entropy = kentropy;
+	return 0;
 }
 
 static const struct af_alg_type algif_type_rng = {
@@ -171,6 +257,7 @@ static const struct af_alg_type algif_type_rng = {
 	.release	=	rng_release,
 	.accept		=	rng_accept_parent,
 	.setkey		=	rng_setkey,
+	.setentropy	=	rng_setentropy,
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
2.27.0.383.g050319c2ae-goog

