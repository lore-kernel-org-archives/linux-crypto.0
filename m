From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 0/4] crypto: ccp - CCP driver updates 2015-10-01
Date: Thu, 1 Oct 2015 16:32:25 -0500
Message-ID: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0091.outbound.protection.outlook.com ([207.46.100.91]:29408
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750745AbbJAVcb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 17:32:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following patches are included in this driver update series:

- Remove the usage of BUG_ON and replace with WARN_ON and an error
  return code
- Remove unused variable
- Change references to accelerator to offload
- Use the module name in the driver structure instead of a
  descriptive name
 
This patch series is based on cryptodev-2.6.

---

Tom Lendacky (4):
      crypto: ccp - Replace BUG_ON with WARN_ON and a return code
      crypto: ccp - Remove use ACPI field
      crypto: ccp - Change references to accelerator to offload
      crypto: ccp - Use module name in driver structures


 drivers/crypto/Kconfig                   |    2 -
 drivers/crypto/ccp/Kconfig               |   13 ++--
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   20 +++++-
 drivers/crypto/ccp/ccp-crypto-main.c     |    6 +-
 drivers/crypto/ccp/ccp-crypto-sha.c      |   13 ++++
 drivers/crypto/ccp/ccp-ops.c             |  108 +++++++++++++++++++-----------
 drivers/crypto/ccp/ccp-pci.c             |    2 -
 drivers/crypto/ccp/ccp-platform.c        |    6 --
 8 files changed, 114 insertions(+), 56 deletions(-)

-- 
Tom Lendacky
