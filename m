From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.1
Date: Tue, 5 May 2015 18:06:21 +0800
Message-ID: <20150505100621.GA8678@gondor.apana.org.au>
References: <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20141231033217.GA27261@gondor.apana.org.au>
 <20150107021737.GA25043@gondor.apana.org.au>
 <20150425080310.GA6873@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50287 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbbEEKGc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2015 06:06:32 -0400
Content-Disposition: inline
In-Reply-To: <20150425080310.GA6873@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a build problem with bcm63xx and yet another fix
to the memzero_explicit function to ensure that the memset is not
elided.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Daniel Borkmann (1):
      lib: make memzero_explicit more robust against dead store elimina=
tion

=C1lvaro Fern=E1ndez Rojas (1):
      hwrng: bcm63xx - Fix driver compilation

 drivers/char/hw_random/bcm63xx-rng.c |   18 +++++++++---------
 include/linux/compiler-gcc.h         |   16 +++++++++++++++-
 include/linux/compiler-intel.h       |    3 +++
 include/linux/compiler.h             |    4 ++++
 lib/string.c                         |    2 +-
 5 files changed, 32 insertions(+), 11 deletions(-)

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
