Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07918C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Feb 2022 18:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238565AbiBISAu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbiBISAt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 13:00:49 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CD1C05CB82;
        Wed,  9 Feb 2022 10:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644429652; x=1675965652;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z2zWrH2HkZBNXsLzdL6i8wAQzbfQXjTz9qslPV+fO6Q=;
  b=hUN6KsgqIQf/JR9uK6MPeieyS2B+5Vra7dwR2fD4J3Dfu1lfWHkak5u9
   fsDYLgvTRXQAqIEAAHQDdxz1O+FJSsI/LTRf/f+yiLEudeNtxUtHmGgm5
   ovnrQFbTTDIGxblCX0AZQXmoJy2zdyWoISSlVcBmawgzXiq3mnw7EC2Ga
   U1fFLvC08of/61t5dRbrXSDcCZ1JPWlazP2KJyTFMg1QBB/vVsRlKpSP2
   VJvGvLmv2eAi26aCIfIZDubS+AO0RlFJnAV5e0k7NTEB3oTtoeBwIJdQS
   W+u3ShaqqJKkyyv6gkF3oU4Kwi+K3bIH1Gx3Z6eLoQkX/XbFNkzrzQr4w
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="246865443"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="246865443"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 10:00:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="585657289"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 09 Feb 2022 10:00:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 7576E107; Wed,  9 Feb 2022 20:00:49 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Jack Xu <jack.xu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Zhehui Xiang <zhehui.xiang@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] crypto: qat - don't cast parameter in bit operations
Date:   Wed,  9 Feb 2022 20:00:47 +0200
Message-Id: <20220209180047.54829-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While in this particular case it would not be a (critical) issue,
the pattern itself is bad and error prone in case the location
of the parameter is changed.

Don't cast parameter to unsigned long pointer in the bit operations.
Instead copy to a local variable on stack of a proper type and use.

Fixes: b4b7e67c917f ("crypto: qat - Intel(R) QAT ucode part of fw loader")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 2026cc6be8f0..6356402a2c9e 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -387,7 +387,9 @@ static int qat_uclo_init_ustore(struct icp_qat_fw_loader_handle *handle,
 	page = image->page;
 
 	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
-		if (!test_bit(ae, (unsigned long *)&uof_image->ae_assigned))
+		unsigned long ae_assigned = uof_image->ae_assigned;
+
+		if (!test_bit(ae, &ae_assigned))
 			continue;
 
 		if (!test_bit(ae, &cfg_ae_mask))
@@ -664,8 +666,9 @@ static int qat_uclo_map_ae(struct icp_qat_fw_loader_handle *handle, int max_ae)
 			continue;
 
 		for (i = 0; i < obj_handle->uimage_num; i++) {
-			if (!test_bit(ae, (unsigned long *)
-			&obj_handle->ae_uimage[i].img_ptr->ae_assigned))
+			unsigned long ae_assigned = obj_handle->ae_uimage[i].img_ptr->ae_assigned;
+
+			if (!test_bit(ae, &ae_assigned))
 				continue;
 			mflag = 1;
 			if (qat_uclo_init_ae_data(obj_handle, ae, i))
-- 
2.34.1

