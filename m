From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH v2 0/3] Add support for Cavium CNN55XX crypto adapters.
Date: Tue, 30 May 2017 17:28:00 +0530
Message-ID: <20170530115803.8965-1-Jampala.Srikanth@cavium.com>
References: <3575749.J6klBtBYWh@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Sreerama.Gadam@cavium.com,
        Ram.Kumar@cavium.com, Nidadavolu.Murthy@cavium.com,
        George.Cherian@cavium.com,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0080.outbound.protection.outlook.com ([104.47.33.80]:64480
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750905AbdE3L6l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 07:58:41 -0400
In-Reply-To: <3575749.J6klBtBYWh@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds support for Cavium CNN55XX crypto adapters.
  
 CNN55XX crypto adapters belongs to Cavium NITROX family series,
 able to accelerates both Symmetric and Asymmetric crypto workloads.
 These adapters have crypto cores for Symmetric and Asymmetric
 crypto operations, and needs to load firmware to become operational.
 
 Patches are generated on top of kernel/git/herbert/crypto-2.6

 The series was tested with dm-crypt for in kernel
 cryptographic offload operations.

Changes from v1 to v2:
- Addressed the Stephan Muller comments.
  - Moved from ablkcipher to skcipher API.
  - Clear the context information while releasing.
- Cleanup in request processing, avoids unnecessary copies.
- Use refcount_t type for reference counters.
- Dependencies updated in Kconfig.

Srikanth Jampala (3):
  crypto: cavium - Add support for CNN55XX adapters.
  crypto: cavium - Add debugfs support in CNN55XX driver.
  crypto: cavium - Register the CNN55XX supported crypto algorithms.

 drivers/crypto/Kconfig                       |    1 +
 drivers/crypto/Makefile                      |    1 +
 drivers/crypto/cavium/nitrox/Kconfig         |   21 +
 drivers/crypto/cavium/nitrox/Makefile        |    8 +
 drivers/crypto/cavium/nitrox/nitrox_algs.c   |  457 +++++++++++
 drivers/crypto/cavium/nitrox/nitrox_common.h |   42 +
 drivers/crypto/cavium/nitrox/nitrox_csr.h    | 1084 ++++++++++++++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_dev.h    |  179 +++++
 drivers/crypto/cavium/nitrox/nitrox_hal.c    |  401 ++++++++++
 drivers/crypto/cavium/nitrox/nitrox_isr.c    |  467 +++++++++++
 drivers/crypto/cavium/nitrox/nitrox_lib.c    |  210 +++++
 drivers/crypto/cavium/nitrox/nitrox_main.c   |  640 +++++++++++++++
 drivers/crypto/cavium/nitrox/nitrox_req.h    |  445 +++++++++++
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c |  732 +++++++++++++++++
 14 files changed, 4688 insertions(+)
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
