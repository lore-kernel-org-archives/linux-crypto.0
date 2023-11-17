Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F50127
	for <linux-crypto@vger.kernel.org>; Thu, 16 Nov 2023 21:19:44 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3rGU-000XOX-SS; Fri, 17 Nov 2023 13:19:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 13:19:46 +0800
Date: Fri, 17 Nov 2023 13:19:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 4/8] crypto: skcipher - Add lskcipher
Message-ID: <ZVb38sHNJYJ9x0po@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-5-herbert@gondor.apana.org.au>
 <20230920062551.GB2739@sol.localdomain>
 <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
 <20230922031030.GB935@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922031030.GB935@sol.localdomain>

On Thu, Sep 21, 2023 at 08:10:30PM -0700, Eric Biggers wrote:
>
> Well, IV is *initialization vector*: a value that the algorithm uses as input.
> It shouldn't be overloaded to represent some internal intermediate state.  We
> already made this mistake with the iv vs. iv_out thing, which only ever got
> implemented by CBC and CTR, and people repeatedly get confused by.  So we know
> it technically works for those two algorithms, but not anything else.
> 
> With ChaCha, for example, it makes more sense to use 16-word state matrix as the
> intermediate state instead of the 4-word "IV".  (See chacha_crypt().)
> Especially for XChaCha, so that the HChaCha step doesn't need to be repeated.

Fair enough, but what's the point of keeping the internal state
across two lskcipher calls? The whole point of lskcipher is that the
input is linear and can be processed in one go.

With shash we must keep the internal state because the API operates
on the update/final model so we need multiple suboperations to finish
each hashing operation.

With ciphers we haven't traditionally done it that way.  Are you
thinking of extending lskcipher so that it is more like hashing, with
an explicit finalisation step?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
