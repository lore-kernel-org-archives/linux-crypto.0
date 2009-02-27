From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.29
Date: Fri, 27 Feb 2009 12:30:35 +0800
Message-ID: <20090227043035.GA21665@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au> <20090115044020.GA29891@gondor.apana.org.au> <20090127061546.GA27962@gondor.apana.org.au> <20090209033924.GA31250@gondor.apana.org.au> <20090217121252.GA22812@gondor.apana.org.au> <20090223095428.GA11076@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57828 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754798AbZB0Eaq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Feb 2009 23:30:46 -0500
Content-Disposition: inline
In-Reply-To: <20090223095428.GA11076@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a 2.6.27 regression where the new test mechanism
can cause the optimised AES implementation on s390 to hang on
initial module load.  The same thing can affect the VIA PadLock,
although modprobe alias ordering may have prevented it from
occurring.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: api - Fix module load deadlock with fallback algorithms

 arch/s390/crypto/aes_s390.c  |    2 +-
 crypto/api.c                 |   15 +++++++++++++--
 drivers/crypto/padlock-aes.c |    2 +-
 drivers/crypto/padlock-sha.c |    4 ++--
 4 files changed, 17 insertions(+), 6 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
