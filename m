Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4644BCD6E64
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjJKMgX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjJKMgV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D54B7
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027779; x=1728563779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w23T8HOjR6B7a4ek1l9T30IEt7NoOEpXXihlRX/TWxo=;
  b=b7nHv1qIcg0ZH69OdSudHNoDxXF1/KPb6vKE5evOzw/prC1NxUtuEqSM
   0arfxoYr4fSAkSHwnqXlUyfYFGNjTNzC5cALLbd40FHkHUj2yXVtFQAIl
   bdzkRBxXq2RPF1vo9lw6LQhOIPynfq+LuSiNqQVVb21TPCscv7bh+4nfQ
   Lvb4H1+l2xDzcxSbZiEvjPFG2fac4GSGC/1aKAY7MEjArSBYQMO0Uni+4
   z9NDKJtFT/e6+O5BJeXah+XHrIPk0xcr39QUJdObvLo/6+pOGzty6WaxW
   /8+xwBBhovlzC+NGFukIX+4Lhi2VvfIhkU3UsB+Lu3OUr16zZSdruQfPm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992887"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992887"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124667"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124667"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:36:18 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 06/11] crypto: qat - add bits.h to icp_qat_hw.h
Date:   Wed, 11 Oct 2023 14:15:04 +0200
Message-ID: <20231011121934.45255-7-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011121934.45255-1-damian.muszynski@intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some enums use the macro BIT. Include bits.h as it is missing.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/icp_qat_hw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
index 0c8883e2ccc6..eb2ef225bcee 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
@@ -3,6 +3,8 @@
 #ifndef _ICP_QAT_HW_H_
 #define _ICP_QAT_HW_H_
 
+#include <linux/bits.h>
+
 enum icp_qat_hw_ae_id {
 	ICP_QAT_HW_AE_0 = 0,
 	ICP_QAT_HW_AE_1 = 1,
-- 
2.41.0

