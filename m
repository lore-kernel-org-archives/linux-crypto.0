From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.2
Date: Mon, 3 Aug 2015 15:16:36 +0800
Message-ID: <20150803071636.GA19444@gondor.apana.org.au>
References: <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150630135135.GA24621@gondor.apana.org.au>
 <20150713040858.GA7160@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34952 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbbHCHQp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 03:16:45 -0400
Content-Disposition: inline
In-Reply-To: <20150713040858.GA7160@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

* A bogus BUG_ON in ixp4xx that can be triggered by a dst buffer
  that is an SG list.
* The error handling in hwrngd may cause a crash in case of an error.
* Fix a race condition in qat registration when multiple devices are
  present.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: ixp4xx - Remove bogus BUG_ON on scattered dst buffer

Martin Schwidefsky (1):
      hwrng: core - correct error check of kthread_run call

Tadeusz Struk (1):
      crypto: qat - Fix invalid synchronization between register/unregister sym algs

 drivers/char/hw_random/core.c            |    2 +-
 drivers/crypto/ixp4xx_crypto.c           |    1 -
 drivers/crypto/qat/qat_common/qat_algs.c |   24 ++++++++++++++++--------
 3 files changed, 17 insertions(+), 10 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
