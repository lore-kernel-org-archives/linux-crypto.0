From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: authenc methods vs FIPS in light of unencrypted associated data
Date: Fri, 3 Jun 2016 18:12:05 +0800
Message-ID: <20160603101205.GA31461@gondor.apana.org.au>
References: <20160602160104.GK18490@suse.de>
 <2641743.LA46gJhHTE@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcus Meissner <meissner@suse.de>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2641743.LA46gJhHTE@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 03, 2016 at 08:42:31AM +0200, Stephan Mueller wrote:
>
> Herbert, when using crypto_spawn_*, is there a flag set by the crypto API that 
> the to-be-instantiated cipher is invoked by the kernel crypto API instead of 
> by a user? I would assume that the INTERNAL flag could be of relevance here. 
> If that INTERNAL flag is set, I think that the function alg_test could be 
> changed such that if the INTERNAL flag is set, the fips_allowed flag is not 
> enforced.

Yes we can certainly set INTERNAL for this case.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
