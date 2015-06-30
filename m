From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.2
Date: Tue, 30 Jun 2015 22:51:35 +0900
Message-ID: <20150630135135.GA24621@gondor.apana.org.au>
References: <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43265 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbbF3Nvp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Jun 2015 09:51:45 -0400
Content-Disposition: inline
In-Reply-To: <20150626102234.GA19393@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the aesni setkey error and removes a couple of
unnecessary NULL checks in the Intel qat driver.

 
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Markus Elfring (1):
      crypto: qat - Deletion of unnecessary checks before two function calls

Tadeusz Struk (1):
      crypto: aesni - fix failing setkey for rfc4106-gcm-aesni

 arch/x86/crypto/aesni-intel_glue.c               |    2 +-
 drivers/crypto/qat/qat_common/adf_accel_engine.c |    5 +----
 drivers/crypto/qat/qat_common/adf_transport.c    |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
