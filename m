From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/8] crypto: user - Add CRYPTO_MSG_DELRNG
Date: Sun, 21 Jun 2015 19:11:45 +0800
Message-ID: <E1Z6dA9-0007qF-Jd@gondolin.me.apana.org.au>
References: <20150621110702.GA29747@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48949 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbFULLt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 07:11:49 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z6dA9-0000F5-Qz
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2015 21:11:46 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a new crypto_user command that allows the admin to
delete the crypto system RNG.  Note that this can only be done if
the RNG is currently not in use.  The next time it is used a new
system RNG will be allocated.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_user.c            |   12 +++++++++++-
 include/uapi/linux/cryptouser.h |    1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 11dbd5a..08ea286 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -27,6 +27,7 @@
 #include <net/net_namespace.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/internal/rng.h>
 #include <crypto/akcipher.h>
 
 #include "internal.h"
@@ -472,13 +473,21 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return 0;
 }
 
+static int crypto_del_rng(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct nlattr **attrs)
+{
+	if (!netlink_capable(skb, CAP_NET_ADMIN))
+		return -EPERM;
+	return crypto_del_default_rng();
+}
+
 #define MSGSIZE(type) sizeof(struct type)
 
 static const int crypto_msg_min[CRYPTO_NR_MSGTYPES] = {
 	[CRYPTO_MSG_NEWALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
 	[CRYPTO_MSG_DELALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
 	[CRYPTO_MSG_UPDATEALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
-	[CRYPTO_MSG_GETALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
+	[CRYPTO_MSG_DELRNG	- CRYPTO_MSG_BASE] = 0,
 };
 
 static const struct nla_policy crypto_policy[CRYPTOCFGA_MAX+1] = {
@@ -498,6 +507,7 @@ static const struct crypto_link {
 	[CRYPTO_MSG_GETALG	- CRYPTO_MSG_BASE] = { .doit = crypto_report,
 						       .dump = crypto_dump_report,
 						       .done = crypto_dump_report_done},
+	[CRYPTO_MSG_DELRNG	- CRYPTO_MSG_BASE] = { .doit = crypto_del_rng },
 };
 
 static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index 36efbbb..2e67bb6 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -25,6 +25,7 @@ enum {
 	CRYPTO_MSG_DELALG,
 	CRYPTO_MSG_UPDATEALG,
 	CRYPTO_MSG_GETALG,
+	CRYPTO_MSG_DELRNG,
 	__CRYPTO_MSG_MAX
 };
 #define CRYPTO_MSG_MAX (__CRYPTO_MSG_MAX - 1)
