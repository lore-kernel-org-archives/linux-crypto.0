From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 2.6.29
Date: Thu, 15 Jan 2009 15:40:20 +1100
Message-ID: <20090115044020.GA29891@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48371 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755196AbZAOEk3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 23:40:29 -0500
Content-Disposition: inline
In-Reply-To: <20080727063659.GA936@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a crash in authenc that may occur if null encryption
is used (a rare configuration).

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: authenc - Fix zero-length IV crash

 crypto/authenc.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
