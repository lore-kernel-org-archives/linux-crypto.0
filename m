Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C381CC64ED6
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 15:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjB0PoT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjB0PoS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 10:44:18 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D40E067
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 07:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677512657; x=1709048657;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BLhQ87Nai8LpBA3jfHa82Je4CWmaASOExiqXOrJLRb4=;
  b=ESHpx2VnIe1ur/mejwLiD9TmSqwrJOYrYCR+ZR+UdfllZw+0ArqaTNTb
   cbqaC83vbwTjMrSamU59rVzXGa1b1fib7keWXRJPGeyyL73bhkYsv3/o1
   c8+owfp2vXm+6EHgqNN3viW1jaFv+vtCF86LRD7nB/Em4lEwhaxjvSVp/
   LkvNH/yKcttbqxs5iyxhh7oXAOGhNS4y9SCAoHzoWUCACXDU3Tn4lN7Wd
   y7t46z9XSSTJYgaeEO6U3y8IyO2KFLifZrA3gWdL6rAJmNmTaILw2Z+FG
   7Wiy+BdM/nUAVYo9glqjTmpDKQSf76CWnG/Cj9YJ+V8MuXqQaI0b5HZev
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="336166177"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="336166177"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 07:44:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="919392232"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="919392232"
Received: from linux-gr8q.igk.intel.com ([10.102.16.18])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2023 07:44:14 -0800
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>
Subject: [PATCH 0/5] crypto: qat - fix concurrency related issues
Date:   Mon, 27 Feb 2023 15:55:40 -0500
Message-Id: <20230227205545.5796-1-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.16.4
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set fixes issues related to using unprotected QAT device state    
machine functions that might cause concurrency issues at the time of state  
transition.

The first patch fixes the QAT 4XXX device's unexpected behaviour that
might occur if the user changes the device state or configuration via
sysfs while the driver performing device bring-up. The sequence is changed
in the probe function now the sysfs attribute is created after the device
initialization.

The second patch fixes the concurrency issue in the sysfs `state` 
attribute if multiple processes change the state of the qat device in 
parallel. The change introduces the protected wrapper function 
adf_dev_up() and adf_dev_down() that protects the transition of the device
state. These are used in adf_sysfs.c instead of low-level state machine 
functions.

The third patch replaces the use of unsafe low-level device state machine 
function with its protected wrapper functions.

The forth patch refactor device restart logic by moving it into 
adf_dev_restart() which uses safe adf_dev_up() and adf_dev_down().

The fifth patch define state machine functions static as they are unsafe
to use for state transition now performed by safe adf_dev_up() and 
adf_dev_down().

Shashank Gupta (5):
  crypto: qat - delay sysfs initialization
  crypto: qat - fix concurrency issue when device state changes
  crypto: qat - replace state machine calls
  crypto: qat - refactor device restart logic
  crypto: qat - make state machine functions static

 drivers/crypto/qat/qat_4xxx/adf_drv.c             | 21 ++---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c            | 17 +---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c          | 13 +--
 drivers/crypto/qat/qat_c62x/adf_drv.c             | 17 +---
 drivers/crypto/qat/qat_c62xvf/adf_drv.c           | 13 +--
 drivers/crypto/qat/qat_common/adf_accel_devices.h |  1 +
 drivers/crypto/qat/qat_common/adf_aer.c           |  4 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h    |  8 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c       | 27 +++----
 drivers/crypto/qat/qat_common/adf_dev_mgr.c       |  2 +
 drivers/crypto/qat/qat_common/adf_init.c          | 96 ++++++++++++++++++++---
 drivers/crypto/qat/qat_common/adf_sriov.c         | 10 +--
 drivers/crypto/qat/qat_common/adf_sysfs.c         | 23 +-----
 drivers/crypto/qat/qat_common/adf_vf_isr.c        |  3 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c         | 17 +---
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c       | 13 +--
 16 files changed, 132 insertions(+), 153 deletions(-)

-- 
2.16.4

