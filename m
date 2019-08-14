Return-Path: <SRS0=c3b/=WK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841D6C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 09:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62AEF204EC
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 09:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfHNJa6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Aug 2019 05:30:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44656 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726121AbfHNJa6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Aug 2019 05:30:58 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3EA8BAFA9CB883CE19DB;
        Wed, 14 Aug 2019 17:30:56 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 14 Aug 2019 17:30:48 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH 0/5] crypto: hisilicon: Misc fixes
Date:   Wed, 14 Aug 2019 17:28:34 +0800
Message-ID: <1565774919-31853-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Patch 1~3 are fixes about kbuild errors, patch 4,5 are tiny fixes about qm
and zip.

This series is based on cryptodev-2.6.

Zhou Wang (5):
  crypto: hisilicon - fix kbuild warnings
  crypto: hisilicon - add dependency for CRYPTO_DEV_HISI_ZIP
  crypto: hisilicon - init curr_sgl_dma to fix compile warning
  crypto: hisilicon - add missing single_release
  crypto: hisilicon - fix error handle in hisi_zip_create_req_q

 drivers/crypto/hisilicon/Kconfig          | 1 +
 drivers/crypto/hisilicon/qm.c             | 7 ++++---
 drivers/crypto/hisilicon/sgl.c            | 2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c | 6 ++++--
 4 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.8.1

