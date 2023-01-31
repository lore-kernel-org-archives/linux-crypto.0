Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6F2C38142
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjAaIDk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjAaIC4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:56 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8AD46097
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:38 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlb9-005vsN-Vt; Tue, 31 Jan 2023 16:02:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:35 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:35 +0800
Subject: [PATCH 25/32] crypto: octeontx - Use request_complete helpers
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
Message-Id: <E1pMlb9-005vsN-Vt@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the request_complete helpers instead of calling the completion
function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 83493dd0416f..1c2c870e887a 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -138,7 +138,7 @@ static void otx_cpt_aead_callback(int status, void *arg1, void *arg2)
 
 complete:
 	if (areq)
-		areq->complete(areq, status);
+		crypto_request_complete(areq, status);
 }
 
 static void output_iv_copyback(struct crypto_async_request *areq)
@@ -188,7 +188,7 @@ static void otx_cpt_skcipher_callback(int status, void *arg1, void *arg2)
 			pdev = cpt_info->pdev;
 			do_request_cleanup(pdev, cpt_info);
 		}
-		areq->complete(areq, status);
+		crypto_request_complete(areq, status);
 	}
 }
 
