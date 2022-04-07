Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8A9C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244193AbiDGQxN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345833AbiDGQxK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B37130577
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350270; x=1680886270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RjiZqvFwjJL91T4V1UyJBpsPl+ltVVHgM2qhrxarQmw=;
  b=hRReONI1OjDlGBIMu1XWbqFp86KH+6E34IHoXbpmVygVMwfiytgiSiyg
   MnKC6TPwxwzVP/fMytYsXymAqFLB2DLEiECl9D4gZ83rTY5HWhvVOaQY2
   Pyy7Pg2VmG0RJdpUo6iy4eO9J3J34HLqbhBBMsnaoUZoyNcqVjifbFZkV
   DZBLTLcoh0gyVsD5at95k7Nhi/jSx5bMPDzXmf/wTuJ/u5qNVjcJginPS
   jq1HddC44OIw2AVHvLOtDY2nWHi3CheS+ILpAN8E+8KQa7QHlOxpQOG9+
   3p1R5jWsRQMsMi1jfYB/1EW95TfIkXGSZBs7M3YSw2AUSXIubG9DRtrs0
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312033"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312033"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898307"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:08 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 04/16] crypto: qat - remove unneeded braces
Date:   Thu,  7 Apr 2022 17:54:43 +0100
Message-Id: <20220407165455.256777-5-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove unnecessary braces around a single statement in a for loop.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_sriov.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index b960bca1f9d2..81f484cbad3d 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -117,9 +117,8 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 	if (hw_data->configure_iov_threads)
 		hw_data->configure_iov_threads(accel_dev, false);
 
-	for (i = 0, vf = accel_dev->pf.vf_info; i < totalvfs; i++, vf++) {
+	for (i = 0, vf = accel_dev->pf.vf_info; i < totalvfs; i++, vf++)
 		mutex_destroy(&vf->pf2vf_lock);
-	}
 
 	kfree(accel_dev->pf.vf_info);
 	accel_dev->pf.vf_info = NULL;
-- 
2.34.1

