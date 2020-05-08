Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647E5C4724C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47A5D21582
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgEHG7E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 02:59:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56570 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726770AbgEHG7E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 02:59:04 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2CCA1B4BB55ABE0098A5;
        Fri,  8 May 2020 14:59:00 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 14:58:51 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 00/13] crypto: hisilicon - misc cleanup and optimizations
Date:   Fri, 8 May 2020 14:57:35 +0800
Message-ID: <1588921068-20739-1-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset includes some misc updates.
patch 1-3: modify the accelerator probe process.
patch 4: refactor module parameter pf_q_num.
patch 5-6: add state machine and FLR support.
patch 7: remove use_dma_api related useless codes.
patch 8-9: QM initialization process and memory management optimization.
patch 10-11: add device error report through abnormal irq.
patch 12-13: tiny change of zip driver.

Longfang Liu (3):
  crypto: hisilicon/sec2 - modify the SEC probe process
  crypto: hisilicon/hpre - modify the HPRE probe process
  crypto: hisilicon/zip - modify the ZIP probe process

Shukun Tan (5):
  crypto: hisilicon - refactor module parameter pf_q_num related code
  crypto: hisilicon - add FLR support
  crypto: hisilicon - remove use_dma_api related codes
  crypto: hisilicon - remove codes of directly report device errors
    through MSI
  crypto: hisilicon - add device error report through abnormal irq

Weili Qian (2):
  crypto: hisilicon - unify initial value assignment into QM
  crypto: hisilicon - QM memory management optimization

Zhou Wang (3):
  crypto: hisilicon/qm - add state machine for QM
  crypto: hisilicon/zip - Use temporary sqe when doing work
  crypto: hisilicon/zip - Make negative compression not an error

 drivers/crypto/hisilicon/hpre/hpre_main.c |  107 ++-
 drivers/crypto/hisilicon/qm.c             | 1102 +++++++++++++++++++----------
 drivers/crypto/hisilicon/qm.h             |   75 +-
 drivers/crypto/hisilicon/sec2/sec_main.c  |  134 ++--
 drivers/crypto/hisilicon/zip/zip_crypto.c |   13 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |  128 ++--
 6 files changed, 952 insertions(+), 607 deletions(-)

-- 
2.7.4

