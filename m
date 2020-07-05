Return-Path: <SRS0=i4aU=AQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03197C433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 09:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFD0206BE
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 09:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgGEJVJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Jul 2020 05:21:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7372 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgGEJVJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Jul 2020 05:21:09 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 111141996C1192924428;
        Sun,  5 Jul 2020 17:21:05 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.202.129) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sun, 5 Jul 2020 17:20:58 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <akpm@linux-foundation.org>, <linux-crypto@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH v3 0/3] crypto: allow users to specify acomp hardware from a desired NUMA node
Date:   Sun, 5 Jul 2020 21:18:57 +1200
Message-ID: <20200705091900.29232-1-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.202.129]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For a typical Linux server, probably there are multiple ZIP modules.
For example, numa node0 has a compressor, numa node2 has a same module.
Some drivers are automatically using the module near the CPU calling
acomp_alloc.
But it isn't necessarily correct. Just like memory allocation API like
kmalloc and kmalloc_node. Similar optimization may be done for crypto.

-v3:
  move to use kzalloc_node according to Herbert's comment
-v2:
  cleanup according to Jonathan Cameron's comment

Barry Song (3):
  crypto: permit users to specify numa node of acomp hardware
  crypto: hisilicon/zip - permit users to specify NUMA node
  mm/zswap: allocate acomp on the numa node committing acomp_req[1]

[1] This patch is againest a zswap patch which has not been merged yet:
 "[PATCH v3] mm/zswap: move to use crypto_acomp API for hardware
 acceleration"
 https://lkml.org/lkml/2020/6/26/95

 crypto/acompress.c                        |  8 ++++++++
 crypto/api.c                              | 24 ++++++++++++++---------
 crypto/internal.h                         | 23 ++++++++++++++++++----
 drivers/crypto/hisilicon/zip/zip.h        |  2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c |  6 +++---
 drivers/crypto/hisilicon/zip/zip_main.c   |  5 +++--
 include/crypto/acompress.h                | 18 +++++++++++++++++
 include/linux/crypto.h                    |  2 ++
 mm/zswap.c                                |  2 +-
 9 files changed, 70 insertions(+), 20 deletions(-)

-- 
2.27.0


