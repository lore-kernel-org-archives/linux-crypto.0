Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DEEC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 05:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E87622075E
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 05:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbfKSFqb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 00:46:31 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:54692 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731097AbfKSFq2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 00:46:28 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 83AF03CA6513DDAEA570;
        Tue, 19 Nov 2019 13:46:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Tue, 19 Nov 2019 13:46:14 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH 0/3] crypto: hisilicon - Misc qm/zip fixes
Date:   Tue, 19 Nov 2019 13:42:55 +0800
Message-ID: <1574142178-76514-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These patches are independent fixes about qm and zip.

Jonathan Cameron (2):
  crypto: hisilicon - Fix issue with wrong number of sg elements after
    dma map
  crypto: hisilicon - Use the offset fields in sqe to avoid need to
    split scatterlists

Zhou Wang (1):
  crypto: hisilicon - Remove useless MODULE macros

 drivers/crypto/hisilicon/Kconfig          |  1 -
 drivers/crypto/hisilicon/sgl.c            | 17 +++---
 drivers/crypto/hisilicon/zip/zip.h        |  4 ++
 drivers/crypto/hisilicon/zip/zip_crypto.c | 92 ++++++++-----------------------
 4 files changed, 35 insertions(+), 79 deletions(-)

-- 
2.8.1

