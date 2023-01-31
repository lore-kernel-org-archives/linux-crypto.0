Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EEEC636CC
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjAaIDn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjAaIDD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:03:03 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD314614E
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:02:45 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlbG-005vte-GJ; Tue, 31 Jan 2023 16:02:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:02:42 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:02:42 +0800
Subject: [PATCH 28/32] crypto: qat - Use request_complete helpers
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
Message-Id: <E1pMlbG-005vte-GJ@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the request_complete helpers instead of calling the completion
function directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/qat/qat_common/qat_algs.c      |    4 ++--
 drivers/crypto/qat/qat_common/qat_algs_send.c |    3 ++-
 drivers/crypto/qat/qat_common/qat_comp_algs.c |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index b4b9f0aa59b9..bcd239b11ec0 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -676,7 +676,7 @@ static void qat_aead_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	qat_bl_free_bufl(inst->accel_dev, &qat_req->buf);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EBADMSG;
-	areq->base.complete(&areq->base, res);
+	aead_request_complete(areq, res);
 }
 
 static void qat_alg_update_iv_ctr_mode(struct qat_crypto_request *qat_req)
@@ -752,7 +752,7 @@ static void qat_skcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 
 	memcpy(sreq->iv, qat_req->iv, AES_BLOCK_SIZE);
 
-	sreq->base.complete(&sreq->base, res);
+	skcipher_request_complete(sreq, res);
 }
 
 void qat_alg_callback(void *resp)
diff --git a/drivers/crypto/qat/qat_common/qat_algs_send.c b/drivers/crypto/qat/qat_common/qat_algs_send.c
index ff5b4347f783..bb80455b3e81 100644
--- a/drivers/crypto/qat/qat_common/qat_algs_send.c
+++ b/drivers/crypto/qat/qat_common/qat_algs_send.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2022 Intel Corporation */
+#include <crypto/algapi.h>
 #include "adf_transport.h"
 #include "qat_algs_send.h"
 #include "qat_crypto.h"
@@ -34,7 +35,7 @@ void qat_alg_send_backlog(struct qat_instance_backlog *backlog)
 			break;
 		}
 		list_del(&req->list);
-		req->base->complete(req->base, -EINPROGRESS);
+		crypto_request_complete(req->base, -EINPROGRESS);
 	}
 	spin_unlock_bh(&backlog->lock);
 }
diff --git a/drivers/crypto/qat/qat_common/qat_comp_algs.c b/drivers/crypto/qat/qat_common/qat_comp_algs.c
index 1480d36a8d2b..cf0ac9f8ea83 100644
--- a/drivers/crypto/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_comp_algs.c
@@ -94,7 +94,7 @@ static void qat_comp_resubmit(struct work_struct *work)
 
 err:
 	qat_bl_free_bufl(accel_dev, qat_bufs);
-	areq->base.complete(&areq->base, ret);
+	acomp_request_complete(areq, ret);
 }
 
 static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
@@ -169,7 +169,7 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
 
 end:
 	qat_bl_free_bufl(accel_dev, &qat_req->buf);
-	areq->base.complete(&areq->base, res);
+	acomp_request_complete(areq, res);
 }
 
 void qat_comp_alg_callback(void *resp)
