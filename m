From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 3.19
Date: Tue, 20 Jan 2015 11:52:55 +1100
Message-ID: <20150120005255.GA9746@gondor.apana.org.au>
References: <20120126024342.GA12492@gondor.apana.org.au>
 <20120823083242.GA23102@gondor.apana.org.au>
 <20121109093005.GA25632@gondor.apana.org.au>
 <20130328082841.GA7425@gondor.apana.org.au>
 <20131203124129.GA12067@gondor.apana.org.au>
 <20131209115705.GA1361@gondor.apana.org.au>
 <20140101061016.GA22579@gondor.apana.org.au>
 <20140203125944.GA31446@gondor.apana.org.au>
 <20141231033217.GA27261@gondor.apana.org.au>
 <20150107021737.GA25043@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150107021737.GA25043@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a regression that arose from the change to add
a crypto prefix to module names which was done to prevent the
loading of arbitrary modules through the Crypto API.  In particular,
a number of modules were missing the crypto prefix which meant
that they could no longer be autoloaded.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Mathias Krause (1):
      crypto: add missing crypto module aliases

 arch/powerpc/crypto/sha1.c       |    1 +
 arch/x86/crypto/sha-mb/sha1_mb.c |    2 +-
 crypto/aes_generic.c             |    1 +
 crypto/ansi_cprng.c              |    1 +
 crypto/blowfish_generic.c        |    1 +
 crypto/camellia_generic.c        |    1 +
 crypto/cast5_generic.c           |    1 +
 crypto/cast6_generic.c           |    1 +
 crypto/crc32c_generic.c          |    1 +
 crypto/crct10dif_generic.c       |    1 +
 crypto/des_generic.c             |    7 ++++---
 crypto/ghash-generic.c           |    1 +
 crypto/krng.c                    |    1 +
 crypto/salsa20_generic.c         |    1 +
 crypto/serpent_generic.c         |    1 +
 crypto/sha1_generic.c            |    1 +
 crypto/sha256_generic.c          |    2 ++
 crypto/sha512_generic.c          |    2 ++
 crypto/tea.c                     |    1 +
 crypto/tgr192.c                  |    1 +
 crypto/twofish_generic.c         |    1 +
 crypto/wp512.c                   |    1 +
 22 files changed, 27 insertions(+), 4 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
