Return-Path: <SRS0=1Gsi=PR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr690060.outbound.protection.outlook.com ([40.107.69.60]:65088
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729148AbfAIJ0m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Jan 2019 04:26:42 -0500
From: Kalyani Akula <kalyani.akula@xilinx.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH V2 0/4] Add Xilinx's ZynqMP SHA3 driver support
Date: Wed, 9 Jan 2019 14:56:21 +0530
Message-ID: <1547025985-7228-1-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set adds support for
- dt-binding docs for Xilinx ZynqMP SHA3 driver
- Adds communication layer support for sha_hash in zynqmp.c
- Adds Xilinx ZynqMP driver for SHA3 Algorithm
- Adds device tree node for ZynqMP SHA3 driver

V2 Changes :
- Added new patch (2/4) for sha_hash zynqmp API support
- Incorporated code review comments from v1 patch series. Discussed below:
        https://lore.kernel.org/patchwork/patch/1029433/

Kalyani Akula (4):
  dt-bindings: crypto: Add bindings for ZynqMP SHA3 driver
  firmware: xilinx: Add ZynqMP sha_hash API for SHA3 functionality
  crypto: Add Xilinx SHA3 driver
  ARM64: zynqmp: Add Xilinix SHA-384 node.

 .../devicetree/bindings/crypto/zynqmp-sha.txt      |   12 +
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |    4 +
 drivers/crypto/Kconfig                             |   10 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/zynqmp-sha.c                        |  305 ++++++++++++++++++++
 drivers/firmware/xilinx/zynqmp.c                   |   27 ++
 include/linux/firmware/xlnx-zynqmp.h               |    2 +
 7 files changed, 361 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/zynqmp-sha.txt
 create mode 100644 drivers/crypto/zynqmp-sha.c
