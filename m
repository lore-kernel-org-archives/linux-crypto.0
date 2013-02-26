From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: Re: [PATCH v3 2/2] omap-aes: Use pm_runtime_put instead of
 pm_runtime_put_sync in tasklet
Date: Tue, 26 Feb 2013 16:06:36 -0700
Message-ID: <20130226230636.GD13338@animalcreek.com>
References: <1361894672-10431-1-git-send-email-agnel.joel@gmail.com>
 <1361894672-10431-2-git-send-email-agnel.joel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Joel A Fernandes <joelagnel@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: agnel.joel@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from p3plsmtpa11-10.prod.phx3.secureserver.net ([68.178.252.111]:57237
	"EHLO p3plsmtpa11-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029Ab3BZXGh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Feb 2013 18:06:37 -0500
Content-Disposition: inline
In-Reply-To: <1361894672-10431-2-git-send-email-agnel.joel@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 26, 2013 at 10:04:32AM -0600, agnel.joel@gmail.com wrote:
> From: Joel A Fernandes <joelagnel@ti.com>
> 
> After DMA is complete, the omap_aes_finish_req function is called as
> a part of the done_task tasklet. During this its atomic and any calls
> to pm functions should not assume they wont sleep.
> 
> The patch replaces a call to pm_runtime_put_sync (which can sleep) with
> pm_runtime_put thus fixing a kernel panic observed on AM33xx SoC during
> AES operation.
> 
> Tested on an AM33xx SoC device (beaglebone board).
> To reproduce the problem, I used the tcrypt kernel module as:
> modprobe tcrypt sec=2 mode=500
> 
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  drivers/crypto/omap-aes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index cf57866..8450bfd2 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -636,7 +636,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
>  
>  	pr_debug("err: %d\n", err);
>  
> -	pm_runtime_put_sync(dd->dev);
> +	pm_runtime_put(dd->dev);
>  	dd->flags &= ~FLAGS_BUSY;
>  
>  	req->base.complete(&req->base, err);

Acked-by: Mark A. Greer <mgreer@animalcreek.com>
