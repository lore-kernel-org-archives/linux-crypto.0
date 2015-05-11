From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.1
Date: Mon, 11 May 2015 13:56:08 +0800
Message-ID: <20150511055608.GA2055@gondor.apana.org.au>
References: <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20141231033217.GA27261@gondor.apana.org.au>
 <20150107021737.GA25043@gondor.apana.org.au>
 <20150425080310.GA6873@gondor.apana.org.au>
 <20150505100621.GA8678@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47239 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbEKF4T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 01:56:19 -0400
Content-Disposition: inline
In-Reply-To: <20150505100621.GA8678@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a the implementation of CRC32 on arm64 where it
incorrectly applied negation on the result.  It also fixes the
arm64 implementations of SHA/SHA256 where in some cases it may
end up finalising the result twice.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Ard Biesheuvel (3):
      crypto: arm64/crc32 - bring in line with generic CRC32
      crypto: arm64/sha1-ce - prevent asm code finalization in final() path
      crypto: arm64/sha2-ce - prevent asm code finalization in final() path

 arch/arm64/crypto/crc32-arm64.c  |   22 +++++++++++++++++++---
 arch/arm64/crypto/sha1-ce-glue.c |    3 +++
 arch/arm64/crypto/sha2-ce-glue.c |    3 +++
 3 files changed, 25 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
