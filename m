From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] drivers/crypto: Use RCU_INIT_POINTER(x, NULL) in
 nx/nx-842.c
Date: Mon, 24 Mar 2014 07:16:06 -0400
Message-ID: <20140324111606.GB19368@hmsreliant.think-freely.org>
References: <1395603064-16537-1-git-send-email-monamagarwal123@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rcj@linux.vnet.ibm.com, mhcerri@linux.vnet.ibm.com,
	fin@linux.vnet.ibm.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Monam Agarwal <monamagarwal123@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39607 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaCXLQ2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2014 07:16:28 -0400
Content-Disposition: inline
In-Reply-To: <1395603064-16537-1-git-send-email-monamagarwal123@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 24, 2014 at 01:01:04AM +0530, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
> 
> The rcu_assign_pointer() ensures that the initialization of a structure       
> is carried out before storing a pointer to that structure. 
> And in the case of the NULL pointer, there is no structure to initialize. 
> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
> ---
>  drivers/crypto/nx/nx-842.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
> index 1e5481d..c4fcbf4 100644
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -1234,7 +1234,7 @@ static int __exit nx842_remove(struct vio_dev *viodev)
>  	old_devdata = rcu_dereference_check(devdata,
>  			lockdep_is_held(&devdata_mutex));
>  	of_reconfig_notifier_unregister(&nx842_of_nb);
> -	rcu_assign_pointer(devdata, NULL);
> +	RCU_INIT_POINTER(devdata, NULL);
>  	spin_unlock_irqrestore(&devdata_mutex, flags);
>  	synchronize_rcu();
>  	dev_set_drvdata(&viodev->dev, NULL);
> @@ -1285,7 +1285,7 @@ static void __exit nx842_exit(void)
>  	spin_lock_irqsave(&devdata_mutex, flags);
>  	old_devdata = rcu_dereference_check(devdata,
>  			lockdep_is_held(&devdata_mutex));
> -	rcu_assign_pointer(devdata, NULL);
> +	RCU_INIT_POINTER(devdata, NULL);
>  	spin_unlock_irqrestore(&devdata_mutex, flags);
>  	synchronize_rcu();
>  	if (old_devdata)

This really does't seem right.  rcu_assign_pointer users ACCESS_ONCE to protect
against multiple loads that allow for concurrent read/write use with parallel
rcu_dereference calls, whereas RCU_INIT_POINTER does not.  It also just doesn't
look right.  We've already initalized the pointerin nx842_init, we don't need to
re-initalize it here, we need to assign it to NULL.

Neil

> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
