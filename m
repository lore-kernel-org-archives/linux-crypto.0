Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6955AC43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 11:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45E3820726
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 11:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfLJLI0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:08:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7206 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726915AbfLJLI0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 06:08:26 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 202FCBC233D4A5380CA7;
        Tue, 10 Dec 2019 19:08:25 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 10 Dec 2019
 19:08:16 +0800
To:     Herbert Xu <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.or>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
Subject: [PATCH] crypto: user - use macro CRYPTO_MSG_INDEX() to instead of
 index calculation
Message-ID: <6306e685-51fa-1a04-e9d9-07d4c80b5400@huawei.com>
Date:   Tue, 10 Dec 2019 19:07:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are multiple places using CRYPTO_MSG_BASE to calculate the index,
so use macro CRYPTO_MSG_INDEX() instead for better readability.

Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
---
 crypto/crypto_user_base.c       | 28 ++++++++++++++--------------
 include/uapi/linux/cryptouser.h |  1 +
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user_base.c
index 910e0b4..4c8cac4 100644
--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -387,12 +387,12 @@ static int crypto_del_rng(struct sk_buff *skb, struct nlmsghdr *nlh,
 #define MSGSIZE(type) sizeof(struct type)

 static const int crypto_msg_min[CRYPTO_NR_MSGTYPES] = {
-	[CRYPTO_MSG_NEWALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
-	[CRYPTO_MSG_DELALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
-	[CRYPTO_MSG_UPDATEALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
-	[CRYPTO_MSG_GETALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
-	[CRYPTO_MSG_DELRNG	- CRYPTO_MSG_BASE] = 0,
-	[CRYPTO_MSG_GETSTAT	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_NEWALG)] = MSGSIZE(crypto_user_alg),
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_DELALG)] = MSGSIZE(crypto_user_alg),
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_UPDATEALG)] = MSGSIZE(crypto_user_alg),
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_GETALG)] = MSGSIZE(crypto_user_alg),
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_DELRNG)] = 0,
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_GETSTAT)] = MSGSIZE(crypto_user_alg),
 };

 static const struct nla_policy crypto_policy[CRYPTOCFGA_MAX+1] = {
@@ -406,14 +406,14 @@ static int crypto_del_rng(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int (*dump)(struct sk_buff *, struct netlink_callback *);
 	int (*done)(struct netlink_callback *);
 } crypto_dispatch[CRYPTO_NR_MSGTYPES] = {
-	[CRYPTO_MSG_NEWALG	- CRYPTO_MSG_BASE] = { .doit = crypto_add_alg},
-	[CRYPTO_MSG_DELALG	- CRYPTO_MSG_BASE] = { .doit = crypto_del_alg},
-	[CRYPTO_MSG_UPDATEALG	- CRYPTO_MSG_BASE] = { .doit = crypto_update_alg},
-	[CRYPTO_MSG_GETALG	- CRYPTO_MSG_BASE] = { .doit = crypto_report,
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_NEWALG)] = { .doit = crypto_add_alg},
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_DELALG)] = { .doit = crypto_del_alg},
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_UPDATEALG)] = { .doit = crypto_update_alg},
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_GETALG)] = { .doit = crypto_report,
 						       .dump = crypto_dump_report,
 						       .done = crypto_dump_report_done},
-	[CRYPTO_MSG_DELRNG	- CRYPTO_MSG_BASE] = { .doit = crypto_del_rng },
-	[CRYPTO_MSG_GETSTAT	- CRYPTO_MSG_BASE] = { .doit = crypto_reportstat},
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_DELRNG)] = { .doit = crypto_del_rng },
+	[CRYPTO_MSG_INDEX(CRYPTO_MSG_GETSTAT)] = { .doit = crypto_reportstat},
 };

 static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -428,10 +428,10 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (type > CRYPTO_MSG_MAX)
 		return -EINVAL;

-	type -= CRYPTO_MSG_BASE;
+	type = CRYPTO_MSG_INDEX(type);
 	link = &crypto_dispatch[type];

-	if ((type == (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE) &&
+	if ((type == CRYPTO_MSG_INDEX(CRYPTO_MSG_GETALG) &&
 	    (nlh->nlmsg_flags & NLM_F_DUMP))) {
 		struct crypto_alg *alg;
 		unsigned long dump_alloc = 0;
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index 5730c67..8a5fe9c 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -37,6 +37,7 @@ enum {
 };
 #define CRYPTO_MSG_MAX (__CRYPTO_MSG_MAX - 1)
 #define CRYPTO_NR_MSGTYPES (CRYPTO_MSG_MAX + 1 - CRYPTO_MSG_BASE)
+#define CRYPTO_MSG_INDEX(x) ((x) - CRYPTO_MSG_BASE)

 #define CRYPTO_MAX_NAME 64

-- 
1.8.3.1

