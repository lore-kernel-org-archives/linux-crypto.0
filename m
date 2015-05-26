From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.1
Date: Tue, 26 May 2015 16:43:51 +0800
Message-ID: <20150526084351.GA7377@gondor.apana.org.au>
References: <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20141231033217.GA27261@gondor.apana.org.au>
 <20150107021737.GA25043@gondor.apana.org.au>
 <20150425080310.GA6873@gondor.apana.org.au>
 <20150505100621.GA8678@gondor.apana.org.au>
 <20150511055608.GA2055@gondor.apana.org.au>
 <20150520065441.GA8330@gondor.apana.org.au>
 <20150522040559.GA30475@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47974 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbEZIoA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 04:44:00 -0400
Content-Disposition: inline
In-Reply-To: <20150522040559.GA30475@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push disables the newly (4.1) added user-space AEAD interface
so that we can fix issues in the underlying kernel AEAD interface.
Once the new kernel AEAD interface is ready we can then reenable
the user-space AEAD interface.
 
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: algif_aead - Disable AEAD user-space for now

 crypto/Kconfig |    9 ---------
 1 file changed, 9 deletions(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
