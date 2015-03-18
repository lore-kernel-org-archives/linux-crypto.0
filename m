From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.0
Date: Wed, 18 Mar 2015 16:25:17 +1100
Message-ID: <20150318052517.GA20347@gondor.apana.org.au>
References: <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20141231033217.GA27261@gondor.apana.org.au>
 <20150107021737.GA25043@gondor.apana.org.au>
 <20150309051950.GA1526@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:40465 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbCRFZY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 01:25:24 -0400
Content-Disposition: inline
In-Reply-To: <20150309051950.GA1526@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

On Mon, Mar 09, 2015 at 04:19:50PM +1100, Herbert Xu wrote:
> 
> This push fixes a bug in the ARM XTS implementation that can
> cause failures to in decrypting encrypted disks.

For some reason this didn't get pulled so I'm resending it with
another fix.

The new fix is a memory overwrite bug that can cause a crash
which can be triggered from userspace.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Ard Biesheuvel (1):
      crypto: arm/aes update NEON AES module to latest OpenSSL version

Stephan Mueller (1):
      crypto: aesni - fix memory usage in GCM decryption

 arch/arm/crypto/aesbs-core.S_shipped |   12 ++++++++----
 arch/arm/crypto/bsaes-armv7.pl       |   12 ++++++++----
 arch/x86/crypto/aesni-intel_glue.c   |    4 ++--
 3 files changed, 18 insertions(+), 10 deletions(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
