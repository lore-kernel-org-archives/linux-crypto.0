Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8E7C4338F
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 06:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A0D16101C
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 06:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhHGGdN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Aug 2021 02:33:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13398 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhHGGdM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Aug 2021 02:33:12 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GhXW14DFSzclMs;
        Sat,  7 Aug 2021 14:29:17 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 7 Aug 2021 14:32:53 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 0/3] crypto: hisilicon - enable clock gating for accelerator device
Date:   Sat, 7 Aug 2021 14:29:08 +0800
Message-ID: <1628317751-3396-1-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng930 accelerator devices support dynamic clock gating. This patchset
enables clock gating for accelerator devices by writing hardware registers.

Weili Qian (3):
  crypto: hisilicon - enable zip device clock gating
  crypto: hisilicon - enable sec device clock gating
  crypto: hisilicon - enable hpre device clock gating

 drivers/crypto/hisilicon/hpre/hpre_main.c | 63 +++++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_main.c  | 46 +++++++++++++++++++---
 drivers/crypto/hisilicon/zip/zip_main.c   | 26 +++++++++++++
 3 files changed, 130 insertions(+), 5 deletions(-)

-- 
2.8.1

