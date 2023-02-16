Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91590C636CC
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 10:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjBPKi0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 05:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjBPKiV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 05:38:21 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1854D4A1FB
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 02:37:58 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSbbZ-00BwIR-0Y; Thu, 16 Feb 2023 18:35:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 18:35:09 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 16 Feb 2023 18:35:09 +0800
Subject: [v2 PATCH 1/10] crypto: algapi - Move stat reporting into algapi
References: <Y+4GpkkLQjyv7KUt@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1pSbbZ-00BwIR-0Y@formenos.hmeau.com>
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
