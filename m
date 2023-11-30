Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C441F10FC
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 01:55:22 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8dlN-005F6k-27; Thu, 30 Nov 2023 17:55:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 17:55:26 +0800
Date: Thu, 30 Nov 2023 17:55:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [v2 PATCH 0/4] crypto: Fix chaining support for stream ciphers (arc4
 only for now)
Message-ID: <ZWhcDoBp8wPiWiYa@gondor.apana.org.au>
References: <20230914082828.895403-5-herbert@gondor.apana.org.au>
 <20230920062551.GB2739@sol.localdomain>
 <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
 <20230922031030.GB935@sol.localdomain>
 <ZVb38sHNJYJ9x0po@gondor.apana.org.au>
 <20231117054231.GC972@sol.localdomain>
 <ZVctSuGp2SgRUjAM@gondor.apana.org.au>
 <ZWB6jQv4jjBTrRGB@gondor.apana.org.au>
 <20231127222803.GC1463@sol.localdomain>
 <ZWbZEnSPIP5aHydB@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbZEnSPIP5aHydB@gondor.apana.org.au>

v2 fixes a crash when no export/import functions are provided.

This series of patches adds the ability to process a skcipher
request in a piecemeal fashion, which is currently only possible
for selected algorithms such as CBC and CTR.

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
 crypto/skcipher.c         |  80 +++++++++++++++++++++++++++++-
 include/crypto/if_alg.h   |   2 +
 include/crypto/skcipher.h | 100 +++++++++++++++++++++++++++++++++++++-
 8 files changed, 296 insertions(+), 23 deletions(-)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
