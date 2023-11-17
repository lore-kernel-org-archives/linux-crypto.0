Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B1ED5E
	for <linux-crypto@vger.kernel.org>; Fri, 17 Nov 2023 03:21:44 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3wup-000dFP-Tg; Fri, 17 Nov 2023 19:21:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 19:21:47 +0800
Date: Fri, 17 Nov 2023 19:21:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-sunxi@lists.linux.dev,
	clabbe.montjoie@gmail.com
Subject: Re: [PATCH] crypto: sun8i-ss - use crypto_shash_tfm_digest() in
 sun8i_ss_hashkey()
Message-ID: <ZVdMyynEvoXh4t5g@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231029045613.153689-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Simplify sun8i_ss_hashkey() by using crypto_shash_tfm_digest() instead
> of an alloc+init+update+final sequence.  This should also improve
> performance.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 25 +++----------------
> 1 file changed, 4 insertions(+), 21 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
