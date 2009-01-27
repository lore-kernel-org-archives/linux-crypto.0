From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.29
Date: Tue, 27 Jan 2009 17:15:46 +1100
Message-ID: <20090127061546.GA27962@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au> <20090115044020.GA29891@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52682 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751481AbZA0GPx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2009 01:15:53 -0500
Content-Disposition: inline
In-Reply-To: <20090115044020.GA29891@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a number of minor bugs:

* A crash in authenc that may occur if null encryption is used
  (a rare configuration).
* Error handling in blkcipher_walk_done (though this error should
  never occur unless underlying algorithm is buggy).
* Crash in CCM with no association data (only occurs for certification
  testing).

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (2):
      crypto: authenc - Fix zero-length IV crash
      crypto: blkcipher - Fix WARN_ON handling in walk_done

Jarod Wilson (1):
      crypto: ccm - Fix handling of null assoc data

 crypto/authenc.c   |   24 +++++++++++++++---------
 crypto/blkcipher.c |    2 +-
 crypto/ccm.c       |    2 ++
 3 files changed, 18 insertions(+), 10 deletions(-)
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
