Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79F2C4320A
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 10:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B508C608FC
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 10:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhHGKgg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Aug 2021 06:36:36 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16991 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhHGKgf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Aug 2021 06:36:35 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ghdvs1M17zZxjW;
        Sat,  7 Aug 2021 18:32:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 7 Aug 2021 18:36:17 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>
Subject: [PATCH 0/5] crypto: hisilicon - support runtime PM for accelerator devices
Date:   Sat, 7 Aug 2021 18:32:31 +0800
Message-ID: <1628332356-33278-1-git-send-email-qianweili@huawei.com>
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

Kunpeng930 accelerator devices support runtime power management, this
patchset enables runtime PM for accelerator devices.

Weili Qian (5):
  crypto: hisilicon - using 'debugfs_create_file' instead of
    'debugfs_create_regset32'
  crypto: hisilicon - add runtime PM ops
  crypto: hisilicon - support runtime PM for accelerator device
  crypto: hisilicon - change parameter passing of debugfs function
  crypto: hisilicon - check _PS0 and _PR0 method

 drivers/crypto/hisilicon/hpre/hpre_main.c |  60 ++++-
 drivers/crypto/hisilicon/qm.c             | 430 +++++++++++++++++++++++++-----
 drivers/crypto/hisilicon/qm.h             |   8 +
 drivers/crypto/hisilicon/sec2/sec_main.c  |  58 +++-
 drivers/crypto/hisilicon/zip/zip_main.c   |  57 +++-
 5 files changed, 521 insertions(+), 92 deletions(-)

-- 
2.8.1

