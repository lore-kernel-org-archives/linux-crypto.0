From: Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: [RFC PATCH 0/3] Hisilicon SEC accelerator driver
Date: Tue, 30 Jan 2018 15:29:50 +0000
Message-ID: <20180130152953.14068-1-jonathan.cameron@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linuxarm@huawei.com>, <xuzaibo@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        <devicetree@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Xiongfeng Wang <xiongfeng.wang@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:58696 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751787AbeA3Pa4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jan 2018 10:30:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

This an RFC for a couple of reasons:
1) There is some ongoing discussion on how to handle IVs in the AF_ALG
   interface when doing async IO.  There are a few corners of handling
   in here that are performance enhancements based on Stephan's recent
   set.
2) The handling of iommu presence is ugly.  I need to discuss this with
   iommu maintainer and interested parties.
3) The hardware is limited to 32MB per queued job. We need to handle
   splitting this up into multiple jobs and related IV chaining.

This driver provides in kernel support for the Hisilicon SEC
accelerators found on the hip06 and hip07 SoCs.  There are 4 such
units on the D05 board for which DT bindings are provided.  ACPI
configuration also works with an appropriate UEFI build.

The hardware does not update the IV in chaining or counting modes.
This is done in the driver on completion of the cipher operation.

If we are relying on IV chaining with current AF_ALG it is necessary
to ensure we do not stream the elements directly into the hardware
queues.  For modes where this necessary we use a front end software
queue.

The driver currently supports AES, DES and 3DES block ciphers.
Hash support and AAED support to follow.

Jonathan Cameron (3):
  dt-bindings: Add bindings for Hisilicon SEC crypto accelerators.
  crypto: hisilicon hacv1 driver
  arm64: dts: hisi: add SEC crypto accelerator nodes for hip07 SoC

 .../bindings/crypto/hisilicon,hip07-sec.txt        |   71 +
 arch/arm64/boot/dts/hisilicon/hip07.dtsi           |  293 ++++
 drivers/crypto/Kconfig                             |    2 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/hisilicon/Kconfig                   |   16 +
 drivers/crypto/hisilicon/Makefile                  |    2 +
 drivers/crypto/hisilicon/sec/Makefile              |    3 +
 drivers/crypto/hisilicon/sec/sec_algs.c            | 1082 +++++++++++++++
 drivers/crypto/hisilicon/sec/sec_drv.c             | 1418 ++++++++++++++++++++
 drivers/crypto/hisilicon/sec/sec_drv.h             |  282 ++++
 10 files changed, 3170 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
 create mode 100644 drivers/crypto/hisilicon/Kconfig
 create mode 100644 drivers/crypto/hisilicon/Makefile
 create mode 100644 drivers/crypto/hisilicon/sec/Makefile
 create mode 100644 drivers/crypto/hisilicon/sec/sec_algs.c
 create mode 100644 drivers/crypto/hisilicon/sec/sec_drv.c
 create mode 100644 drivers/crypto/hisilicon/sec/sec_drv.h

-- 
2.11.0
