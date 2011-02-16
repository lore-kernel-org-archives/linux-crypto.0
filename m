From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 2.6.38
Date: Wed, 16 Feb 2011 16:39:11 +1100
Message-ID: <20110216053911.GA10999__18586.1880927861$1297834785$gmane$org@gondor.apana.org.au>
References: <20091230021253.GA17067@gondor.apana.org.au> <20100201195204.GA6953@gondor.apana.org.au> <20100305071043.GA3548@gondor.apana.org.au> <20100427135547.GA4008@gondor.apana.org.au> <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51530 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1BPFjT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Feb 2011 00:39:19 -0500
Content-Disposition: inline
In-Reply-To: <20101215115035.GA25248@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes an ancient bug in s390's implementation of SHA
that manifests itself only under certain conditions.  This bug
causes the generation of incorrect hashes, and potentially memory
corruption.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: sha-s390 - Reset index after processing partial block

 arch/s390/crypto/sha_common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
