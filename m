From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.26
Date: Wed, 9 Jul 2008 08:37:41 +0800
Message-ID: <20080709003741.GA32340@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080509132343.GA12979@gondor.apana.org.au> <20080602080512.GA22059@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38175 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752131AbYGIAhs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jul 2008 20:37:48 -0400
Content-Disposition: inline
In-Reply-To: <20080602080512.GA22059@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a memory leak in the crypto testing module.  Since
this module is designed to be used repeatedly, the leak could add
up quickly.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Darren Jenkins (1):
      crypto: tcrypt - Fix memory leak in test_cipher

 crypto/tcrypt.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
