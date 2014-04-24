From: Matthias-Christian Ott <ott@mirix.org>
Subject: [PATCH] crypto: user - Allow CRYPTO_MSG_GETALG without CAP_NET_ADMIN
Date: Fri, 25 Apr 2014 00:51:06 +0200
Message-ID: <5359955A.4070903@mirix.org>
References: <534016A0.6020702@mirix.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040408040300080004030802"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mirix.org ([78.46.130.147]:38753 "EHLO a.mirix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759139AbaDXWuY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 18:50:24 -0400
Received: from [2003:5c:ad74:c200:e415:150c:e790:6883]
	by a.mirix.org with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <ott@mirix.org>)
	id 1WdSTG-0003PQ-MS
	for linux-crypto@vger.kernel.org; Fri, 25 Apr 2014 00:50:22 +0200
In-Reply-To: <534016A0.6020702@mirix.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040408040300080004030802
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


CRYPTO_USER requires CAP_NET_ADMIN for all operations. Most information
provided by CRYPTO_MSG_GETALG is also accessible through /proc/modules
and AF_ALG. CRYPTO_MSG_GETALG should not require CAP_NET_ADMIN so that
processes without CAP_NET_ADMIN can use CRYPTO_MSG_GETALG to get cipher
details, such as cipher priorities, for AF_ALG.

Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
---
 crypto/crypto_user.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)



--------------040408040300080004030802
Content-Type: text/x-patch;
 name="0001-crypto-user-Allow-CRYPTO_MSG_GETALG-without-CAP_NET_.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-crypto-user-Allow-CRYPTO_MSG_GETALG-without-CAP_NET_.pa";
 filename*1="tch"

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 1512e41..aa906b8 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -265,6 +265,9 @@ static int crypto_update_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *priority = attrs[CRYPTOCFGA_PRIORITY_VAL];
 	LIST_HEAD(list);
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
 		return -EINVAL;
 
@@ -295,6 +298,9 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct crypto_alg *alg;
 	struct crypto_user_alg *p = nlmsg_data(nlh);
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
 		return -EINVAL;
 
@@ -379,6 +385,9 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct crypto_user_alg *p = nlmsg_data(nlh);
 	struct nlattr *priority = attrs[CRYPTOCFGA_PRIORITY_VAL];
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
 		return -EINVAL;
 
@@ -466,9 +475,6 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	type -= CRYPTO_MSG_BASE;
 	link = &crypto_dispatch[type];
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
 	if ((type == (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE) &&
 	    (nlh->nlmsg_flags & NLM_F_DUMP))) {
 		struct crypto_alg *alg;


--------------040408040300080004030802--
