From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 2.6.28
Date: Wed, 10 Dec 2008 23:35:24 +1100
Message-ID: <20081210123524.GA11696@gondor.apana.org.au>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org> <20081011021357.GB3685@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42172 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907AbYLJMfd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Dec 2008 07:35:33 -0500
Content-Disposition: inline
In-Reply-To: <20081011021357.GB3685@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

At this late stage there is just one fix for a regression from
2.6.27.  We used to allow algorithms to be built-in with the new
testing framework built as a module.  This meant that the built-in
algorithms may not get tested properly if modules can't be loaded
when the built-in algorithms are registered.  It also seems to
trigger a modprobe loop on one distro.  This configuration is now
forbidden.
 
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: api - Disallow cryptomgr as a module if algorithms are built-in

 crypto/Kconfig  |   36 ++++++++++++++++++++++++++++++++----
 crypto/Makefile |   18 +++++++++---------
 2 files changed, 41 insertions(+), 13 deletions(-)
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
