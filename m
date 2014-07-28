From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 3.16
Date: Mon, 28 Jul 2014 22:05:07 +0800
Message-ID: <20140728140507.GA11926@gondor.apana.org.au>
References: <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20140710090314.GA15729@gondor.apana.org.au>
 <20140718105717.GA18087@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34717 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaG1OFP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Jul 2014 10:05:15 -0400
Content-Disposition: inline
In-Reply-To: <20140718105717.GA18087@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a regression on ARM where odd-sized blocks supplied
to AES may cause crashes.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Mikulas Patocka (2):
      crypto: arm64-aes - fix encryption of unaligned data
      crypto: arm-aes - fix encryption of unaligned data

 arch/arm/crypto/aesbs-glue.c |   10 +++++-----
 arch/arm64/crypto/aes-glue.c |   12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
