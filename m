From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.3
Date: Wed, 16 Sep 2015 18:30:14 +0800
Message-ID: <20150916103014.GA12315@gondor.apana.org.au>
References: <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150626102234.GA19393@gondor.apana.org.au>
 <20150908092502.GA8332@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46573 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbbIPKa0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2015 06:30:26 -0400
Content-Disposition: inline
In-Reply-To: <20150908092502.GA8332@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

* The selftest overreads the IV test vector.
* Fix potential infinite loop in sunxi-ss driver.
* Fix powerpc build failure when VMX is set without VSX.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Andrey Ryabinin (1):
      crypto: testmgr - don't copy from source IV too much

LABBE Corentin (1):
      crypto: sunxi-ss - Fix a possible driver hang with ciphers

Michael Ellerman (1):
      crypto: vmx - VMX crypto should depend on CONFIG_VSX

 crypto/testmgr.c                          |    5 +++--
 drivers/crypto/Kconfig                    |    2 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
