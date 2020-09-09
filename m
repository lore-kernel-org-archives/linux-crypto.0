Return-Path: <SRS0=sZ2L=CS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3057C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 10:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D9F821D7A
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 10:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgIIK7t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 06:59:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:31531 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgIIK7r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 06:59:47 -0400
IronPort-SDR: EpzqTwvHfjDONCdGRbqaGhfALv+YBK61eHJl6iX/N5LY1n6fpf8ZeD1uDtNN4GbFDW8I+qNoFG
 S0+DzJbJDcoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9738"; a="222511308"
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="222511308"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 03:59:44 -0700
IronPort-SDR: cX20ItUVLzuIxLwKVaYry0gug0p3U8U1KF8JuN3l0pMgE6c9Oj8xJWyoGQDujMKLHg60lm4rpm
 63l6J2i9XgPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,409,1592895600"; 
   d="scan'208";a="341534334"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Sep 2020 03:59:43 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH RESEND 0/2] crypto: qat - replace DIDs macros
Date:   Wed,  9 Sep 2020 11:59:38 +0100
Message-Id: <20200909105940.203532-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Resending patches 4 and 5 from the series "vfio/pci: add denylist and
disable qat" that didn't get apply.

This set replaces the device IDs defined in the qat drivers with the ones
in linux/pci_ids.h and replaces the custom ADF_SYSTEM_DEVICE macro with
PCI_VDEVICE.

Giovanni Cabiddu (2):
  crypto: qat - replace device ids defines
  crypto: qat - use PCI_VDEVICE

 drivers/crypto/qat/qat_c3xxx/adf_drv.c            | 11 ++++-------
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c          | 11 ++++-------
 drivers/crypto/qat/qat_c62x/adf_drv.c             | 11 ++++-------
 drivers/crypto/qat/qat_c62xvf/adf_drv.c           | 11 ++++-------
 drivers/crypto/qat/qat_common/adf_accel_devices.h |  6 ------
 drivers/crypto/qat/qat_common/qat_hal.c           |  7 ++++---
 drivers/crypto/qat/qat_common/qat_uclo.c          |  9 +++++----
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c         | 11 ++++-------
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c       | 11 ++++-------
 9 files changed, 33 insertions(+), 55 deletions(-)

-- 
2.26.2

