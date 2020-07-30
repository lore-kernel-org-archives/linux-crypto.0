Return-Path: <SRS0=EYtX=BJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C8EC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jul 2020 12:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA5D2074B
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jul 2020 12:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgG3M2K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jul 2020 08:28:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:18766 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgG3M2J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jul 2020 08:28:09 -0400
IronPort-SDR: tipnjiX28NsBeT5hYv0TcCpnd7amAXR+WhYngICPKer3yR18vKazCChSyM6X3eFU5prUrfXo1K
 S8xUdz6U/BeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="131144071"
X-IronPort-AV: E=Sophos;i="5.75,414,1589266800"; 
   d="scan'208";a="131144071"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 05:28:09 -0700
IronPort-SDR: Yqml/qFxzpsSC8f9AXGqHo0F8GQ09AcI+3pdJ8PbkqTN5pTsJNx9G+mk32oHtY8c5eluh1w34d
 w1sh8PoBHlwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,414,1589266800"; 
   d="scan'208";a="286843312"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga003.jf.intel.com with ESMTP; 30 Jul 2020 05:28:08 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - add delay before polling mailbox
Date:   Thu, 30 Jul 2020 13:27:42 +0100
Message-Id: <20200730122742.216566-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The mailbox CSR register has a write latency and requires a delay before
being read. This patch replaces readl_poll_timeout with read_poll_timeout
that allows to sleep before read.
The initial sleep was removed when the mailbox poll loop was replaced with
readl_poll_timeout.

Fixes: a79d471c6510 ("crypto: qat - update timeout logic in put admin msg")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_admin.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index 1c8ca151a963..ec9b390276d6 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -131,9 +131,10 @@ static int adf_put_admin_msg_sync(struct adf_accel_dev *accel_dev, u32 ae,
 	memcpy(admin->virt_addr + offset, in, ADF_ADMINMSG_LEN);
 	ADF_CSR_WR(mailbox, mb_offset, 1);
 
-	ret = readl_poll_timeout(mailbox + mb_offset, status,
-				 status == 0, ADF_ADMIN_POLL_DELAY_US,
-				 ADF_ADMIN_POLL_TIMEOUT_US);
+	ret = read_poll_timeout(ADF_CSR_RD, status, status == 0,
+				ADF_ADMIN_POLL_DELAY_US,
+				ADF_ADMIN_POLL_TIMEOUT_US, true,
+				mailbox, mb_offset);
 	if (ret < 0) {
 		/* Response timeout */
 		dev_err(&GET_DEV(accel_dev),
-- 
2.26.2

