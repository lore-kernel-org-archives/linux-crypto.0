From: David Miller <davem@davemloft.net>
Subject: [PATCH 0/7]: N2CRYPTO fixes and HMAC support
Date: Tue, 25 May 2010 17:43:29 -0700 (PDT)
Message-ID: <20100525.174329.59682635.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37711
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab0EZAnT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:43:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


As we discussed side-band the n2crypto driver plumbed async hash
requests to fallbacks incorrectly.  And along the way I found
several other bugs as well.

The recent of_device/of_platform_driver infrastructure changes
criss-crossed the n2_crypto driver addition, so some fixups
were needed to restore the build.

Finally, HMAC support because really easy to add once the async
hash fallback stuff was fixed properly, so here it is :-)

Please pull, thanks a lot.

The following changes since commit b1cdc4670b9508fcd47a15fbd12f70d269880b37:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/crypto-2.6.git master

David S. Miller (7):
      n2_crypto: Fix build after of_device/of_platform_driver changes.
      n2_crypto: Fix MAU kmem_cache name.
      n2_crypto: Plumb fallback ahash requests properly.
      n2_crypto: Kill n2_base_ctx and helpers.
      n2_crypto: Log algorithm success/failure in kernel log.
      n2_crypto: Make ahash parameterization explicit.
      n2_crypto: Add HMAC support.

 drivers/crypto/n2_core.c |  520 +++++++++++++++++++++++++++++++---------------
 1 files changed, 352 insertions(+), 168 deletions(-)
