From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.11
Date: Fri, 24 Mar 2017 21:46:27 +0800
Message-ID: <20170324134627.GA14273@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
 <20170304074119.GA3041@gondor.apana.org.au>
 <20170315063151.GA6767@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42550 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754323AbdCXNqs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 09:46:48 -0400
Content-Disposition: inline
In-Reply-To: <20170315063151.GA6767@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes regressions in the crypto ccp driver and the
hwrng drivers amd and geode.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Gary R Hook (1):
      crypto: ccp - Assign DMA commands to the channel's CCP

Prarit Bhargava (2):
      hwrng: amd - Revert managed API changes
      hwrng: geode - Revert managed API changes

 drivers/char/hw_random/amd-rng.c   |   42 ++++++++++++++++++++++++------
 drivers/char/hw_random/geode-rng.c |   50 +++++++++++++++++++++++++-----------
 drivers/crypto/ccp/ccp-dev.c       |    5 +++-
 drivers/crypto/ccp/ccp-dmaengine.c |    1 +
 include/linux/ccp.h                |    2 +-
 5 files changed, 75 insertions(+), 25 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
