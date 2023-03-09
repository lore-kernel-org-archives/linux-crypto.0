Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F50C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Mar 2023 10:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCIKcn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Mar 2023 05:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjCIKck (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2023 05:32:40 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFBB39B8D
        for <linux-crypto@vger.kernel.org>; Thu,  9 Mar 2023 02:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678357959; x=1709893959;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fUIF7jLubiFU0ez60d6XZluZv3qne72wpq6adqFpZq0=;
  b=UvMB3RiWT9baxFmHn3dOuFFnKyvzD8mKQQPk7KNOMIxb5JNOcCTVA585
   LgRzB1wKlJzu4Za/HlSnbS8Mbr/kmoIy3+ucYWB1z7sFUd7IEyG5XNFQR
   vhYzbnBzq/Bf7blC3SBkENKW19Ym4A52Smq/4QQU8ytO2hqlJ7VOIKuGA
   ftiQPKeGfKMkMsTq5ti1WmAImj2AklZWQkMoSFhnn7JTCeNHWn1X/BL8o
   v6PWierIkhugoNgvQwV4s9uOL1xXxSTE1DyxRCfuzSnVZVIVEhha3yCfW
   aAicrIDL7ENJyeo6iSI/l9dTCLgsRONMrRsQEyjOs6DbsbBFcbidNWWLf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="398989451"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="398989451"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 02:32:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="746267978"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="746267978"
Received: from 984fee006c34.jf.intel.com ([10.165.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 09 Mar 2023 02:32:36 -0800
From:   Meadhbh Fitzpatrick <meadhbh.fitzpatrick@intel.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     Meadhbh Fitzpatrick <meadhbh.fitzpatrick@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH] crypto: qat - change size of status variable
Date:   Thu,  9 Mar 2023 11:33:06 +0000
Message-Id: <20230309113306.4008-1-meadhbh.fitzpatrick@intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The `status` variable is of type int but it is used to store the
output of an s8 type returned by the functions
qat_comp_get_xlt_status() and qat_comp_get_cmp_status().

Declare `status` as `s8` to match the output type of the two functions.

This commit does not implement any functional changes.

Signed-off-by: Meadhbh Fitzpatrick <meadhbh.fitzpatrick@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 drivers/crypto/qat/qat_common/qat_comp_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_comp_algs.c b/drivers/crypto/qat/qat_common/qat_comp_algs.c
index b533984906ec..726b71d2a4a8 100644
--- a/drivers/crypto/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_comp_algs.c
@@ -183,7 +183,7 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
 	int consumed, produced;
 	s8 cmp_err, xlt_err;
 	int res = -EBADMSG;
-	int status;
+	s8 status;
 	u8 cnv;
 
 	status = qat_comp_get_cmp_status(resp);
-- 
2.37.3

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

