From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.2
Date: Mon, 17 Aug 2015 16:27:15 +0800
Message-ID: <20150817082715.GA28272@gondor.apana.org.au>
References: <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150630135135.GA24621@gondor.apana.org.au>
 <20150713040858.GA7160@gondor.apana.org.au>
 <20150803071636.GA19444@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34527 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbbHQI11 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 04:27:27 -0400
Content-Disposition: inline
In-Reply-To: <20150803071636.GA19444@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

* A regression caused by the conversion of IPsec ESP to the new
  AEAD interface: ESN with authencesn no longer works because it
  relied on the AD input SG list having a specific layout which
  is no longer the case.  In linux-next authencesn is fixed properly
  and no longer assumes anything about the SG list format.  While
  for this release a minimal fix is applied to authencesn so that
  it works with the new linear layout.
* Fix memory corruption caused by bogus index in the caam hash code.
* Fix powerpc nx SHA hashing which could cause module load failures
  if module signature verification is enabled.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: authencesn - Fix breakage with new ESP code

Horia Geant? (1):
      crypto: caam - fix memory corruption in ahash_final_ctx

Jan Stancek (1):
      crypto: nx - respect sg limit bounds when building sg lists for SHA

 crypto/authencesn.c            |   44 +++++++++++-----------------------------
 drivers/crypto/caam/caamhash.c |    7 ++++---
 drivers/crypto/nx/nx-sha256.c  |   27 ++++++++++++++----------
 drivers/crypto/nx/nx-sha512.c  |   28 ++++++++++++++-----------
 4 files changed, 48 insertions(+), 58 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
