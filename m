Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F20C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Mar 2022 18:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241155AbiCDSEz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Mar 2022 13:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241480AbiCDSEy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Mar 2022 13:04:54 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D0F3B002
        for <linux-crypto@vger.kernel.org>; Fri,  4 Mar 2022 10:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646417044; x=1677953044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vln7oadlRYUoMuAuriiJ/8aJmDBzBmuUoCSJwHiUgxE=;
  b=S3LT9SFO8bEb+wjMbyRvpWL4EH0nv2BluZmkmx1MiAFLnb4SQq08MVxN
   nq4fqsbin1p1haKZj6bs903f/RAUoihd4RDSvFXzD2fKCuwsQq0yMkb+X
   rj3o5zTLDFbJMoH1m8o2BKcpHuCHwhIGd07LqcPVbRDLQ1c4mR6Yy/o5b
   TfS//YLe+aFfZMEOw4vgR8Ubhe5NNEQaVCoGDL9nzfl7Q/tsTwp5UfY+J
   T6SQWq1xUF3Fn8uGSvCZqw1x3yIFQARROX7xypA/aM+aORPKFx6WFRgP+
   Ioy4ENErRnBKhfM/ZnLw+UQunoSnZMxgrnuETWX4NtGKz5p1xYlP5jKdg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="314744417"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="314744417"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 10:04:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="552308557"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga008.jf.intel.com with ESMTP; 04 Mar 2022 10:04:02 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 3/3] crypto: qat - fix initialization of pfvf rts_map_msg structures
Date:   Fri,  4 Mar 2022 18:03:56 +0000
Message-Id: <20220304180356.22469-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304180356.22469-1-giovanni.cabiddu@intel.com>
References: <20220304180356.22469-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Initialize fully the structures rts_map_msg containing the ring to
service map from the host.

This is to fix the following warning when compiling the QAT driver
using the clang compiler with CC=clang W=2:

    drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c:144:51: warning: missing field 'map' initializer [-Wmissing-field-initializers]
            struct ring_to_svc_map_v1 rts_map_msg = { { 0 }, };
                                                             ^
Fixes: e1b176af3d7e ("crypto: qat - exchange ring-to-service mappings over PFVF")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
index c5b326f63e95..1141258db4b6 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -141,7 +141,7 @@ int adf_vf2pf_get_capabilities(struct adf_accel_dev *accel_dev)
 
 int adf_vf2pf_get_ring_to_svc(struct adf_accel_dev *accel_dev)
 {
-	struct ring_to_svc_map_v1 rts_map_msg = { { 0 }, };
+	struct ring_to_svc_map_v1 rts_map_msg = { 0 };
 	unsigned int len = sizeof(rts_map_msg);
 
 	if (accel_dev->vf.pf_compat_ver < ADF_PFVF_COMPAT_RING_TO_SVC_MAP)
-- 
2.35.1

