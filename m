Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4DFC55ABD
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 16:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F7E921D1A
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 16:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgKMQqu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 11:46:50 -0500
Received: from mga07.intel.com ([134.134.136.100]:5727 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgKMQqu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 11:46:50 -0500
IronPort-SDR: QgUDwMjSbOix0ZkcgZQqXzXdIdVZWJ4k0Lk2P3EWyAaFGzw5Z8hhwCQHD16Lpo9E3B9vR4zG72
 AyRxh0nhCg3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="234655770"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="234655770"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:46:49 -0800
IronPort-SDR: SBP/ncO8mWKAmSmC5sSvrhmXd/hySc0+229IUtAtc1IQFJvzLSgVWeL1L0YfShxDu+jukRzBGg
 MUZDtjz0uFrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="328926306"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga006.jf.intel.com with ESMTP; 13 Nov 2020 08:46:48 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/3] crypto: qat - add qat_4xxx driver
Date:   Fri, 13 Nov 2020 16:46:40 +0000
Message-Id: <20201113164643.103383-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for QAT 4xxx devices.

The first patch reworks the logic that loads the firmware images to
allow for for devices that require multiple firmware images to work.
The second patch introduces an hook to program the vector routing table,
which is introduced in QAT 4XXX, to allow to change the vector associated
with the interrupt source.
The third patch implements the QAT 4xxx driver.

Giovanni Cabiddu (3):
  crypto: qat - target fw images to specific AEs
  crypto: qat - add hook to initialize vector routing table
  crypto: qat - add qat_4xxx driver

 drivers/crypto/qat/Kconfig                    |  11 +
 drivers/crypto/qat/Makefile                   |   1 +
 drivers/crypto/qat/qat_4xxx/Makefile          |   4 +
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 218 ++++++++++++
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |  75 ++++
 drivers/crypto/qat/qat_4xxx/adf_drv.c         | 320 ++++++++++++++++++
 drivers/crypto/qat/qat_common/Makefile        |   1 +
 .../crypto/qat/qat_common/adf_accel_devices.h |   5 +
 .../crypto/qat/qat_common/adf_accel_engine.c  |  58 +++-
 .../crypto/qat/qat_common/adf_cfg_common.h    |   3 +-
 .../crypto/qat/qat_common/adf_gen4_hw_data.c  | 101 ++++++
 .../crypto/qat/qat_common/adf_gen4_hw_data.h  |  99 ++++++
 drivers/crypto/qat/qat_common/adf_isr.c       |   3 +
 13 files changed, 893 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_4xxx/Makefile
 create mode 100644 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_4xxx/adf_drv.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h

-- 
2.28.0

