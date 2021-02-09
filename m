Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDDCFC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 07:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8162064EB6
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 07:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhBIHEd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 02:04:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11714 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhBIHEd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 02:04:33 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZYjT3cZnzlJ12;
        Tue,  9 Feb 2021 15:02:05 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 15:03:30 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <clabbe.montjoie@gmail.com>, <clabbe@baylibre.com>,
        <gcherian@marvell.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@openeuler.org>,
        <prime.zeng@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 0/4] Fix the parameter of dma_map_sg()
Date:   Tue, 9 Feb 2021 14:59:21 +0800
Message-ID: <1612853965-67777-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

According to Documentation/core-api/dma-api-howto.rst, the parameters 
of dma_unmap_sg() must be the same as those which are passed in to the 
scatter/gather mapping API.
But for some drivers under crypto, the <nents> parameter of dma_unmap_sg() 
is number of elements after mapping. So fix them.

Part of the document is as follows:

To unmap a scatterlist, just call::

        dma_unmap_sg(dev, sglist, nents, direction);
	
Again, make sure DMA activity has already finished.
	
	.. note::
	
	        The 'nents' argument to the dma_unmap_sg call must be
		the _same_ one you passed into the dma_map_sg call,
		it should _NOT_ be the 'count' value _returned_ from the
		dma_map_sg call.

chenxiang (4):
  crypto: amlogic - Fix the parameter of dma_unmap_sg()
  crypto: cavium - Fix the parameter of dma_unmap_sg()
  crypto: ux500 - Fix the parameter of dma_unmap_sg()
  crypto: allwinner - Fix the parameter of dma_unmap_sg()

 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 9 ++++++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 3 ++-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 9 ++++++---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   | 3 ++-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c         | 6 +++---
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c        | 8 ++++----
 drivers/crypto/ux500/cryp/cryp_core.c               | 4 ++--
 drivers/crypto/ux500/hash/hash_core.c               | 2 +-
 8 files changed, 26 insertions(+), 18 deletions(-)

-- 
2.8.1

