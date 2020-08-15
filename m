Return-Path: <SRS0=CHgJ=B2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC68C433F2
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 01:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B90720708
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 01:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgHPBor (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Aug 2020 21:44:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33858 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729406AbgHPBoR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Aug 2020 21:44:17 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E75C5359DCB713A97F8F;
        Sat, 15 Aug 2020 17:58:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 15 Aug 2020 17:58:22 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v5 00/10] crypto: hisilicon/qm - misc fixes
Date:   Sat, 15 Aug 2020 17:56:07 +0800
Message-ID: <1597485377-2678-1-git-send-email-shenyang39@huawei.com>
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
patch 8: register callback to 'pci_driver.shutdown'
patch 9: wait for all working function finishs when remove the device
patch 10: move the process of register alg to crypto in driver 'hisi_zip'

v5:
 - add a error branch instead of return immediately in patch "fix wrong
   release after using strsep"

v4:
 - exchange the patch 'fix the call trace when unbind device' and
   'fix the process of register algorithms to crypto' to make sure the
   driver is stable.

v3:
 - add the patch 10 which is aimed to fix the call trace when remove a
   working device

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

Weili Qian (1):
  crypto: hisilicon/qm - fix the call trace when unbind device

Yang Shen (4):
  crypto: hisilicon/qm - fix print frequence in hisi_qp_send
  crypto: hisilicon/qm - fix no stop reason when use 'hisi_qm_stop'
  crypto: hisilicon/qm - register callback function to
    'pci_driver.shutdown'
  crypto: hisilicon/qm - fix the process of register algorithms to
    crypto

 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  36 ++---
 drivers/crypto/hisilicon/hpre/hpre_main.c   |  28 ++--
 drivers/crypto/hisilicon/qm.c               | 224 ++++++++++++++++++++++++----
 drivers/crypto/hisilicon/qm.h               |  27 ++--
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  35 ++---
 drivers/crypto/hisilicon/sec2/sec_main.c    |  34 ++---
 drivers/crypto/hisilicon/zip/zip_crypto.c   |   2 +-
 drivers/crypto/hisilicon/zip/zip_main.c     |  49 +++---
 8 files changed, 290 insertions(+), 145 deletions(-)

--
2.7.4

