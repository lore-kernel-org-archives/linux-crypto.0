From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] [PATCH v2] Staging: ccree: Use kcalloc instead
 of kzalloc
Date: Thu, 14 Sep 2017 14:54:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709141454330.3185@hadrien>
References: <1505393293-5941-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: gilad@benyossef.com, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Srishti Sharma <srishtishar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505393293-5941-1-git-send-email-srishtishar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Thu, 14 Sep 2017, Srishti Sharma wrote:

> Use kcalloc instead of kzalloc to check for overflow before
> multiplication. Done using the following semantic patch by
> coccinelle.
>
> http://coccinelle.lip6.fr/rules/kzalloc.cocci
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
> Changes in v2:
>  - eliminate parentheses around the first argument
>
>  drivers/staging/ccree/ssi_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
> index 0655658..f7e0c502 100644
> --- a/drivers/staging/ccree/ssi_sysfs.c
> +++ b/drivers/staging/ccree/ssi_sysfs.c
> @@ -376,7 +376,7 @@ static int sys_init_dir(struct sys_dir *sys_dir, struct ssi_drvdata *drvdata,
>  		return -ENOMEM;
>  	/* allocate memory for directory's attributes list */
>  	sys_dir->sys_dir_attr_list =
> -		kzalloc(sizeof(struct attribute *) * (num_of_attrs + 1),
> +		kcalloc(num_of_attrs + 1, sizeof(struct attribute *),
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
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1505393293-5941-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
