From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.3
Date: Sun, 27 Sep 2015 04:01:33 +0800
Message-ID: <20150926200133.GA19035@gondor.apana.org.au>
References: <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150908092502.GA8332@gondor.apana.org.au>
 <20150916103014.GA12315@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41496 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbbIZUBm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Sep 2015 16:01:42 -0400
Content-Disposition: inline
In-Reply-To: <20150916103014.GA12315@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

* Check the return value of platform_get_irq as signed int in xgene.
* Skip adf_dev_restore on virtual functions in qat.
* Fix double-free with backlogged requests in marvell_cesa.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Andrzej Hajda (1):
      hwrng: xgene - fix handling platform_get_irq

Conor McLoughlin (1):
      crypto: qat - VF should never trigger SBR on PH

Thomas Petazzoni (1):
      crypto: marvell - properly handle CRYPTO_TFM_REQ_MAY_BACKLOG-flagged requests

 drivers/char/hw_random/xgene-rng.c      |    7 ++++---
 drivers/crypto/marvell/cesa.h           |   27 +++++++++++++++++++++++++++
 drivers/crypto/marvell/cipher.c         |    7 +++----
 drivers/crypto/marvell/hash.c           |    8 +++-----
 drivers/crypto/qat/qat_common/adf_aer.c |    3 +++
 5 files changed, 40 insertions(+), 12 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
