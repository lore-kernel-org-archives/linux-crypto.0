Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7E7C4708D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 11:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C636113D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 11:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhE1Lqt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 07:46:49 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2514 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbhE1Lqr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 07:46:47 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fs2qB5s3zzYqHq;
        Fri, 28 May 2021 19:42:30 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 19:45:11 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 28 May
 2021 19:45:11 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 0/3] crypto: hisilicon - supports new skciphers for new hardware
Date:   Fri, 28 May 2021 19:42:03 +0800
Message-ID: <1622202126-19237-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver adds new skciphers, add fallback tfm supporting for XTS mode.
The crypto fuzzing test has been passed. fixup 3des minimum key size declaration
that fuzz testing found.

Kai Ye (3):
  crypto: hisilicon/sec - add new skcipher mode for SEC
  crypto: hisilicon/sec - add fallback tfm supporting for XTS mode
  crypto: hisilicon/sec - fixup 3des minimum key size declaration

 drivers/crypto/hisilicon/sec2/sec.h        |   4 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 192 ++++++++++++++++++++++++++---
 drivers/crypto/hisilicon/sec2/sec_crypto.h |   3 +
 3 files changed, 182 insertions(+), 17 deletions(-)

-- 
2.8.1

