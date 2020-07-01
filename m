Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E1AC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 07:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C76A20773
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 07:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgGAHYa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 03:24:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7325 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728112AbgGAHYa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 03:24:30 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C25F88BB24E256D4BA10;
        Wed,  1 Jul 2020 15:21:36 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 1 Jul 2020 15:21:30 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [Patch v2 0/9] crypto: hisilicon/qm - misc fixes
Date:   Wed, 1 Jul 2020 15:19:46 +0800
Message-ID: <1593587995-7391-1-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset fix some qm bugs:
patch 1: store the string address before pass to 'strsep'
patch 2: clear 'qp_status->used' when init the 'qp'
patch 3: use 'dev_info_ratelimited' to avoid printk flooding.
patch 4: fix the judgement of queue is full
patch 7: save the vf configuration space to make sure it is available
 after the 'PF' 'FLR'
patch 8: move the process of register alg to crypto in driver 'hisi_zip'
patch 9: register callback to 'pci_driver.shutdown'

This patchset depends on:
https://patchwork.kernel.org/cover/1162709/

v2:
- fix the wrong email address on patch 1

Hui Tang (1):
  crypto: hisilicon/qm - fix judgement of queue is full

Shukun Tan (3):
  crypto: hisilicon/qm - clear used reference count when start qp
  crypto: hisilicon/qm - fix event queue depth to 2048
  crypto: hisilicon/qm - fix VF not available after PF FLR

Sihang Chen (1):
  crypto: hisilicon/qm - fix wrong release after using strsep

Yang Shen (4):
  crypto: hisilicon/qm - fix print frequence in hisi_qp_send
  crypto: hisilicon/qm - fix no stop reason when use hisi_qm_stop
  crypto: hisilicon/qm - fix the process of register algorithms to
    crypto
  crypto: hisilicon/qm - register callback function to
    'pci_driver.shutdown'

 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  36 +++-----
 drivers/crypto/hisilicon/hpre/hpre_main.c   |  26 +++---
 drivers/crypto/hisilicon/qm.c               | 126 +++++++++++++++++++++++-----
 drivers/crypto/hisilicon/qm.h               |  23 ++---
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  35 +++-----
 drivers/crypto/hisilicon/sec2/sec_main.c    |  30 +++----
 drivers/crypto/hisilicon/zip/zip_crypto.c   |   2 +-
 drivers/crypto/hisilicon/zip/zip_main.c     |  44 +++++-----
 8 files changed, 189 insertions(+), 133 deletions(-)

--
2.7.4

