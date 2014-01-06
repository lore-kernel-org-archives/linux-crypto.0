From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 0/6] crypto: ccp - more code fixes/cleanup
Date: Mon, 6 Jan 2014 13:33:53 -0600
Message-ID: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:59622
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682AbaAFTeC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jan 2014 14:34:02 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements a fix to hash length wrapping as well
as some additional fixes and cleanups (proper gfp_t type on some memory
allocations, scatterlist usage improvements, null request result field
checks and driver enabled/disabled changes).

This patch series is based on the cryptodev-2.6 kernel tree.

---

Tom Lendacky (6):
      crypto: ccp - Apply appropriate gfp_t type to memory allocations
      crypto: ccp - Cleanup scatterlist usage
      crypto: ccp - Check for caller result area before using it
      crypto: ccp - Change data length declarations to u64
      crypto: ccp - Cleanup hash invocation calls
      crypto: ccp - CCP device enabled/disabled changes


 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |   38 +++++++++----
 drivers/crypto/ccp/ccp-crypto-sha.c      |   88 ++++++++++++++++++------------
 drivers/crypto/ccp/ccp-crypto.h          |   10 +++
 drivers/crypto/ccp/ccp-dev.c             |   15 +++++
 drivers/crypto/ccp/ccp-ops.c             |   34 ++++++------
 drivers/crypto/ccp/ccp-pci.c             |    3 +
 include/linux/ccp.h                      |   20 +++++--
 7 files changed, 139 insertions(+), 69 deletions(-)

-- 
Tom Lendacky
