Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498F0C47087
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 10:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A0F56139A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 10:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhE1Kaz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 06:30:55 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2337 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbhE1Kaz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 06:30:55 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fs15R1Nqsz1BFqY;
        Fri, 28 May 2021 18:24:43 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 18:29:19 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 28 May
 2021 18:29:19 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 0/2] crypto: hisilicon - add new type of sqe for Kunpeng930
Date:   Fri, 28 May 2021 18:26:12 +0800
Message-ID: <1622197574-7779-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add new type of sqe for Kunpeng930, and modify the driver as needed.

chages v1->v2:
	fix two sparse warnings.

Kai Ye (2):
  crypto: hisilicon/sec - add new type of SQE
  crypto: hisilicon/sec - driver adapt to new SQE

 drivers/crypto/hisilicon/sec2/sec.h        |   6 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 291 ++++++++++++++++++++++++-----
 drivers/crypto/hisilicon/sec2/sec_crypto.h | 181 ++++++++++++++++++
 3 files changed, 434 insertions(+), 44 deletions(-)

-- 
2.8.1

