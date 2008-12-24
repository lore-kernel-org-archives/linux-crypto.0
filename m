From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 2.6.28
Date: Thu, 25 Dec 2008 09:20:45 +1100
Message-ID: <20081224222045.GA488@gondor.apana.org.au>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org> <20081011021357.GB3685@gondor.apana.org.au> <20081210123524.GA11696@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37323 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751222AbYLXWUw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Dec 2008 17:20:52 -0500
Content-Disposition: inline
In-Reply-To: <20081210123524.GA11696@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

A regression has been reported where the new algorithm testing
infrastructure may cause the optimised versions of AES to fail
when it's built into the kernel (as opposed to as a module).
This is due to its use of shared AES tables that may not have
been initialised yet.  This has been fixed by pregenerating
the tables instead of having them computed at boot/run-time.
  
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: aes - Precompute tables

 crypto/aes_generic.c | 1145 ++++++++++++++++++++++++++++++++++++++++++++++----
 include/crypto/aes.h |    8 +-
 2 files changed, 1059 insertions(+), 94 deletions(-)
  
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
