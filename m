From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam/qi - Remove unused 'qi_congested' entry
Date: Mon, 31 Jul 2017 07:22:12 +0000
Message-ID: <VI1PR0401MB2591F4C20C9318D4F59424C898B20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <1501368901-8248-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Fabio Estevam" <fabio.estevam@nxp.com>
To: Fabio Estevam <festevam@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr10072.outbound.protection.outlook.com ([40.107.1.72]:35136
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751239AbdGaHWR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 03:22:17 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/30/2017 1:55 AM, Fabio Estevam wrote:=0A=
> From: Fabio Estevam <fabio.estevam@nxp.com>=0A=
> =0A=
> 'qi_congested' member from structure caam_drv_private=0A=
> is never used at all, so it is safe to remove it.=0A=
=0A=
Agree, though I would remove all the other dentry members not currently=0A=
used - since debugfs_remove_recursive() is called, we don't need the=0A=
file entries.=0A=
=0A=
> =0A=
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>=0A=
> ---=0A=
>  drivers/crypto/caam/intern.h | 3 ---=0A=
>  drivers/crypto/caam/qi.c     | 6 ++----=0A=
>  2 files changed, 2 insertions(+), 7 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h=
=0A=
> index 9e3f3e0..9625b2d 100644=0A=
> --- a/drivers/crypto/caam/intern.h=0A=
> +++ b/drivers/crypto/caam/intern.h=0A=
> @@ -109,9 +109,6 @@ struct caam_drv_private {=0A=
>  =0A=
>  	struct debugfs_blob_wrapper ctl_kek_wrap, ctl_tkek_wrap, ctl_tdsk_wrap;=
=0A=
>  	struct dentry *ctl_kek, *ctl_tkek, *ctl_tdsk;=0A=
> -#ifdef CONFIG_CAAM_QI=0A=
> -	struct dentry *qi_congested;=0A=
> -#endif=0A=
>  #endif=0A=
>  };=0A=
>  =0A=
> diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c=0A=
> index 6d5a010..b2f7a42 100644=0A=
> --- a/drivers/crypto/caam/qi.c=0A=
> +++ b/drivers/crypto/caam/qi.c=0A=
> @@ -793,10 +793,8 @@ int caam_qi_init(struct platform_device *caam_pdev)=
=0A=
>  	/* Done with the CGRs; restore the cpus allowed mask */=0A=
>  	set_cpus_allowed_ptr(current, &old_cpumask);=0A=
>  #ifdef CONFIG_DEBUG_FS=0A=
> -	ctrlpriv->qi_congested =3D debugfs_create_file("qi_congested", 0444,=0A=
> -						     ctrlpriv->ctl,=0A=
> -						     &times_congested,=0A=
> -						     &caam_fops_u64_ro);=0A=
> +	debugfs_create_file("qi_congested", 0444, ctrlpriv->ctl,=0A=
> +			    &times_congested, &caam_fops_u64_ro);=0A=
=0A=
Either here or in a different patch the return value of debugfs_create_*=0A=
functions should be checked, such that if IS_ERR_OR_NULL(ret) we could=0A=
print a warning.=0A=
=0A=
Thanks,=0A=
Horia=0A=
