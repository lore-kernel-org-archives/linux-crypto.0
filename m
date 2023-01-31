Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5BFC636D6
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjAaICN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjAaICF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:05 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC8940BF5
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:05 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlac-005vhS-9R; Tue, 31 Jan 2023 16:02:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:02 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:02 +0800
Subject: [PATCH 9/32] crypto: engine - Use crypto_request_complete
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        linux-arm-kernel@axis.com,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com, Thara Gopinath <thara.gopinath@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Message-Id: <E1pMlac-005vhS-9R@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the crypto_request_complete helper instead of calling the
completion function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_engine.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 64dc9aa3ca24..21f791615114 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -54,7 +54,7 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 		}
 	}
 	lockdep_assert_in_softirq();
-	req->complete(req, err);
+	crypto_request_complete(req, err);
 
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
 }
@@ -130,7 +130,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		engine->cur_req = async_req;
 
 	if (backlog)
-		backlog->complete(backlog, -EINPROGRESS);
+		crypto_request_complete(backlog, -EINPROGRESS);
 
 	if (engine->busy)
 		was_busy = true;
@@ -214,7 +214,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	}
 
 req_err_2:
-	async_req->complete(async_req, ret);
+	crypto_request_complete(async_req, ret);
 
 retry:
 	/* If retry mechanism is supported, send new requests to engine */
