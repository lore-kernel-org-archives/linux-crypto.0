Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2ECC38147
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Jan 2023 17:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjARRPk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Jan 2023 12:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjARRPj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2023 12:15:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF424B48A
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2023 09:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674062138; x=1705598138;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Qr2yti9Y2SttmzhbN0rQYK2Gj+ItSWFONIYmsPA476U=;
  b=X5gdxtAFh6gtBzN3ukOgleKE9hHjOjTzmj98Ox4t1mlVAu7fpPhsCeqV
   nKXMLCjgqV7SLBVNIFXrUL3rqa/OmwvdxMtWesn4IvTb/UekqxZ9dZqHh
   86i/qmbgPjgZtqc4wTeHkclcZEdreSoFa0QFD5+NwFk45KL8Nia6j7Jir
   Jri+zXozXHWL4fwQdth5HWQWGH6B9v9i9Bic5LK4vKCfmOEEObX+xCGzc
   6bScGdWN7ytVcYHjaf4x76VaN03Clp71XjtrGkG0/0s1YlrdqwuXxA+2+
   UCqt37OrETBTHxkew7MBPEjci2Je1pkK4E1K84C2T8zA/k0JmQoVOFbZk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="312916457"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="312916457"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 09:14:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="692074558"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="692074558"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga001.jf.intel.com with ESMTP; 18 Jan 2023 09:14:14 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     linux-crypto@vger.kernel.org
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [RFC] crypto: qat - enable polling for compression
Date:   Wed, 18 Jan 2023 17:14:11 +0000
Message-Id: <20230118171411.8088-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When a request is synchronous, it is more efficient to submit it and
poll for a response without going through the interrupt path.

This patch adds logic in the transport layer to poll the response ring
and enables polling for compression in the QAT driver.

This is an initial and not complete implementation. The reason why it
has been sent as RFC is to discuss about ways to mark a request as
synchronous from the acomp APIs.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport.c | 28 +++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_transport.h |  1 +
 drivers/crypto/qat/qat_common/qat_comp_algs.c |  9 +++++-
 .../crypto/qat/qat_common/qat_compression.c   |  2 +-
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 630d0483c4e0..af613ee84cdc 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -133,6 +133,34 @@ static int adf_handle_response(struct adf_etr_ring_data *ring)
 	return 0;
 }
 
+int adf_poll_message(struct adf_etr_ring_data *ring)
+{
+	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(ring->bank->accel_dev);
+	u32 msg_counter = 0;
+	u32 *msg = (u32 *)((uintptr_t)ring->base_addr + ring->head);
+
+	if (atomic_read(ring->inflights) == 0)
+		return 0;
+
+	while (*msg != ADF_RING_EMPTY_SIG) {
+		ring->callback((u32 *)msg);
+		atomic_dec(ring->inflights);
+		*msg = ADF_RING_EMPTY_SIG;
+		ring->head = adf_modulo(ring->head +
+					ADF_MSG_SIZE_TO_BYTES(ring->msg_size),
+					ADF_RING_SIZE_MODULO(ring->ring_size));
+		msg_counter++;
+		msg = (u32 *)((uintptr_t)ring->base_addr + ring->head);
+	}
+	if (msg_counter > 0) {
+		csr_ops->write_csr_ring_head(ring->bank->csr_addr,
+					     ring->bank->bank_number,
+					     ring->ring_number, ring->head);
+		return 0;
+	}
+	return -EAGAIN;
+}
+
 static void adf_configure_tx_ring(struct adf_etr_ring_data *ring)
 {
 	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(ring->bank->accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_transport.h b/drivers/crypto/qat/qat_common/adf_transport.h
index e6ef6f9b7691..d549081172f8 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.h
+++ b/drivers/crypto/qat/qat_common/adf_transport.h
@@ -16,5 +16,6 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 
 bool adf_ring_nearly_full(struct adf_etr_ring_data *ring);
 int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg);
+int adf_poll_message(struct adf_etr_ring_data *ring);
 void adf_remove_ring(struct adf_etr_ring_data *ring);
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_comp_algs.c b/drivers/crypto/qat/qat_common/qat_comp_algs.c
index 1480d36a8d2b..07378e9fe8fa 100644
--- a/drivers/crypto/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_comp_algs.c
@@ -291,8 +291,15 @@ static int qat_comp_alg_compress_decompress(struct acomp_req *areq,
 	}
 
 	ret = qat_alg_send_dc_message(qat_req, inst, &areq->base);
-	if (ret == -ENOSPC)
+	if (ret == -ENOSPC) {
 		qat_bl_free_bufl(inst->accel_dev, &qat_req->buf);
+		return ret;
+	}
+
+	do {
+		ret = adf_poll_message(inst->dc_rx);
+		schedule();
+	} while (ret);
 
 	return ret;
 }
diff --git a/drivers/crypto/qat/qat_common/qat_compression.c b/drivers/crypto/qat/qat_common/qat_compression.c
index 9fd10f4242f8..49b34c5ec595 100644
--- a/drivers/crypto/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/qat/qat_common/qat_compression.c
@@ -174,7 +174,7 @@ static int qat_compression_create_instances(struct adf_accel_dev *accel_dev)
 		msg_size = ICP_QAT_FW_RESP_DEFAULT_SZ;
 		snprintf(key, sizeof(key), ADF_DC "%d" ADF_RING_DC_RX, i);
 		ret = adf_create_ring(accel_dev, SEC, bank, num_msg_dc,
-				      msg_size, key, qat_comp_alg_callback, 0,
+				      msg_size, key, qat_comp_alg_callback, 1,
 				      &inst->dc_rx);
 		if (ret)
 			return ret;
-- 
2.39.0

