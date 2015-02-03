From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 0/5] crypto: ccp - CCP driver updates 2015-01-28
Date: Tue, 3 Feb 2015 13:06:59 -0600
Message-ID: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0145.outbound.protection.outlook.com ([157.56.110.145]:55104
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965948AbbBCTlW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2015 14:41:22 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For some reason this series never reached the mailing list... resending.

The following series of patches includes functional updates to the
driver as well as some trivial changes.

- Fix checks/warnings from checkpatch
- Update how the CCP is built (Kconfig and Makefile)
- Use dma_set_mask_and_coherent to set the DMA mask
- Use devm_ calls where appropriate
- Add ACPI support
  
This patch series is based on cryptodev-2.6.

---

Tom Lendacky (5):
      crypto: ccp - Updates for checkpatch warnings/errors
      crypto: ccp - Update CCP build support
      crypto: ccp - Use dma_set_mask_and_coherent to set DMA mask
      crypto: ccp - Convert calls to their devm_ counterparts
      crypto: ccp - Add ACPI support


 drivers/crypto/Kconfig                   |    2 -
 drivers/crypto/ccp/Makefile              |    9 +-
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   12 ++-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c  |    4 -
 drivers/crypto/ccp/ccp-crypto-aes.c      |    3 -
 drivers/crypto/ccp/ccp-crypto-main.c     |    5 +
 drivers/crypto/ccp/ccp-crypto-sha.c      |   12 ++-
 drivers/crypto/ccp/ccp-crypto.h          |    3 -
 drivers/crypto/ccp/ccp-dev.c             |    7 +-
 drivers/crypto/ccp/ccp-dev.h             |   12 +--
 drivers/crypto/ccp/ccp-ops.c             |   24 +++---
 drivers/crypto/ccp/ccp-pci.c             |   21 ++----
 drivers/crypto/ccp/ccp-platform.c        |  111 ++++++++++++++++++++++++++----
 13 files changed, 143 insertions(+), 82 deletions(-)

-- 
Tom Lendacky
