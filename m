From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 3/3] crypto: user - ensure user supplied strings are nul-terminated
Date: Tue,  5 Feb 2013 18:19:15 +0100
Message-ID: <1360084755-11044-4-git-send-email-minipli@googlemail.com>
References: <1360084755-11044-1-git-send-email-minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:64639 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab3BERTg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Feb 2013 12:19:36 -0500
Received: by mail-bk0-f43.google.com with SMTP id jm19so207987bkc.30
        for <linux-crypto@vger.kernel.org>; Tue, 05 Feb 2013 09:19:35 -0800 (PST)
In-Reply-To: <1360084755-11044-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

To avoid misuse, ensure cru_name and cru_driver_name are always
nul-terminated strings.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 crypto/crypto_user.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 423a267..dfd511f 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -30,6 +30,8 @@
 
 #include "internal.h"
 
+#define null_terminated(x)	(strnlen(x, sizeof(x)) < sizeof(x))
+
 static DEFINE_MUTEX(crypto_cfg_mutex);
 
 /* The crypto netlink socket */
@@ -196,6 +198,9 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	struct crypto_dump_info info;
 	int err;
 
+	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
+		return -EINVAL;
+
 	if (!p->cru_driver_name[0])
 		return -EINVAL;
 
@@ -260,6 +265,9 @@ static int crypto_update_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *priority = attrs[CRYPTOCFGA_PRIORITY_VAL];
 	LIST_HEAD(list);
 
+	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
+		return -EINVAL;
+
 	if (priority && !strlen(p->cru_driver_name))
 		return -EINVAL;
 
@@ -287,6 +295,9 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct crypto_alg *alg;
 	struct crypto_user_alg *p = nlmsg_data(nlh);
 
+	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
+		return -EINVAL;
+
 	alg = crypto_alg_match(p, 1);
 	if (!alg)
 		return -ENOENT;
@@ -368,6 +379,9 @@ static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct crypto_user_alg *p = nlmsg_data(nlh);
 	struct nlattr *priority = attrs[CRYPTOCFGA_PRIORITY_VAL];
 
+	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
+		return -EINVAL;
+
 	if (strlen(p->cru_driver_name))
 		exact = 1;
 
-- 
1.7.10.4
