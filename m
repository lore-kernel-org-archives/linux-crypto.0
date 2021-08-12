Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E90CC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B56D60EB2
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhHLUWI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:4133 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232564AbhHLUWG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474000"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474000"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:21:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608551"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:21:38 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 01/20] crypto: qat - use proper type for vf_mask
Date:   Thu, 12 Aug 2021 21:21:10 +0100
Message-Id: <20210812202129.18831-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace vf_mask type with unsigned long to avoid a stack-out-of-bound.

This is to fix the following warning reported by KASAN the first time
adf_msix_isr_ae() gets called.

    [  692.091987] BUG: KASAN: stack-out-of-bounds in find_first_bit+0x28/0x50
    [  692.092017] Read of size 8 at addr ffff88afdf789e60 by task swapper/32/0
    [  692.092076] Call Trace:
    [  692.092089]  <IRQ>
    [  692.092101]  dump_stack+0x9c/0xcf
    [  692.092132]  print_address_description.constprop.0+0x18/0x130
    [  692.092164]  ? find_first_bit+0x28/0x50
    [  692.092185]  kasan_report.cold+0x7f/0x111
    [  692.092213]  ? static_obj+0x10/0x80
    [  692.092234]  ? find_first_bit+0x28/0x50
    [  692.092262]  find_first_bit+0x28/0x50
    [  692.092288]  adf_msix_isr_ae+0x16e/0x230 [intel_qat]

Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_isr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index e3ad5587be49..daab02011717 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -15,6 +15,8 @@
 #include "adf_transport_access_macros.h"
 #include "adf_transport_internal.h"
 
+#define ADF_MAX_NUM_VFS	32
+
 static int adf_enable_msix(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
@@ -72,7 +74,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 		struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 		void __iomem *pmisc_bar_addr = pmisc->virt_addr;
-		u32 vf_mask;
+		unsigned long vf_mask;
 
 		/* Get the interrupt sources triggered by VFs */
 		vf_mask = ((ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU5) &
@@ -93,8 +95,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 			 * unless the VF is malicious and is attempting to
 			 * flood the host OS with VF2PF interrupts.
 			 */
-			for_each_set_bit(i, (const unsigned long *)&vf_mask,
-					 (sizeof(vf_mask) * BITS_PER_BYTE)) {
+			for_each_set_bit(i, &vf_mask, ADF_MAX_NUM_VFS) {
 				vf_info = accel_dev->pf.vf_info + i;
 
 				if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
-- 
2.31.1

