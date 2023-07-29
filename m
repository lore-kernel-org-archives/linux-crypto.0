Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E84DC001DC
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Jul 2023 12:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjG2Mz2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 Jul 2023 08:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjG2Mz1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Jul 2023 08:55:27 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267D930C0;
        Sat, 29 Jul 2023 05:55:26 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RCkvr0Z0lzVjjk;
        Sat, 29 Jul 2023 20:53:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 29 Jul 2023 20:55:22 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <liulongfang@huawei.com>, Weili Qian <qianweili@huawei.com>
Subject: [PATCH 0/7] crypto: hisilicon - fix some issues in hisilicon drivers
Date:   Sat, 29 Jul 2023 20:52:32 +0800
Message-ID: <20230729125239.25337-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset fixes some issues of the HiSilicon accelerator drivers,
including device configuration, algorithm registration and so on.

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
 drivers/crypto/hisilicon/qm.c               | 557 ++++++++++----------
 drivers/crypto/hisilicon/qm_common.h        |   6 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  31 +-
 drivers/crypto/hisilicon/sec2/sec_main.c    |  29 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  29 +-
 drivers/crypto/hisilicon/zip/zip_main.c     |  15 +-
 include/linux/hisi_acc_qm.h                 |  39 +-
 10 files changed, 468 insertions(+), 357 deletions(-)

-- 
2.33.0

