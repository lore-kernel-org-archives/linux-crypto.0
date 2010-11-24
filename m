From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 4/5] Audit type-independent events
Date: Wed, 24 Nov 2010 18:05:54 +0100
Message-ID: <1290618355-31193-5-git-send-email-mitr@redhat.com>
References: <1290618355-31193-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-audit@redhat.com, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: eparis@redhat.com, herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab0KXRGR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Nov 2010 12:06:17 -0500
In-Reply-To: <1290618355-31193-1-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Miloslav Trma=C4=8D <mitr@redhat.com>
---
 crypto/af_alg.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 490ae43..fc1b0f7 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -14,6 +14,7 @@
=20
 #include <asm/atomic.h>
 #include <crypto/if_alg.h>
+#include <linux/audit.h>
 #include <linux/crypto.h>
 #include <linux/idr.h>
 #include <linux/init.h>
@@ -160,6 +161,11 @@ static void alg_sk_destruct(struct sock *sk) {}
 void af_alg_sk_destruct_child(struct sock *sk)
 {
 	struct alg_sock *ask =3D alg_sk(sk);
+	struct alg_sock *parent_ask =3D alg_sk(ask->parent);
+
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_CTX_DEL, parent_ask->id,
+			    ask->id, -1,
+			    ask->type->alg_name(parent_ask->private), NULL);
=20
 	sock_put(ask->parent);
 	alg_sk_destruct(sk);
@@ -235,6 +241,11 @@ static int alg_setkey(struct sock *sk, char __user=
 *ukey,
 	u8 *key;
 	int err;
=20
+	err =3D audit_log_crypto_op(AUDIT_CRYPTO_OP_TFM_KEY_IMPORT, ask->id, =
-1,
+				  -1, type->alg_name(ask->private), NULL);
+	if (err)
+		return err;
+
 	key =3D sock_kmalloc(sk, keylen, GFP_KERNEL);
 	if (!key)
 		return -ENOMEM;
@@ -315,6 +326,14 @@ int af_alg_accept(struct sock *sk, struct socket *=
newsock)
 	alg_sk(sk2)->parent =3D sk;
 	alg_sk(sk2)->type =3D type;
=20
+	err =3D audit_log_crypto_op(AUDIT_CRYPTO_OP_CTX_NEW, ask->id,
+				  alg_sk(sk2)->id, -1,
+				  type->alg_name(ask->private), NULL);
+	if (err) {
+		sk_free(sk2);
+		return err;
+	}
+
 	newsock->ops =3D type->ops;
 	newsock->state =3D SS_CONNECTED;
=20
@@ -359,6 +378,9 @@ static void alg_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask =3D alg_sk(sk);
=20
+	audit_log_crypto_op(AUDIT_CRYPTO_OP_TFM_DEL, ask->id, -1, -1, NULL,
+			    NULL);
+
 	alg_do_release(ask->type, ask->private);
 	alg_sk_destruct(sk);
 }
@@ -379,6 +401,14 @@ static int alg_create(struct net *net, struct sock=
et *sock, int protocol,
 	if (!sk)
 		goto out;
=20
+	err =3D audit_log_crypto_op(AUDIT_CRYPTO_OP_TFM_NEW, alg_sk(sk)->id, =
-1,
+				  -1, NULL, NULL);
+	if (err) {
+		alg_sk_destruct(sk);
+		sk_free(sk);
+		goto out;
+	}
+
 	sock->ops =3D &alg_proto_ops;
 	sock_init_data(sock, sk);
=20
--=20
1.7.3.2
