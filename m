Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F332DC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B132B64F11
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbhCDGWR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 01:22:17 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13052 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbhCDGWB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 01:22:01 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DrggJ4hLszMhpp;
        Thu,  4 Mar 2021 14:19:08 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Thu, 4 Mar 2021
 14:21:10 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>, <wangzhou1@hisilicon.com>,
        <xuzaibo@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/2] crypto:hisilicon/sec - fixes some coding style
Date:   Thu, 4 Mar 2021 14:18:53 +0800
Message-ID: <1614838735-52668-1-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Fix a problems.
2. Fix some coding style.

Changes v2 -> v3:
  - Delete shash test error patch.

Changes v1 -> v2:
  - Modify the way to fix shash test error.

Longfang Liu (2):
  crypto: hisilicon/sec - fixes some log printing style
  crypto: hisilicon/sec - fixes some driver coding style

 drivers/crypto/hisilicon/sec2/sec.h        |   5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  82 +++++++++---------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |   2 -
 drivers/crypto/hisilicon/sec2/sec_main.c   | 131 +++++++++++++++++------------
 4 files changed, 118 insertions(+), 102 deletions(-)

-- 
2.8.1

