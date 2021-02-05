Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57784C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1990364F3F
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBEKce (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Feb 2021 05:32:34 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12854 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhBEKQD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Feb 2021 05:16:03 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DXB8l5RlBz7h5k;
        Fri,  5 Feb 2021 18:13:59 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 18:15:12 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 0/6] crypto: hisilicon/qm - misc fixes
Date:   Fri, 5 Feb 2021 18:12:52 +0800
Message-ID: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset fixes some bugs:
1. Removing the waiting reset's completion logic of driver.
2. In order to prevent request missing,
   call user's callback before device resetting.
3. Fix the value of 'QM_SQC_VFT_BASE_MASK_V2'.
4. Update irqflag.
5. Do not reset when CE error occurs.
6. Fix printing format issue. 

Sihang Chen (1):
  crypto: hisilicon/qm - update irqflag

Weili Qian (5):
  crypto: hisilicon/qm - removing driver after reset
  crypto: hisilicon/qm - fix request missing error
  crypto: hisilicon/qm - fix the value of 'QM_SQC_VFT_BASE_MASK_V2'
  crypto: hisilicon/qm - do not reset hardware when CE happens
  crypto: hisilicon/qm - fix printing format issue

 drivers/crypto/hisilicon/hpre/hpre_main.c |   3 +-
 drivers/crypto/hisilicon/qm.c             | 124 +++++++++++++++++++++---------
 drivers/crypto/hisilicon/qm.h             |   5 +-
 drivers/crypto/hisilicon/sec2/sec_main.c  |   3 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |   7 +-
 5 files changed, 101 insertions(+), 41 deletions(-)

-- 
2.8.1

