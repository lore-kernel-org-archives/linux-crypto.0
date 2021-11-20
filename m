Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B60C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhKTEw5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:52:57 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14962 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhKTEwz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:52:55 -0500
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hx1Gz2DN7zZd4S;
        Sat, 20 Nov 2021 12:47:23 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 20 Nov 2021 12:49:50 +0800
Received: from huawei.com (10.69.192.56) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 20 Nov
 2021 12:49:49 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 0/4] crypto: hisilicon/qm - misc clean up and fixes
Date:   Sat, 20 Nov 2021 12:47:35 +0800
Message-ID: <20211120044739.5667-1-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Modify the value of qos initialization in resetting.
2. Some optimizations.

Kai Ye (4):
  crypto: hisilicon - modify the value of engine type rate
  crypto: hisilicon/qm - modify the value of qos initialization
  crypto: hisilicon/qm - some optimizations of ths qos write process
  crypto: hisilicon/qm - simplified the calculation of qos shaper
    parameters

 drivers/crypto/hisilicon/hpre/hpre_main.c |   2 +-
 drivers/crypto/hisilicon/qm.c             | 183 +++++++++++++---------
 drivers/crypto/hisilicon/sec2/sec_main.c  |   2 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |   4 +-
 4 files changed, 112 insertions(+), 79 deletions(-)

-- 
2.33.0

