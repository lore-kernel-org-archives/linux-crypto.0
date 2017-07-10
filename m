From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 09/13] crypto: caam/qi - lower driver verbosity
Date: Mon, 10 Jul 2017 08:40:35 +0300
Message-ID: <20170710054039.21555-10-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
 <20170710054039.21555-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0048.outbound.protection.outlook.com ([104.47.37.48]:58775
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751161AbdGJFlK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 01:41:10 -0400
In-Reply-To: <20170710054039.21555-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change log level for some prints from dev_info() to dev_dbg(), low-level
details are needed only when debugging.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/qi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 1c1f3faf6394..6d5a010a1881 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -201,8 +201,8 @@ static struct qman_fq *create_caam_req_fq(struct device *qidev,
 		goto init_req_fq_fail;
 	}
 
-	dev_info(qidev, "Allocated request FQ %u for CPU %u\n", req_fq->fqid,
-		 smp_processor_id());
+	dev_dbg(qidev, "Allocated request FQ %u for CPU %u\n", req_fq->fqid,
+		smp_processor_id());
 	return req_fq;
 
 init_req_fq_fail:
@@ -643,7 +643,7 @@ static int alloc_rsp_fq_cpu(struct device *qidev, unsigned int cpu)
 
 	per_cpu(pcpu_qipriv.rsp_fq, cpu) = fq;
 
-	dev_info(qidev, "Allocated response FQ %u for CPU %u", fq->fqid, cpu);
+	dev_dbg(qidev, "Allocated response FQ %u for CPU %u", fq->fqid, cpu);
 	return 0;
 }
 
@@ -676,7 +676,7 @@ static int init_cgr(struct device *qidev)
 		return ret;
 	}
 
-	dev_info(qidev, "Congestion threshold set to %llu\n", val);
+	dev_dbg(qidev, "Congestion threshold set to %llu\n", val);
 	return 0;
 }
 
-- 
2.12.0.264.gd6db3f216544
