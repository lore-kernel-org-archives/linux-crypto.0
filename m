From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.1
Date: Wed, 20 May 2015 14:54:41 +0800
Message-ID: <20150520065441.GA8330@gondor.apana.org.au>
References: <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20141231033217.GA27261@gondor.apana.org.au>
 <20150107021737.GA25043@gondor.apana.org.au>
 <20150425080310.GA6873@gondor.apana.org.au>
 <20150505100621.GA8678@gondor.apana.org.au>
 <20150511055608.GA2055@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60417 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbbETGyz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 02:54:55 -0400
Content-Disposition: inline
In-Reply-To: <20150511055608.GA2055@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a the crash in the newly added algif_aead interface
when it tries to link SG lists.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Tadeusz Struk (1):
      crypto: algif_aead - fix invalid sgl linking

 crypto/algif_aead.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
