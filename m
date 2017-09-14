From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] [PATCH] Staging: ccree: Use kcalloc instead
 of kzalloc
Date: Thu, 14 Sep 2017 14:31:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709141431050.3185@hadrien>
References: <1505391353-4516-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: gilad@benyossef.com, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17055 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751673AbdINMcV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2017 08:32:21 -0400
In-Reply-To: <1505391353-4516-1-git-send-email-srishtishar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Thu, 14 Sep 2017, Srishti Sharma wrote:

> Use kcalloc instead of kzalloc to check for overflow before
> multiplication. Done using the following semantic patch by
> coccinelle.
>
> http://coccinelle.lip6.fr/rules/kzalloc.cocci
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> ---
>  drivers/staging/ccree/ssi_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
> index 0655658..65a0529 100644
> --- a/drivers/staging/ccree/ssi_sysfs.c
> +++ b/drivers/staging/ccree/ssi_sysfs.c
> @@ -376,7 +376,7 @@ static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
>  		return -ENOMEM;
>  	/* allocate memory for directory's attributes list */
>  	sys_dir->sys_dir_attr_list =
> -		kzalloc(sizeof(struct attribute *) * (num_of_attrs + 1),
> +		kcalloc((num_of_attrs + 1), sizeof(struct attribute *),

You don't need the parentheses around the first argument.

julia

>  			GFP_KERNEL);
>
>  	if (!(sys_dir->sys_dir_attr_list)) {
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1505391353-4516-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
