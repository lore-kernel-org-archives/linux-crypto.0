From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] Add RNG support to AF_ALG
Date: Mon, 13 Dec 2010 12:11:57 -0500
Message-ID: <1292260317-2684-1-git-send-email-nhorman@tuxdriver.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59302 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab0LMRM0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Dec 2010 12:12:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch enhances the AF_ALG protocol family to include support for random
number generator algorithms.  With this enhancment, users of the AF_ALG protocol
can now bind sockets to instances of the various RNG algorithms available to the
kernel.  For those RNG's that support it, instances can be reseeded using the
SETKEY socket option within the AF_ALG socket family.  Like with hashes and
ciphers, only the intially created socket allows seeding, and only child sockets
retured via accept may return random data.  Sending data on RNG instances is
prohibited, only receiving RNG data is possible.

Tested successfully using NIST provided RNG vectors by myself:
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
---
 crypto/Kconfig     |    9 +++
 crypto/Makefile    |    1 +
 crypto/algif_rng.c |  197 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 207 insertions(+), 0 deletions(-)
 create mode 100644 crypto/algif_rng.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 96b0e55..ea448ca 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -864,6 +864,15 @@ config CRYPTO_USER_API_SKCIPHER
 	  This option enables the user-spaces interface for symmetric
 	  key cipher algorithms.
 
+config CRYPTO_USER_API_RNG
+	tristate "User-space interface for Random Number Generator algorithms"
+	depends on NET
+	select CRYPTO_ANSI_CPRNG
+	select CRYPTO_USER_API
+	help
+	  This option enables the user-space interface for random number
+	  generation algorithms.
+
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
diff --git a/crypto/Makefile b/crypto/Makefile
index e9a399c..8868555 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -88,6 +88,7 @@ obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
+obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 
 #
 # generic algorithms and the async_tx api
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
new file mode 100644
index 0000000..b660a2a
--- /dev/null
+++ b/crypto/algif_rng.c
@@ -0,0 +1,197 @@
+/*
+ * algif_rng: User-space interface for rng algorithms
+ *
+ * This file provides the user-space API for rng algorithms.
+ *
+ * Copyright (c) 2010 Neil Horman <nhorman@tuxdriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#include <crypto/rng.h>
+#include <crypto/if_alg.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/net.h>
+#include <net/sock.h>
+
+struct rng_ctx {
+	struct crypto_rng *ctx;
+	u8 *seed;
+	size_t seedlen;
+	char *name;
+	u32 type;
+	u32 mask;
+};
+
+static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
+			struct msghdr *msg, size_t len, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct rng_ctx *ctx = ask->private;
+	int rc, i;
+	u8 *data = kzalloc(len, GFP_KERNEL);
+
+	if (!data)
+		return -ENOMEM;
+	rc = crypto_rng_get_bytes(ctx->ctx, data, len);
+	if (rc < 0)
+		goto out;
+
+	rc = memcpy_toiovec(msg->msg_iov, data, len);
+out:
+	kfree(data);
+	return rc ?: len;
+}
+
+
+static const struct proto_ops algif_rng_ops = {
+	.family		=	PF_ALG,
+
+	.connect	=	sock_no_connect,
+	.socketpair	=	sock_no_socketpair,
+	.getname	=	sock_no_getname,
+	.ioctl		=	sock_no_ioctl,
+	.listen		=	sock_no_listen,
+	.shutdown	=	sock_no_shutdown,
+	.getsockopt	=	sock_no_getsockopt,
+	.mmap		=	sock_no_mmap,
+	.bind		=	sock_no_bind,
+	.setsockopt	=	sock_no_setsockopt,
+	.poll		=	sock_no_poll,
+
+	.release	=	af_alg_release,
+	.sendmsg	=	sock_no_sendmsg,
+	.sendpage	=	sock_no_sendpage,
+	.recvmsg	=	rng_recvmsg,
+	.accept		=	sock_no_accept,
+};
+
+static void *rng_bind(const char *name, u32 type, u32 mask)
+{
+	struct rng_ctx *new = kzalloc(sizeof(struct rng_ctx), GFP_KERNEL);
+
+	if (!new)
+		goto out;
+
+	new->name = kmemdup(name, strnlen(name, 63)+1, GFP_KERNEL);
+	new->type = type;
+	new->mask = mask;
+out:
+	return new;
+}
+
+static void rng_release(void *private)
+{
+	struct rng_ctx *ctx = private;
+	crypto_free_rng(ctx->ctx);
+	kfree(ctx->seed);
+	kfree(ctx->name);
+	kfree(ctx);
+}
+
+static int rng_setkey(void *private, const u8 *key, unsigned int keylen)
+{
+	struct rng_ctx *ctx = private;
+	u8 *oldseed = ctx->seed;
+
+	ctx->seed = kmemdup(key, keylen, GFP_KERNEL);
+
+	if (!ctx->seed)
+		return -ENOMEM;
+
+	kfree(oldseed);
+	ctx->seedlen = keylen;
+
+	return 0;
+}
+
+static void rng_sock_destruct(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct rng_ctx *ctx = ask->private;
+
+	crypto_free_rng(ctx->ctx);
+	kfree(ctx->seed);
+	sock_kfree_s(sk, ctx, sizeof(struct rng_ctx));
+	af_alg_release_parent(sk);
+}
+
+static int rng_accept_parent(void *private, struct sock *sk)
+{
+	struct rng_ctx *parent = private;
+	struct rng_ctx *child;
+	struct alg_sock *ask = alg_sk(sk);
+	int rc = -EINVAL;
+
+	if (!parent->seed)
+		goto out;
+
+	rc = -ENOMEM;
+	child = sock_kmalloc(sk, sizeof(struct rng_ctx), GFP_KERNEL);
+
+	if (!child)
+		goto out;
+
+	rc = -ENOENT;
+	child->ctx = crypto_alloc_rng(parent->name,
+				      parent->type, parent->mask);
+	if (IS_ERR(child->ctx))
+		goto out_child;
+	child->seed = kmemdup(parent->seed, parent->seedlen, GFP_KERNEL);
+	if (!child->seed)
+		goto out_ctx;
+
+	child->seedlen = parent->seedlen;
+
+	rc = -EBUSY;
+	if (crypto_rng_reset(child->ctx, child->seed, child->seedlen))
+		goto out_seed;
+
+	ask->private = child;
+
+	sk->sk_destruct = rng_sock_destruct;
+
+
+	return 0;
+
+out_seed:
+	kfree(child->seed);
+out_ctx:
+	crypto_free_rng(child->ctx);
+out_child:
+	kfree(child);
+out:
+	return rc;
+}
+
+static const struct af_alg_type algif_type_rng = {
+	.bind		=	rng_bind,
+	.release	=	rng_release,
+	.setkey		=	rng_setkey,
+	.accept		=	rng_accept_parent,
+	.ops		=	&algif_rng_ops,
+	.name		=	"rng",
+	.owner		=	THIS_MODULE
+};
+
+static int __init algif_rng_init(void)
+{
+	return af_alg_register_type(&algif_type_rng);
+}
+
+static void __exit algif_rng_exit(void)
+{
+	int err = af_alg_unregister_type(&algif_type_rng);
+	BUG_ON(err);
+}
+
+module_init(algif_rng_init);
+module_exit(algif_rng_exit);
+MODULE_LICENSE("GPL");
-- 
1.7.2.3
