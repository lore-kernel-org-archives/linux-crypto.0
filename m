From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.6
Date: Wed, 23 Mar 2016 21:09:39 +0800
Message-ID: <20160323130939.GA29644@gondor.apana.org.au>
References: <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38937 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbcCWNJu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2016 09:09:50 -0400
Content-Disposition: inline
In-Reply-To: <20160122101828.GA15966@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

API:

* Fix kzalloc error path crash in ecryptfs added by skcipher
conversion.  Note the subject of the commit is screwed up and
the correct subject is actually in the body.

Drivers:

* A number of fixes to the marvell cesa hashing code.
* Remove bogus nested irqsave that clobbers the saved flags in ccp.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Boris BREZILLON (3):
      crypto: marvell/cesa - fix memory leak
      crypto: marvell/cesa - initialize hash states
      crypto: marvell/cesa - forward devm_ioremap_resource() error code

Gary R Hook (1):
      crypto: ccp - fix lock acquisition code

Herbert Xu (1):
      eCryptfs: Use skcipher and shash

 drivers/crypto/ccp/ccp-dev.c  |    6 +--
 drivers/crypto/marvell/cesa.c |    2 +-
 drivers/crypto/marvell/cesa.h |    3 +-
 drivers/crypto/marvell/hash.c |  106 +++++++++++++++--------------------------
 fs/ecryptfs/keystore.c        |    6 +--
 5 files changed, 46 insertions(+), 77 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
