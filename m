Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE976C3F2D2
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 06:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4BA824697
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 06:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCBGTG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 01:19:06 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:35924 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726052AbgCBGTG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 01:19:06 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 69CFF2287A6DDC4D844B;
        Mon,  2 Mar 2020 14:18:57 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Mon, 2 Mar 2020 14:18:50 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <wangzhou1@hisilicon.com>, <tanghui20@huawei.com>,
        <yekai13@huawei.com>, <liulongfang@huawei.com>,
        <qianweili@huawei.com>, <zhangwei375@huawei.com>,
        <fanghao11@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH v2 0/5] crypto: hisilicon - Improve SEC performance
Date:   Mon, 2 Mar 2020 14:15:11 +0800
Message-ID: <1583129716-28382-1-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: liulongfang <liulongfang@huawei.com>

Improve SEC throughput by allocating a workqueue for each device
instead of one workqueue for all SEC devices. What's more,
when IOMMU translation is turned on, the plat buffer (pbuffer)
will be reserved for small packets (<512Bytes) to
which small packets are copied. This can avoid DMA mapping on
user small packets and improve performance.

This series is based on:
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git

Changes v1 -> v2:
	- Split pbuf patch into two patches.
	- Move 'use_pbuf' from 'qp_ctx' to TFM request.
	- Misc fixes on coding style.

Shukun Tan (1):
  crypto: hisilicon - Use one workqueue per qm instead of per qp

liulongfang (3):
  crypto: hisilicon/sec2 - Add iommu status check
  crypto: hisilicon/sec2 - Update IV and MAC operation
  crypto: hisilicon/sec2 - Add pbuffer mode for SEC driver

yekai13 (1):
  crypto: hisilicon/sec2 - Add workqueue for SEC driver.

 drivers/crypto/hisilicon/qm.c              |  38 ++---
 drivers/crypto/hisilicon/qm.h              |   5 +-
 drivers/crypto/hisilicon/sec2/sec.h        |   7 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 242 ++++++++++++++++++++++++-----
 drivers/crypto/hisilicon/sec2/sec_main.c   |  45 +++++-
 5 files changed, 274 insertions(+), 63 deletions(-)

-- 
2.8.1

