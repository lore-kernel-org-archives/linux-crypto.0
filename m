From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 3.13
Date: Wed, 1 Jan 2014 14:10:16 +0800
Message-ID: <20140101061016.GA22579@gondor.apana.org.au>
References: <20101215115035.GA25248@gondor.apana.org.au>
 <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au>
 <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:49003 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaAAGK0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jan 2014 01:10:26 -0500
Content-Disposition: inline
In-Reply-To: <20131209115705.GA1361@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a build error on ARM that was introduced in 3.13-rc1.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Krzysztof Ha=C5=82asa (1):
      crypto: ixp4xx - Fix kernel compile error

 drivers/crypto/ixp4xx_crypto.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
