From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH V1 0/3] crypto: ccp - arm64 platform support
Date: Thu, 5 Jun 2014 10:17:39 -0500
Message-ID: <20140605151739.20604.41748.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:16859
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752374AbaFEPRo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jun 2014 11:17:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements support for the CCP as a platform
driver on ARM64.

This patch series is based on the cryptodev-2.6 kernel tree.

---

Tom Lendacky (3):
      crypto: ccp - Modify PCI support in prep for arm64 support
      crypto: ccp - CCP device bindings documentation
      crypto: ccp - Add platform device support for arm64


 .../devicetree/bindings/crypto/amd-ccp.txt         |   16 +
 drivers/crypto/Kconfig                             |    2 
 drivers/crypto/ccp/Makefile                        |    5 
 drivers/crypto/ccp/ccp-dev.c                       |   34 +++
 drivers/crypto/ccp/ccp-dev.h                       |   10 +
 drivers/crypto/ccp/ccp-pci.c                       |   39 +--
 drivers/crypto/ccp/ccp-platform.c                  |  224 ++++++++++++++++++++
 7 files changed, 301 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/amd-ccp.txt
 create mode 100644 drivers/crypto/ccp/ccp-platform.c

-- 
Tom Lendacky
