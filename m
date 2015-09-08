From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.3
Date: Tue, 8 Sep 2015 17:25:02 +0800
Message-ID: <20150908092502.GA8332@gondor.apana.org.au>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:35354 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbbIHJZL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Sep 2015 05:25:11 -0400
Content-Disposition: inline
In-Reply-To: <20150626102234.GA19393@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a memory corruption bug in ghash-clmulni-intel
due to insufficient memory allocation.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Andrey Ryabinin (1):
      crypto: ghash-clmulni: specify context size for ghash async algorithm

 arch/x86/crypto/ghash-clmulni-intel_glue.c |    1 +
 1 file changed, 1 insertion(+)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
