From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: s5p-sss - Fix completing crypto request in IRQ
 handler
Date: Wed, 8 Mar 2017 16:47:45 +0800
Message-ID: <20170308084745.GA4883@gondor.apana.org.au>
References: <20170305171407.839-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Royce <nroycea+kernel@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170305171407.839-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Mar 05, 2017 at 07:14:07PM +0200, Krzysztof Kozlowski wrote:
> In a regular interrupt handler driver was finishing the crypt/decrypt
> request by calling complete on crypto request.  This is disallowed since
> converting to skcipher in commit b286d8b1a690 ("crypto: skcipher - Add
> skcipher walk interface") and causes a warning:
> 	WARNING: CPU: 0 PID: 0 at crypto/skcipher.c:430 skcipher_walk_first+0x13c/0x14c
> 
> The interrupt is marked shared but in fact there are no other users
> sharing it.  Thus the simplest solution seems to be to just use a
> threaded interrupt handler, after converting it to oneshot.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
