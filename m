Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA927C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345868AbiDGQxW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345844AbiDGQxM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEC55DE78
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350271; x=1680886271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nKMjKa7P8iE+d2qWgKFj9xmHYb9DshK9Ru74HI5pbkA=;
  b=fdvacGwoEM43em2diO503xhw+Na4TCQ66UV3IUDhSv2LvoNYFzMx+h3x
   B/ef+czu+6lg93SHsIwrSbieZouaptTOVZ+8IGh4sZOk/wbEsOygrVRvH
   saLILZpQUsJr7Z7j75hkygczm6mv6ZIKdv9XJw8dEz/8kEzWHTVsMBfIB
   fvBsscOouBbvFprmwuWvF94Z+eoHt9FZ4a9CMJQxyrfEHD/gGEJyIY7pj
   P97/kz5njUH28b1PKfNmhCvkSi17+Fjyp9TZh8CqT9U88rFcdrThrT5CA
   2qJGW6nmtNFFHg4HmPICgyudP903EDpaM9WjanQ8wjG+AU600d2e5csHR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312042"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312042"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898323"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:09 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 05/16] crypto: qat - remove unused PFVF stubs
Date:   Thu,  7 Apr 2022 17:54:44 +0100
Message-Id: <20220407165455.256777-6-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The functions adf_enable_pf2vf_interrupts(), adf_flush_vf_wq() and
adf_disable_pf2vf_interrupts() are not referenced when the driver is
compiled with CONFIG_PCI_IOV=n. This patch removes these unused stubs.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index e8c9b77c0d66..feecf1035a90 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -217,14 +217,6 @@ static inline void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 {
 }
 
-static inline void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
-{
-}
-
-static inline void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
-{
-}
-
 static inline int adf_init_pf_wq(void)
 {
 	return 0;
@@ -243,10 +235,6 @@ static inline void adf_exit_vf_wq(void)
 {
 }
 
-static inline void adf_flush_vf_wq(struct adf_accel_dev *accel_dev)
-{
-}
-
 #endif
 
 static inline void __iomem *adf_get_pmisc_base(struct adf_accel_dev *accel_dev)
-- 
2.34.1

