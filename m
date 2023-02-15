Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B15C636CC
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Feb 2023 09:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbjBOJZp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Feb 2023 04:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjBOJZo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2023 04:25:44 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1364E3433E
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 01:25:12 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSE2F-00BVkQ-4u; Wed, 15 Feb 2023 17:25:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Feb 2023 17:25:07 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 15 Feb 2023 17:25:07 +0800
Subject: [PATCH 1/10] crypto: algapi - Move stat reporting into algapi
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1pSE2F-00BVkQ-4u@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The stats code resurrected the unions from the early days of
kernel crypto.  This patch starts the process of moving them
out to the individual type structures as we do for everything
else.

In particular, add a report_stat function to cra_type and call
that from the stats code if available.  This allows us to move
the actual code over one-by-one.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_user_stat.c |    6 ++++++
 include/crypto/algapi.h   |    3 +++
 2 files changed, 9 insertions(+)

diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 154884bf9275..2369814029fa 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -204,6 +204,12 @@ static int crypto_reportstat_one(struct crypto_alg *alg,
 		goto out;
 	}
 
+	if (alg->cra_type && alg->cra_type->report_stat) {
+		if (alg->cra_type->report_stat(skb, alg))
+			goto nla_put_failure;
+		goto out;
+	}
+
 	switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
 	case CRYPTO_ALG_TYPE_AEAD:
 		if (crypto_report_aead(skb, alg))
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index fede394ae2ab..dcc1fd4ef1b4 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -50,6 +50,9 @@ struct crypto_type {
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
 	int (*report)(struct sk_buff *skb, struct crypto_alg *alg);
 	void (*free)(struct crypto_instance *inst);
+#ifdef CONFIG_CRYPTO_STATS
+	int (*report_stat)(struct sk_buff *skb, struct crypto_alg *alg);
+#endif
 
 	unsigned int type;
 	unsigned int maskclear;
