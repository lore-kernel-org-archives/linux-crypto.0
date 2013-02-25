From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: Re: [PATCH 1/2] omap-sham: Use pm_runtime_put instead of
 pm_runtime_put_sync
Date: Mon, 25 Feb 2013 11:24:15 -0700
Message-ID: <20130225182415.GB5518@animalcreek.com>
References: <1360915168-28786-1-git-send-email-agnel.joel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Joel A Fernandes <joelagnel@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Joel A Fernandes <agnel.joel@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from p3plsmtpa11-07.prod.phx3.secureserver.net ([68.178.252.108]:33230
	"EHLO p3plsmtpa11-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347Ab3BYScX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Feb 2013 13:32:23 -0500
Content-Disposition: inline
In-Reply-To: <1360915168-28786-1-git-send-email-agnel.joel@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 15, 2013 at 01:59:27AM -0600, Joel A Fernandes wrote:
> From: Joel A Fernandes <joelagnel@ti.com>

Hi Joel.

> Not doing so could cause sleep in interrupt context resulting in a kernel panic.
> 
> Tested on an AM33xx SoC device (beaglebone board).
> 
> To reproduce the problem, I used the tcrypt kernel module as:
> modprobe tcrypt sec=2 mode=403
> 
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  drivers/crypto/omap-sham.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index edff981..b8bb583 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -923,7 +923,7 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
>  	dd->flags &= ~(BIT(FLAGS_BUSY) | BIT(FLAGS_FINAL) | BIT(FLAGS_CPU) |
>  			BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY));
>  
> -	pm_runtime_put_sync(dd->dev);
> +	pm_runtime_put(dd->dev);
>  
>  	if (req->base.complete)
>  		req->base.complete(&req->base, err);

I like your patch but I think it could use a better description.

Please put in a good description of the symptom(s) you saw,
the root cause, and what you did to fix it (and why it fixes it).

Ditto for the omap-aes patch.

Mark
--
