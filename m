Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F532C636D6
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjAaIDo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjAaIDE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:03:04 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D3CC9
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:51 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlbM-005vur-QD; Tue, 31 Jan 2023 16:02:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:48 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:48 +0800
Subject: [PATCH 31/32] crypto: sahara - Use request_complete helpers
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
Message-Id: <E1pMlbM-005vur-QD@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the request_complete helpers instead of calling the completion
function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/sahara.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 7ab20fb95166..dd4c703cd855 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1049,7 +1049,7 @@ static int sahara_queue_manage(void *data)
 		spin_unlock_bh(&dev->queue_spinlock);
 
 		if (backlog)
-			backlog->complete(backlog, -EINPROGRESS);
+			crypto_request_complete(backlog, -EINPROGRESS);
 
 		if (async_req) {
 			if (crypto_tfm_alg_type(async_req->tfm) ==
@@ -1065,7 +1065,7 @@ static int sahara_queue_manage(void *data)
 				ret = sahara_aes_process(req);
 			}
 
-			async_req->complete(async_req, ret);
+			crypto_request_complete(async_req, ret);
 
 			continue;
 		}
