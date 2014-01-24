From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 0/4] crypto: ccp - selective algorithm registration and
 ipsec-related fixes
Date: Fri, 24 Jan 2014 16:17:50 -0600
Message-ID: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Patch 1: Allow for selectively disabling the registration of an algorithm
family (sha or aes algorithms) via module parameters.

Patch 2-4: Fix errors/issues that were found during IPSec testing. In
order to prevent deadlocks with the networking code, the crypto callback
was changed to run as a tasklet.  In order for the callback to be run as
a tasklet, the HMAC calculation needed to be moved out of the callback
path (since it sleeps) and into the CCP sha operation logic.  Additionally,
trying to allow concurrency within the tfm while maintaining serialization
of the tfm per CPU was not working properly so a single queue is used now.

This patch series is based on the cryptodev-2.6 kernel tree.

---

Tom Lendacky (4):
      crypto: ccp - Allow for selective disablement of crypto API algorithms
      crypto: ccp - Move HMAC calculation down to ccp ops file
      crypto: ccp - Use a single queue for proper ordering of tfm requests
      crypto: ccp - Perform completion callbacks using a tasklet


 drivers/crypto/ccp/ccp-crypto-main.c |  201 ++++++++++++----------------------
 drivers/crypto/ccp/ccp-crypto-sha.c  |  130 ++++------------------
 drivers/crypto/ccp/ccp-crypto.h      |    8 +
 drivers/crypto/ccp/ccp-dev.c         |   21 +++-
 drivers/crypto/ccp/ccp-ops.c         |  104 +++++++++++++++++-
 include/linux/ccp.h                  |    7 +
 6 files changed, 229 insertions(+), 242 deletions(-)

-- 
Tom Lendacky
