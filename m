Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E06C32750
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4130920679
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390806AbfHBIQw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 04:16:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49856 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390804AbfHBIQw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 04:16:52 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 63D6DC10F1FDFDB74E08;
        Fri,  2 Aug 2019 16:16:50 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Fri, 2 Aug 2019 16:16:43 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v3 0/7] crypto: hisilicon: Add HiSilicon QM and ZIP controller driver
Date:   Fri, 2 Aug 2019 15:57:49 +0800
Message-ID: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series adds HiSilicon QM and ZIP controller driver in crypto subsystem.

A simple QM/ZIP driver which helps to provide an example for a general
accelerator framework is under review in community[1]. Based on this simple
driver, this series adds HW v2 support, PCI passthrough, PCI/misc error
handler, debug support. But unlike [1], driver in this patchset only registers
to crypto subsystem.

There will be a long discussion about above accelerator framework in the
process of upstreaming. So let's firstly review and upstream QM/ZIP crypto
driver.

Changes v2 -> v3:
- Change to register zlib/gzip to crypto acomp.
- As acomp is using sgl interface, add a common hardware sgl module which
  also can be used in other HiSilicon accelerator drivers.
- Change irq thread to work queue in the flow of irq handler in QM.
- Split SRIOV and debugfs out for the convenience of review.
- rebased on v5.3-rc1.
- Some tiny fixes.

Links:
- v2  https://lkml.org/lkml/2019/1/23/358
- v1  https://lwn.net/Articles/775484/
- rfc https://lkml.org/lkml/2018/12/13/290

Note: this series is based on https://lkml.org/lkml/2019/7/23/1135

Reference:
[1] https://lkml.org/lkml/2018/11/12/1951

Zhou Wang (7):
  crypto: hisilicon: Add queue management driver for HiSilicon QM module
  crypto: hisilicon: Add hardware SGL support
  crypto: hisilicon: Add HiSilicon ZIP accelerator support
  crypto: hisilicon: Add SRIOV support for ZIP
  Documentation: Add debugfs doc for hisi_zip
  crypto: hisilicon: Add debugfs for ZIP and QM
  MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver

 Documentation/ABI/testing/debugfs-hisi-zip |   50 +
 MAINTAINERS                                |   11 +
 drivers/crypto/hisilicon/Kconfig           |   23 +
 drivers/crypto/hisilicon/Makefile          |    3 +
 drivers/crypto/hisilicon/qm.c              | 1912 ++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h              |  215 ++++
 drivers/crypto/hisilicon/sgl.c             |  214 ++++
 drivers/crypto/hisilicon/sgl.h             |   24 +
 drivers/crypto/hisilicon/zip/Makefile      |    2 +
 drivers/crypto/hisilicon/zip/zip.h         |   71 ++
 drivers/crypto/hisilicon/zip/zip_crypto.c  |  651 ++++++++++
 drivers/crypto/hisilicon/zip/zip_main.c    | 1013 +++++++++++++++
 12 files changed, 4189 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip
 create mode 100644 drivers/crypto/hisilicon/qm.c
 create mode 100644 drivers/crypto/hisilicon/qm.h
 create mode 100644 drivers/crypto/hisilicon/sgl.c
 create mode 100644 drivers/crypto/hisilicon/sgl.h
 create mode 100644 drivers/crypto/hisilicon/zip/Makefile
 create mode 100644 drivers/crypto/hisilicon/zip/zip.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
 create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c

-- 
2.8.1

