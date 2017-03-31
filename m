From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.11
Date: Fri, 31 Mar 2017 18:29:07 +0800
Message-ID: <20170331102907.GA11348@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
 <20170304074119.GA3041@gondor.apana.org.au>
 <20170315063151.GA6767@gondor.apana.org.au>
 <20170324134627.GA14273@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53934 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932677AbdCaK3i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2017 06:29:38 -0400
Content-Disposition: inline
In-Reply-To: <20170324134627.GA14273@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

- Memory corruption when kmalloc fails in xts/lrw.
- Mark some CCP DMA channels as private.
- Fix reordering race in padata.
- Regression in omap-rng DT description.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Eric Biggers (1):
      crypto: xts,lrw - fix out-of-bounds write after kmalloc failure

Gary R Hook (1):
      crypto: ccp - Make some CCP DMA channels private

Jason A. Donenfeld (1):
      padata: avoid race in reordering

Thomas Petazzoni (1):
      dt-bindings: rng: clocks property on omap_rng not always mandatory

 Documentation/devicetree/bindings/rng/omap_rng.txt |    3 +-
 crypto/lrw.c                                       |    7 +++-
 crypto/xts.c                                       |    7 +++-
 drivers/crypto/ccp/ccp-dev-v5.c                    |    1 +
 drivers/crypto/ccp/ccp-dev.h                       |    5 +++
 drivers/crypto/ccp/ccp-dmaengine.c                 |   41 ++++++++++++++++++++
 kernel/padata.c                                    |    5 ++-
 7 files changed, 62 insertions(+), 7 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
