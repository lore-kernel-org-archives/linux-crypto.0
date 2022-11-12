Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9ECC43217
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Nov 2022 08:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiKLI5S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Nov 2022 03:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbiKLI5R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Nov 2022 03:57:17 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F2931DF0;
        Sat, 12 Nov 2022 00:57:14 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N8Tw71mV1zmVr0;
        Sat, 12 Nov 2022 16:56:55 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 16:57:12 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 12 Nov
 2022 16:57:12 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yekai13@huawei.com>
Subject: [PATCH 0/2] crypto: hisilicon/sec - some misc cleanup
Date:   Sat, 12 Nov 2022 08:51:03 +0000
Message-ID: <20221112085105.7644-1-yekai13@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Fix spelling mistake.
2. Remove continuous blank lines

Kai Ye (1):
  crypto: hisilicon/sec - fix spelling mistake 'ckeck' -> 'check'

Wenkai Lin (1):
  crypto: hisilicon/sec - remove continuous blank lines

 drivers/crypto/hisilicon/sec2/sec_crypto.c | 5 ++---
 drivers/crypto/hisilicon/sec2/sec_main.c   | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.17.1

