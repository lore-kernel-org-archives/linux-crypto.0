Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DC8C0015E
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 14:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjHKOKq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 10:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjHKOKq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 10:10:46 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F39D7
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 07:10:44 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RMlxL1V2NzqSgQ
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 22:07:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 22:10:42 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <shenyang39@huawei.com>,
        <liulongfang@huawei.com>, Weili Qian <qianweili@huawei.com>
Subject: [PATCH v2 0/7] crypto: hisilicon - fix some issues in hisilicon drivers
Date:   Fri, 11 Aug 2023 22:07:42 +0800
Message-ID: <20230811140749.5202-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset fixes some issues of the HiSilicon accelerator drivers.

The first patch uses 128bit atomic operations to access mailbox instead of
the generic IO interface. The reason is that one QM hardware entity in
one accelerator servers QM mailbox MMIO interfaces in related PF and VFs.
A mutex cannot lock mailbox processes in different functions.

The second patch allocs memory for mailbox openration when the driver is
bound to the device. The software directly returns after waiting for the
mailbox times out, but the hardware does not cancel the operation. If the
temporary memory is used, the hardware may access the memory after it is
released.

The third patch enables the maximum number of queues supported by the
device instead of returning error, when the maximum number of queues is
less than the default value.

The fourth patch checks the number of queues on the function before
algorithm registering to crypto subsystem. If the number of queues
does not meet the minimum number of queues for task execution, the
function is not registered to crypto to avoid process initialization
failure.

The fifth patch adds a cond_resched() to prevent soft lockup.
The sixth patch fixes aeq type value. 
The last patch increases function communication waiting time so that the
PF can communicate with all VFs.

v2:
 - Re-describe the issues resolved by these patches.
 - Fix some code styles.

Longfang Liu (1):
  crypto: hisilicon/qm - fix PF queue parameter issue

Weili Qian (6):
  crypto: hisilicon/qm - obtain the mailbox configuration at one time
  crypto: hisilicon/qm - alloc buffer to set and get xqc
  crypto: hisilicon/qm - check function qp num before alg register
  crypto: hisilicon/qm - prevent soft lockup in qm_poll_req_cb()'s loop
  crypto: hisilicon/qm - fix the type value of aeq
  crypto: hisilicon/qm - increase function communication waiting time

 drivers/crypto/hisilicon/debugfs.c          |  75 ++-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  25 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c   |  19 +-
 drivers/crypto/hisilicon/qm.c               | 567 ++++++++++----------
 drivers/crypto/hisilicon/qm_common.h        |   6 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  31 +-
 drivers/crypto/hisilicon/sec2/sec_main.c    |  29 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  29 +-
 drivers/crypto/hisilicon/zip/zip_main.c     |  19 +-
 include/linux/hisi_acc_qm.h                 |  39 +-
 10 files changed, 475 insertions(+), 364 deletions(-)
 mode change 100644 => 100755 drivers/crypto/hisilicon/qm.c

-- 
2.33.0

