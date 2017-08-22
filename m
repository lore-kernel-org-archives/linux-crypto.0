From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: inside-secure - fix an error handling path in
 safexcel_probe()
Date: Tue, 22 Aug 2017 15:58:51 +0800
Message-ID: <20170822075851.GJ6269@gondor.apana.org.au>
References: <20170815193324.8193-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: antoine.tenart@free-electrons.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170815193324.8193-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 15, 2017 at 09:33:24PM +0200, Christophe JAILLET wrote:
> 'ret' is known to be 0 at this point.
> If 'safexcel_request_ring_irq()' fails, it returns an error code.
> Return this value instead of 0 which means success.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
