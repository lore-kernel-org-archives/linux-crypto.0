From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 3.4
Date: Fri, 20 Apr 2012 22:16:08 +0800
Message-ID: <20120420141608.GA9686@gondor.apana.org.au>
References: <20100722055043.GA25689@gondor.apana.org.au>
 <20100903060055.GA28915@gondor.apana.org.au>
 <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120322012046.GA8854@gondor.apana.org.au>
 <20120402094516.GA23763@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:43151 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753931Ab2DTOQQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Apr 2012 10:16:16 -0400
Content-Disposition: inline
In-Reply-To: <20120402094516.GA23763@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a number of issues:

* Locking fix for talitos driver.
* Fix 64-bit counter overflow in SHA-512.
* Build fix for ixp4xx.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Horia Geanta (1):
      crypto: talitos - properly lock access to global talitos register=
s

Kent Yoder (1):
      crypto: sha512 - Fix byte counter overflow in SHA-512

Micha=C5=82 Wr=C3=B3bel (1):
      crypto: ixp4xx - include fix

 crypto/sha512_generic.c        |    2 +-
 drivers/crypto/ixp4xx_crypto.c |    1 +
 drivers/crypto/talitos.c       |   20 +++++++++++++++++---
 3 files changed, 19 insertions(+), 4 deletions(-)
=20
Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
