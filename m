From: Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] crypto: Add support for ALG_SET_KEY_ID for skcipher
Date: Wed, 28 Oct 2015 02:02:51 +0100
Message-ID: <1445994171-30914-1-git-send-email-marcel@holtmann.org>
Cc: dhowells@redhat.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53074 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbbJ1BDB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Oct 2015 21:03:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds support for a new socket options called ALG_SET_KEY_ID that
allows providing the symmetric key via a key serial from the keys
subsystem.

NOTE: Currently we do not have a dedicated symmetric key type and using
the user key type is not optional. Also lookup_user_key() is currently
private to the keys subsystem and might need to be exposed to usage by
the crypto subystem first. This is just a RFC and not for merging !!!

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 crypto/af_alg.c             | 14 ++++++++++++++
 crypto/algif_skcipher.c     | 25 +++++++++++++++++++++++++
 include/crypto/if_alg.h     |  2 ++
 include/uapi/linux/if_alg.h |  1 +
 4 files changed, 42 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index a8e7aa3e257b..48ddbb4063aa 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -203,6 +203,7 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 	struct alg_sock *ask = alg_sk(sk);
 	const struct af_alg_type *type;
 	int err = -ENOPROTOOPT;
+	key_serial_t keyid;
 
 	lock_sock(sk);
 	type = ask->type;
@@ -225,6 +226,19 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 		if (!type->setauthsize)
 			goto unlock;
 		err = type->setauthsize(ask->private, optlen);
+		break;
+	case ALG_SET_KEY_ID:
+		if (sock->state == SS_CONNECTED)
+			goto unlock;
+		if (!type->setkeyid)
+			goto unlock;
+
+		err = -EFAULT;
+		if (get_user(keyid, (key_serial_t __user *) optval))
+			goto unlock;
+
+		err = type->setkeyid(ask->private, keyid);
+		break;
 	}
 
 unlock:
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 945075292bc9..5dfae3cb6e20 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -22,6 +22,8 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <net/sock.h>
+#include <keys/user-type.h>
+#include "../security/keys/internal.h"
 
 struct skcipher_sg_list {
 	struct list_head list;
@@ -764,6 +766,28 @@ static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 	return crypto_ablkcipher_setkey(private, key, keylen);
 }
 
+static int skcipher_setkeyid(void *private, key_serial_t id)
+{
+	key_ref_t key_ref;
+	int err = -EPROTOTYPE;
+
+	key_ref = lookup_user_key(id, 0, KEY_NEED_READ);
+	if (IS_ERR(key_ref))
+		return PTR_ERR(key_ref);
+
+	if (key_ref_to_ptr(key_ref)->type == &key_type_user) {
+		struct user_key_payload *upayload;
+
+		upayload = rcu_dereference_key(key_ref_to_ptr(key_ref));
+
+		err = crypto_ablkcipher_setkey(private, upayload->data,
+					       upayload->datalen);
+	}
+
+	key_ref_put(key_ref);
+	return err;
+}
+
 static void skcipher_wait(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -832,6 +856,7 @@ static const struct af_alg_type algif_type_skcipher = {
 	.bind		=	skcipher_bind,
 	.release	=	skcipher_release,
 	.setkey		=	skcipher_setkey,
+	.setkeyid	=	skcipher_setkeyid,
 	.accept		=	skcipher_accept_parent,
 	.ops		=	&algif_skcipher_ops,
 	.name		=	"skcipher",
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 018afb264ac2..f71d88162326 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -17,6 +17,7 @@
 #include <linux/completion.h>
 #include <linux/if_alg.h>
 #include <linux/scatterlist.h>
+#include <linux/key.h>
 #include <linux/types.h>
 #include <net/sock.h>
 
@@ -51,6 +52,7 @@ struct af_alg_type {
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*accept)(void *private, struct sock *sk);
 	int (*setauthsize)(void *private, unsigned int authsize);
+	int (*setkeyid)(void *private, key_serial_t id);
 
 	struct proto_ops *ops;
 	struct module *owner;
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index d81dcca5bdd7..28cdc05695c0 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -34,6 +34,7 @@ struct af_alg_iv {
 #define ALG_SET_OP			3
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
+#define ALG_SET_KEY_ID			6
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
-- 
2.4.3
