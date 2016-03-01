From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 0/4] crypto: ccp - CCP driver updates  2016-03-01
Date: Tue, 1 Mar 2016 13:48:43 -0600
Message-ID: <20160301194831.6788.2154.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0056.outbound.protection.outlook.com ([157.56.111.56]:10064
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750813AbcCAUEG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Mar 2016 15:04:06 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following patches are includes in this update series:

- Remove the extraneous family check
- Refactor code to enable support for >1 CCPs in a system
- Add initial support for versioning
- Refactor: move version-specific code to separate files 
  where possible; abstract worker functions through a
  struct of function pointers

This patch series is based on cryptodev-2.6

---

Gary R Hook (4):
      crypto: ccp - Remove check for x86 family and model
      crypto: ccp - Support for multiple CCPs
      crypto: ccp - CCP versioning support
      crypto: ccp - Add abstraction for device-specific calls


 drivers/crypto/ccp/Makefile         |    2 
 drivers/crypto/ccp/ccp-crypto-aes.c |   12 +
 drivers/crypto/ccp/ccp-crypto-sha.c |    9 +
 drivers/crypto/ccp/ccp-dev-v3.c     |  534 +++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.c        |  471 ++++++++++---------------------
 drivers/crypto/ccp/ccp-dev.h        |  155 ++++++++++
 drivers/crypto/ccp/ccp-ops.c        |  381 +------------------------
 drivers/crypto/ccp/ccp-pci.c        |   23 +-
 drivers/crypto/ccp/ccp-platform.c   |   48 +++
 include/linux/ccp.h                 |   17 +
 10 files changed, 938 insertions(+), 714 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-dev-v3.c

--
