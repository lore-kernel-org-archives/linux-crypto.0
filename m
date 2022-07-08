Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14864C43334
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jul 2022 07:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbiGHHPR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jul 2022 03:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiGHHPM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jul 2022 03:15:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7962C76E97;
        Fri,  8 Jul 2022 00:15:11 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LfPb16tlWzTh9j;
        Fri,  8 Jul 2022 15:11:25 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 15:15:01 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 8 Jul
 2022 15:15:01 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v5 0/3] crypto: hisilicon - supports device isolation feature
Date:   Fri, 8 Jul 2022 15:08:17 +0800
Message-ID: <20220708070820.43958-1-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1、Add the uacce hardware error isolation interface. Supports
   configures the hardware error isolation frequency.
2、Defining the isolation strategy for ACC by uacce sysfs node. If the 
   number of hardware errors in a per hour exceeds the configured value,
   the device will not be available in user space. The VF device use the
   PF device isolation strategy.
   
changes v1->v2:
	- deleted dev_to_uacce api.
	- add vfs node doc. 
	- move uacce->ref to driver.
changes v2->v3:
	- deleted some redundant code.
	- use qm state instead of reference count.
	- add null pointer check.
	- isolate_strategy_read() instead of a copy.
changes v3->v4:
	- modify a comment
changes v4->v5:
	- use bool instead of atomic.
	- isolation frequency instead of isolation command.

 Documentation/ABI/testing/sysfs-driver-uacce |  18 ++
 drivers/crypto/hisilicon/qm.c                | 163 +++++++++++++++++--
 drivers/misc/uacce/uacce.c                   |  55 +++++++
 include/linux/hisi_acc_qm.h                  |   9 +
 include/linux/uacce.h                        |  11 ++
 5 files changed, 244 insertions(+), 12 deletions(-)

-- 
2.33.0

