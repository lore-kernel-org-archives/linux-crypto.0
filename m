Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F6CC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Apr 2022 14:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377471AbiDDOgx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377467AbiDDOgs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Apr 2022 10:36:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6BB3AA44
        for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2022 07:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649082892; x=1680618892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nKMjKa7P8iE+d2qWgKFj9xmHYb9DshK9Ru74HI5pbkA=;
  b=WyQ7MsuWlR1b85OhLIaAcdqbj7qD/kil3rc4OSpjwxvxvgomHzZdiUc3
   GYkXUihCzjZJ/Wi9rdofVMMLvSABSfepxufAneOo9ZAV8cNbFSmOmpEkp
   NWtytqxZI3CusT7xaLvHW9zsSG0hh5ZLCTDOeJTZUGaxks6rlpk+ZFjSL
   3hKeq8DNGWWx+Vuga4bwxupBHi85mtCNGoANEfx9n44ZSgQVoUSJuk9nE
   gIYJqiKnW/jhX30RthPZMeY5oUEAQ47xrV3VFon6yFKIHwB/xL+KHb4TS
   H6431CNiGI+1WJt1uf21vSZk0ZjgQqp4gkQX6zscHQd4sziPSwZmn/x5U
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260704481"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="260704481"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 07:34:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="657521418"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga004.jf.intel.com with ESMTP; 04 Apr 2022 07:34:50 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 3/8] crypto: qat - remove unused PFVF stubs
Date:   Mon,  4 Apr 2022 15:38:24 +0100
Message-Id: <20220404143829.147404-4-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404143829.147404-1-marco.chiappero@intel.com>
References: <20220404143829.147404-1-marco.chiappero@intel.com>
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

