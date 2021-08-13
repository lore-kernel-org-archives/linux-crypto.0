Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2846EC4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E51361038
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239351AbhHMJl4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Aug 2021 05:41:56 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13311 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239316AbhHMJl4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Aug 2021 05:41:56 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GmJTx5Xxkz84Zf;
        Fri, 13 Aug 2021 17:41:25 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 13 Aug 2021 17:41:28 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 13 Aug
 2021 17:41:27 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 0/5] crypto: hisilicon - supports hash algorithm for SEC engine
Date:   Fri, 13 Aug 2021 17:40:21 +0800
Message-ID: <1628847626-24383-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver adds hash algorithms, 
sm3, md5, sha1, sha256, sha512.
Add fallback tfm supporting. Modify the driver
as needed. The fuzzing test has been passed.

Kai Ye (5):
  crypto: hisilicon/sec - add ping-pong buffer for ahash
  crypto: hisilicon/sec - add ahash alg features for Kunpeng920
  crypto: hisilicon/sec - support the larger packets for digest mode
  crypto: hisilicon/sec - ahash adapt to Kunpeng930 SQE
  crypto: hisilicon/sec - add fallback tfm supporting for ahash

 drivers/crypto/hisilicon/sec2/sec.h        |   52 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 1315 +++++++++++++++++++++++++++-
 drivers/crypto/hisilicon/sec2/sec_crypto.h |    9 +
 3 files changed, 1359 insertions(+), 17 deletions(-)

-- 
2.7.4

