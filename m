From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.33
Date: Tue, 2 Feb 2010 06:52:04 +1100
Message-ID: <20100201195204.GA6953__42515.9805141904$1265053962$gmane$org@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au> <20090910141905.GA17948@gondor.apana.org.au> <20091020065442.GA5947@gondor.apana.org.au> <20091230021253.GA17067@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57751 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756004Ab0BATwL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2010 14:52:11 -0500
Content-Disposition: inline
In-Reply-To: <20091230021253.GA17067@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a couple of serious bugs:

* UBIFS assertion failure caused by /dev/random (since forever)
* Broken hmac support in padlock-sha (since 2.6.32)


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (2):
      crypto: padlock-sha - Add import/export support
      random: Remove unused inode variable

Matt Mackall (1):
      random: drop weird m_time/a_time manipulation

 drivers/char/random.c        |    9 ---------
 drivers/crypto/padlock-sha.c |   23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 9 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
