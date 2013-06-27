From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 3.10
Date: Thu, 27 Jun 2013 21:02:26 +0800
Message-ID: <20130627130225.GA1612@gondor.apana.org.au>
References: <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20130528055229.GA23937@gondor.apana.org.au>
 <20130610090544.GA13465@gondor.apana.org.au>
 <20130620132922.GA19014@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130620132922.GA19014@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a crash in the crypto layer exposed by an SCTP
test tool.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: algboss - Hold ref count on larval

 crypto/algboss.c  |   15 ++++++++-------
 crypto/api.c      |    6 ------
 crypto/internal.h |    6 ++++++
 3 files changed, 14 insertions(+), 13 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
