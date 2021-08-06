Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76ECC4320A
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97E376115C
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244778AbhHFJ7t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:59:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7799 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242882AbhHFJ7t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 05:59:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gh1Cv3p1czYlm0;
        Fri,  6 Aug 2021 17:59:23 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 17:59:31 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 6 Aug 2021
 17:59:30 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 0/2] crypto: hisilicon - some misc bugfix for SEC engine
Date:   Fri, 6 Aug 2021 17:58:32 +0800
Message-ID: <1628243914-33224-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

some misc bugfix for SEC engine.

Kai Ye (2):
  crypto: hisilicon/sec - fix the abnormal exiting process
  crypto: hisilicon/sec - modify the hardware endian configuration

 drivers/crypto/hisilicon/sec2/sec.h      |  5 -----
 drivers/crypto/hisilicon/sec2/sec_main.c | 38 +++++++++++---------------------
 2 files changed, 13 insertions(+), 30 deletions(-)

-- 
2.7.4

