Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr800073.outbound.protection.outlook.com ([40.107.80.73]:14816
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725980AbfAQHCq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 02:02:46 -0500
From: Kalyani Akula <kalyani.akula@xilinx.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH 0/5] Add Xilinx's ZynqMP AES driver support
Date: Thu, 17 Jan 2019 12:32:16 +0530
Message-ID: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set adds support for
- dt-binding docs for Xilinx ZynqMP AES driver
- Adds device tree node for ZynqMP SHA3 driver
- Adds communication layer support for aes in zynqmp.c
- Adds user space interface for ALG_SET_KEY_TYPE
- Adds Xilinx ZynqMP driver for AES Algorithm

Kalyani Akula (5):
  dt-bindings: crypto: Add bindings for ZynqMP AES driver
  ARM64: zynqmp: Add Xilinix AES node.
  firmware: xilinx: Add ZynqMP aes API for AES functionality
  crypto: Adds user space interface for ALG_SET_KEY_TYPE
  crypto: Add Xilinx AES driver

 .../devicetree/bindings/crypto/xlnx,zynqmp-aes.txt |  12 +
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +
 crypto/af_alg.c                                    |   7 +
 crypto/algif_skcipher.c                            |   7 +
 crypto/blkcipher.c                                 |   9 +
 crypto/skcipher.c                                  |  18 ++
 drivers/crypto/Kconfig                             |  11 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/zynqmp-aes.c                        | 331 +++++++++++++++++++++
 drivers/firmware/xilinx/zynqmp.c                   |  24 ++
 include/crypto/if_alg.h                            |   2 +
 include/crypto/skcipher.h                          |  10 +
 include/linux/crypto.h                             |  12 +
 include/linux/firmware/xlnx-zynqmp.h               |   2 +
 include/uapi/linux/if_alg.h                        |   1 +
 15 files changed, 451 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.txt
 create mode 100644 drivers/crypto/zynqmp-aes.c

-- 
1.9.5
