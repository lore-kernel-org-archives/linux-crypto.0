From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.6
Date: Fri, 13 May 2016 13:59:02 +0800
Message-ID: <20160513055902.GA13595@gondor.apana.org.au>
References: <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34223 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbcEMF7V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 May 2016 01:59:21 -0400
Content-Disposition: inline
In-Reply-To: <20160122101828.GA15966@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a bug in the RSA self-test that may cause crashes
on some architectures such as SPARC.
 

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (1):
      crypto: testmgr - Use kmalloc memory for RSA input

 crypto/testmgr.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
