Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7A8C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 02:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17058221F2
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 02:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbgFVCux (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 22:50:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6304 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726699AbgFVCux (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 22:50:53 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 262BBB429DC9B69FDCEB;
        Mon, 22 Jun 2020 10:50:50 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.201.106) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Mon, 22 Jun 2020 10:50:41 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <akpm@linux-foundation.org>,
        <linux-crypto@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH 0/3] crypto: allow users to specify acomp hardware from a desired NUMA node
Date:   Mon, 22 Jun 2020 14:48:58 +1200
Message-ID: <20200622024901.12632-1-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.201.106]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For a typical Linux server, probably there are several hardware modules.
For example, numa node0 has a compressor, numa node2 has a same module.
Some drivers are automatically using the module near the CPU calling
acomp_alloc.
But it isn't necessarily correct. Just like memory allocation API like
kmalloc and kmalloc_node. Similar optimization may be done for crypto.

Barry Song (3):
  crypto: permit users to specify numa node of acomp hardware
  crypto: hisilicon/zip - permit users to specify NUMA node
  mm/zswap: specify the NUMA node of acomp to use local compressors
  [mm/zswap patch is on top of linux-next tree]

 crypto/acompress.c                        |  8 ++++++++
 crypto/api.c                              | 22 ++++++++++++++--------
 crypto/internal.h                         | 23 +++++++++++++++++++----
 drivers/crypto/hisilicon/zip/zip.h        |  2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c |  6 +++---
 drivers/crypto/hisilicon/zip/zip_main.c   |  5 +++--
 include/crypto/acompress.h                |  7 +++++++
 include/linux/crypto.h                    |  3 ++-
 mm/zswap.c                                |  2 +-
 9 files changed, 58 insertions(+), 20 deletions(-)

-- 
2.27.0


