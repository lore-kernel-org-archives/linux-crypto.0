Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0B8C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jun 2022 12:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiFIMhj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jun 2022 08:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245521AbiFIMhf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jun 2022 08:37:35 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3337422B26;
        Thu,  9 Jun 2022 05:37:34 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LJk8Y6CfvzgYc1;
        Thu,  9 Jun 2022 20:35:41 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 20:37:32 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 20:37:31 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>
Subject: [PATCH 0/3] crypto: hisilicon/qm - modify event interrupt processing
Date:   Thu, 9 Jun 2022 20:31:16 +0800
Message-ID: <20220609123119.27252-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset contains following updates:
1. Modify accelerator devices event irq processing.
2. Some cleanups.

Weili Qian (3):
  crypto: hisilicon/qm - add functions for releasing resources
  crypto: hisilicon/qm - move alloc qm->wq to qm.c
  crypto: hisilicon/qm - modify event irq processing

 drivers/crypto/hisilicon/qm.c            | 203 +++++++++++++++--------
 drivers/crypto/hisilicon/sec2/sec_main.c |  24 +--
 drivers/crypto/hisilicon/zip/zip_main.c  |  17 +-
 include/linux/hisi_acc_qm.h              |   8 +-
 4 files changed, 141 insertions(+), 111 deletions(-)

-- 
2.33.0

