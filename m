Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952E3C433E6
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Mar 2021 07:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B0464DAF
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Mar 2021 07:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhCMHbd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Mar 2021 02:31:33 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13511 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhCMHa5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Mar 2021 02:30:57 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DyDns0c1gzrTkT;
        Sat, 13 Mar 2021 15:29:05 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Sat, 13 Mar 2021
 15:30:44 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>, <wangzhou1@hisilicon.com>,
        <xuzaibo@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/3] crypto:hisilicon/sec - fixes some coding style
Date:   Sat, 13 Mar 2021 15:28:22 +0800
Message-ID: <1615620505-50018-1-git-send-email-liulongfang@huawei.com>
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

Changes v3 -> v4:
  - Fixed an unused warning on dev.
  - Create a patch for bugfix

Changes v2 -> v3:
  - Delete shash test error patch.

Changes v1 -> v2:
  - Modify the way to fix shash test error.

Longfang Liu (3):
  crypto: hisilicon/sec - fixes a printing error
  crypto: hisilicon/sec - fixes some coding style
  crypto: hisilicon/sec - fixes some driver coding style

 drivers/crypto/hisilicon/sec2/sec.h        |   5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  77 +++++++++--------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |   2 -
 drivers/crypto/hisilicon/sec2/sec_main.c   | 131 +++++++++++++++++------------
 4 files changed, 116 insertions(+), 99 deletions(-)

-- 
2.8.1

