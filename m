From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 0/4] Remove a attribute group from a kobject
Date: Sat, 25 Nov 2017 12:09:27 +0530
Message-ID: <1511591971-8615-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        lustre-devel@lists.lustre.org
To: gilad@benyossef.com, gregkh@linuxfoundation.org,
        oleg.drokin@intel.com, andreas.dilger@intel.com,
        jsimmons@infradead.org, paulmck@linux.vnet.ibm.com,
        vitaly_fertman@xyratex.com, yawei.niu@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:44380 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdKYGjr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Nov 2017 01:39:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Arvind Yadav (4):
  [PATCH 1/4] staging: ccree: Remove a attribute group from a kobject
  [PATCH 2/4] staging: lustre: ldlm: Remove a attribute group from a kobject
  [PATCH 3/4] staging: lustre: obdclass: Remove a attribute group from a kobject
  [PATCH 4/4] staging: most: Remove a attribute group from a kobject

 drivers/staging/ccree/ssi_sysfs.c                           | 5 ++++-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c             | 4 +++-
 drivers/staging/lustre/lustre/obdclass/linux/linux-module.c | 3 +++
 drivers/staging/most/hdm-dim2/dim2_sysfs.c                  | 1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

-- 
2.7.4
