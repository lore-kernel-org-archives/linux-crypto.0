From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: xts - Fix an error handling path in 'create()'
Date: Sat, 7 Oct 2017 12:17:52 +0800
Message-ID: <20171007041752.GA29803@gondor.apana.org.au>
References: <20170926061744.31587-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170926061744.31587-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 26, 2017 at 08:17:44AM +0200, Christophe JAILLET wrote:
> All error handling paths 'goto err_drop_spawn' except this one.
> In order to avoid some resources leak, we should do it as well here.
> 
> Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
