Received: from smtpcmd0642.aruba.it (smtpcmd0642.aruba.it [62.149.156.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF862E9EDD
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 08:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925834; cv=none; b=FEyBlEYFkuO3vd7fiVK4dnDiOd5Y807A2O3/YjLXhO1VtW+Z8jzrOYEo8bqJ24wX/UHfKIGJW5uarGZcXKwMrf3VIfQkSxuDVh65+NKBJcVcNp9SVmwCsSYTInLG3/IGRyNfMxg0CRxe8mcaDdEhHS86u2UGYiLLM4lV9Su3Ocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925834; c=relaxed/simple;
	bh=kPHAVRFDn+HWfpqa5jWSdph3f+qT7+WgKTFhuZxqdU0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kflhw5Snagx3OYZZLcRY1Ucc6Pgy6g1KQbeOu8OPPqhmk95FtNLAbOpyESPbIU6L2JF5hTaIt0AoMDF0qXGJr4L5fTnZ+21NBr2I+PokPN0FMHlrSeJ7tRFZrDCpNxB+z+flJKiAKVrfcoax/BrBrR/bRgvQ+ryHYy0aTK4gFl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com; spf=pass smtp.mailfrom=enneenne.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=IdrSGRrF; arc=none smtp.client-ip=62.149.156.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="IdrSGRrF"
Received: from polimar.homenet.telecomitalia.it ([79.0.204.227])
	by Aruba SMTP with ESMTPSA
	id y4lLumNEnL0Iyy4lNuiWik; Mon, 15 Sep 2025 10:40:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1757925642; bh=kPHAVRFDn+HWfpqa5jWSdph3f+qT7+WgKTFhuZxqdU0=;
	h=From:To:Subject:Date:MIME-Version;
	b=IdrSGRrFS/AUfULt5WsTPJP8Ya/KwzX79z89R+fr3x7uHy51P8wHvE9AyJhYo6D2f
	 3oAs76p8sPzfS/xST8n7KCNhkwNij7ImtdIHnll+hrZR1Jgjuk1ayTYCd89K8sOHmG
	 riZeyBUAm+Sy7z/+CrDn7ck5ExJ/IgGYA9nxzeu2R7zdruPeOFycn70YZfbCsH5fxl
	 LH6RoLmnTaIafHplpD/nnb8qH2i1PS3P9ZtI6m75jtD9RNGCSdvfWwNNNiex0D20C0
	 rsKVfx4xbE2r2TMxzI4wEpDpVByZVC9W8Oh1x8neuttFp39ghXKgReeNojOsIe489M
	 RsCrQNgduXA8A==
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [V1 4/4] crypto: add user-space interface for KPP algorithms
Date: Mon, 15 Sep 2025 10:40:39 +0200
Message-Id: <20250915084039.2848952-5-giometti@enneenne.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915084039.2848952-1-giometti@enneenne.com>
References: <20250915084039.2848952-1-giometti@enneenne.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfOfVGLuTUM4gotCP23FqkHfa03p93wKXKSkdcgEwisPrxKcA1UxC1mMcshpvCiUMzfV+hpwdoSaStxsG0uK/sGsZOPXelHzHwcTsWPIyZvAR7qZF7Ssn
 BVL2ETVDwdaYyz2sZQciR+8ZhibfDbC1+AvHL+dvCiHxtGMtXqfTA6yxj/wG+WneqQINedTfyZV6Hn8G2aymm7X2Sn6D/7Rk/h4MjFq/pcplH/O/kbyL+KXL
 8DxmhJ0Fz5deeAJUkBNm/evdxylswPaCyA32OmgsNZTZifHUNPczZbmAZ5uJSy9gk7531pFwnsMfb/BjR6qn4gggmj5F+sTYVEJ+7yzyk5A=

It adds a dedicated user interface for the Key-agreement Protocol
Primitive (KPP).

Now, from user applications, we can use the following specification
for AF_ALG sockets:

    struct sockaddr_alg sa = {
            .salg_family = AF_ALG,
            .salg_type = "kpp",
            .salg_name = "ecdh-nist-p256",
    };

Once the private key is set with ALG_SET_KEY or (better by)
ALG_SET_KEY_BY_KEY_SERIAL, the user program should write the peer's
public key to the socket and then receive its public key followed by
the shared secret calculated by the selected kernel algorithm.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 crypto/Kconfig     |   8 ++
 crypto/Makefile    |   1 +
 crypto/algif_kpp.c | 286 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 295 insertions(+)
 create mode 100644 crypto/algif_kpp.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 23bd98981ae8..367951444d20 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1412,6 +1412,14 @@ config CRYPTO_USER_API_AEAD
 	  See Documentation/crypto/userspace-if.rst and
 	  https://www.chronox.de/libkcapi/html/index.html
 
+config CRYPTO_USER_API_KPP
+	tristate "Key-agreement Protocol Primitive"
+	depends on NET
+	select CRYPTO_KPP
+	select CRYPTO_USER_API
+	help
+	  Enable the userspace interface for Key-agreement Protocol Primitive.
+
 config CRYPTO_USER_API_ENABLE_OBSOLETE
 	bool "Obsolete cryptographic algorithms"
 	depends on CRYPTO_USER_API
diff --git a/crypto/Makefile b/crypto/Makefile
index 6c5d59369dac..044d1f194342 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -179,6 +179,7 @@ obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
+obj-$(CONFIG_CRYPTO_USER_API_KPP) += algif_kpp.o
 obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
diff --git a/crypto/algif_kpp.c b/crypto/algif_kpp.c
new file mode 100644
index 000000000000..9cbb5589889c
--- /dev/null
+++ b/crypto/algif_kpp.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * algif_kpp: User-space interface for KPP algorithms
+ *
+ * This file provides the user-space API for Key-agreement Protocol Primitive
+ * (KPP).
+ *
+ * Copyright (C) 2025 Rodolfo Giometti <giometti@enneenne.com>
+ */
+
+#include <crypto/dh.h>
+#include <crypto/internal/kpp.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/if_alg.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/net.h>
+#include <net/sock.h>
+#include <crypto/ecdh.h>
+
+struct alg_kpp_ctx {
+	struct crypto_kpp *tfm;
+	void *peer_pubkey;
+	size_t peer_pubkey_len;
+};
+
+static int kpp_sendmsg(struct socket *sock, struct msghdr *msg, size_t ignored)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct alg_kpp_ctx *ctx = ask->private;
+	size_t pubkey_len, size;
+	int ret;
+
+	/* Check the user data for proper length */
+	pubkey_len = crypto_kpp_maxsize(ctx->tfm);
+	size = iov_iter_count(&msg->msg_iter);
+	if (pubkey_len == 0 || pubkey_len != size)
+		return -EINVAL;
+
+	/* Read the peer public key */
+	if (ctx->peer_pubkey_len > 0)
+		kfree(ctx->peer_pubkey);
+	ctx->peer_pubkey = kmalloc(pubkey_len, GFP_KERNEL);
+	if (!ctx->peer_pubkey)
+		return -ENOMEM;
+	ctx->peer_pubkey_len = pubkey_len;
+	ret = copy_from_iter(ctx->peer_pubkey, pubkey_len, &msg->msg_iter);
+	if (ret < 0) {
+		kfree(ctx->peer_pubkey);
+		ctx->peer_pubkey_len = 0;
+	}
+
+	return ret;
+}
+
+static int kpp_recvmsg(struct socket *sock, struct msghdr *msg,
+		       size_t ignored, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct alg_kpp_ctx *ctx = ask->private;
+	struct kpp_request *req;
+	size_t pubkey_len, size;
+	struct scatterlist sg_in, sg_out;
+	uint8_t *buf;
+	int ret;
+
+	pubkey_len = crypto_kpp_maxsize(ctx->tfm);
+	if (pubkey_len == 0)
+		return -EINVAL;
+
+	/* Check for the user buffer proper length */
+	size = iov_iter_count(&msg->msg_iter);
+	if (size < pubkey_len)
+		return -EINVAL;
+
+	buf = kmalloc(pubkey_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* Allocate request buffer */
+	req = kpp_request_alloc(ctx->tfm, GFP_KERNEL);
+	if (IS_ERR(req)) {
+		ret = PTR_ERR(req);
+		goto free_buf;
+	}
+
+	/* Generate our public key */
+	sg_init_one(&sg_out, buf, pubkey_len);
+	kpp_request_set_input(req, NULL, 0);
+	kpp_request_set_output(req, &sg_out, pubkey_len);
+	ret = crypto_kpp_generate_public_key(req);
+	if (ret)
+		goto free_req;
+
+	/* Compute the shared secret */
+	sg_init_one(&sg_in, ctx->peer_pubkey, ctx->peer_pubkey_len);
+	sg_init_one(&sg_out, buf, pubkey_len);
+	kpp_request_set_input(req, &sg_in, ctx->peer_pubkey_len);
+	kpp_request_set_output(req, &sg_out, pubkey_len);
+	ret = crypto_kpp_compute_shared_secret(req);
+	if (ret)
+		goto free_req;
+
+	/* Drop the current peer's key */
+	kfree(ctx->peer_pubkey);
+	ctx->peer_pubkey_len = 0;
+
+	/* Return the shared secret to user space */
+	ret = copy_to_iter(buf, pubkey_len, &msg->msg_iter);
+
+free_req:
+	kpp_request_free(req);
+free_buf:
+	kfree(buf);
+
+	return ret;
+}
+
+static struct proto_ops algif_kpp_ops = {
+	.family = PF_ALG,
+	.release = af_alg_release,
+	.sendmsg = kpp_sendmsg,
+	.recvmsg = kpp_recvmsg,
+};
+
+static int kpp_check_key(struct socket *sock)
+{
+	int err = 0;
+	struct sock *psk;
+	struct alg_sock *pask;
+	struct crypto_kpp *tfm;
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+
+	lock_sock(sk);
+	if (!atomic_read(&ask->nokey_refcnt))
+		goto unlock_child;
+
+	psk = ask->parent;
+	pask = alg_sk(psk);
+	tfm = pask->private;
+
+	err = -ENOKEY;
+	lock_sock_nested(psk, SINGLE_DEPTH_NESTING);
+	if (crypto_kpp_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		goto unlock;
+
+	atomic_dec(&pask->nokey_refcnt);
+	atomic_set(&ask->nokey_refcnt, 0);
+
+	err = 0;
+
+unlock:
+	release_sock(psk);
+unlock_child:
+	release_sock(sk);
+
+	return err;
+}
+
+static int kpp_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
+			     size_t size)
+{
+	int err;
+
+	err = kpp_check_key(sock);
+	if (err)
+		return err;
+
+	return kpp_sendmsg(sock, msg, size);
+}
+
+static int kpp_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
+			     size_t ignored, int flags)
+{
+	int err;
+
+	err = kpp_check_key(sock);
+	if (err)
+		return err;
+
+	return kpp_recvmsg(sock, msg, ignored, flags);
+}
+
+static struct proto_ops algif_kpp_ops_nokey = {
+	.family = PF_ALG,
+	.release = af_alg_release,
+	.sendmsg = kpp_sendmsg_nokey,
+	.recvmsg = kpp_recvmsg_nokey,
+};
+
+static void *kpp_bind(const char *name, u32 type, u32 mask)
+{
+	return crypto_alloc_kpp(name, type, mask);
+}
+
+static void kpp_release(void *private)
+{
+	crypto_free_kpp(private);
+}
+
+static int kpp_set_secret(void *private, const u8 *key, unsigned int keylen)
+{
+	return crypto_kpp_set_secret_raw(private, key, keylen);
+}
+
+static void kpp_sock_destruct_child(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct alg_kpp_ctx *ctx = ask->private;
+
+	if (ctx) {
+		if (ctx->peer_pubkey_len > 0)
+			kfree(ctx->peer_pubkey);
+		sock_kfree_s(sk, ctx, sizeof(*ctx));
+	}
+
+	af_alg_release_parent(sk);
+}
+
+static int kpp_accept_parent_nokey(void *private, struct sock *sk)
+{
+	struct alg_kpp_ctx *ctx;
+	struct alg_sock *ask = alg_sk(sk);
+	struct crypto_kpp *tfm = private;
+
+	ctx = sock_kmalloc(sk, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->tfm = tfm;
+	ctx->peer_pubkey = NULL;
+	ctx->peer_pubkey_len = 0;
+	ask->private = ctx;
+
+	sk->sk_destruct = kpp_sock_destruct_child;
+
+	return 0;
+}
+
+static int kpp_accept_parent(void *private, struct sock *sk)
+{
+	struct crypto_kpp *tfm = private;
+
+	if (crypto_kpp_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
+	return kpp_accept_parent_nokey(private, sk);
+}
+
+static const struct af_alg_type algif_type_kpp = {
+	.bind = kpp_bind,
+	.release = kpp_release,
+	.setkey = kpp_set_secret,
+	.accept = kpp_accept_parent,
+	.accept_nokey = kpp_accept_parent_nokey,
+
+	.ops = &algif_kpp_ops,
+	.ops_nokey = &algif_kpp_ops_nokey,
+
+	.name = "kpp",
+	.owner = THIS_MODULE
+};
+
+static int __init algif_kpp_init(void)
+{
+	return af_alg_register_type(&algif_type_kpp);
+}
+
+static void __exit algif_kpp_exit(void)
+{
+	int err = af_alg_unregister_type(&algif_type_kpp);
+
+	WARN_ON_ONCE(err);
+}
+
+module_init(algif_kpp_init);
+module_exit(algif_kpp_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rodolfo Giometti <giometti@enneenne.com>");
+MODULE_DESCRIPTION("KPP kernel crypto API user space interface");
-- 
2.34.1

