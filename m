From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 3.15
Date: Wed, 21 May 2014 20:22:13 +0800
Message-ID: <20140521122213.GA24102@gondor.apana.org.au>
References: <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20140413233411.GA19019@gondor.apana.org.au>
 <20140513110233.GA21743@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:54378 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaEUMWY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2014 08:22:24 -0400
Content-Disposition: inline
In-Reply-To: <20140513110233.GA21743@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a NULL pointer dereference on allocation failure
in caam, as well as a regression in the ctr mode on s390 that was
added with the recent concurrency fixes.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Harald Freudenberger (1):
      crypto: s390 - fix aes,des ctr mode concurrency finding.

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

 arch/s390/crypto/aes_s390.c |    3 +++
 arch/s390/crypto/des_s390.c |    3 +++
 drivers/crypto/caam/error.c |   10 +++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
