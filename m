Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C73C171D
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 22:24:16 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8DzV-004j9l-SB; Wed, 29 Nov 2023 14:24:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 Nov 2023 14:24:18 +0800
Date: Wed, 29 Nov 2023 14:24:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/4] crypto: Fix chaining support for stream ciphers (arc4
 only for now)
Message-ID: <ZWbZEnSPIP5aHydB@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-5-herbert@gondor.apana.org.au>
 <20230920062551.GB2739@sol.localdomain>
 <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
 <20230922031030.GB935@sol.localdomain>
 <ZVb38sHNJYJ9x0po@gondor.apana.org.au>
 <20231117054231.GC972@sol.localdomain>
 <ZVctSuGp2SgRUjAM@gondor.apana.org.au>
 <ZWB6jQv4jjBTrRGB@gondor.apana.org.au>
 <20231127222803.GC1463@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127222803.GC1463@sol.localdomain>

On Mon, Nov 27, 2023 at 02:28:03PM -0800, Eric Biggers wrote:
>
> As far as I can tell, currently "chaining" is only implemented by CBC and CTR.
> So this really seems like an issue in AF_ALG, not the skcipher API per se.
> AF_ALG should not support splitting up encryption/decryption operations on
> algorithms that don't support it.

Yes I can see your view.  But it really is only a very small number
of algorithms (basically arc4 and chacha) that are currently broken
in this way.  CTS is similarly broken but for a different reason.

Yes we could change the way af_alg operates by removing the ability
to process unlimited amounts of data and instead switching to the
AEAD model where all data is presented together.

However, I think this would be an unnecessary limitation since there
is a way to solve the chaining issue for stream ciphers and others
such as CTS.

So here is my attempt at this, hopefully without causing too much
churn or breakage:

Herbert Xu (4):
  crypto: skcipher - Add internal state support
  crypto: skcipher - Make use of internal state
  crypto: arc4 - Add internal state
  crypto: algif_skcipher - Fix stream cipher chaining

 crypto/algif_skcipher.c   |  71 +++++++++++++++++++++++++--
 crypto/arc4.c             |   8 ++-
 crypto/cbc.c              |   6 ++-
 crypto/ecb.c              |  10 ++--
 crypto/lskcipher.c        |  42 ++++++++++++----
 crypto/skcipher.c         |  64 +++++++++++++++++++++++-
 include/crypto/if_alg.h   |   2 +
 include/crypto/skcipher.h | 100 +++++++++++++++++++++++++++++++++++++-
 8 files changed, 280 insertions(+), 23 deletions(-)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
