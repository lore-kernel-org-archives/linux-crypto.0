From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - fix hashing
Date: Thu, 21 Sep 2017 16:06:29 +0800
Message-ID: <20170921080629.GD7718@gondor.apana.org.au>
References: <20170913104457.CA81D684D7@po15668-vm-win7.idsi0.si.c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, Stephan Muller <smueller@chronox.de>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170913104457.CA81D684D7@po15668-vm-win7.idsi0.si.c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 13, 2017 at 12:44:57PM +0200, Christophe Leroy wrote:
> md5sum on some files gives wrong result
> 
> Exemple:
> 
> With the md5sum from libkcapi:
> c15115c05bad51113f81bdaee735dd09  test
> 
> With the original md5sum:
> bbdf41d80ba7e8b2b7be3a0772be76cb  test
> 
> This patch fixes this issue
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
