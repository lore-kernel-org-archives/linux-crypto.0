From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: user - constify netlink dispatch table
Date: Sun, 24 Feb 2013 14:09:12 +0100
Message-ID: <1361711352-7795-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61845 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab3BXNJV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Feb 2013 08:09:21 -0500
Received: by mail-bk0-f47.google.com with SMTP id jc3so895132bkc.34
        for <linux-crypto@vger.kernel.org>; Sun, 24 Feb 2013 05:09:19 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is no need to modify the netlink dispatch table at runtime and
making it const even makes the resulting object file slightly smaller.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 crypto/crypto_user.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 35d700a..77f6c4e 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -426,7 +426,7 @@ static const struct nla_policy crypto_policy[CRYPTOCFGA_MAX+1] = {
 
 #undef MSGSIZE
 
-static struct crypto_link {
+static const struct crypto_link {
 	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **);
 	int (*dump)(struct sk_buff *, struct netlink_callback *);
 	int (*done)(struct netlink_callback *);
@@ -442,7 +442,7 @@ static struct crypto_link {
 static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	struct nlattr *attrs[CRYPTOCFGA_MAX+1];
-	struct crypto_link *link;
+	const struct crypto_link *link;
 	int type, err;
 
 	type = nlh->nlmsg_type;
-- 
1.7.10.4
