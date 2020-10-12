Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3012DC43457
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD4B2145D
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgJLUjh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730636AbgJLUjh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:37 -0400
IronPort-SDR: 2ZaON1vbzZv1dI5nfrVnpWIvSdzduKzvT65ptWAQbdf7e+NWNq0xYLQKl1yjaDwmQeraWuwk+E
 /qSJyhbmvx8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913145"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913145"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:37 -0700
IronPort-SDR: h+bsIcJOn26VYFu3VUcUYUa1tYBf9ZwwxxHA+IjhHVeAXmTjHe4TshKQsv9E7W1s6IE8D7u5c5
 TSmS3VY/oqIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328218"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:35 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 18/31] crypto: qat - enable ring after pair is programmed
Date:   Mon, 12 Oct 2020 21:38:34 +0100
Message-Id: <20201012203847.340030-19-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable arbitration on the TX ring only after the RX ring is programmed.

Before this change, arbitration was enabled on the TX ring before the RX
ring was programmed allowing the HW to process a request before having
the ring pair configured.
With this change, the arbitration logic is programmed only if the TX
half of the ring mask matches the RX half.

This change does not affect QAT GEN2 devices (c62x, c3xxx and dh895xcc),
but it is a must for QAT GEN4 devices since the CSRs of the ring pair
are locked after arbitration is enabled on the TX ring.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../crypto/qat/qat_common/adf_hw_arbiter.c    | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
index 9dc9d58f6093..bd03c8f54eb4 100644
--- a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
@@ -55,9 +55,27 @@ EXPORT_SYMBOL_GPL(adf_init_arb);
 
 void adf_update_ring_arb(struct adf_etr_ring_data *ring)
 {
+	struct adf_accel_dev *accel_dev = ring->bank->accel_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 tx_ring_mask = hw_data->tx_rings_mask;
+	u32 shift = hw_data->tx_rx_gap;
+	u32 arben, arben_tx, arben_rx;
+	u32 rx_ring_mask;
+
+	/*
+	 * Enable arbitration on a ring only if the TX half of the ring mask
+	 * matches the RX part. This results in writes to CSR on both TX and
+	 * RX update - only one is necessary, but both are done for
+	 * simplicity.
+	 */
+	rx_ring_mask = tx_ring_mask << shift;
+	arben_tx = (ring->bank->ring_mask & tx_ring_mask) >> 0;
+	arben_rx = (ring->bank->ring_mask & rx_ring_mask) >> shift;
+	arben = arben_tx & arben_rx;
+
 	WRITE_CSR_ARB_RINGSRVARBEN(ring->bank->csr_addr,
 				   ring->bank->bank_number,
-				   ring->bank->ring_mask & 0xFF);
+				   arben);
 }
 
 void adf_exit_arb(struct adf_accel_dev *accel_dev)
-- 
2.26.2

