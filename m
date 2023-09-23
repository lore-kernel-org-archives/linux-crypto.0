Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5075ACE7A88
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Sep 2023 10:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjIWKIc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Sep 2023 06:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjIWKIb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Sep 2023 06:08:31 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FD2199
        for <linux-crypto@vger.kernel.org>; Sat, 23 Sep 2023 03:08:22 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qjzYe-0001ja-NX; Sat, 23 Sep 2023 12:08:16 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qjzYc-008NfE-74; Sat, 23 Sep 2023 12:08:14 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qjzYb-0047zd-R5; Sat, 23 Sep 2023 12:08:13 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 2/2] crypto: Make crypto_engine_exit() return void
Date:   Sat, 23 Sep 2023 12:08:06 +0200
Message-Id: <20230923100806.1762943-3-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230923100806.1762943-1-u.kleine-koenig@pengutronix.de>
References: <20230923100806.1762943-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1804; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=oGx/T9R7JDurOdYPHegJL1iwZNpx/77lykGWyxyua/k=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlDrkClrT0fOZUDH0IoLSiJBh7iUBet33jQ9wCR hWJPlhlKtyJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZQ65AgAKCRCPgPtYfRL+ Tr34B/41OVw/FLj/PeGxTwGskAfoT1Pf7Ziot5aGnHoB4z6S7ho/AGKPR7uhIZ0+9P/Zai7c8pR /4WwKh9T+ffAFVGv9G46uOUEcXMldphHSL4YaMcGeiFMbFjQdX45rkH4360DnEf6l8ggE+dNNay eYtJxhKvG/ODzGQ/tN56ckh4ECiW4uraeNPXMs6+b4NIgPcGbHKfqSICM1tZ/FtlN+pob0OahC9 3iFUanuvResYPJVtthrdeRbvG12upDwv+VyTOex/BDuqR6tZWUKPY8RxW2PDiYnWkc2TPwci9Aa RCsOMNy6V89Y0fRVTEjsv6s5WrBLsWOo8+ZIyBAufCMF4/9z
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

All callers ignore the return value, so simplify by not providing one.

Note that crypto_engine_exit() is typically called in a device driver's
remove path (or the error path in probe), where errors cannot be handled
anyhow.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 crypto/crypto_engine.c  | 8 ++------
 include/crypto/engine.h | 2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 108d9d55c509..e60a0eb628e8 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -552,20 +552,16 @@ EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
 /**
  * crypto_engine_exit - free the resources of hardware engine when exit
  * @engine: the hardware engine need to be freed
- *
- * Return 0 for success.
  */
-int crypto_engine_exit(struct crypto_engine *engine)
+void crypto_engine_exit(struct crypto_engine *engine)
 {
 	int ret;
 
 	ret = crypto_engine_stop(engine);
 	if (ret)
-		return ret;
+		return;
 
 	kthread_destroy_worker(engine->kworker);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_engine_exit);
 
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 2835069c5997..545dbefe3e13 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -78,7 +78,7 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 						       bool retry_support,
 						       int (*cbk_do_batch)(struct crypto_engine *engine),
 						       bool rt, int qlen);
-int crypto_engine_exit(struct crypto_engine *engine);
+void crypto_engine_exit(struct crypto_engine *engine);
 
 int crypto_engine_register_aead(struct aead_engine_alg *alg);
 void crypto_engine_unregister_aead(struct aead_engine_alg *alg);
-- 
2.40.1

