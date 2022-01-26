Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41409C28CF5
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 14:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242339AbiAZOxd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 09:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbiAZOxd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 09:53:33 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E297CC06161C
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 06:53:32 -0800 (PST)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nCjfv-0004Wa-B0; Wed, 26 Jan 2022 15:53:31 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de
Subject: [PATCH] crypto: algapi - Remove test larvals to fix error paths
Date:   Wed, 26 Jan 2022 15:53:22 +0100
Message-Id: <20220126145322.646723-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If crypto_unregister_alg() is called with an algorithm that still has a
pending test larval, the algorithm will have a reference count of 2 and
crypto_unregister_alg() will trigger a BUG(). This can happen during
cleanup if the error path is taken for a built-in algorithm, before
crypto_algapi_init() was called.

Kill test larvals for untested algorithms during removal to fix the
reference count.

Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 crypto/algapi.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index a366cb3e8aa1..fc3b75e59d0e 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -458,6 +458,28 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
 		return;
 
+	/* If there is a test larval holding a reference, remove it */
+	if (!(alg->cra_flags & CRYPTO_ALG_TESTED)) {
+		struct crypto_alg *q, *n;
+
+		list_for_each_entry_safe(q, n, &crypto_alg_list, cra_list) {
+			struct crypto_larval *l;
+
+			if (!crypto_is_larval(q))
+				continue;
+
+			l = (void *)q;
+
+			if (!crypto_is_test_larval(l))
+				continue;
+
+			if (l->adult != alg)
+				continue;
+
+			crypto_larval_kill(q);
+		}
+	}
+
 	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
 	if (alg->cra_destroy)
 		alg->cra_destroy(alg);

base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
-- 
2.30.2

