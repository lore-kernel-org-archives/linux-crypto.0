Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5ED3C17441
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 02:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B72AC20869
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 02:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfKICFn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 21:05:43 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:42024 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbfKICFn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 21:05:43 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 060A3B50B21B5765EACA;
        Sat,  9 Nov 2019 10:05:39 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Sat, 9 Nov 2019 10:05:33 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>,
        <fanghao11@huawei.com>, <yekai13@huawei.com>,
        <zhangwei375@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH v2 0/5] crypto: hisilicon - add HiSilicon SEC V2 support
Date:   Sat, 9 Nov 2019 10:01:52 +0800
Message-ID: <1573264917-14588-1-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series adds HiSilicon Security Engine (SEC) version 2 controller
driver in Crypto subsystem. It includes PCIe enabling, Skcipher, DebugFS
and SRIOV support of SEC.

This patchset rebases on:
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git

This patchset is based on:
https://www.spinics.net/lists/linux-crypto/msg43520.html

Changes:
 - delete checking return value of debugfs_create_xxx functions.

Change log:
v2:    - remove checking return value of debugfs_create_xxx functions.

Longfang Liu (1):
  Documentation: add DebugFS doc for HiSilicon SEC

Zaibo Xu (4):
  crypto: hisilicon - add HiSilicon SEC V2 driver
  crypto: hisilicon - add SRIOV for HiSilicon SEC
  crypto: hisilicon - add DebugFS for HiSilicon SEC
  MAINTAINERS: Add maintainer for HiSilicon SEC V2 driver

 Documentation/ABI/testing/debugfs-hisi-sec |   43 ++
 MAINTAINERS                                |   10 +
 drivers/crypto/hisilicon/Kconfig           |   16 +
 drivers/crypto/hisilicon/Makefile          |    1 +
 drivers/crypto/hisilicon/sec2/Makefile     |    2 +
 drivers/crypto/hisilicon/sec2/sec.h        |  156 ++++
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  862 ++++++++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  198 +++++
 drivers/crypto/hisilicon/sec2/sec_main.c   | 1095 ++++++++++++++++++++++++++++
 9 files changed, 2383 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-sec
 create mode 100644 drivers/crypto/hisilicon/sec2/Makefile
 create mode 100644 drivers/crypto/hisilicon/sec2/sec.h
 create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.c
 create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.h
 create mode 100644 drivers/crypto/hisilicon/sec2/sec_main.c

-- 
2.8.1

