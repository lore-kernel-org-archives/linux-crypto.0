From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.4
Date: Mon, 14 Dec 2015 17:29:38 +0800
Message-ID: <20151214092938.GA32124@gondor.apana.org.au>
References: <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150908092502.GA8332@gondor.apana.org.au>
 <20151026110247.GA20464@gondor.apana.org.au>
 <20151111070818.GA22344@gondor.apana.org.au>
 <20151205010425.GA21859@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35381 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbbLNJaH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Dec 2015 04:30:07 -0500
Content-Disposition: inline
In-Reply-To: <20151205010425.GA21859@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a boundary condition in the blkcipher SG walking
code that can lead to a crash when used with the new chacha20
algorithm.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Jason A. Donenfeld (1):
      crypto: skcipher - Copy iv from desc even for 0-len walks

 crypto/ablkcipher.c |    2 +-
 crypto/blkcipher.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
