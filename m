Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D0BC47082
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78B0E61157
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhE2OUU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 10:20:20 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2103 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhE2OUU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 10:20:20 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fsk7b660rzWlXW;
        Sat, 29 May 2021 22:14:03 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 22:18:41 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 0/4] crypto: hisilicon/qm - support the communication between PF and VF
Date:   Sat, 29 May 2021 22:15:33 +0800
Message-ID: <1622297737-46604-1-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for PF and VF communications in accelerator driver,
and updates the reset flow based on VF/PF communications.

Weili Qian (4):
  crypto: hisilicon/qm - adjust reset interface
  crypto: hisilicon/qm - enable PF and VFs communication
  crypto: hisilicon/qm - add callback to support communication
  crypto: hisilicon/qm - update reset flow

 drivers/crypto/hisilicon/qm.c | 713 +++++++++++++++++++++++++++++++++++++-----
 drivers/crypto/hisilicon/qm.h |   1 +
 2 files changed, 629 insertions(+), 85 deletions(-)

-- 
2.8.1

