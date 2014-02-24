From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 0/3] crypto: ccp - minor code fixes
Date: Mon, 24 Feb 2014 08:41:56 -0600
Message-ID: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:40979
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbaBXOmF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Feb 2014 09:42:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series implements some fixes to some code paths executed
during crypto API request processing.  These fixes address processing of
requests when the CCP driver returns -EBUSY and freeing memory in error
paths.

This patch series is based on the cryptodev-2.6 kernel tree.

---

Tom Lendacky (3):
      crypto: ccp - Prevent a possible lost CCP command request
      crypto: ccp - Invoke context callback when there is a backlog error
      crypto: ccp - Account for CCP backlog processing


 drivers/crypto/ccp/ccp-crypto-main.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

-- 
Tom Lendacky
