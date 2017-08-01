From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] crypto: caam: Remove unused dentry members
Date: Tue, 1 Aug 2017 12:24:13 +0000
Message-ID: <VI1PR0401MB25913EDDEA2B161F06A0AF9398B30@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <1501503711-12920-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Fabio Estevam <festevam@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:31364
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751915AbdHAMYQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 08:24:16 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/31/2017 3:22 PM, Fabio Estevam wrote:=0A=
> Most of the dentry members from structure caam_drv_private=0A=
> are never used at all, so it is safe to remove them.=0A=
> =0A=
> Since debugfs_remove_recursive() is called, we don't need the=0A=
> file entries.=0A=
> =0A=
> Signed-off-by: Fabio Estevam <festevam@gmail.com>=0A=
> ---=0A=
> Changes since v1:=0A=
> - Remove all the unused dentry members (Horia)=0A=
> =0A=
>  drivers/crypto/caam/ctrl.c   | 81 ++++++++++++++++----------------------=
------=0A=
>  drivers/crypto/caam/intern.h |  8 -----=0A=
>  drivers/crypto/caam/qi.c     |  6 ++--=0A=
>  3 files changed, 32 insertions(+), 63 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c=0A=
> index 7338f15..dc65fed 100644=0A=
> --- a/drivers/crypto/caam/ctrl.c=0A=
> +++ b/drivers/crypto/caam/ctrl.c=0A=
> @@ -734,59 +734,38 @@ static int caam_probe(struct platform_device *pdev)=
=0A=
>  		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);=0A=
>  =0A=
>  #ifdef CONFIG_DEBUG_FS=0A=
> -=0A=
> -	ctrlpriv->ctl_rq_dequeued =3D=0A=
> -		debugfs_create_file("rq_dequeued",=0A=
> -				    S_IRUSR | S_IRGRP | S_IROTH,=0A=
> -				    ctrlpriv->ctl, &perfmon->req_dequeued,=0A=
> -				    &caam_fops_u64_ro);=0A=
> -	ctrlpriv->ctl_ob_enc_req =3D=0A=
> -		debugfs_create_file("ob_rq_encrypted",=0A=
> -				    S_IRUSR | S_IRGRP | S_IROTH,=0A=
> -				    ctrlpriv->ctl, &perfmon->ob_enc_req,=0A=
> -				    &caam_fops_u64_ro);=0A=
> -	ctrlpriv->ctl_ib_dec_req =3D=0A=
> -		debugfs_create_file("ib_rq_decrypted",=0A=
> -				    S_IRUSR | S_IRGRP | S_IROTH,=0A=
> -				    ctrlpriv->ctl, &perfmon->ib_dec_req,=0A=
> -				    &caam_fops_u64_ro);=0A=
> -	ctrlpriv->ctl_ob_enc_bytes =3D=0A=
> -		debugfs_create_file("ob_bytes_encrypted",=0A=
> -				    S_IRUSR | S_IRGRP | S_IROTH,=0A=
> -				    ctrlpriv->ctl, &perfmon->ob_enc_bytes,=0A=
> -				    &caam_fops_u64_ro);=0A=
> -	ctrlpriv->ctl_ob_prot_bytes =3D=0A=
> -		debugfs_create_file("ob_bytes_protected",=0A=
> -				    S_IRUSR | S_IRGRP | S_IROTH,=0A=
> -				    ctrlpriv->ctl, &perfmon->ob_prot_bytes,=0A=
> -				    &caam_fops_u64_ro);=0A=
> -	ctrlpriv->ctl_ib_dec_bytes =3D=0A=
> -		debugfs_create_file("ib_bytes_decrypted",=0A=
> -				    S_IRUSR | S_IRGRP | S_IROTH,=0A=
> -				    ctrlpriv->ctl, &perfmon->ib_dec_bytes,=0A=
> -				    &caam_fops_u64_ro);=0A=
> -	ctrlpriv->ctl_ib_valid_bytes =3D=0A=
> -		debugfs_create_file("ib_bytes_validated",=0A=
> -				    S_IRUSR | S_IRGRP | S_IROTH,=0A=
> -				    ctrlpriv->ctl, &perfmon->ib_valid_bytes,=0A=
> -				    &caam_fops_u64_ro);=0A=
> +	debugfs_create_file("rq_dequeued",S_IRUSR | S_IRGRP | S_IROTH,=0A=
checkpatch complains here                ^=0A=
ERROR: space required after that ',' (ctx:VxV)=0A=
=0A=
Regards,=0A=
Horia=0A=
=0A=
