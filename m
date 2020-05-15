Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1637C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEDEC2065C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgEOJPU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 05:15:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58008 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727857AbgEOJPU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 05:15:20 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AAFC6E93C06EF95C7B6F;
        Fri, 15 May 2020 17:15:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 15 May 2020 17:15:08 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 0/7] crypto: hisilicon - add debugfs for DFX
Date:   Fri, 15 May 2020 17:13:53 +0800
Message-ID: <1589534040-50725-1-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to quickly locate bugs of the accelerator driver, this series
add some DebugFS files.

Add counters for accelerator's IO operation path, count all normal IO
operations and error IO operations. Add dump information of QM state
and SQC/CQC/EQC/AEQC/SQE/CQE/EQE/AEQE.

Hui Tang (1):
  crypto: hisilicon/hpre - add debugfs for Hisilicon HPRE

Kai Ye (1):
  crypto: hisilicon/sec2 - add debugfs for Hisilicon SEC

Longfang Liu (3):
  crypto: hisilicon/qm - add debugfs for QM
  crypto: hisilicon/qm - add debugfs to the QM state machine
  crypto: hisilicon/zip - add debugfs for Hisilicon ZIP

Shukun Tan (2):
  crypto: hisilicon/qm - add DebugFS for xQC and xQE dump
  crypto: hisilicon/qm - change debugfs file name from qm_regs to regs

 Documentation/ABI/testing/debugfs-hisi-hpre |  89 ++++-
 Documentation/ABI/testing/debugfs-hisi-sec  |  94 ++++-
 Documentation/ABI/testing/debugfs-hisi-zip  |  70 +++-
 drivers/crypto/hisilicon/hpre/hpre.h        |  17 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  99 ++++-
 drivers/crypto/hisilicon/hpre/hpre_main.c   |  60 +++
 drivers/crypto/hisilicon/qm.c               | 598 ++++++++++++++++++++++++++--
 drivers/crypto/hisilicon/qm.h               |  11 +
 drivers/crypto/hisilicon/sec2/sec.h         |   4 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  15 +-
 drivers/crypto/hisilicon/sec2/sec_main.c    |  49 ++-
 drivers/crypto/hisilicon/zip/zip.h          |   8 +
 drivers/crypto/hisilicon/zip/zip_crypto.c   |   9 +-
 drivers/crypto/hisilicon/zip/zip_main.c     |  58 +++
 14 files changed, 1097 insertions(+), 84 deletions(-)

-- 
2.7.4

