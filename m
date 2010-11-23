From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 2/5] Add unique IDs to AF_ALG sockets
Date: Tue, 23 Nov 2010 13:50:32 +0100
Message-ID: <1290516635-26601-2-git-send-email-mitr@redhat.com>
References: <344091777.216361290516431362.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-audit@redhat.com, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: sgrubb@redhat.com, herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab0KWMuv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Nov 2010 07:50:51 -0500
In-Reply-To: <344091777.216361290516431362.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ideally we should be able to use i_ino of the inode associated with the
socket, but i_ino can have duplicate values if the static counter insid=
e
new_inode() wraps around.

Signed-off-by: Miloslav Trma=C4=8D <mitr@redhat.com>
---
 crypto/af_alg.c         |   66 +++++++++++++++++++++++++++++++++++++++=
++++++-
 crypto/algif_hash.c     |    2 +-
 crypto/algif_skcipher.c |    2 +-
 include/crypto/if_alg.h |   10 +++---
 4 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index cabed0e..490ae43 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -15,10 +15,12 @@
 #include <asm/atomic.h>
 #include <crypto/if_alg.h>
 #include <linux/crypto.h>
+#include <linux/idr.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/net.h>
 #include <linux/rwsem.h>
=20
@@ -38,6 +40,10 @@ static struct proto alg_proto =3D {
=20
 static LIST_HEAD(alg_types);
 static DECLARE_RWSEM(alg_types_sem);
+#ifdef CONFIG_AUDIT
+static DEFINE_MUTEX(alg_ida_mutex);
+static DEFINE_IDA(alg_ida);
+#endif
=20
 static const struct af_alg_type *alg_get_type(const char *name)
 {
@@ -107,6 +113,59 @@ int af_alg_unregister_type(const struct af_alg_typ=
e *type)
 }
 EXPORT_SYMBOL_GPL(af_alg_unregister_type);
=20
+static struct sock *alg_sk_alloc(struct net *net)
+{
+	struct sock *sk;
+
+	sk =3D sk_alloc(net, PF_ALG, GFP_KERNEL, &alg_proto);
+	if (!sk)
+		goto out;
+
+#ifdef CONFIG_AUDIT
+	mutex_lock(&alg_ida_mutex);
+	/* ida_pre_get() should preallocate enough, and, due to
+	   lists_ida_mutex, nobody else can use the preallocated data.
+	   Therefore the loop recommended in idr_get_new() documentation is n=
ot
+	   necessary. */
+	if (ida_pre_get(&alg_ida, GFP_KERNEL) =3D=3D 0 ||
+	    ida_get_new(&alg_ida, &alg_sk(sk)->id) !=3D 0) {
+		mutex_unlock(&alg_ida_mutex);
+		alg_sk(sk)->id =3D -1;
+		sk_free(sk);
+		sk =3D NULL;
+		goto out;
+	}
+	mutex_unlock(&alg_ida_mutex);
+#endif
+
+out:
+	return sk;
+}
+
+#ifdef CONFIG_AUDIT
+static void alg_sk_destruct(struct sock *sk)
+{
+	struct alg_sock *ask =3D alg_sk(sk);
+
+	if (ask->id !=3D -1) {
+               mutex_lock(&alg_ida_mutex);
+               ida_remove(&alg_ida, ask->id);
+               mutex_unlock(&alg_ida_mutex);
+	}
+}
+#else
+static void alg_sk_destruct(struct sock *sk) {}
+#endif
+
+void af_alg_sk_destruct_child(struct sock *sk)
+{
+	struct alg_sock *ask =3D alg_sk(sk);
+
+	sock_put(ask->parent);
+	alg_sk_destruct(sk);
+}
+EXPORT_SYMBOL_GPL(af_alg_sk_destruct_child);
+
 static void alg_do_release(const struct af_alg_type *type, void *priva=
te)
 {
 	if (!type)
@@ -236,7 +295,7 @@ int af_alg_accept(struct sock *sk, struct socket *n=
ewsock)
 	if (!type)
 		goto unlock;
=20
-	sk2 =3D sk_alloc(sock_net(sk), PF_ALG, GFP_KERNEL, &alg_proto);
+	sk2 =3D alg_sk_alloc(sock_net(sk));
 	err =3D -ENOMEM;
 	if (!sk2)
 		goto unlock;
@@ -245,6 +304,7 @@ int af_alg_accept(struct sock *sk, struct socket *n=
ewsock)
=20
 	err =3D type->accept(ask->private, sk2);
 	if (err) {
+		alg_sk_destruct(sk2);
 		sk_free(sk2);
 		goto unlock;
 	}
@@ -300,6 +360,7 @@ static void alg_sock_destruct(struct sock *sk)
 	struct alg_sock *ask =3D alg_sk(sk);
=20
 	alg_do_release(ask->type, ask->private);
+	alg_sk_destruct(sk);
 }
=20
 static int alg_create(struct net *net, struct socket *sock, int protoc=
ol,
@@ -314,7 +375,7 @@ static int alg_create(struct net *net, struct socke=
t *sock, int protocol,
 		return -EPROTONOSUPPORT;
=20
 	err =3D -ENOMEM;
-	sk =3D sk_alloc(net, PF_ALG, GFP_KERNEL, &alg_proto);
+	sk =3D alg_sk_alloc(net);
 	if (!sk)
 		goto out;
=20
@@ -474,6 +535,7 @@ static void __exit af_alg_exit(void)
 {
 	sock_unregister(PF_ALG);
 	proto_unregister(&alg_proto);
+	ida_destroy(&alg_ida);
 }
=20
 module_init(af_alg_init);
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 62122a1..f08a42c 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -256,7 +256,7 @@ static void hash_sock_destruct(struct sock *sk)
 	sock_kfree_s(sk, ctx->result,
 		     crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
 	sock_kfree_s(sk, ctx, ctx->len);
-	af_alg_release_parent(sk);
+	af_alg_sk_destruct_child(sk);
 }
=20
 static int hash_accept_parent(void *private, struct sock *sk)
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index d8d3ddf..4069460 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -575,7 +575,7 @@ static void skcipher_sock_destruct(struct sock *sk)
 	skcipher_free_sgl(sk);
 	sock_kfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
-	af_alg_release_parent(sk);
+	af_alg_sk_destruct_child(sk);
 }
=20
 static int skcipher_accept_parent(void *private, struct sock *sk)
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index c5813c8..336b9f2 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -31,6 +31,9 @@ struct alg_sock {
=20
 	const struct af_alg_type *type;
 	void *private;
+#ifdef CONFIG_AUDIT
+	int id;
+#endif
 };
=20
 struct af_alg_completion {
@@ -62,6 +65,8 @@ struct af_alg_sgl {
 int af_alg_register_type(const struct af_alg_type *type);
 int af_alg_unregister_type(const struct af_alg_type *type);
=20
+void af_alg_sk_destruct_child(struct sock *sk);
+
 int af_alg_release(struct socket *sock);
 int af_alg_accept(struct sock *sk, struct socket *newsock);
=20
@@ -79,11 +84,6 @@ static inline struct alg_sock *alg_sk(struct sock *s=
k)
 	return (struct alg_sock *)sk;
 }
=20
-static inline void af_alg_release_parent(struct sock *sk)
-{
-	sock_put(alg_sk(sk)->parent);
-}
-
 static inline void af_alg_init_completion(struct af_alg_completion *co=
mpletion)
 {
 	init_completion(&completion->completion);
--=20
1.7.3.2
