From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 03/13] crypto: caam/qi - fix compilation with CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
Date: Fri, 7 Jul 2017 16:05:13 +0300
Message-ID: <20170707130523.32427-4-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:63401
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750878AbdGGNFx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 09:05:53 -0400
In-Reply-To: <20170707130523.32427-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caam/qi driver fails to compile when CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y.
Fix it by making the offending local per_cpu variable global.

Cc: <stable@vger.kernel.org>
Fixes: 67c2315def06c ("crypto: caam - add Queue Interface (QI) backend support")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/qi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 1990ed460c46..53aed5816416 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -55,6 +55,7 @@ struct caam_qi_pcpu_priv {
 } ____cacheline_aligned;
 
 static DEFINE_PER_CPU(struct caam_qi_pcpu_priv, pcpu_qipriv);
+static DEFINE_PER_CPU(int, last_cpu);
 
 /*
  * caam_qi_priv - CAAM QI backend private params
@@ -392,7 +393,6 @@ struct caam_drv_ctx *caam_drv_ctx_init(struct device *qidev,
 	dma_addr_t hwdesc;
 	struct caam_drv_ctx *drv_ctx;
 	const cpumask_t *cpus = qman_affine_cpus();
-	static DEFINE_PER_CPU(int, last_cpu);
 
 	num_words = desc_len(sh_desc);
 	if (num_words > MAX_SDLEN) {
-- 
2.12.0.264.gd6db3f216544
