From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - replace hardcoded BIT(0) in vf_isr
Date: Thu, 22 Dec 2016 14:59:40 +0000
Message-ID: <20161222145940.5952-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24999 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756592AbcLVO74 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 09:59:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace BIT(0) macro with proper definition in pf2vf path

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index bf99e11..4a73fc7 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -148,7 +148,7 @@ static void adf_pf2vf_bh_handler(void *data)
 		INIT_WORK(&stop_data->work, adf_dev_stop_async);
 		queue_work(adf_vf_stop_wq, &stop_data->work);
 		/* To ack, clear the PF2VFINT bit */
-		msg &= ~BIT(0);
+		msg &= ~ADF_PF2VF_INT;
 		ADF_CSR_WR(pmisc_bar_addr, hw_data->get_pf2vf_offset(0), msg);
 		return;
 	}
@@ -168,7 +168,7 @@ static void adf_pf2vf_bh_handler(void *data)
 	}
 
 	/* To ack, clear the PF2VFINT bit */
-	msg &= ~BIT(0);
+	msg &= ~ADF_PF2VF_INT;
 	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_pf2vf_offset(0), msg);
 
 	/* Re-enable PF2VF interrupts */
-- 
2.9.3
