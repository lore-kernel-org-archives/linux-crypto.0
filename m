From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.31
Date: Thu, 3 Sep 2009 08:03:27 +1000
Message-ID: <20090902220327.GA17020@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au> <20090621140924.GA3305@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55826 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752858AbZIBWDb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Sep 2009 18:03:31 -0400
Content-Disposition: inline
In-Reply-To: <20090621140924.GA3305@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a serious regression for IPsec when using the
chainiv algorithm.  We were checking for NULL after converting a
pointer that can be NULL to its container, which means that
the NULL pointer check is useless.  This would occur when the
chainiv backlog queue is depleted.  The result is a crash.

Based on the one report received it does not occur all the time
though, possibly because we only use the backlog when two CPUs
try to push data through a single SA at the same time, which is
rare.
 
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: skcipher - Fix skcipher_dequeue_givcrypt NULL test

 crypto/algapi.c                    |   11 +++++++++--
 include/crypto/algapi.h            |    1 +
 include/crypto/internal/skcipher.h |    4 ++--
 3 files changed, 12 insertions(+), 4 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
