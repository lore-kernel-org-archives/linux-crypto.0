From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.27
Date: Mon, 8 Sep 2008 14:33:23 +1000
Message-ID: <20080908043323.GA15259@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au> <20080813121620.GA23142@gondor.apana.org.au> <20080822151102.GA678@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40430 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbYIHFaH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Sep 2008 01:30:07 -0400
Content-Disposition: inline
In-Reply-To: <20080822151102.GA678@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push reverts a patch that caused a regression after 2.6.26.
It broke the Camellia algorithm which may be used by IPsec or for
encrypted disks.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      Revert "crypto: camellia - Use kernel-provided bitops, unaligned access helpers"

 crypto/camellia.c |   84 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 48 insertions(+), 36 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
