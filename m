Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E73C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 17 May 2022 14:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240607AbiEQOKK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 May 2022 10:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235614AbiEQOKJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 May 2022 10:10:09 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D933E0D0
        for <linux-crypto@vger.kernel.org>; Tue, 17 May 2022 07:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652796607; x=1684332607;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eDOCKtvZ8AcbbQ0xhBSfJSuE/pNW67dcl4fnM+aiVm0=;
  b=VbxcJ+zmBxbBeTGDwju18Vpa92y1ohIAhpLo4TwJq9fJDRc/sNA9bvQ/
   suVE2OJGramONxDLFwtw6pikRvMpaWV7OcH4hLdflsWXixVZuQXUUPdFN
   i3Z30v1Lnggc7EqxV4+4HlEExI290JPSIPlP2OLZrikufaos4ieOxJ0pi
   NVHQ2GSs0VvxIxBsoS8SaaRYIiETqHTbwCi2ADhwMte7T+Oe402ZCYAQm
   UTD0Oi1WPQ1J/uiTzZN2FQ+EPzQAqqxxMlskZ+FQ2Zt8hI+wDYc9sfUpA
   36cZuVBJHi4RBsla4BDINBF+SiZDtPNyBtx5r2oLPPMWdm+rPq4BuoIlQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="268777748"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="268777748"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 07:10:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="816916394"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 May 2022 07:10:06 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/4] crypto: qat - enable configuration for 4xxx
Date:   Tue, 17 May 2022 15:09:58 +0100
Message-Id: <20220517141002.32385-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

qat_4xxx devices can be configured to allow either crypto or compression
operations. By default, devices are configured statically according
to following rule:
  - odd numbered devices assigned to compression services
  - even numbered devices assigned to crypto services

This set exposes two attributes in sysfs that allow to report and change
the state and the configuration of a QAT 4xxx device.
The first, /sys/bus/pci/devices/<BDF>/qat/state, allows to bring a
device down in order to change the configuration, and bring it up again.
The second, /sys/bus/pci/devices/<BDF>/qat/cfg_services, allows to
inspect the current configuration of a device (i.e. crypto or
compression) and change it.

Giovanni Cabiddu (4):
  crypto: qat - expose device state through sysfs for 4xxx
  crypto: qat - change behaviour of adf_cfg_add_key_value_param()
  crypto: qat - relocate and rename adf_sriov_prepare_restart()
  crypto: qat - expose device config through sysfs for 4xxx

 Documentation/ABI/testing/sysfs-driver-qat    |  58 ++++++
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   1 +
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |   1 +
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |   6 +-
 drivers/crypto/qat/qat_common/Makefile        |   1 +
 .../crypto/qat/qat_common/adf_accel_devices.h |   1 +
 drivers/crypto/qat/qat_common/adf_cfg.c       |  41 +++-
 .../crypto/qat/qat_common/adf_common_drv.h    |   3 +
 drivers/crypto/qat/qat_common/adf_init.c      |  26 +++
 drivers/crypto/qat/qat_common/adf_sriov.c     |  28 +--
 drivers/crypto/qat/qat_common/adf_sysfs.c     | 191 ++++++++++++++++++
 11 files changed, 328 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat
 create mode 100644 drivers/crypto/qat/qat_common/adf_sysfs.c

-- 
2.36.1

