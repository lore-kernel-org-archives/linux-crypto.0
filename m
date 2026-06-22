Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B75372060;
	Mon, 22 Jun 2026 23:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782172171; cv=none; b=F6H7nBu8aVlV9JTAF2BInVbx8fpq3qvL4Bn5+P9kXHQmFRSwzf5DIlFJHh4clZ6YTCexIJ09IvbIZx55tF25PSynBar8CIt0YOdmCSH+wjdbWJwuyZWDVKm/KoyZFYOxD1guguss6m5eEmom6n4GG85ehHBqVmsdBkxtG3izKcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782172171; c=relaxed/simple;
	bh=wd0gTLpR8RKsLIpM3mnVB2HRTMXrkaQhXX/lCgl23vU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PUiqMJ1vINC3+oohD/NnLiUi6pqVjALqkOumGbvoFvAvVblyhiH59iudLdhHKvBDtmiwP8kSLqrYSK/DPzadJujoS04TOu7aDNLDYI/Dn25UfkFo/R6x2PtCRFve/n5GNIXaNgCor1mDyetowAtGETMfWdox9JmcpCnhHPlNBRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2b+5zzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2b+5zzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2C61F000E9;
	Mon, 22 Jun 2026 23:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782172169;
	bh=GnZLvcRVW7DH0YWGgniiJVL49Hc0ztZntmG9UfEVV3U=;
	h=From:To:Cc:Subject:Date;
	b=D2b+5zzAAcoJ8fp/vIfzdieTrZimtoHDeMeE9CvCIt/q+9LdtsUXTeFHuhnuLTTYj
	 PYbFcRjIQcjqSvpXRmIL8B/Q/VmUe/34Am/iWGBVrVRwml9HUF1Wa1y1EdTsmGJpfb
	 lvMbBA5dlQuZK37ORC3CVfEZrI5H3pJGt3Bgu/vWO3+QO59WsPwhIvrik/1LQ/sjKn
	 VpwLUYmpbWsfuO6zisM0V1Av3BA8G9T8NgnvN60AG5Sr7IQyGQSFFSY/Pn/CxEK68y
	 rsMqYPILQVBgMnrhAGphHIBmqdQeFvxPjH9L0qVpnXNsRu9/uI8o+Dw+wU9SRQlbxv
	 ZQPT+zmLrAIAQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Milan Broz <gmazyland@gmail.com>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1
Date: Mon, 22 Jun 2026 16:48:03 -0700
Message-ID: <20260622234803.6982-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AF_ALG is a frequent source of vulnerabilities and a maintenance
nightmare.  It exposes far more functionality to userspace than ever
should have been exposed, especially to unprivileged processes.  Recent
exploits have targeted kernel internal implementation details like
"authencesn" that have zero use case for userspace access.

Fortunately, AF_ALG is rarely used in practice, as userspace crypto
libraries exist.  And when it is used, only some functionality is known
to be used, and many users are known to hold capabilities already.
iwd for example requires CAP_NET_ADMIN and has a known algorithm list
(https://lore.kernel.org/linux-crypto/bcbbef00-5881-421b-8892-7be6c04b832d@gmail.com/).

Thus, let's restrict the set of allowed algorithms by default, depending
on the capabilities held.

Add a sysctl /proc/sys/crypto/af_alg_restrict with meaning:

    0: unrestricted
    1: limited functionality
    2: completely disabled

Set the default value to 1, which enables an algorithm allowlist for
unprivileged processes and a slightly longer allowlist for privileged
processes.

Note that the list may be tweaked in the future.  However, the common
use cases such as iwd and bluez are taken into account already.  I've
tested that iwd still works with the default value of 1.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/admin-guide/sysctl/crypto.rst | 36 +++++++++++
 Documentation/crypto/userspace-if.rst       | 13 +++-
 crypto/af_alg.c                             | 72 +++++++++++++++++++--
 crypto/algif_aead.c                         | 11 ++++
 crypto/algif_hash.c                         | 24 +++++++
 crypto/algif_rng.c                          |  9 +++
 crypto/algif_skcipher.c                     | 20 ++++++
 include/crypto/if_alg.h                     |  8 +++
 8 files changed, 184 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/crypto.rst b/Documentation/admin-guide/sysctl/crypto.rst
index b707bd314a64..9a1bd53287f4 100644
--- a/Documentation/admin-guide/sysctl/crypto.rst
+++ b/Documentation/admin-guide/sysctl/crypto.rst
@@ -5,10 +5,46 @@
 These files show up in ``/proc/sys/crypto/``, depending on the
 kernel configuration:
 
 .. contents:: :local:
 
+.. _af_alg_restrict:
+
+af_alg_restrict
+===============
+
+Controls the level of restriction of AF_ALG.
+
+AF_ALG is a deprecated and rarely-used userspace interface that is a
+frequent source of vulnerabilities. It also unnecessarily exposes a
+large number of kernel implementation details. For more information
+about AF_ALG, see :ref:`Documentation/crypto/userspace-if.rst
+<crypto_userspace_interface>`.
+
+Starting in Linux v7.3, AF_ALG supports only a limited set of
+algorithms by default. This sysctl allows the system administrator to
+remove this restriction when needed for compatibility reasons, or to
+go further and disable AF_ALG entirely. The default value is 1.
+
+===  ==================================================================
+0    AF_ALG is unrestricted.
+
+1    AF_ALG is supported with a limited list of algorithms. The list
+     is designed for compatibility with known users such as iwd and
+     bluez that haven't yet been fixed to use userspace crypto code.
+
+     Specifically, there is an allowlist for unprivileged processes
+     and a somewhat longer allowlist for processes that hold
+     CAP_SYS_ADMIN or CAP_NET_ADMIN in the initial user namespace.
+
+     Attempts to bind() an AF_ALG socket with a disallowed algorithm
+     fail with ENOENT.
+
+2    AF_ALG is completely disabled. Attempts to create an AF_ALG
+     socket fail with EAFNOSUPPORT.
+===  ==================================================================
+
 fips_enabled
 ============
 
 Read-only flag that indicates whether FIPS mode is enabled.
 
diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index ab93300c8e04..d6194346e366 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -1,5 +1,7 @@
+.. _crypto_userspace_interface:
+
 User Space Interface
 ====================
 
 Introduction
 ------------
@@ -10,13 +12,18 @@ code.
 
 AF_ALG is insecure and is deprecated. Originally added to the kernel in 2010,
 most kernel developers now consider it to be a mistake. Support for hardware
 accelerators, which was the original purpose of AF_ALG, has been removed.
 
-AF_ALG continues to be supported only for backwards compatibility. On systems
-where no programs using AF_ALG remain, the support for it should be disabled by
-disabling ``CONFIG_CRYPTO_USER_API_*``.
+AF_ALG continues to be supported only for backwards compatibility.
+
+Starting in Linux v7.3, the set of algorithms supported by AF_ALG is limited by
+default. See :ref:`/proc/sys/crypto/af_alg_restrict <af_alg_restrict>`.
+
+On systems where no programs using AF_ALG remain, the support for it should be
+disabled entirely by setting ``/proc/sys/crypto/af_alg_restrict`` to 2 or by
+disabling ``CONFIG_CRYPTO_USER_API_*`` in the kernel configuration.
 
 Deprecation
 -----------
 
 AF_ALG was originally intended to provide userspace programs access to crypto
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index cce000e8590e..34b801568fba 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -6,10 +6,11 @@
  *
  * Copyright (c) 2010 Herbert Xu <herbert@gondor.apana.org.au>
  */
 
 #include <linux/atomic.h>
+#include <linux/capability.h>
 #include <crypto/if_alg.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/key.h>
@@ -20,14 +21,32 @@
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/security.h>
 #include <linux/string.h>
+#include <linux/sysctl.h>
+#include <linux/user_namespace.h>
 #include <keys/user-type.h>
 #include <keys/trusted-type.h>
 #include <keys/encrypted-type.h>
 
+static int af_alg_restrict = 1;
+
+static const struct ctl_table af_alg_table[] = {
+	{
+		.procname       = "af_alg_restrict",
+		.data           = &af_alg_restrict,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
+};
+
+static struct ctl_table_header *af_alg_header;
+
 struct alg_type_list {
 	const struct af_alg_type *type;
 	struct list_head list;
 };
 
@@ -108,10 +127,43 @@ int af_alg_unregister_type(const struct af_alg_type *type)
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(af_alg_unregister_type);
 
+static bool af_alg_capable(void)
+{
+	return ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN) ||
+	       capable(CAP_SYS_ADMIN);
+}
+
+int af_alg_check_restriction(const char *name,
+			     const struct af_alg_allowlist_entry allowlist[])
+{
+	int level = READ_ONCE(af_alg_restrict);
+
+	if (level == 0)
+		return 0;
+	if (level == 1) {
+		for (const struct af_alg_allowlist_entry *ent = allowlist;
+		     ent->name; ent++) {
+			if (strcmp(name, ent->name) == 0 &&
+			    (!ent->privileged || af_alg_capable()))
+				return 0;
+		}
+	}
+	/*
+	 * Use -ENOENT (the error code for "algorithm not found") instead of
+	 * -EACCES or -EPERM, for the highest chance of correctly triggering
+	 * fallback code paths in userspace programs.
+	 *
+	 * Don't log a warning, since it would be noisy.  iwd tries to bind a
+	 * bunch of algorithms that it never uses.
+	 */
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(af_alg_check_restriction);
+
 static void alg_do_release(const struct af_alg_type *type, void *private)
 {
 	if (!type)
 		return;
 
@@ -504,10 +556,13 @@ static int alg_create(struct net *net, struct socket *sock, int protocol,
 		      int kern)
 {
 	struct sock *sk;
 	int err;
 
+	if (READ_ONCE(af_alg_restrict) == 2)
+		return -EAFNOSUPPORT;
+
 	if (sock->type != SOCK_SEQPACKET)
 		return -ESOCKTNOSUPPORT;
 	if (protocol != 0)
 		return -EPROTONOSUPPORT;
 
@@ -1220,31 +1275,36 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 }
 EXPORT_SYMBOL_GPL(af_alg_get_rsgl);
 
 static int __init af_alg_init(void)
 {
-	int err = proto_register(&alg_proto, 0);
+	int err;
+
+	af_alg_header = register_sysctl("crypto", af_alg_table);
 
+	err = proto_register(&alg_proto, 0);
 	if (err)
-		goto out;
+		goto out_unregister_sysctl;
 
 	err = sock_register(&alg_family);
-	if (err != 0)
+	if (err)
 		goto out_unregister_proto;
 
-out:
-	return err;
+	return 0;
 
 out_unregister_proto:
 	proto_unregister(&alg_proto);
-	goto out;
+out_unregister_sysctl:
+	unregister_sysctl_table(af_alg_header);
+	return err;
 }
 
 static void __exit af_alg_exit(void)
 {
 	sock_unregister(PF_ALG);
 	proto_unregister(&alg_proto);
+	unregister_sysctl_table(af_alg_header);
 }
 
 module_init(af_alg_init);
 module_exit(af_alg_exit);
 MODULE_DESCRIPTION("Crypto userspace interface");
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 787aac8aeb24..b9217f9086aa 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -32,10 +32,15 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <net/sock.h>
 
+static const struct af_alg_allowlist_entry aead_allowlist[] = {
+	{ "ccm(aes)", true }, /* bluez */
+	{},
+};
+
 static inline bool aead_sufficient_data(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct sock *psk = ask->parent;
 	struct alg_sock *pask = alg_sk(psk);
@@ -342,10 +347,16 @@ static struct proto_ops algif_aead_ops_nokey = {
 	.poll		=	af_alg_poll,
 };
 
 static void *aead_bind(const char *name)
 {
+	int err;
+
+	err = af_alg_check_restriction(name, aead_allowlist);
+	if (err)
+		return ERR_PTR(err);
+
 	return crypto_alloc_aead(name, 0, AF_ALG_CRYPTOAPI_MASK);
 }
 
 static void aead_release(void *private)
 {
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 5452ad6c1506..a8d958d51ece 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -14,10 +14,28 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <net/sock.h>
 
+static const struct af_alg_allowlist_entry hash_allowlist[] = {
+	{ "cmac(aes)", true }, /* iwd, bluez */
+	{ "hmac(md5)", true }, /* iwd */
+	{ "hmac(sha1)", true }, /* iwd */
+	{ "hmac(sha224)", true }, /* iwd */
+	{ "hmac(sha256)", true }, /* iwd */
+	{ "hmac(sha384)", true }, /* iwd */
+	{ "hmac(sha512)", true }, /* iwd, sha512hmac */
+	{ "md4", true }, /* iwd */
+	{ "md5", true }, /* iwd */
+	{ "sha1", false }, /* iwd, iproute2 < 7.0 */
+	{ "sha224", true }, /* iwd */
+	{ "sha256", true }, /* iwd */
+	{ "sha384", true }, /* iwd */
+	{ "sha512", true }, /* iwd */
+	{},
+};
+
 struct hash_ctx {
 	struct af_alg_sgl sgl;
 
 	u8 *result;
 
@@ -380,10 +398,16 @@ static struct proto_ops algif_hash_ops_nokey = {
 	.accept		=	hash_accept_nokey,
 };
 
 static void *hash_bind(const char *name)
 {
+	int err;
+
+	err = af_alg_check_restriction(name, hash_allowlist);
+	if (err)
+		return ERR_PTR(err);
+
 	return crypto_alloc_ahash(name, 0, AF_ALG_CRYPTOAPI_MASK);
 }
 
 static void hash_release(void *private)
 {
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 4dfe7899f8fa..bd522915d56d 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -48,10 +48,14 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
 MODULE_DESCRIPTION("User-space interface for random number generators");
 
+static const struct af_alg_allowlist_entry rng_allowlist[] = {
+	{},
+};
+
 struct rng_ctx {
 #define MAXSIZE 128
 	unsigned int len;
 	struct crypto_rng *drng;
 	u8 *addtl;
@@ -199,10 +203,15 @@ static struct proto_ops __maybe_unused algif_rng_test_ops = {
 
 static void *rng_bind(const char *name)
 {
 	struct rng_parent_ctx *pctx;
 	struct crypto_rng *rng;
+	int err;
+
+	err = af_alg_check_restriction(name, rng_allowlist);
+	if (err)
+		return ERR_PTR(err);
 
 	pctx = kzalloc_obj(*pctx);
 	if (!pctx)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index df20bdfe1f1f..2b8069667974 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -32,10 +32,24 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <net/sock.h>
 
+static const struct af_alg_allowlist_entry skcipher_allowlist[] = {
+	{ "adiantum(xchacha12,aes)", false }, /* cryptsetup */
+	{ "adiantum(xchacha20,aes)", false }, /* cryptsetup */
+	{ "cbc(aes)", true }, /* iwd */
+	{ "cbc(des)", true }, /* iwd */
+	{ "cbc(des3_ede)", true }, /* iwd */
+	{ "ctr(aes)", true }, /* iwd */
+	{ "ecb(aes)", true }, /* iwd, bluez */
+	{ "ecb(des)", true }, /* iwd */
+	{ "hctr2(aes)", false }, /* cryptsetup */
+	{ "xts(aes)", false }, /* cryptsetup benchmark */
+	{},
+};
+
 static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 			    size_t size)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
@@ -307,10 +321,16 @@ static struct proto_ops algif_skcipher_ops_nokey = {
 	.poll		=	af_alg_poll,
 };
 
 static void *skcipher_bind(const char *name)
 {
+	int err;
+
+	err = af_alg_check_restriction(name, skcipher_allowlist);
+	if (err)
+		return ERR_PTR(err);
+
 	return crypto_alloc_skcipher(name, 0, AF_ALG_CRYPTOAPI_MASK);
 }
 
 static void skcipher_release(void *private)
 {
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 7643ba954125..4e9ed8e73403 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -159,13 +159,21 @@ struct af_alg_ctx {
 	unsigned int len;
 
 	unsigned int inflight;
 };
 
+struct af_alg_allowlist_entry {
+	const char *name;
+	bool privileged;
+};
+
 int af_alg_register_type(const struct af_alg_type *type);
 int af_alg_unregister_type(const struct af_alg_type *type);
 
+int af_alg_check_restriction(const char *name,
+			     const struct af_alg_allowlist_entry allowlist[]);
+
 int af_alg_release(struct socket *sock);
 void af_alg_release_parent(struct sock *sk);
 int af_alg_accept(struct sock *sk, struct socket *newsock,
 		  struct proto_accept_arg *arg);
 

base-commit: 1dc18801be29bc54709aa355b8acd80e183b03cd
-- 
2.54.0

