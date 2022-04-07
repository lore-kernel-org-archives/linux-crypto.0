Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42808C433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345840AbiDGQxh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345847AbiDGQx3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:29 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF77869CEC
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350288; x=1680886288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uNjy8V0/M4qdjyf8iNqFJRxnwSYwvm+J44KRt/NMdYA=;
  b=U9SSDmmkYmn5qFlMcv1zZvKRaPSjg2JYGEn+A6p7XOI4zoY3kMVjURm0
   /tyhZyU2wUYVBCFkFeQa0qfk9sW3yeneand58HPWceDlLgY3upDnl6wvM
   jLrQG1JuuUPa/yzXmCY+1yLYipBA9cQZVWMz+/ClxkoKjpp3396dn+C19
   Ne/odwpGAZ4ZGU0acTe4NfMOJ5+T1DMUQ56aCFWrtw+/zr5e+ousO3Upb
   wgbIZG6tCHvkCQFwES1zRauBW/TEZb7NLnp5zNRdGKW1i8kWyhlVep/L2
   e9C44UPu+9YlDHvT72U5PMiVtCcXcgp7eqkgHX/N6x0nzjhA4xmPsn3C9
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312114"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312114"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898408"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:26 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 16/16] crypto: qat - remove line wrapping for pfvf_ops functions
Date:   Thu,  7 Apr 2022 17:54:55 +0100
Message-Id: <20220407165455.256777-17-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove unnecessary line wrapping for the
adf_enable_vf2pf_interrupts() function, and harmonize pfvf_ops text.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h | 3 +--
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c  | 3 +--
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c  | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index da9d765834f0..0464fa257929 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -195,8 +195,7 @@ bool adf_misc_wq_queue_work(struct work_struct *work);
 #if defined(CONFIG_PCI_IOV)
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
-void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
-				 u32 vf_mask);
+void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask);
 void adf_disable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 606409533409..70ef11963938 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -51,8 +51,7 @@ static u32 adf_gen2_vf_get_pfvf_offset(u32 i)
 	return ADF_GEN2_VF_PF2VF_OFFSET;
 }
 
-static void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
-					     u32 vf_mask)
+static void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 {
 	/* Enable VF2PF Messaging Ints - VFs 0 through 15 per vf_mask[15:0] */
 	if (vf_mask & ADF_GEN2_VF_MSK) {
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
index 73ec8defb2d3..8e8efe93f3ee 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
@@ -37,8 +37,7 @@ static u32 adf_gen4_pf_get_vf2pf_offset(u32 i)
 	return ADF_4XXX_VM2PF_OFFSET(i);
 }
 
-static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
-					     u32 vf_mask)
+static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 {
 	u32 val;
 
-- 
2.34.1

