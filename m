Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F4CC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jun 2022 06:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiFWGHq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jun 2022 02:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiFWGHp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jun 2022 02:07:45 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D53744A0E;
        Wed, 22 Jun 2022 23:07:43 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LT8rQ5HMGzkWRx;
        Thu, 23 Jun 2022 14:05:58 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 23 Jun 2022 14:07:41 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 23 Jun
 2022 14:07:40 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-accelerators@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>,
        <yekai13@huawei.com>
Subject: [PATCH v3 0/3] crypto: hisilicon - supports device isolation feature
Date:   Thu, 23 Jun 2022 14:01:11 +0800
Message-ID: <20220623060114.37505-1-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1、Add the uacce hardware error isolation interface. 
2、Add related implementation in ACC driver to support uacce interface.
   e.g. Defining the isolation strategy for ACC by uacce sysfs node, if
   the AER error frequency exceeds the value of setting for a certain 
   period of time. The device will not be available in user space. The
   VF device use the PF device isolation strategy. as well as the 
   isolation strategy should not be set during device use.
   
changes v1->v2:
	1、deleted dev_to_uacce api.
	2、add vfs node doc. 
	3、move uacce->ref to driver.
changes v2->v3:
	1、deleted some redundant code.
	2、use qm state instead of reference count.
	3、add null pointer check.
	4、isolate_strategy_read() instead of a copy.

Kai Ye (3):
  uacce: supports device isolation feature
  Documentation: add a isolation strategy sysfs node for uacce
  crypto: hisilicon/qm - defining the device isolation strategy

 Documentation/ABI/testing/sysfs-driver-uacce |  18 ++
 drivers/crypto/hisilicon/qm.c                | 178 +++++++++++++++++--
 drivers/misc/uacce/uacce.c                   |  41 +++++
 include/linux/hisi_acc_qm.h                  |   9 +
 include/linux/uacce.h                        |  11 ++
 5 files changed, 245 insertions(+), 12 deletions(-)

-- 
2.33.0

