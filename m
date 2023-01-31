Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86B4C636D6
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjAaIDm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjAaIC6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:58 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D1046084
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:43 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlbE-005vtF-9Z; Tue, 31 Jan 2023 16:02:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:40 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:40 +0800
Subject: [PATCH 27/32] crypto: mxs-dcp - Use request_complete helpers
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
Message-Id: <E1pMlbE-005vtF-9Z@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the request_complete helpers instead of calling the completion
function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/mxs-dcp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d6f9e2fe863d..1c11946a4f0b 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -413,11 +413,11 @@ static int dcp_chan_thread_aes(void *data)
 		set_current_state(TASK_RUNNING);
 
 		if (backlog)
-			backlog->complete(backlog, -EINPROGRESS);
+			crypto_request_complete(backlog, -EINPROGRESS);
 
 		if (arq) {
 			ret = mxs_dcp_aes_block_crypt(arq);
-			arq->complete(arq, ret);
+			crypto_request_complete(arq, ret);
 		}
 	}
 
@@ -709,11 +709,11 @@ static int dcp_chan_thread_sha(void *data)
 		set_current_state(TASK_RUNNING);
 
 		if (backlog)
-			backlog->complete(backlog, -EINPROGRESS);
+			crypto_request_complete(backlog, -EINPROGRESS);
 
 		if (arq) {
 			ret = dcp_sha_req_to_buf(arq);
-			arq->complete(arq, ret);
+			crypto_request_complete(arq, ret);
 		}
 	}
 
