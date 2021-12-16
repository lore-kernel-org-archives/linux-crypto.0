Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A8FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhLPJLg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:36 -0500
Received: from mga12.intel.com ([192.55.52.136]:9683 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232888AbhLPJLe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645894; x=1671181894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U25gde491WTGhSUqTUeM0lvLr3rTCGjvib2coeNmkRE=;
  b=m5F1qwjr8GtZf/Q4L/gwysP7tLLv7+5F7R8yszZB6gO3/hSieZgn2nB9
   HIBVVJ3PfZpu5b0Iq14Ze6dQYtq73Mb1QEPFHMUlfacB7Sq2djRZcxvll
   iz9poTsGOeKOGJbu6gqx67VhPHdE3owBKf1YpOlgRR7y7DXHVgnTcOF3U
   82SxGarOJDOh3dX/9SlLRSehr18jwYCbuQIxnIeCh9LjRJ7323G/NCiLo
   Fb3PdwdNbubfTQylRwvyNrxSrarTrbPpiUCzgWLH4A3CM7i2vWhG2XxfI
   qBL9wm93nbjXxQml24G7/Vtk02eN0TPZeOSuU7y6/Tdw+3qRgZB4ZIAzH
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458441"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458441"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968507"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:32 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 12/24] crypto: qat - leverage read_poll_timeout in PFVF send
Date:   Thu, 16 Dec 2021 09:13:22 +0000
Message-Id: <20211216091334.402420-13-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the polling loop, waiting for the remote end to acknowledge
the reception of the message, with the equivalent and standard
read_poll_timeout() in adf_gen2_pfvf_send().

Also, the use of the read_poll_timeout():
- implies the use of microseconds for the timings, so update the previous
  values from ms to us
- allows to leverage the return value for both success and error,
  removing the need for the reset of the 'ret' variable soon after the
  'start' label.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 7a927bea4ac6..53c2e124944d 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2021 Intel Corporation */
 #include <linux/delay.h>
+#include <linux/iopoll.h>
 #include <linux/mutex.h>
 #include <linux/types.h>
 #include "adf_accel_devices.h"
@@ -36,8 +37,8 @@ static const struct pfvf_csr_format csr_gen2_fmt = {
 	{ ADF_PFVF_GEN2_MSGDATA_SHIFT, ADF_PFVF_GEN2_MSGDATA_MASK },
 };
 
-#define ADF_PFVF_MSG_ACK_DELAY		2
-#define ADF_PFVF_MSG_ACK_MAX_RETRY	100
+#define ADF_PFVF_MSG_ACK_DELAY_US	2000
+#define ADF_PFVF_MSG_ACK_MAX_DELAY_US	(ADF_PFVF_MSG_ACK_DELAY_US * 100)
 
 #define ADF_PFVF_MSG_RETRY_DELAY	5
 #define ADF_PFVF_MSG_MAX_RETRIES	3
@@ -143,7 +144,6 @@ static int adf_gen2_pfvf_send(struct adf_accel_dev *accel_dev,
 	unsigned int retries = ADF_PFVF_MSG_MAX_RETRIES;
 	struct mutex *lock = params->csr_lock;
 	u32 pfvf_offset = params->pfvf_offset;
-	u32 count = 0;
 	u32 int_bit;
 	u32 csr_val;
 	u32 csr_msg;
@@ -172,8 +172,6 @@ static int adf_gen2_pfvf_send(struct adf_accel_dev *accel_dev,
 	mutex_lock(lock);
 
 start:
-	ret = 0;
-
 	/* Check if the PFVF CSR is in use by remote function */
 	csr_val = ADF_CSR_RD(pmisc_addr, pfvf_offset);
 	if (gen2_csr_is_in_use(csr_val, local_offset)) {
@@ -186,15 +184,13 @@ static int adf_gen2_pfvf_send(struct adf_accel_dev *accel_dev,
 	ADF_CSR_WR(pmisc_addr, pfvf_offset, csr_msg | int_bit);
 
 	/* Wait for confirmation from remote func it received the message */
-	do {
-		msleep(ADF_PFVF_MSG_ACK_DELAY);
-		csr_val = ADF_CSR_RD(pmisc_addr, pfvf_offset);
-	} while ((csr_val & int_bit) && (count++ < ADF_PFVF_MSG_ACK_MAX_RETRY));
-
-	if (csr_val & int_bit) {
+	ret = read_poll_timeout(ADF_CSR_RD, csr_val, !(csr_val & int_bit),
+				ADF_PFVF_MSG_ACK_DELAY_US,
+				ADF_PFVF_MSG_ACK_MAX_DELAY_US,
+				true, pmisc_addr, pfvf_offset);
+	if (unlikely(ret < 0)) {
 		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
 		csr_val &= ~int_bit;
-		ret = -EIO;
 	}
 
 	if (csr_val != csr_msg) {
-- 
2.31.1

