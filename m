Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7009DC43470
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 14:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D2DC6128D
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 14:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348224AbhDGOSt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Apr 2021 10:18:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15950 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344354AbhDGOSs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Apr 2021 10:18:48 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FFmfL1jlkzrdFv;
        Wed,  7 Apr 2021 22:16:26 +0800 (CST)
Received: from localhost (10.174.179.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Wed, 7 Apr 2021
 22:18:26 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next 0/5] Remove redundant dev_err call
Date:   Wed, 7 Apr 2021 22:18:14 +0800
Message-ID: <20210407141819.32588-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.96]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset remove some redundant dev_err calls

YueHaibing (5):
  crypto: atmel-tdes - Remove redundant dev_err call in
    atmel_tdes_probe()
  crypto: img-hash - Remove redundant dev_err call in img_hash_probe()
  crypto: ux500 - Remove redundant dev_err calls
  crypto: keembay - Remove redundant dev_err calls
  crypto: ccree - Remove redundant dev_err call in init_cc_resources()

 drivers/crypto/atmel-tdes.c                   | 1 -
 drivers/crypto/ccree/cc_driver.c              | 4 +---
 drivers/crypto/img-hash.c                     | 3 ---
 drivers/crypto/keembay/keembay-ocs-aes-core.c | 4 +---
 drivers/crypto/keembay/keembay-ocs-hcu-core.c | 4 +---
 drivers/crypto/ux500/cryp/cryp_core.c         | 1 -
 drivers/crypto/ux500/hash/hash_core.c         | 1 -
 7 files changed, 3 insertions(+), 15 deletions(-)

-- 
2.17.1

