From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/3] crypto: qat: Fix typo in name of tasklet_struct
Date: Wed, 10 Sep 2014 14:07:31 -0700
Message-ID: <20140910210731.25455.18427.stgit@tstruk-mobl1>
References: <20140910210559.25455.16693.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, bruce.w.allan@intel.com, qat-linux@intel.com,
	conor.mcloughlin@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17026 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbaIJVK3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Sep 2014 17:10:29 -0400
In-Reply-To: <20140910210559.25455.16693.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix typo. resp_hanlder should be resp_handler

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 .../crypto/qat/qat_common/adf_transport_internal.h |    2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index f854bac..c405460 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -75,7 +75,7 @@ struct adf_etr_ring_data {
 
 struct adf_etr_bank_data {
 	struct adf_etr_ring_data rings[ADF_ETR_MAX_RINGS_PER_BANK];
-	struct tasklet_struct resp_hanlder;
+	struct tasklet_struct resp_handler;
 	void __iomem *csr_addr;
 	struct adf_accel_dev *accel_dev;
 	uint32_t irq_coalesc_timer;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
index 1082e3b..67ec61e 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
@@ -89,7 +89,7 @@ static irqreturn_t adf_msix_isr_bundle(int irq, void *bank_ptr)
 	struct adf_etr_bank_data *bank = bank_ptr;
 
 	WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number, 0);
-	tasklet_hi_schedule(&bank->resp_hanlder);
+	tasklet_hi_schedule(&bank->resp_handler);
 	return IRQ_HANDLED;
 }
 
@@ -217,7 +217,7 @@ static int adf_setup_bh(struct adf_accel_dev *accel_dev)
 	int i;
 
 	for (i = 0; i < hw_data->num_banks; i++)
-		tasklet_init(&priv_data->banks[i].resp_hanlder,
+		tasklet_init(&priv_data->banks[i].resp_handler,
 			     adf_response_handler,
 			     (unsigned long)&priv_data->banks[i]);
 	return 0;
@@ -230,8 +230,8 @@ static void adf_cleanup_bh(struct adf_accel_dev *accel_dev)
 	int i;
 
 	for (i = 0; i < hw_data->num_banks; i++) {
-		tasklet_disable(&priv_data->banks[i].resp_hanlder);
-		tasklet_kill(&priv_data->banks[i].resp_hanlder);
+		tasklet_disable(&priv_data->banks[i].resp_handler);
+		tasklet_kill(&priv_data->banks[i].resp_handler);
 	}
 }
 
