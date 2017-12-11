From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.15
Date: Mon, 11 Dec 2017 18:22:08 +1100
Message-ID: <20171211072208.GA8749@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:43746 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750759AbdLKHWa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 02:22:30 -0500
Content-Disposition: inline
In-Reply-To: <20171128230929.GA17783@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes the following issues:

- Buffer overread in RSA.
- Potential use after free in algif_aead.
- Error path null pointer dereference in af_alg.
- Forbid combinations such as hmac(hmac(sha3)) which may crash.
- Crash in salsa20 due to incorrect API usage.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Eric Biggers (5):
      crypto: rsa - fix buffer overread when stripping leading zeroes
      crypto: algif_aead - fix reference counting of null skcipher
      crypto: af_alg - fix NULL pointer dereference in
      crypto: hmac - require that the underlying hash algorithm is unkeyed
      crypto: salsa20 - fix blkcipher_walk API usage

 arch/x86/crypto/salsa20_glue.c |    7 -------
 crypto/af_alg.c                |   13 +++++++------
 crypto/algif_aead.c            |    2 +-
 crypto/hmac.c                  |    6 +++++-
 crypto/rsa_helper.c            |    2 +-
 crypto/salsa20_generic.c       |    7 -------
 crypto/shash.c                 |    5 +++--
 include/crypto/internal/hash.h |    8 ++++++++
 8 files changed, 25 insertions(+), 25 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
