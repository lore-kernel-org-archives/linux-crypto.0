From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 3.17
Date: Mon, 15 Sep 2014 19:35:06 +0800
Message-ID: <20140915113506.GA4736@gondor.apana.org.au>
References: <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20140710090314.GA15729@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:55734 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaIOLfR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Sep 2014 07:35:17 -0400
Content-Disposition: inline
In-Reply-To: <20140710090314.GA15729@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the newly added drbg generator so that it actually
works on 32-bit machines.  Previously the code was only tested on
64-bit and on 32-bit it overflowed and simply doesn't work.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: drbg - backport "fix maximum value checks on 32 bit systems"

Stephan Mueller (1):
      crypto: drbg - remove check for uninitialized DRBG handle

 crypto/drbg.c         |    3 ---
 include/crypto/drbg.h |   13 +++++++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
