Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:50923 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728643AbeLMLWO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 06:22:14 -0500
From: Zhou Wang <wangzhou1@hisilicon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH RFC 0/4] crypto: hisilicon: Add HiSilicon QM and ZIP controller driver
Date: Thu, 13 Dec 2018 19:22:07 +0800
Message-ID: <1544700131-196846-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds HiSilicon QM and ZIP controller driver in crypto subsystem.

A simple QM/ZIP driver which helps to provide an example for a general
accelerator framework is under review in community[1]. Based on this simple
driver, this series adds HW v2 support, PCI passthrough, reset, PCI/misc error
handler, debug support. But unlike [1], driver in this patchset only registers
to crypto subsystem.

There will be a long discussion about above accelerator framework in the
process of upstreaming. So let's firstly review and upstream QM/ZIP crypto
driver.

References:
[1] https://lkml.org/lkml/2018/11/12/1951

Zhou Wang (4):
  Documentation: Add debugfs doc for hisi_zip
  crypto: hisilicon: Add queue management driver for HiSilicon QM module
  crypto: hisilicon: Add HiSilicon ZIP accelerator support
  MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver

 Documentation/ABI/testing/debugfs-hisi-zip |   50 +
 MAINTAINERS                                |    8 +
 drivers/crypto/hisilicon/Kconfig           |   11 +
 drivers/crypto/hisilicon/Makefile          |    2 +
 drivers/crypto/hisilicon/qm.c              | 1815 ++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h              |  176 +++
 drivers/crypto/hisilicon/zip/Makefile      |    2 +
 drivers/crypto/hisilicon/zip/zip.h         |   55 +
 drivers/crypto/hisilicon/zip/zip_crypto.c  |  404 +++++++
 drivers/crypto/hisilicon/zip/zip_main.c    | 1162 ++++++++++++++++++
 10 files changed, 3685 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip
 create mode 100644 drivers/crypto/hisilicon/qm.c
 create mode 100644 drivers/crypto/hisilicon/qm.h
 create mode 100644 drivers/crypto/hisilicon/zip/Makefile
 create mode 100644 drivers/crypto/hisilicon/zip/zip.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
 create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c

-- 
2.8.1
