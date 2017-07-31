From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] crypto: caam/qi - Remove unused 'qi_congested' entry
Date: Mon, 31 Jul 2017 09:14:26 -0300
Message-ID: <CAOMZO5DYTRRShoJO0uTz9Y_j3Ojo-aErg-=92RSazW7s1a==+w@mail.gmail.com>
References: <1501368901-8248-1-git-send-email-festevam@gmail.com> <VI1PR0401MB2591F4C20C9318D4F59424C898B20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:38480 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbdGaMO1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:14:27 -0400
Received: by mail-vk0-f66.google.com with SMTP id i133so4865514vka.5
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jul 2017 05:14:27 -0700 (PDT)
In-Reply-To: <VI1PR0401MB2591F4C20C9318D4F59424C898B20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 31, 2017 at 4:22 AM, Horia Geant=C4=83 <horia.geanta@nxp.com> w=
rote:
> On 7/30/2017 1:55 AM, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@nxp.com>
>>
>> 'qi_congested' member from structure caam_drv_private
>> is never used at all, so it is safe to remove it.
>
> Agree, though I would remove all the other dentry members not currently
> used - since debugfs_remove_recursive() is called, we don't need the
> file entries.

Ok, it makes sense. Wil do it in v2.

>> diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
>> index 6d5a010..b2f7a42 100644
>> --- a/drivers/crypto/caam/qi.c
>> +++ b/drivers/crypto/caam/qi.c
>> @@ -793,10 +793,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
>>       /* Done with the CGRs; restore the cpus allowed mask */
>>       set_cpus_allowed_ptr(current, &old_cpumask);
>>  #ifdef CONFIG_DEBUG_FS
>> -     ctrlpriv->qi_congested =3D debugfs_create_file("qi_congested", 044=
4,
>> -                                                  ctrlpriv->ctl,
>> -                                                  &times_congested,
>> -                                                  &caam_fops_u64_ro);
>> +     debugfs_create_file("qi_congested", 0444, ctrlpriv->ctl,
>> +                         &times_congested, &caam_fops_u64_ro);
>
> Either here or in a different patch the return value of debugfs_create_*
> functions should be checked, such that if IS_ERR_OR_NULL(ret) we could
> print a warning.

I will leave the error checking for a separate patch then.
