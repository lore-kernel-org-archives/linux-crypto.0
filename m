From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 2/8] crypto: AF_ALG -- add DH param / ECDH curve setsockopt  call
Date: Wed, 19 Apr 2017 01:05:12 +0200
Message-ID: <4340841.16OFkZJjv3@positron.chronox.de>
References: <2715753.J0rCo2lbig@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59004 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757695AbdDRXJy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 19:09:54 -0400
In-Reply-To: <2715753.J0rCo2lbig@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For supporting DH ciphers, user space must be able to set the
DH parameters. The patch adds a new setsockopt call for setting
these parameters.

Similarly, the ECDH curve information can be set by user space via the
newly added setsockopt call.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c             | 12 ++++++++++++
 include/crypto/if_alg.h     |  2 ++
 include/uapi/linux/if_alg.h |  2 ++
 3 files changed, 16 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 0a91404..a3210bf 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -260,6 +260,18 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 
 		err = alg_setkey(sk, optval, optlen, type->setpubkey);
 		break;
+	case ALG_SET_DH_PARAMETERS:
+		if (sock->state == SS_CONNECTED)
+			goto unlock;
+
+		err = alg_setkey(sk, optval, optlen, type->dhparams);
+		break;
+	case ALG_SET_ECDH_CURVE:
+		if (sock->state == SS_CONNECTED)
+			goto unlock;
+
+		err = alg_setkey(sk, optval, optlen, type->ecdhcurve);
+		break;
 	case ALG_SET_AEAD_AUTHSIZE:
 		if (sock->state == SS_CONNECTED)
 			goto unlock;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 3c3ebe3..52dcefe 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -53,6 +53,8 @@ struct af_alg_type {
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*setpubkey)(void *private, const u8 *key, unsigned int keylen);
+	int (*dhparams)(void *private, const u8 *param, unsigned int paramlen);
+	int (*ecdhcurve)(void *private, const u8 *param, unsigned int paramlen);
 	int (*accept)(void *private, struct sock *sk);
 	int (*accept_nokey)(void *private, struct sock *sk);
 	int (*setauthsize)(void *private, unsigned int authsize);
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index c48eeb6..fc9ed9f 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -35,6 +35,8 @@ struct af_alg_iv {
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
 #define ALG_SET_PUBKEY			6
+#define ALG_SET_DH_PARAMETERS		7
+#define ALG_SET_ECDH_CURVE		8
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
-- 
2.9.3
