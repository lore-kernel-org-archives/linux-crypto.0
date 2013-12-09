From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 3.13
Date: Mon, 9 Dec 2013 19:57:05 +0800
Message-ID: <20131209115705.GA1361@gondor.apana.org.au>
References: <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131203124129.GA12067@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

Unfortunately the last push that fixed a crash in the crypto
scatterwalk code introduced a new crash when SG debugging is
enabled.  This push fixes that.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Tom Lendacky (1):
      crypto: scatterwalk - Use sg_chain_ptr on chain entries

 include/crypto/scatterwalk.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
