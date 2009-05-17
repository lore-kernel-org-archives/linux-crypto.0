From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 2.6.30
Date: Mon, 18 May 2009 08:28:18 +1000
Message-ID: <20090517222818.GA14969@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090402061413.GA28925@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38311 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752404AbZEQW2Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 May 2009 18:28:24 -0400
Content-Disposition: inline
In-Reply-To: <20090402061413.GA28925@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a few bugs/regressions:

* Check firmware before claiming algorithm support in ixp4xx.
* Fix autoloading of optimised AES modules.
* Fix eseqiv IV generation.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Christian Hohnstaedt (1):
      crypto: ixp4xx - check firmware for crypto support

Herbert Xu (2):
      crypto: api - Fix algorithm module auto-loading
      crypto: padlock - Revert aes-all alias to aes

Steffen Klassert (1):
      crypto: eseqiv - Fix IV generation for sync algorithms

 crypto/api.c                   |    3 ++-
 crypto/eseqiv.c                |    3 ++-
 drivers/crypto/ixp4xx_crypto.c |   33 ++++++++++++++++++++++++++++++++-
 drivers/crypto/padlock-aes.c   |    2 +-
 4 files changed, 37 insertions(+), 4 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
