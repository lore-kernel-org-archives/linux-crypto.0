Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18F9C4321E
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 13:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbiLBNFO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 08:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbiLBNFM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 08:05:12 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CB5D757B
        for <linux-crypto@vger.kernel.org>; Fri,  2 Dec 2022 05:05:11 -0800 (PST)
Received: from dggpemm500002.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NNtST4Tc8zRpFJ;
        Fri,  2 Dec 2022 21:04:25 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 21:05:08 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <olivia@selenic.com>, <herbert@gondor.apana.org.au>,
        <mpm@selenic.com>, <mb@bu3sch.de>, <dilinger@queued.net>
CC:     <linux-crypto@vger.kernel.org>, <yangyingliang@huawei.com>,
        <wangxiongfeng2@huawei.com>
Subject: [PATCH v2 0/2] hwrng: Fix PCI device refcount leak
Date:   Fri, 2 Dec 2022 21:22:32 +0800
Message-ID: <20221202132234.60631-1-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

for_each_pci_dev() is implemented by pci_get_device(). The comment of
pci_get_device() says that it will increase the reference count for the
returned pci_dev and also decrease the reference count for the input
pci_dev @from if it is not NULL.

If we break for_each_pci_dev() loop with pdev not NULL, we need to call
pci_dev_put() to decrease the reference count. Add the missing
pci_dev_put() for amd-hwrng and geode-hwrng.


ChangeLog:
v1 -> v2:
  1. fix error in amd_rng_mod_exit()
  2. also add refcount leak fix for geode-hwrng

Xiongfeng Wang (2):
  hwrng: amd - Fix PCI device refcount leak
  hwrng: geode - Fix PCI device refcount leak

 drivers/char/hw_random/amd-rng.c   | 18 ++++++++++-----
 drivers/char/hw_random/geode-rng.c | 36 +++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 13 deletions(-)

-- 
2.20.1

