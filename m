From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.6
Date: Wed, 20 Apr 2016 17:49:25 +0800
Message-ID: <20160420094925.GA2947@gondor.apana.org.au>
References: <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
 <20160330091150.GA17143@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36385 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445AbcDTJte (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 05:49:34 -0400
Content-Disposition: inline
In-Reply-To: <20160330091150.GA17143@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

- Incorrect output buffer size calculation in rsa-pkcs1pad.
- Uninitialised padding bytes on exported state in ccp driver.
- Potentially freed pointer used on completion callback in sha1-mb.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Tadeusz Struk (1):
      crypto: rsa-pkcs1pad - fix dst len

Tom Lendacky (1):
      crypto: ccp - Prevent information leakage on export

Xiaodong Liu (1):
      crypto: sha1-mb - use corrcet pointer while completing jobs

 arch/x86/crypto/sha-mb/sha1_mb.c         |    4 ++--
 crypto/rsa-pkcs1pad.c                    |   12 ++++++------
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    3 +++
 drivers/crypto/ccp/ccp-crypto-sha.c      |    3 +++
 4 files changed, 14 insertions(+), 8 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
