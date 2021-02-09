Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2CDC433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 10:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97C7564E50
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 10:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhBIKb5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 05:31:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:61339 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231824AbhBIK3s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 05:29:48 -0500
IronPort-SDR: gNwq2F4C4h4wTF65434ScsUGQIa+UMVv0g6jfFhSeHTNxnpW7O3lXS7D5KaXur48lixXmOU6BE
 MF2Ekqs/lhQA==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="181922139"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="181922139"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 02:29:05 -0800
IronPort-SDR: fMEuGWa5NSF+d8DJD/IMk/attiKgviBrGKnLE3k2li3SQ/4LablUf4CY6u/sEj+uvXSqM8KhZe
 oW5QfvfXdjMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="359142708"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga003.jf.intel.com with ESMTP; 09 Feb 2021 02:29:03 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix spelling mistake: "messge" -> "message"
Date:   Tue,  9 Feb 2021 10:28:55 +0000
Message-Id: <20210209102855.118609-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Trivial fix to spelling mistake in adf_pf2vf_msg.c and adf_vf2pf_msg.c.
s/messge/message/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 2 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 8b090b7ae8c6..a1b77bd7a894 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -169,7 +169,7 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
  * @msg:	Message to send
  * @vf_nr:	VF number to which the message will be sent
  *
- * Function sends a messge from the PF to a VF
+ * Function sends a message from the PF to a VF
  *
  * Return: 0 on success, error code otherwise.
  */
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index 2c98fb63f7b7..e85bd62d134a 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -8,7 +8,7 @@
  * adf_vf2pf_init() - send init msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
- * Function sends an init messge from the VF to a PF
+ * Function sends an init message from the VF to a PF
  *
  * Return: 0 on success, error code otherwise.
  */
@@ -31,7 +31,7 @@ EXPORT_SYMBOL_GPL(adf_vf2pf_init);
  * adf_vf2pf_shutdown() - send shutdown msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
- * Function sends a shutdown messge from the VF to a PF
+ * Function sends a shutdown message from the VF to a PF
  *
  * Return: void
  */
-- 
2.29.2

