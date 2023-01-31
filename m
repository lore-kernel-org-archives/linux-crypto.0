Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF3AC636CC
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjAaICt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjAaICY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:24 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB61B45F67
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:19 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlar-005vm9-7P; Tue, 31 Jan 2023 16:02:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:17 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:17 +0800
Subject: [PATCH 16/32] crypto: nitrox - Use request_complete helpers
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
Message-Id: <E1pMlar-005vm9-7P@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the request_complete helpers instead of calling the completion
function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/cavium/nitrox/nitrox_aead.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_aead.c b/drivers/crypto/cavium/nitrox/nitrox_aead.c
index 0653484df23f..b0e53034164a 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_aead.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_aead.c
@@ -199,7 +199,7 @@ static void nitrox_aead_callback(void *arg, int err)
 		err = -EINVAL;
 	}
 
-	areq->base.complete(&areq->base, err);
+	aead_request_complete(areq, err);
 }
 
 static inline bool nitrox_aes_gcm_assoclen_supported(unsigned int assoclen)
@@ -434,7 +434,7 @@ static void nitrox_rfc4106_callback(void *arg, int err)
 		err = -EINVAL;
 	}
 
-	areq->base.complete(&areq->base, err);
+	aead_request_complete(areq, err);
 }
 
 static int nitrox_rfc4106_enc(struct aead_request *areq)
