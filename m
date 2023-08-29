Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733B6C6FA8F
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Aug 2023 10:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjH2KO6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Aug 2023 06:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbjH2KO3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2023 06:14:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677A3184
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2023 03:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693304058; x=1724840058;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+vSjULPcqSWLzMs9IdN1BqANBLpqQ+T8gpM8m4VaR3A=;
  b=fUIJBpMmOvloITXwM3e/CWlDXler3EP4HoMkI1rQo/JspnTgMOd691if
   ZNrCP+tKnAuQCuHDqW9/hb/gwN7nLh3LpdpMpyvTIUM8FAvKdvSASRcHK
   mdAbe3cSQwG4oONu2tsUUw2QgePS/sgH0eQDNUDMTBqR65E43gXGGfzLt
   MB2oaSUY265UoaNngzDRt70CRtwEXA99BpaxN3vychpLquCYB4JSK6ZGS
   zaqiytHxRrY0c/mLuRT8cxwhvslEJ+namzY4ODtlhTtNWzzVeij+LfLGm
   GJi0mDWzXOxjc5G03KXkxVd4uH9fX3Njegbw7hrC1zlxA1u2Dws9thKGY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="461692127"
X-IronPort-AV: E=Sophos;i="6.02,210,1688454000"; 
   d="scan'208";a="461692127"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 03:14:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="715478811"
X-IronPort-AV: E=Sophos;i="6.02,210,1688454000"; 
   d="scan'208";a="715478811"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by orsmga006.jf.intel.com with ESMTP; 29 Aug 2023 03:14:15 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] Documentation: ABI: debugfs-driver-qat: fix fw_counters path
Date:   Tue, 29 Aug 2023 11:13:57 +0100
Message-ID: <20230829101410.11859-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The debugfs description for fw_counters reports an incorrect path
indicating a qat folder that does not exist. Fix it.

Fixes: 865b50fe6ea8 ("crypto: qat - add fw_counters debugfs file")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/debugfs-driver-qat | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/debugfs-driver-qat b/Documentation/ABI/testing/debugfs-driver-qat
index 6731ffacc5f0..3f9b4f708051 100644
--- a/Documentation/ABI/testing/debugfs-driver-qat
+++ b/Documentation/ABI/testing/debugfs-driver-qat
@@ -1,4 +1,4 @@
-What:		/sys/kernel/debug/qat_<device>_<BDF>/qat/fw_counters
+What:		/sys/kernel/debug/qat_<device>_<BDF>/fw_counters
 Date:		November 2023
 KernelVersion:	6.6
 Contact:	qat-linux@intel.com
-- 
2.41.0

