Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D2FC433E9
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 10:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D975764E2C
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 10:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBGKHr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 05:07:47 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12475 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGKHo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 05:07:44 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYPtC5N9kzjKgd;
        Sun,  7 Feb 2021 18:05:39 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Sun, 7 Feb 2021
 18:06:55 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>, <wangzhou1@hisilicon.com>,
        <xuzaibo@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] crypto:hisilicon/sec - fixes some coding style
Date:   Sun, 7 Feb 2021 18:04:37 +0800
Message-ID: <1612692280-11386-1-git-send-email-liulongfang@huawei.com>
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

Changes v1 -> v2:
  - Modify the way to fix shash test error.

Longfang Liu (3):
  crypto: hisilicon/sec - fixes some log printing style
  crypto: hisilicon/sec - fixes some driver coding style
  crypto: hisilicon/sec - fixes shash test error

 drivers/crypto/hisilicon/sec2/sec.h        |   5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  83 +++++++++---------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |   2 -
 drivers/crypto/hisilicon/sec2/sec_main.c   | 131 +++++++++++++++++------------
 4 files changed, 119 insertions(+), 102 deletions(-)

-- 
2.8.1

