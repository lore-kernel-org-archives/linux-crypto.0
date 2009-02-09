From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Fixes for 2.6.29
Date: Mon, 9 Feb 2009 14:39:24 +1100
Message-ID: <20090209033924.GA31250@gondor.apana.org.au>
References: <20080501102812.GA7151@gondor.apana.org.au> <20080727063659.GA936@gondor.apana.org.au> <20090115044020.GA29891@gondor.apana.org.au> <20090127061546.GA27962@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42555 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752988AbZBIDje (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 22:39:34 -0500
Content-Disposition: inline
In-Reply-To: <20090127061546.GA27962@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a number of bugs/regerssions:

* shash modules weren't ref counted properly.
* AEAD initialisation may fail which broke IPsec.
* Not all memory were zeroed when a crypto tfm is freed.
* We were doing flush_dcache_page on slab pages.
 
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Adrian-Ken Rueegsegger (1):
      crypto: shash - Fix module refcount

Herbert Xu (4):
      crypto: api - Fix algorithm test race that broke aead initialisation
      crypto: api - Fix zeroing on free
      crypto: shash - Fix tfm destruction
      crypto: scatterwalk - Avoid flush_dcache_page on slab pages

 crypto/algapi.c        |    6 +++++-
 crypto/api.c           |   20 ++++++++++----------
 crypto/scatterwalk.c   |    3 ++-
 crypto/shash.c         |    7 ++++++-
 include/crypto/hash.h  |    2 +-
 include/linux/crypto.h |    7 ++++++-
 6 files changed, 30 insertions(+), 15 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
