From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH v1 0/3] Add support for Cavium CNN55XX crypto adapters.
Date: Wed, 10 May 2017 18:36:37 +0530
Message-ID: <20170510130640.5838-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, George.Cherian@cavium.com,
        Nidadavolu.Murthy@cavium.com, Sreerama.Gadam@cavium.com,
        Ram.Kumar@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0045.outbound.protection.outlook.com ([104.47.34.45]:34848
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750733AbdEJNHN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 May 2017 09:07:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 Hi Herbert,
 
 This series adds support for Cavium CNN55XX crypto adapters.

 CNN55XX crypto adapters belongs to Cavium NITROX family series,
 able to accelerates both Symmetric and Asymmetric crypto workloads.
 These adapters have crypto cores for Symmetric and Asymmetric
 crypto operations, and needs to load firmware to become operational.

 Patches are generated on top of kernel/git/herbert/crypto-2.6
 'commit 929562b14478 ("crypto: stm32 - Fix OF module alias information")'
 I will send the firmware to linux-firmware.

 The series was tested with dm-crypt for in kernel
 cryptographic offload operations.

 Please provide the feeback.

Srikanth Jampala (3):
  crypto: cavium - Add support for CNN55XX adapters.
  crypto: cavium - Add debugfs support in CNN55XX driver
  crypto: cavium - Register the CNN55XX supported crypto algorithms.

 drivers/crypto/Kconfig                       |    1 +
 drivers/crypto/Makefile                      |    1 +
 drivers/crypto/cavium/nitrox/Kconfig         |   21 +
 drivers/crypto/cavium/nitrox/Makefile        |    8 +
 drivers/crypto/cavium/nitrox/nitrox_algs.c   |  584 ++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_common.h |   36 +
 drivers/crypto/cavium/nitrox/nitrox_csr.h    | 1085 ++++++++++++++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_dev.h    |  184 +++++
 drivers/crypto/cavium/nitrox/nitrox_hal.c    |  404 ++++++++++
 drivers/crypto/cavium/nitrox/nitrox_isr.c    |  449 +++++++++++
 drivers/crypto/cavium/nitrox/nitrox_lib.c    |  208 +++++
 drivers/crypto/cavium/nitrox/nitrox_main.c   |  639 +++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_req.h    |  438 +++++++++++
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c |  572 ++++++++++++++
 14 files changed, 4630 insertions(+)
 create mode 100644 drivers/crypto/cavium/nitrox/Kconfig
 create mode 100644 drivers/crypto/cavium/nitrox/Makefile
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_algs.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_common.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_csr.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_dev.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_hal.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_isr.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_lib.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_main.c
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_req.h
 create mode 100644 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c

-- 
2.9.3
