From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] [PATCH] Staging: ccree: Don't use volatile
 for monitor_lock
Date: Mon, 11 Sep 2017 18:03:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709111801590.13726@hadrien>
References: <1505145571-11248-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: gilad@benyossef.com, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505145571-11248-1-git-send-email-srishtishar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Mon, 11 Sep 2017, Srishti Sharma wrote:

> The use of volatile for the variable monitor_lock is unnecessary.

You need to give more evidence of why this is the case.  How is the
variable used?  I guess this comes from checkpatch, but checkpatch has
only a local view of things, and doesn't know how the variable is used.

julia

>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> ---
>  drivers/staging/ccree/ssi_request_mgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
> index e5c2f92..7d77941 100644
> --- a/drivers/staging/ccree/ssi_request_mgr.c
> +++ b/drivers/staging/ccree/ssi_request_mgr.c
> @@ -49,7 +49,7 @@ struct ssi_request_mgr_handle {
>  	dma_addr_t dummy_comp_buff_dma;
>  	struct cc_hw_desc monitor_desc;
>
> -	volatile unsigned long monitor_lock;
> +	unsigned long monitor_lock;
>  #ifdef COMP_IN_WQ
>  	struct workqueue_struct *workq;
>  	struct delayed_work compwork;
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1505145571-11248-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
