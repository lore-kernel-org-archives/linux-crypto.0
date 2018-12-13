Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53924 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbeLMIgr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 03:36:47 -0500
Received: by mail-wm1-f66.google.com with SMTP id y1so1402562wmi.3
        for <linux-crypto@vger.kernel.org>; Thu, 13 Dec 2018 00:36:45 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/2] crypto: crypto_user_stat: remove unused dump functions
Date: Thu, 13 Dec 2018 08:36:37 +0000
Message-Id: <1544690198-21993-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes unused dump functions for crypto_user_stats.
There are remains of the copy/paste of crypto_user_base to
crypto_user_stat and I forgot to remove them.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/crypto_user_base.c            |  4 +---
 crypto/crypto_user_stat.c            | 33 ----------------------------
 include/crypto/internal/cryptouser.h | 12 ----------
 3 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user_base.c
index 7021efbb35a1..f4f607631429 100644
--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -420,9 +420,7 @@ static const struct crypto_link {
 						       .dump = crypto_dump_report,
 						       .done = crypto_dump_report_done},
 	[CRYPTO_MSG_DELRNG	- CRYPTO_MSG_BASE] = { .doit = crypto_del_rng },
-	[CRYPTO_MSG_GETSTAT	- CRYPTO_MSG_BASE] = { .doit = crypto_reportstat,
-						       .dump = crypto_dump_reportstat,
-						       .done = crypto_dump_reportstat_done},
+	[CRYPTO_MSG_GETSTAT	- CRYPTO_MSG_BASE] = { .doit = crypto_reportstat},
 };
 
 static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 0ba00aaeb810..3e9a53233d80 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -336,37 +336,4 @@ int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
 }
 
-int crypto_dump_reportstat(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	struct crypto_alg *alg;
-	struct crypto_dump_info info;
-	int err;
-
-	if (cb->args[0])
-		goto out;
-
-	cb->args[0] = 1;
-
-	info.in_skb = cb->skb;
-	info.out_skb = skb;
-	info.nlmsg_seq = cb->nlh->nlmsg_seq;
-	info.nlmsg_flags = NLM_F_MULTI;
-
-	list_for_each_entry(alg, &crypto_alg_list, cra_list) {
-		err = crypto_reportstat_alg(alg, &info);
-		if (err)
-			goto out_err;
-	}
-
-out:
-	return skb->len;
-out_err:
-	return err;
-}
-
-int crypto_dump_reportstat_done(struct netlink_callback *cb)
-{
-	return 0;
-}
-
 MODULE_LICENSE("GPL");
diff --git a/include/crypto/internal/cryptouser.h b/include/crypto/internal/cryptouser.h
index 3492ab42eefb..40623f4457df 100644
--- a/include/crypto/internal/cryptouser.h
+++ b/include/crypto/internal/cryptouser.h
@@ -4,22 +4,10 @@
 struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact);
 
 #ifdef CONFIG_CRYPTO_STATS
-int crypto_dump_reportstat(struct sk_buff *skb, struct netlink_callback *cb);
 int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh, struct nlattr **attrs);
-int crypto_dump_reportstat_done(struct netlink_callback *cb);
 #else
-static int crypto_dump_reportstat(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	return -ENOTSUPP;
-}
-
 static int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh, struct nlattr **attrs)
 {
 	return -ENOTSUPP;
 }
-
-static int crypto_dump_reportstat_done(struct netlink_callback *cb)
-{
-	return -ENOTSUPP;
-}
 #endif
-- 
2.19.2
