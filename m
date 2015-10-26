From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.3
Date: Mon, 26 Oct 2015 20:02:47 +0900
Message-ID: <20151026110247.GA20464@gondor.apana.org.au>
References: <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150908092502.GA8332@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37775 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbbJZLDR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Oct 2015 07:03:17 -0400
Content-Disposition: inline
In-Reply-To: <20150908092502.GA8332@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a problem in the Crypto API that may cause spurious
errors when signals are received by the process that made the orignal
system call into the kernel.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (1):
      crypto: api - Only abort operations on fatal signal

 crypto/ablkcipher.c  |    2 +-
 crypto/algapi.c      |    2 +-
 crypto/api.c         |    6 +++---
 crypto/crypto_user.c |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
