Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37836C77B73
	for <linux-crypto@archiver.kernel.org>; Tue, 30 May 2023 16:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbjE3QCE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 May 2023 12:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbjE3QB7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2023 12:01:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F8511B
        for <linux-crypto@vger.kernel.org>; Tue, 30 May 2023 09:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685462515; x=1716998515;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IzSICJ/W3j+Ownu4e2oFaqoKJ3yEX5ONKpMOVJw9BBA=;
  b=OqGCsRX0gwtlLW+zxsw8RMNIPvfHr/9Nxl+vcfHCSHonEZ53mldgyr63
   BNfnxIxArFz1JZYVy+uRhNZgW35x5k1IjmYYXO9hCQh9YtYg5813Kcn0+
   e14RaHKd51hQchijDCqRAhWSTblPE8msiKwwY5/HZvxEZOR8XEmeeIRuo
   E7TbKxyQQ1hzEJb7oMDn5U4wKuVStTDm6mfzOQzrG9P63Xv5PDiR4C3d3
   HxNUn8vj0LTPzfEvGJC2VnF8izG1ggfHq68cF+oE4Oe91shySxcBNb0C3
   yfaJ/9dV6WtQyd4I3nT6sgNndpFVVZN1a7VzvkUfKaNMaPVkoco2ypQKY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="441319734"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="441319734"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 09:01:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="776379558"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="776379558"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by fmsmga004.fm.intel.com with ESMTP; 30 May 2023 09:01:52 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Karthikeyan Gopal <karthikeyan.gopal@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - update slice mask for 4xxx devices
Date:   Tue, 30 May 2023 17:01:47 +0100
Message-Id: <20230530160147.9977-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Karthikeyan Gopal <karthikeyan.gopal@intel.com>

Update slice mask enum for 4xxx device with BIT(7) to mask SMX fuse.
This change is done to align the slice mask with the hardware fuse
register.

Signed-off-by: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h
index 085e259c245a..e5b314d2b60e 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.h
@@ -72,7 +72,7 @@ enum icp_qat_4xxx_slice_mask {
 	ICP_ACCEL_4XXX_MASK_COMPRESS_SLICE = BIT(3),
 	ICP_ACCEL_4XXX_MASK_UCS_SLICE = BIT(4),
 	ICP_ACCEL_4XXX_MASK_EIA3_SLICE = BIT(5),
-	ICP_ACCEL_4XXX_MASK_SMX_SLICE = BIT(6),
+	ICP_ACCEL_4XXX_MASK_SMX_SLICE = BIT(7),
 };
 
 void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id);
-- 
2.40.1

