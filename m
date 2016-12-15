From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.10
Date: Fri, 16 Dec 2016 00:07:32 +0800
Message-ID: <20161215160732.GA16580@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161119102748.GA4277@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes the following issues:

- A crash regression in the new skcipher walker.
- Incorrect return value in public_key_verify_signature.
- Fix for in-place signing in the sign-file utility.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Alex Yashchenko (1):
      sign-file: Fix inplace signing when src and dst names are both specified

Ard Biesheuvel (1):
      crypto: skcipher - fix crash in virtual walk

Pan Bian (1):
      crypto: asymmetric_keys - set error code on failure

 crypto/asymmetric_keys/public_key.c |    1 +
 crypto/skcipher.c                   |    4 +++-
 scripts/sign-file.c                 |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
