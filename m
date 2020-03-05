Return-Path: <SRS0=yJek=4W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C95C3F2D1
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 02:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455A320842
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Mar 2020 02:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgCECKM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 21:10:12 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbgCECKM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 21:10:12 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 184F74F503A70E859736;
        Thu,  5 Mar 2020 10:10:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 10:10:01 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH v3 0/5] crypto: hisilicon - Improve SEC performance
Date:   Thu, 5 Mar 2020 10:06:20 +0800
Message-ID: <1583373985-718-1-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

Improve SEC throughput by allocating a workqueue for each device
instead of one workqueue for all SEC devices. What's more,
when IOMMU translation is turned on, the plat buffer (pbuffer)
will be reserved for small packets (<512Bytes) to
which small packets are copied. This can avoid DMA mapping on
user small packets and improve performance.

This series is based on:
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git

Changes v2 -> v3:
	- Updated some comments and commit messages from Jonathan Cameron.
	- Removed CPU intensive workqueue flag WQ_CPU_INTENSIVE
	- Some small misc fixes.

Changes v1 -> v2:
	- Split pbuf patch into two patches.
	- Move 'use_pbuf' from 'qp_ctx' to TFM request.
	- Misc fixes on coding style.

Longfang Liu (3):
  crypto: hisilicon/sec2 - Add iommu status check
  crypto: hisilicon/sec2 - Update IV and MAC operation
  crypto: hisilicon/sec2 - Add pbuffer mode for SEC driver

Shukun Tan (1):
  crypto: hisilicon - Use one workqueue per qm instead of per qp

Ye Kai (1):
  crypto: hisilicon/sec2 - Add workqueue for SEC driver.

 drivers/crypto/hisilicon/qm.c              |  39 ++---
 drivers/crypto/hisilicon/qm.h              |   5 +-
 drivers/crypto/hisilicon/sec2/sec.h        |   7 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 242 ++++++++++++++++++++++++-----
 drivers/crypto/hisilicon/sec2/sec_main.c   |  51 +++++-
 5 files changed, 281 insertions(+), 63 deletions(-)

-- 
2.8.1

