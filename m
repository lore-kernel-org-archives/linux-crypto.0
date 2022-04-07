Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02613C4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345844AbiDGQxY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345833AbiDGQxO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7393700B
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350274; x=1680886274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jw3UQ8ojxhq/Fcg4RvfL/PcsmV367ro/g+enUqfCBr4=;
  b=lbfHbPTYGzCxtxh5m3Jl//0CPdNhBaKEvuXL1HSrsJ0w1GGMsmMqtElO
   dNQTz6QWq+4HKMG/wozGyZFeCtjfq7SZms4MieaYTlsEENgQtfq3Ub7D+
   ngBSIBdueEzxnW/Si5NBs3D6NzbjVp0K2D2kz7fFbQx8Yb45O2sQekF7t
   /kLIWtC0GqgdokiHH8Xq6eYEdVBEChHlmbW6i+ypNdNut/+a8jFkg7buS
   xFDODtCWOz4TYik/QR+dacjX0a9PpNr94+YLRxOVSwKdhsoB0GDDZv7s2
   PnWZq0u1Jk/WUKW82dXwiLzYwur4TtuzUWaU7/cmqs+8WfZE6DUSih87b
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312050"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312050"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898355"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:12 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 07/16] crypto: qat - add missing restarting event notification in VFs
Date:   Thu,  7 Apr 2022 17:54:46 +0100
Message-Id: <20220407165455.256777-8-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VF drivers are notified via PFVF of the VFs being disabled, but
such notification was not propagated within the VF driver.
Dispatch the ADF_EVENT_RESTARTING event by adding a missing call
to adf_dev_restarting_notify().

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 86c3bd0c9c2b..8c95fcd8e64b 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -70,6 +70,7 @@ static void adf_dev_stop_async(struct work_struct *work)
 		container_of(work, struct adf_vf_stop_data, work);
 	struct adf_accel_dev *accel_dev = stop_data->accel_dev;
 
+	adf_dev_restarting_notify(accel_dev);
 	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 
-- 
2.34.1

