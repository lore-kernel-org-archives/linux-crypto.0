Return-Path: <SRS0=zaW3=BX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-25.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C28C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 16:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D63242078D
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 16:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kVhB0DfL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHMQIV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Aug 2020 12:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQIT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Aug 2020 12:08:19 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C77C061757
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2020 09:08:18 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id q12so4243449qvm.19
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2020 09:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=Lw8IvQkOFa2r4p8V2RYvTQ1gZ++ypLhDx+AOFurpr5o=;
        b=kVhB0DfLdD3CI2SxfYoA1ha1+7D0st5tfriOS4rxiE4sJ1jo/krjybwyYd3XfeagFK
         3QP04y1ayQrSBqPSujFHwbJ6C5i4hifRx5C+VjVd72I0I+qfFj9X/v6cFZdmtxkipmrC
         PnWR+XOkXzM1vX77WbcMA4HD9d0mBQyiQlv1MOjMCx6nWIBiOY5ClkPCARzU1Dq+ifT0
         Yrz9hAkA7Acvt1j7kor7vozfjZCHjcMK+5VvVBl0k8ZlWUVOGEGSxAWdknZfMuUaI/aV
         69C2wmlR0Z69VlUXPRJz/cW+pck1g+QMRAYgfLkCahi8R4aKZ+N2i5sA96NvDew7Ljoa
         gtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=Lw8IvQkOFa2r4p8V2RYvTQ1gZ++ypLhDx+AOFurpr5o=;
        b=TsxC0k0gP6/ovgl23rlI/iHjRs0UNaYwhwuR8gVX0TkMgkj5dcqrUSzGNiXsvfV4ks
         +x5igBV3yEAMJvqez6+mEhHyxvra6TuQxWKnHYmuMMcC9ldrKbss+I4oyKmTGlzUvIjn
         pmS/fIvMBWbaew4q010Nixzj77Yo5MdywBT2maonPLmN43IlgC2ZGfcScKcE/dRoztbM
         1N591oeNY3GfcmkAOEeb0YmMV62nIyZyn6vAIARC1xDDpoEyRldpHLukCZbUm9MkcZuG
         jSNk4E255sEg4VdiScCcnxwcVMgVPR0hMoBILIY0tI7LXcp1u3/GbY027cVm3UXsxFWH
         HLiQ==
X-Gm-Message-State: AOAM533fkG2n/CVQpNd/nKI2Ew/T4nvhl4V+/dvvJqxjKFe4vcC5ujjH
        /uyNJk1GVSfirOO/SkHz/xHiPhvpirfIVrgzEpVPNy/5RjftEGD15XkrZgXNfaXB7zy9VODJOYK
        Q9HEaHjkGUp9D6gX/hHtn1DvuS0bS09tdFOVshbRLQCmNfnM51cMdkb/ynxF9QGzCMXaOqxZS
X-Google-Smtp-Source: ABdhPJw5qUzTW2jhimxvzNreeuT4pM7EXySBlfUSpHpX0ae3SYT0WNsNBNUfpiO/GJRDbGa+MAd/7h5XdLVN
X-Received: by 2002:a0c:f607:: with SMTP id r7mr5403958qvm.219.1597334897566;
 Thu, 13 Aug 2020 09:08:17 -0700 (PDT)
Date:   Thu, 13 Aug 2020 17:08:11 +0100
In-Reply-To: <CABvBcwYPXvK1_b2hR5THaqfq8nKVwppdBd2aJF6cmS_aCxHxUg@mail.gmail.com>
Message-Id: <20200813160811.3568494-1-lenaptr@google.com>
Mime-Version: 1.0
References: <CABvBcwYPXvK1_b2hR5THaqfq8nKVwppdBd2aJF6cmS_aCxHxUg@mail.gmail.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v5] crypto: af_alg - add extra parameters for DRBG interface
From:   Elena Petrova <lenaptr@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Elena Petrova <lenaptr@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "=?UTF-8?q?Stephan=20M=C3=BCller?=" <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend the user-space RNG interface:
  1. Add entropy input via ALG_SET_DRBG_ENTROPY setsockopt option;
  2. Add additional data input via sendmsg syscall.

This allows DRBG to be tested with test vectors, for example for the
purpose of CAVP testing, which otherwise isn't possible.

To prevent erroneous use of entropy input, it is hidden under
CRYPTO_USER_API_CAVP_DRBG config option and requires CAP_SYS_ADMIN to
succeed.

Signed-off-by: Elena Petrova <lenaptr@google.com>
Acked-by: Stephan M=C3=BCller <smueller@chronox.de>
---

Updates in v5:
  1) use __maybe_unused instead of #ifdef;
  2) separate code path for a testing mode;
  3) only allow Additional Data input in a testing mode.

Updates in v4:
  1) setentropy returns 0 or error code (used to return length);
  2) bigfixes suggested by Eric.

Updates in v3:
  1) More details in commit message;
  2) config option name is now CRYPTO_USER_API_CAVP_DRBG;
  3) fixed a bug of not releasing socket locks.

Updates in v2:
  1) Adding CONFIG_CRYPTO_CAVS_DRBG around setentropy.
  2) Requiring CAP_SYS_ADMIN for entropy reset.
  3) Locking for send and recv.
  4) Length checks added for send and setentropy; send and setentropy now r=
eturn
     number of bytes accepted.
  5) Minor code style corrections.

libkcapi patch for testing:
  https://github.com/Len0k/libkcapi/commit/6f095d270b982008f419078614c15caa=
592cb531

 Documentation/crypto/userspace-if.rst |  17 ++-
 crypto/Kconfig                        |   9 ++
 crypto/af_alg.c                       |   8 ++
 crypto/algif_rng.c                    | 172 ++++++++++++++++++++++++--
 include/crypto/if_alg.h               |   1 +
 include/uapi/linux/if_alg.h           |   1 +
 6 files changed, 193 insertions(+), 15 deletions(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/u=
serspace-if.rst
index ff86befa61e0..ef7132802c2d 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -296,15 +296,23 @@ follows:
=20
     struct sockaddr_alg sa =3D {
         .salg_family =3D AF_ALG,
-        .salg_type =3D "rng", /* this selects the symmetric cipher */
-        .salg_name =3D "drbg_nopr_sha256" /* this is the cipher name */
+        .salg_type =3D "rng", /* this selects the random number generator =
*/
+        .salg_name =3D "drbg_nopr_sha256" /* this is the RNG name */
     };
=20
=20
 Depending on the RNG type, the RNG must be seeded. The seed is provided
 using the setsockopt interface to set the key. For example, the
 ansi_cprng requires a seed. The DRBGs do not require a seed, but may be
-seeded.
+seeded. The seed is also known as a *Personalization String* in DRBG800-90=
A
+standard.
+
+For the purpose of CAVP testing, the concatenation of *Entropy* and *Nonce=
*
+can be provided to the RNG via ALG_SET_DRBG_ENTROPY setsockopt interface. =
This
+requires a kernel built with CONFIG_CRYPTO_USER_API_CAVP_DRBG, and
+CAP_SYS_ADMIN permission.
+
+*Additional Data* can be provided using the send()/sendmsg() system calls.
=20
 Using the read()/recvmsg() system calls, random numbers can be obtained.
 The kernel generates at most 128 bytes in one call. If user space
@@ -377,6 +385,9 @@ mentioned optname:
    provided ciphertext is assumed to contain an authentication tag of
    the given size (see section about AEAD memory layout below).
=20
+-  ALG_SET_DRBG_ENTROPY -- Setting the entropy of the random number genera=
tor.
+   This option is applicable to RNG cipher type only.
+
 User space API example
 ----------------------
=20
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 091c0a0bbf26..7c8736f71681 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1896,6 +1896,15 @@ config CRYPTO_STATS
 config CRYPTO_HASH_INFO
 	bool
=20
+config CRYPTO_USER_API_CAVP_DRBG
+	tristate "Enable CAVP testing of DRBG"
+	depends on CRYPTO_USER_API_RNG && CRYPTO_DRBG
+	help
+	  This option enables extra API for CAVP testing via the user-space
+	  interface: resetting of DRBG entropy, and providing Additional Data.
+	  This should only be enabled for CAVP testing. You should say
+	  no unless you know what this is.
+
 source "lib/crypto/Kconfig"
 source "drivers/crypto/Kconfig"
 source "crypto/asymmetric_keys/Kconfig"
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index b1cd3535c525..27d6248ca447 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -260,6 +260,14 @@ static int alg_setsockopt(struct socket *sock, int lev=
el, int optname,
 		if (!type->setauthsize)
 			goto unlock;
 		err =3D type->setauthsize(ask->private, optlen);
+		break;
+	case ALG_SET_DRBG_ENTROPY:
+		if (sock->state =3D=3D SS_CONNECTED)
+			goto unlock;
+		if (!type->setentropy)
+			goto unlock;
+
+		err =3D type->setentropy(ask->private, optval, optlen);
 	}
=20
 unlock:
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 087c0ad09d38..6ec78c444206 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -38,6 +38,7 @@
  * DAMAGE.
  */
=20
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <crypto/rng.h>
 #include <linux/random.h>
@@ -53,15 +54,26 @@ struct rng_ctx {
 #define MAXSIZE 128
 	unsigned int len;
 	struct crypto_rng *drng;
+	u8 *addtl;
+	size_t addtl_len;
 };
=20
-static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len=
,
-		       int flags)
+struct rng_parent_ctx {
+	struct crypto_rng *drng;
+	u8 *entropy;
+};
+
+static void rng_reset_addtl(struct rng_ctx *ctx)
 {
-	struct sock *sk =3D sock->sk;
-	struct alg_sock *ask =3D alg_sk(sk);
-	struct rng_ctx *ctx =3D ask->private;
-	int err;
+	kzfree(ctx->addtl);
+	ctx->addtl =3D NULL;
+	ctx->addtl_len =3D 0;
+}
+
+static int _rng_recvmsg(struct crypto_rng *drng, struct msghdr *msg, size_=
t len,
+			u8 *addtl, size_t addtl_len)
+{
+	int err =3D 0;
 	int genlen =3D 0;
 	u8 result[MAXSIZE];
=20
@@ -82,7 +94,7 @@ static int rng_recvmsg(struct socket *sock, struct msghdr=
 *msg, size_t len,
 	 * seeding as they automatically seed. The X9.31 DRNG will return
 	 * an error if it was not seeded properly.
 	 */
-	genlen =3D crypto_rng_get_bytes(ctx->drng, result, len);
+	genlen =3D crypto_rng_generate(drng, addtl, addtl_len, result, len);
 	if (genlen < 0)
 		return genlen;
=20
@@ -92,7 +104,62 @@ static int rng_recvmsg(struct socket *sock, struct msgh=
dr *msg, size_t len,
 	return err ? err : len;
 }
=20
-static struct proto_ops algif_rng_ops =3D {
+static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len=
,
+		       int flags)
+{
+	struct sock *sk =3D sock->sk;
+	struct alg_sock *ask =3D alg_sk(sk);
+	struct rng_ctx *ctx =3D ask->private;
+
+	return _rng_recvmsg(ctx->drng, msg, len, NULL, 0);
+}
+
+static int rng_test_recvmsg(struct socket *sock, struct msghdr *msg, size_=
t len,
+			    int flags)
+{
+	struct sock *sk =3D sock->sk;
+	struct alg_sock *ask =3D alg_sk(sk);
+	struct rng_ctx *ctx =3D ask->private;
+	int err;
+
+	lock_sock(sock->sk);
+	err =3D _rng_recvmsg(ctx->drng, msg, len, ctx->addtl, ctx->addtl_len);
+	rng_reset_addtl(ctx);
+	release_sock(sock->sk);
+
+	return err ? err : len;
+}
+
+static int rng_test_sendmsg(struct socket *sock, struct msghdr *msg, size_=
t len)
+{
+	int err;
+	struct alg_sock *ask =3D alg_sk(sock->sk);
+	struct rng_ctx *ctx =3D ask->private;
+
+	lock_sock(sock->sk);
+	if (len > MAXSIZE)
+		len =3D MAXSIZE;
+
+	rng_reset_addtl(ctx);
+	ctx->addtl =3D kmalloc(len, GFP_KERNEL);
+	if (!ctx->addtl) {
+		err =3D -ENOMEM;
+		goto unlock;
+	}
+
+	err =3D memcpy_from_msg(ctx->addtl, msg, len);
+	if (err) {
+		rng_reset_addtl(ctx);
+		goto unlock;
+	}
+	ctx->addtl_len =3D len;
+
+unlock:
+	release_sock(sock->sk);
+	return err ? err : len;
+}
+
+static struct proto_ops __maybe_unused algif_rng_ops =3D {
 	.family		=3D	PF_ALG,
=20
 	.connect	=3D	sock_no_connect,
@@ -113,14 +180,55 @@ static struct proto_ops algif_rng_ops =3D {
 	.recvmsg	=3D	rng_recvmsg,
 };
=20
+static struct proto_ops __maybe_unused algif_rng_test_ops =3D {
+	.family		=3D	PF_ALG,
+
+	.connect	=3D	sock_no_connect,
+	.socketpair	=3D	sock_no_socketpair,
+	.getname	=3D	sock_no_getname,
+	.ioctl		=3D	sock_no_ioctl,
+	.listen		=3D	sock_no_listen,
+	.shutdown	=3D	sock_no_shutdown,
+	.getsockopt	=3D	sock_no_getsockopt,
+	.mmap		=3D	sock_no_mmap,
+	.bind		=3D	sock_no_bind,
+	.accept		=3D	sock_no_accept,
+	.setsockopt	=3D	sock_no_setsockopt,
+	.sendpage	=3D	sock_no_sendpage,
+
+	.release	=3D	af_alg_release,
+	.recvmsg	=3D	rng_test_recvmsg,
+	.sendmsg	=3D	rng_test_sendmsg,
+};
+
 static void *rng_bind(const char *name, u32 type, u32 mask)
 {
-	return crypto_alloc_rng(name, type, mask);
+	struct rng_parent_ctx *pctx;
+	struct crypto_rng *rng;
+
+	pctx =3D kzalloc(sizeof(*pctx), GFP_KERNEL);
+	if (!pctx)
+		return ERR_PTR(-ENOMEM);
+
+	rng =3D crypto_alloc_rng(name, type, mask);
+	if (IS_ERR(rng)) {
+		kfree(pctx);
+		return ERR_CAST(rng);
+	}
+
+	pctx->drng =3D rng;
+	return pctx;
 }
=20
 static void rng_release(void *private)
 {
-	crypto_free_rng(private);
+	struct rng_parent_ctx *pctx =3D private;
+
+	if (unlikely(!pctx))
+		return;
+	crypto_free_rng(pctx->drng);
+	kzfree(pctx->entropy);
+	kzfree(pctx);
 }
=20
 static void rng_sock_destruct(struct sock *sk)
@@ -128,6 +236,7 @@ static void rng_sock_destruct(struct sock *sk)
 	struct alg_sock *ask =3D alg_sk(sk);
 	struct rng_ctx *ctx =3D ask->private;
=20
+	rng_reset_addtl(ctx);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
 }
@@ -135,6 +244,7 @@ static void rng_sock_destruct(struct sock *sk)
 static int rng_accept_parent(void *private, struct sock *sk)
 {
 	struct rng_ctx *ctx;
+	struct rng_parent_ctx *pctx =3D private;
 	struct alg_sock *ask =3D alg_sk(sk);
 	unsigned int len =3D sizeof(*ctx);
=20
@@ -143,6 +253,8 @@ static int rng_accept_parent(void *private, struct sock=
 *sk)
 		return -ENOMEM;
=20
 	ctx->len =3D len;
+	ctx->addtl =3D NULL;
+	ctx->addtl_len =3D 0;
=20
 	/*
 	 * No seeding done at that point -- if multiple accepts are
@@ -150,7 +262,7 @@ static int rng_accept_parent(void *private, struct sock=
 *sk)
 	 * state of the RNG.
 	 */
=20
-	ctx->drng =3D private;
+	ctx->drng =3D pctx->drng;
 	ask->private =3D ctx;
 	sk->sk_destruct =3D rng_sock_destruct;
=20
@@ -159,11 +271,42 @@ static int rng_accept_parent(void *private, struct so=
ck *sk)
=20
 static int rng_setkey(void *private, const u8 *seed, unsigned int seedlen)
 {
+	struct rng_parent_ctx *pctx =3D private;
 	/*
 	 * Check whether seedlen is of sufficient size is done in RNG
 	 * implementations.
 	 */
-	return crypto_rng_reset(private, seed, seedlen);
+	return crypto_rng_reset(pctx->drng, seed, seedlen);
+}
+
+static int __maybe_unused rng_setentropy(void *private, const u8 *entropy,
+					 unsigned int len)
+{
+	struct rng_parent_ctx *pctx =3D private;
+	u8 *kentropy =3D NULL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (pctx->entropy)
+		return -EINVAL;
+
+	if (len > MAXSIZE)
+		return -EMSGSIZE;
+
+	if (len) {
+		kentropy =3D memdup_user(entropy, len);
+		if (IS_ERR(kentropy))
+			return PTR_ERR(kentropy);
+	}
+
+	crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
+	/*
+	 * Since rng doesn't perform any memory management for the entropy
+	 * buffer, save kentropy pointer to pctx now to free it after use.
+	 */
+	pctx->entropy =3D kentropy;
+	return 0;
 }
=20
 static const struct af_alg_type algif_type_rng =3D {
@@ -171,7 +314,12 @@ static const struct af_alg_type algif_type_rng =3D {
 	.release	=3D	rng_release,
 	.accept		=3D	rng_accept_parent,
 	.setkey		=3D	rng_setkey,
+#if IS_ENABLED(CONFIG_CRYPTO_USER_API_CAVP_DRBG)
+	.setentropy	=3D	rng_setentropy,
+	.ops		=3D	&algif_rng_test_ops,
+#else
 	.ops		=3D	&algif_rng_ops,
+#endif
 	.name		=3D	"rng",
 	.owner		=3D	THIS_MODULE
 };
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 56527c85d122..9e5c8ac53c59 100644
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
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index bc2bcdec377b..60b7c2efd921 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -35,6 +35,7 @@ struct af_alg_iv {
 #define ALG_SET_OP			3
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
+#define ALG_SET_DRBG_ENTROPY		6
=20
 /* Operations */
 #define ALG_OP_DECRYPT			0
--=20
2.28.0.220.ged08abb693-goog

