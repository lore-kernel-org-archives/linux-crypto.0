From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.26
Date: Thu, 10 Jul 2008 20:51:26 +0800
Message-ID: <20080710125126.GA25843@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080509132343.GA12979@gondor.apana.org.au> <20080602080512.GA22059@gondor.apana.org.au> <20080709003741.GA32340@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47436 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753927AbYGJMve (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2008 08:51:34 -0400
Content-Disposition: inline
In-Reply-To: <20080709003741.GA32340@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Just found a regression introduced back in 2.6.25.  This causes
packet leaks when IPsec is in use.  When that leak grows it can
eventually lead to hung connections (as their send buffers are
used up) or worse.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: chainiv - Invoke completion function

 crypto/chainiv.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
