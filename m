From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.35
Date: Thu, 22 Jul 2010 13:50:43 +0800
Message-ID: <20100722055043.GA25689@gondor.apana.org.au>
References: <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au> <20090910141905.GA17948@gondor.apana.org.au> <20091020065442.GA5947@gondor.apana.org.au> <20091230021253.GA17067@gondor.apana.org.au> <20100201195204.GA6953@gondor.apana.org.au> <20100305071043.GA3548@gondor.apana.org.au> <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59911 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0GVFuu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Jul 2010 01:50:50 -0400
Content-Disposition: inline
In-Reply-To: <20100716022648.GA28219@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a bug in the talito hash driver that causes too
much data to be copied.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Lee Nipper (1):
      crypto: talitos - fix bug in sg_copy_end_to_buffer

 drivers/crypto/talitos.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
