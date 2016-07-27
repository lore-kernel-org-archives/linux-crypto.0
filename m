From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 00/10] Enablement of a v5 CCP
Date: Tue, 26 Jul 2016 19:09:11 -0500
Message-ID: <20160727000652.24944.44919.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0084.outbound.protection.outlook.com ([104.47.36.84]:27020
	"EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753045AbcG0AJS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 20:09:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series updates the CCP driver to support
both current and new cryptographic coprocessor models.
Refactor code to further separate device-specific code
from driver logic, then add equivalent support for the
new device version.

---

Gary R Hook (10):
      crypto: ccp - Abstract PCI info for the CCP
      crypto: ccp - Shorten the fields of the action structure
      crypto: ccp - Refactoring: symbol cleanup
      crypto: ccp - Refactor the storage block allocation code
      crypto: ccp - Refactor code supporting the CCP's RNG
      crypto: ccp - Refactor code to enable checks for queue space.
      crypto: ccp - Let a v5 CCP provide the same function as v3
      crypto: ccp - Add support for the RNG in a version 5 CCP
      crypto: ccp - Enable DMA service on a v5 CCP
      crypto: ccp - Enable use of the additional CCP


 drivers/crypto/ccp/Makefile         |    1 
 drivers/crypto/ccp/ccp-crypto-sha.c |   18 +
 drivers/crypto/ccp/ccp-dev-v3.c     |  177 ++++--
 drivers/crypto/ccp/ccp-dev-v5.c     | 1011 +++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.c        |   58 ++
 drivers/crypto/ccp/ccp-dev.h        |  288 ++++++++--
 drivers/crypto/ccp/ccp-ops.c        |  576 +++++++++++---------
 drivers/crypto/ccp/ccp-pci.c        |   23 -
 include/linux/ccp.h                 |    3 
 9 files changed, 1744 insertions(+), 411 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-dev-v5.c

--
This Signature Intentionally Left Blank
