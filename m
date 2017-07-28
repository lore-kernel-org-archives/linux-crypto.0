From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.13
Date: Fri, 28 Jul 2017 16:49:55 +0800
Message-ID: <20170728084955.GA19586@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37938 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751722AbdG1IuM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 04:50:12 -0400
Content-Disposition: inline
In-Reply-To: <20170714141855.GA29426@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes the following issues:

- Remove broken dt bindings in inside-secure.
- Fix authencesn crash when used with digest_null.
- Fix cavium/nitrox firmware path.
- Fix SHA3 failure in brcm.
- Fix Kconfig dependency for brcm.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Antoine Tenart (2):
      crypto: inside-secure - do not parse the dma mask from dt
      Documentation/bindings: crypto: remove the dma-mask property

Herbert Xu (1):
      crypto: authencesn - Fix digest_null crash

Srikanth Jampala (1):
      crypto: cavium/nitrox - Change in firmware path.

raveendra padasalagi (2):
      crypto: brcm - Fix SHA3-512 algorithm failure
      crypto: brcm - remove BCM_PDC_MBOX dependency in Kconfig

 .../devicetree/bindings/crypto/inside-secure-safexcel.txt         |    2 --
 crypto/authencesn.c                                               |    5 +++++
 drivers/crypto/Kconfig                                            |    2 +-
 drivers/crypto/bcm/spu2.c                                         |    1 +
 drivers/crypto/cavium/nitrox/nitrox_main.c                        |    3 ++-
 drivers/crypto/inside-secure/safexcel.c                           |    5 +----
 6 files changed, 10 insertions(+), 8 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
