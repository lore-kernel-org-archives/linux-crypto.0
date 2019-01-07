Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr790040.outbound.protection.outlook.com ([40.107.79.40]:42496
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726625AbfAGJDO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Jan 2019 04:03:14 -0500
From: Kalyani Akula <kalyani.akula@xilinx.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH 0/3] Add Xilinx's ZynqMP SHA3 driver support
Date: Mon, 7 Jan 2019 14:32:53 +0530
Message-ID: <1546851776-3456-1-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set adds support for 
- dt-binding docs for Xilinx ZynqMP SHA3 driver
- Adds Xilinx ZynqMP driver for SHA3 Algorithm
- Adds device tree node for ZynqMP SHA3 driver

Kalyani Akula (3):
  dt-bindings: crypto: Add bindings for ZynqMP SHA3 driver
  crypto: Add Xilinx SHA3 driver
  ARM64: zynqmp: Add Xilinix SHA-384 node.

 .../devicetree/bindings/crypto/zynqmp-sha.txt      |   12 +
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |    4 +
 drivers/crypto/Kconfig                             |   10 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/zynqmp-sha.c                        |  303 ++++++++++++++++++++
 5 files changed, 330 insertions(+), 0 deletions(-)
 create mode 100755 Documentation/devicetree/bindings/crypto/zynqmp-sha.txt
 create mode 100755 drivers/crypto/zynqmp-sha.c
