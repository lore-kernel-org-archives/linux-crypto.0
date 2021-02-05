Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F63EC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 23:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A20564F99
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 23:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhBEXTQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Feb 2021 18:19:16 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12438 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbhBEKOX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Feb 2021 05:14:23 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DXB6h6tKGzjHhY;
        Fri,  5 Feb 2021 18:12:12 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Fri, 5 Feb 2021
 18:13:10 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>, <wangzhou1@hisilicon.com>,
        <xuzaibo@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] crypto:hisilicon/sec - fixes some coding style
Date:   Fri, 5 Feb 2021 18:10:54 +0800
Message-ID: <1612519857-30714-1-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Fix two problems.
2. Fix some coding style.

Longfang Liu (3):
  crypto: hisilicon/sec - fixes some log printing style
  crypto: hisilicon/sec - fixes some driver coding style
  crypto: hisilicon/sec - fixes shash test error

 arch/arm64/configs/defconfig               |   2 +-
 drivers/crypto/hisilicon/sec2/sec.h        |   5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  82 +++++++++---------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |   2 -
 drivers/crypto/hisilicon/sec2/sec_main.c   | 131 +++++++++++++++++------------
 5 files changed, 119 insertions(+), 103 deletions(-)

-- 
2.8.1

