From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 3.4
Date: Mon, 2 Apr 2012 17:45:16 +0800
Message-ID: <20120402094516.GA23763@gondor.apana.org.au>
References: <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au> <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au> <20120126024342.GA12492@gondor.apana.org.au> <20120322012046.GA8854@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:40627 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075Ab2DBJpZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Apr 2012 05:45:25 -0400
Content-Disposition: inline
In-Reply-To: <20120322012046.GA8854@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a number of issues:

* Fix for CPU hotplug hang in padata.
* Avoid using cpu_active inappropriately in pcrypt and padata.
* Fix for user-space algorithm lookup hang with IV generators.
* Fix for netlink dump of algorithms where stuff went missing due
  to incorrect calculation of message size.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Steffen Klassert (6):
      padata: Add a reference to the api documentation
      padata: Use the online cpumask as the default
      padata: Fix cpu hotplug
      crypto: pcrypt - Use the online cpumask as the default
      crypto: user - Fix lookup of algorithms with IV generator
      crypto: user - Fix size of netlink dump message

 crypto/ablkcipher.c                |    4 +-
 crypto/aead.c                      |    4 +-
 crypto/crypto_user.c               |   80 +++++++++++++++++++++++++++++++++++-
 crypto/pcrypt.c                    |    8 ++--
 include/crypto/internal/aead.h     |    2 +
 include/crypto/internal/skcipher.h |    2 +
 include/linux/cryptouser.h         |    3 +
 kernel/padata.c                    |   13 ++++--
 8 files changed, 103 insertions(+), 13 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
