From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - Don't provide setkey for non hmac
 hashing algs.
Date: Thu, 21 Sep 2017 16:06:53 +0800
Message-ID: <20170921080653.GE7718@gondor.apana.org.au>
References: <20170912090339.56D8369CAD@po15668-vm-win7.idsi0.si.c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, Stephan Muller <smueller@chronox.de>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170912090339.56D8369CAD@po15668-vm-win7.idsi0.si.c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 12, 2017 at 11:03:39AM +0200, Christophe Leroy wrote:
> Today, md5sum fails with error -ENOKEY because a setkey
> function is set for non hmac hashing algs, see strace output below:
> 
> mmap(NULL, 378880, PROT_READ, MAP_SHARED, 6, 0) = 0x77f50000
> accept(3, 0, NULL)                      = 7
> vmsplice(5, [{"bin/\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 378880}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) = 262144
> splice(4, NULL, 7, NULL, 262144, SPLICE_F_MORE) = -1 ENOKEY (Required key not available)
> write(2, "Generation of hash for file kcap"..., 50) = 50
> munmap(0x77f50000, 378880)              = 0
> 
> This patch ensures that setkey() function is set only
> for hmac hashing.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
