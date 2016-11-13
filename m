From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Crypto: mv_cesa: Switch to using managed resources
Date: Sun, 13 Nov 2016 19:19:10 +0800
Message-ID: <20161113111910.GA7900@gondor.apana.org.au>
References: <20161102115845.GA8386@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Nadim Almas <nadim.902@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161102115845.GA8386@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Nadim Almas <nadim.902@gmail.com> wrote:
> Switch to resource-managed function devm_kzalloc instead
> of kzalloc and remove unneeded kfree
> 
> Also, remove kfree in probe function and remove
> function, mv_remove as it is now has nothing to do.
> The Coccinelle semantic patch used to make this change is as follows:
> //<smpl>
> @platform@
> identifier p, probefn, removefn;
> @@
> struct platform_driver p = {
> .probe = probefn,
> .remove = removefn,
> };
> 
> @prb@
> identifier platform.probefn, pdev;
> expression e, e1, e2;
> @@
> probefn(struct platform_device *pdev, ...) {
> <+...
> - e = kzalloc(e1, e2)
> + e = devm_kzalloc(&pdev->dev, e1, e2)
> ...
> ?-kfree(e);
> ...+>
> }
> @rem depends on prb@
> identifier platform.removefn;
> expression prb.e;
> @@
> removefn(...) {
> <...
> - kfree(e);
> ...>
> }
> //</smpl>
> 
> Signed-off-by: Nadim Almas <nadim.902@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
