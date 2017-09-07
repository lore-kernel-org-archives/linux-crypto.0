From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] [PATCH v5] Staging: ccree: Remove unused
 variable.
Date: Thu, 7 Sep 2017 10:20:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709071020360.3084@hadrien>
References: <1504770561-5554-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: gregkh@linuxfoundation.org, gilad@benyossef.com,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504770561-5554-1-git-send-email-srishtishar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Thu, 7 Sep 2017, Srishti Sharma wrote:

> Remove the local variable inflight_counter as it is never used.
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
> Changes in v5:
>  - Correct the format of the subject.
>  drivers/staging/ccree/ssi_cipher.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
> index 8d31a93..1ff3c8a 100644
> --- a/drivers/staging/ccree/ssi_cipher.c
> +++ b/drivers/staging/ccree/ssi_cipher.c
> @@ -697,13 +697,10 @@ static int ssi_blkcipher_complete(struct device *dev,
>  				  void __iomem *cc_base)
>  {
>  	int completion_error = 0;
> -	u32 inflight_counter;
>  	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
>
>  	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>
> -	/*Set the inflight couter value to local variable*/
> -	inflight_counter =  ctx_p->drvdata->inflight_counter;
>  	/*Decrease the inflight counter*/
>  	if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
>  		ctx_p->drvdata->inflight_counter--;
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504770561-5554-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
