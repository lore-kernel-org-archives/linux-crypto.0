From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.26
Date: Tue, 15 Jul 2008 23:53:08 +0800
Message-ID: <20080715155308.GA7263@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57893 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753764AbYGOPxO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Jul 2008 11:53:14 -0400
Content-Disposition: inline
In-Reply-To: <20080501102812.GA7151@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push reverts the CTR-based PRNG as it clearly isn't able
to pass Ingo's random config hurdle.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      Revert crypto: prng - Deterministic CPRNG

 crypto/Kconfig  |    9 -
 crypto/Makefile |    2 
 crypto/prng.c   |  410 --------------------------------------------------------
 crypto/prng.h   |   27 ---
 4 files changed, 1 insertion(+), 447 deletions(-)


Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
