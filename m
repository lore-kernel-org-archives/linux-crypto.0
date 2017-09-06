From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] [PATCH v3] Staging: ccree: ssi_cipher.c:
 Remove unused variable.
Date: Wed, 6 Sep 2017 23:17:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709062316450.2984@hadrien>
References: <1504732426-9765-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: gregkh@linuxfoundation.org, gilad@benyossef.com,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:58940
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752163AbdIFVSB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2017 17:18:01 -0400
In-Reply-To: <1504732426-9765-1-git-send-email-srishtishar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Thu, 7 Sep 2017, Srishti Sharma wrote:

> Remove local variable inflight_counter ,as it is never used.

"counter ,as" -> "counter, as"

> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> ---
> Changes in v3:
>  - There was no longer a need to make the comment more comprehensible as
>    I have deleted the variable associated with it because it is unused .
>  drivers/staging/ccree/ssi_cipher.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
> index fec2faa..609ebe4 100644
> --- a/drivers/staging/ccree/ssi_cipher.c
> +++ b/drivers/staging/ccree/ssi_cipher.c
> @@ -702,10 +702,7 @@ static int ssi_blkcipher_complete(struct device *dev,
>
>  	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>
> -	/*
> -	 * Save inflight_counter in a local variable.
> -	 */
> -	inflight_counter =  ctx_p->drvdata->inflight_counter;
> +

This is a patch on your previous patch.  It should be a patch on the
original code.  Also, don't add a new blank line.  Just remove the line
completely.

julia

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
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504732426-9765-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
