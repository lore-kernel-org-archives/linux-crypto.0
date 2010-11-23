From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 5/5] Audit type-specific crypto operations
Date: Tue, 23 Nov 2010 13:50:35 +0100
Message-ID: <1290516635-26601-5-git-send-email-mitr@redhat.com>
References: <344091777.216361290516431362.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-audit@redhat.com, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: sgrubb@redhat.com, herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab0KWMu4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Nov 2010 07:50:56 -0500
In-Reply-To: <344091777.216361290516431362.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Miloslav Trma=C4=8D <mitr@redhat.com>
---
 crypto/af_alg.c         |   14 ++++++++++++++
 crypto/algif_hash.c     |   27 +++++++++++++++++++++++----
 crypto/algif_skcipher.c |   15 +++++++++++++++
 include/crypto/if_alg.h |    6 ++++++
 4 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index fc1b0f7..450d51a 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -542,6 +542,20 @@ void af_alg_complete(struct crypto_async_request *=
req, int err)
 }
 EXPORT_SYMBOL_GPL(af_alg_complete);
=20
+#ifdef CONFIG_AUDIT
+int af_alg_audit_crypto_op(struct sock *sk, const char *operation, int=
 ctx2)
+{
+	struct alg_sock *ask =3D alg_sk(sk);
+	struct alg_sock *parent_ask =3D alg_sk(ask->parent);
+	const char *alg_name;
+
+	alg_name =3D parent_ask->type->alg_name(parent_ask->private);
+	return audit_log_crypto_op(AUDIT_CRYPTO_OP_CTX_OP, parent_ask->id,
+				   ask->id, ctx2, alg_name, operation);
+}
+EXPORT_SYMBOL_GPL(af_alg_audit_crypto_op);
+#endif
+
 static int __init af_alg_init(void)
 {
 	int err =3D proto_register(&alg_proto, 0);
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 3a61e9d..7e3ffd1 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -46,6 +46,10 @@ static int hash_sendmsg(struct kiocb *unused, struct=
 socket *sock,
 	long copied =3D 0;
 	int err;
=20
+	err =3D af_alg_audit_crypto_op(sk, "hash-input", -1);
+	if (err)
+		return err;
+
 	if (limit > sk->sk_sndbuf)
 		limit =3D sk->sk_sndbuf;
=20
@@ -112,6 +116,10 @@ static ssize_t hash_sendpage(struct socket *sock, =
struct page *page,
 	struct hash_ctx *ctx =3D ask->private;
 	int err;
=20
+	err =3D af_alg_audit_crypto_op(sk, "hash-input", -1);
+	if (err)
+		return err;
+
 	lock_sock(sk);
 	sg_init_table(ctx->sgl.sg, 1);
 	sg_set_page(ctx->sgl.sg, page, size, offset);
@@ -154,6 +162,10 @@ static int hash_recvmsg(struct kiocb *unused, stru=
ct socket *sock,
 	unsigned ds =3D crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req=
));
 	int err;
=20
+	err =3D af_alg_audit_crypto_op(sk, "hash-output", -1);
+	if (err)
+		return err;
+
 	if (len > ds)
 		len =3D ds;
 	else if (len < ds)
@@ -202,12 +214,19 @@ static int hash_accept(struct socket *sock, struc=
t socket *newsock, int flags)
 	ctx2 =3D ask2->private;
 	ctx2->more =3D 1;
=20
+	err =3D af_alg_audit_crypto_op(sk, "hash-clone", ask2->id);
+	if (err)
+		goto error_sk2;
+
 	err =3D crypto_ahash_import(&ctx2->req, state);
-	if (err) {
-		sock_orphan(sk2);
-		sock_put(sk2);
-	}
+	if (err)
+		goto error_sk2;
+
+	return err;
=20
+error_sk2:
+	sock_orphan(sk2);
+	sock_put(sk2);
 	return err;
 }
=20
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index e14c8be..f69a109 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -283,6 +283,11 @@ static int skcipher_sendmsg(struct kiocb *unused, =
struct socket *sock,
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 	}
=20
+	err =3D af_alg_audit_crypto_op(sk, ctx->enc ? "encrypt-input"
+				     : "decrypt-input", -1);
+	if (err)
+		goto unlock;
+
 	limit =3D max_t(int, sk->sk_sndbuf, PAGE_SIZE);
 	limit -=3D ctx->used;
=20
@@ -384,6 +389,11 @@ static ssize_t skcipher_sendpage(struct socket *so=
ck, struct page *page,
 	int err =3D -EINVAL;
 	int limit;
=20
+	err =3D af_alg_audit_crypto_op(sk, ctx->enc ? "encrypt-input"
+				     : "decrypt-input", -1);
+	if (err)
+		return err;
+
 	lock_sock(sk);
 	if (!ctx->more && ctx->used)
 		goto unlock;
@@ -443,6 +453,11 @@ static int skcipher_recvmsg(struct kiocb *unused, =
struct socket *sock,
 	int used;
 	long copied =3D 0;
=20
+	err =3D af_alg_audit_crypto_op(sk, ctx->enc ? "encrypt-output"
+				     : "decrypt-output", -1);
+	if (err)
+		return err;
+
 	lock_sock(sk);
 	for (iov =3D msg->msg_iov, iovlen =3D msg->msg_iovlen; iovlen > 0;
 	     iovlen--, iov++) {
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 092c599..6650ae5 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -80,6 +80,12 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_a=
lg_control *con);
 int af_alg_wait_for_completion(int err, struct af_alg_completion *comp=
letion);
 void af_alg_complete(struct crypto_async_request *req, int err);
=20
+#ifdef CONFIG_AUDIT
+int af_alg_audit_crypto_op(struct sock *sk, const char *operation, int=
 ctx2);
+#else
+#define af_alg_audit_crypto_op(sk, operation, ctx2) (0)
+#endif
+
 static inline struct alg_sock *alg_sk(struct sock *sk)
 {
 	return (struct alg_sock *)sk;
--=20
1.7.3.2
