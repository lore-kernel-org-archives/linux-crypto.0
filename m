Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B66C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 14:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442326AbiEFOnh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 10:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346735AbiEFOnd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 10:43:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7506AA6C;
        Fri,  6 May 2022 07:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847982; x=1683383982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DzSK5EtvSUu+rARESr34ozWVmZBIJIRsYnefuQZeksk=;
  b=YD3AlCGInBXcbEJfyn0aUm/e6ykSlAEoeFhqhIZDuU3OKXhUsGiuYNRw
   pjqnfdSjazspW6jz7kqvWakcMF5/b8kGfvyPSeqf7IkDUTjqkPLNu9qpP
   76QQeMPm77XG4LALM/FnxYiAep3YJBCVShCmNXu0iQtHV6uBLV5lOhPhJ
   zX190H9fZGyjE2iL805q3CWEaU0faCJeSQDyDR8qCl2A1xhlJ//JN92+f
   nln9MtPQF3+teYXOzOWzuEefoWP83+Q9Yhbua7oQFqXfi0QUvfuWZAOp8
   Chxhux72xiTSDCNb/H6TcTKntOEbAqpAucJNEeJocU0XS/n56R51s6NvU
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="248387524"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248387524"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:39:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537914912"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 07:39:29 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH v2 11/11] crypto: qat - re-enable registration of algorithms
Date:   Fri,  6 May 2022 15:39:03 +0100
Message-Id: <20220506143903.31776-12-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
References: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Re-enable the registration of algorithms after fixes to (1) use
pre-allocated buffers in the datapath and (2) support the
CRYPTO_TFM_REQ_MAY_BACKLOG flag.

This reverts commit 8893d27ffcaf6ec6267038a177cb87bcde4dd3de.

Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c      | 7 -------
 drivers/crypto/qat/qat_common/qat_crypto.c | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index fa4c350c1bf9..a6c78b9c730b 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -75,13 +75,6 @@ static int adf_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
-	/* Temporarily set the number of crypto instances to zero to avoid
-	 * registering the crypto algorithms.
-	 * This will be removed when the algorithms will support the
-	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
-	 */
-	instances = 0;
-
 	for (i = 0; i < instances; i++) {
 		val = i;
 		bank = i * 2;
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 80d905ed102e..9341d892533a 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -161,13 +161,6 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
-	/* Temporarily set the number of crypto instances to zero to avoid
-	 * registering the crypto algorithms.
-	 * This will be removed when the algorithms will support the
-	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
-	 */
-	instances = 0;
-
 	for (i = 0; i < instances; i++) {
 		val = i;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_BANK_NUM, i);
-- 
2.35.1

