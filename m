Return-Path: <SRS0=/ZR5=OQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48972 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbeLGGOQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Dec 2018 01:14:16 -0500
Date: Fri, 7 Dec 2018 14:14:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 4.20
Message-ID: <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
References: <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes the following issues:

- Disable the new crypto stats interface as it's still being changed.
- Fix potential uses-after-free in cbc/cfb/pcbc.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (1):
      crypto: user - Disable statistics interface

Pan Bian (1):
      crypto: do not free algorithm before using

 crypto/Kconfig | 2 +-
 crypto/cbc.c   | 6 ++++--
 crypto/cfb.c   | 6 ++++--
 crypto/pcbc.c  | 6 ++++--
 4 files changed, 13 insertions(+), 7 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
