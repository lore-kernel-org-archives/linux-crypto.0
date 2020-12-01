Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92B5C64E7B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D36C20757
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgLAOZ6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 09:25:58 -0500
Received: from mga18.intel.com ([134.134.136.126]:7317 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729687AbgLAOZ6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 09:25:58 -0500
IronPort-SDR: PhQHS4SauBbhO9du50XB136Ubh+XUJctbXxIGtdn1NygUKYyCcD+V1u0EoI4lFnkSWh06QdfXV
 gJXzIfCDxsig==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="160603446"
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="160603446"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 06:24:55 -0800
IronPort-SDR: G4sE/knM49b0FshppsFVIh0IKXbsKFPZiXDR+BSqtG28HTGJYwhgXz7xyaND+O7HLRiuRDrxjM
 R+SUNXFCnYtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="345478631"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 01 Dec 2020 06:24:54 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/3] crypto: qat - add support for AES-CTR and AES-XTS in qat_4xxx
Date:   Tue,  1 Dec 2020 14:24:48 +0000
Message-Id: <20201201142451.138221-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set adds support for AES-CTR and AES-XTS for QAT GEN4 devices and
adds logic to detect and enable crypto capabilities in the qat_4xxx
driver.

Marco Chiappero (3):
  crypto: qat - add AES-CTR support for QAT GEN4 devices
  crypto: qat - add AES-XTS support for QAT GEN4 devices
  crypto: qat - add capability detection logic in qat_4xxx

 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  24 ++++
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |  11 ++
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |   3 +
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h |   7 ++
 drivers/crypto/qat/qat_common/icp_qat_hw.h    |  17 ++-
 drivers/crypto/qat/qat_common/qat_algs.c      | 111 ++++++++++++++++--
 6 files changed, 165 insertions(+), 8 deletions(-)

-- 
2.28.0

