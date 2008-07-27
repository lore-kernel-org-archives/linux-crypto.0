From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 2.6.27
Date: Sun, 27 Jul 2008 14:36:59 +0800
Message-ID: <20080727063659.GA936@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43607 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbYG0GhI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 Jul 2008 02:37:08 -0400
Content-Disposition: inline
In-Reply-To: <20080501102812.GA7151@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a number of bugs in the recently added talitos
driver.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Kim Phillips (4):
      crypto: talitos - Preempt overflow interrupts
      crypto: talitos - Fix GFP flag usage
      crypto: talitos - Stop leaking memory in error path
      crypto: talitos - sparse fix

Lee Nipper (2):
      crypto: talitos - Remove calls to of_node_put
      crypto: talitos - Correct dst != src case handling

 drivers/crypto/talitos.c |   49 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
