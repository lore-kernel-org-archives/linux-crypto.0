From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: hifn_795x - Fix a memory leak in the error
 handling path of 'hifn_probe()'
Date: Wed, 29 Nov 2017 17:38:28 +1100
Message-ID: <20171129063828.GL21575@gondor.apana.org.au>
References: <20171118134545.25784-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171118134545.25784-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 18, 2017 at 02:45:45PM +0100, Christophe JAILLET wrote:
> 'dev' is leaking in the error handling path of 'hifn_probe()'.
> 
> Add a 'kfree(dev)' to match the code in 'hifn_remove()'
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
