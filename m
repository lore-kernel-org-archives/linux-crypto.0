Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AE9C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jun 2022 12:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357126AbiFNMbJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jun 2022 08:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356837AbiFNM3h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jun 2022 08:29:37 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAE0237DB;
        Tue, 14 Jun 2022 05:29:35 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LMnkw1yWczgYqs;
        Tue, 14 Jun 2022 20:27:36 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 20:29:33 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 14 Jun
 2022 20:29:33 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-accelerators@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>,
        <yekai13@huawei.com>
Subject: [PATCH v2 0/3] crypto: hisilicon - supports device isolation feature
Date:   Tue, 14 Jun 2022 20:23:05 +0800
Message-ID: <20220614122311.824-1-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the hardware error isolation feature for ACC. Defines a driver debugfs
node that used to configures the hardware error frequency. When the error
frequency is exceeded, the device will be isolated. The isolation strategy 
can be defined in each driver module. e.g. Defining the isolation strategy
for ACC, if the AER error frequency exceeds the value of setting for a 
certain period of time, The device will not be available in user space. The
VF device use the PF device isolation strategy. as well as the isolation 
strategy should not be set during device use.

changes v1->v2:
	1、deleted dev_to_uacce api.
	2、add vfs node doc. 
	3、move uacce->ref to driver.

Kai Ye (3):
  uacce: supports device isolation feature
  Documentation: add a isolation strategy vfs node for uacce
  crypto: hisilicon/qm - defining the device isolation strategy

 Documentation/ABI/testing/sysfs-driver-uacce |  17 ++
 drivers/crypto/hisilicon/qm.c                | 157 +++++++++++++++++--
 drivers/misc/uacce/uacce.c                   |  37 +++++
 include/linux/hisi_acc_qm.h                  |   9 ++
 include/linux/uacce.h                        |  16 +-
 5 files changed, 219 insertions(+), 17 deletions(-)

-- 
2.33.0

