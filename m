Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4F7C05027
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 17:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjBARE5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 12:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjBAREt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 12:04:49 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3138D29140
        for <linux-crypto@vger.kernel.org>; Wed,  1 Feb 2023 09:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675271088; x=1706807088;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xbRoFt2+1om4FN6gDJkjqCFwLHAAIun8PxpmIsA37tk=;
  b=HBMzzZyOoQjjSuimXIOwyxRaor8fc06q2/w359Ck6TCmfgNn7g1Nwyu7
   3IxMJKKMUDieKUuwsbgcI3fFr6Po0RQGgkjKmYaEwFGxmDcgzkBHCVUi2
   oyAtbjyTe3PTcg75/vP0ixKxUnL5ecKOQqecVGfZPjxLD8uerzpL2S1Ne
   es3yCEldzyiTjraDdiWrkPQNpZpw22lg96mxnnLUyBSfya0CWmz7Pl817
   M9vt84N+mCI958PGF7AdW6B15Sb/yNVvLGWjkacWjet3VHp04bhaDPgYY
   EzQNhduy2UDrzVJkboVuhnLDzVgQAIocoMSV20hexV+iP16bHFHu6CGUC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="390593926"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="390593926"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 09:04:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="993761852"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="993761852"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2023 09:04:46 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH] crypto: qat - drop log level of msg in get_instance_node()
Date:   Wed,  1 Feb 2023 17:04:41 +0000
Message-Id: <20230201170441.29756-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The functions qat_crypto_get_instance_node() and
qat_compression_get_instance_node() allow to get a QAT instance (ring
pair) on a device close to the node specified as input parameter.
When this is not possible, and a QAT device is available in the system,
these function return an instance on a remote node and they print a
message reporting that it is not possible to find a device on the specified
node. This is interpreted by people as an error rather than an info.

The print "Could not find a device on node" indicates that a kernel
application is running on a core in a socket that does not have a QAT
device directly attached to it and performance might suffer.

Due to the nature of the message, this can be considered as a debug
message, therefore drop the severity to debug and report it only once
to avoid flooding.

Suggested-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/qat_compression.c | 2 +-
 drivers/crypto/qat/qat_common/qat_crypto.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_compression.c b/drivers/crypto/qat/qat_common/qat_compression.c
index 9fd10f4242f8..3f1f35283266 100644
--- a/drivers/crypto/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/qat/qat_common/qat_compression.c
@@ -72,7 +72,7 @@ struct qat_compression_instance *qat_compression_get_instance_node(int node)
 	}
 
 	if (!accel_dev) {
-		pr_info("QAT: Could not find a device on node %d\n", node);
+		pr_debug_ratelimited("QAT: Could not find a device on node %d\n", node);
 		/* Get any started device */
 		list_for_each(itr, adf_devmgr_get_head()) {
 			struct adf_accel_dev *tmp_dev;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index e31199eade5b..40c8e74d1cf9 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -70,7 +70,7 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 	}
 
 	if (!accel_dev) {
-		pr_info("QAT: Could not find a device on node %d\n", node);
+		pr_debug_ratelimited("QAT: Could not find a device on node %d\n", node);
 		/* Get any started device */
 		list_for_each_entry(tmp_dev, adf_devmgr_get_head(), list) {
 			if (adf_dev_started(tmp_dev) &&
-- 
2.39.1

