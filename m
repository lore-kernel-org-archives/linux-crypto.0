Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D55C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 03:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84BE864DE2
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 03:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhCSDlu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbhCSDlT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 23:41:19 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C9EC06174A;
        Thu, 18 Mar 2021 20:41:18 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id j26so4650701iog.13;
        Thu, 18 Mar 2021 20:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kl3VrpietqI+3sBFprRLY1j1t3hc+0cbOaOSaLhFSBw=;
        b=cFl5lps5YPqXsCo2GGbh+JV/rT4pidFsHFWZOP+PNGRn0lD0Ff5MZw7FOLgRp07w0M
         sM+z3aDN1YR9wzsj5sRBMQA4dL0tB7Bv3iWAgA2n3vOSPSEj4WGaiBW6aCpS8ngZVmPJ
         syboNzYNkj4cjbihFLTGAwUGEe4kCfFyKimJiRVVNeVKVYviCB+8d/D2pTIQhstGjXUi
         zGQuIPLEIOgqNdK4k4LLR/3nrxd5hVbc7H+Y7ZePf0mkKhMmjihSRHs1RUwNOTcrwkZp
         IQduvvGSBjY6GGYUBFGm71o19BjoC8IBb0r88ABJJmDYRoapVvKnrA/E4RrlbCD5rQ8d
         6uug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kl3VrpietqI+3sBFprRLY1j1t3hc+0cbOaOSaLhFSBw=;
        b=ZjeA2WLYWIcVDxsFAomQpcxQs87agzBIXe5TRQmH/RwOMpWHT8swdeZhuMx4pcvIgE
         0r+flw5FVo4qziYW0uKU1rvjK/gr37wdSYnJDJv0ZzFCof2gtOlBAl0chP+V6L02LPqU
         h9qGcTIJc8LyPhYSc7B68gjxtojj0CLafKi75b8XULVV18wLOMIelO2HZXw+I32ODdJS
         X5tR2y9STqNDyzBYMpYNk/LHi/9OC2Qk0PKgqjYWZXtf5twme2sTOkeiueqNEdkIS69/
         QC0oXvNmJ2f+S0cg2URxCFhgpcK5kaaikH2CtK5k35qaOkTb/rZmyB2/Kg9bsU+LqgyR
         wq3A==
X-Gm-Message-State: AOAM5322Mpp+UlpYs3v1YZIxkMyC41zGjZeyT6AK4QLdjZp19tyUaG6g
        kuF/ZdvIrn4wf/+4PJ/HtDU2TIuygvLiPfYMQHM=
X-Google-Smtp-Source: ABdhPJzRGCTBUkVtqJba6jfonY93Gl74xtWn0/k6hgEQCATk+bi0TnpJkTPK9w7mntIhl1PkvI0NAVxYVYwz9CQz52E=
X-Received: by 2002:a02:c610:: with SMTP id i16mr9942999jan.36.1616125278265;
 Thu, 18 Mar 2021 20:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <YFN6hlz/L7erLO0H@silpixa00400314> <20210318162105.378239-3-ztong0001@gmail.com>
 <YFOLPn31KF7bW6T/@silpixa00400314>
In-Reply-To: <YFOLPn31KF7bW6T/@silpixa00400314>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Thu, 18 Mar 2021 23:41:07 -0400
Message-ID: <CAA5qM4C8aroiLtxVe5sMhQfHU16US=8wYXd7pzM-uDdJ8BbGyQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] crypto: qat: ADF_STATUS_PF_RUNNING should be set
 after adf_dev_init
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>, qat-linux@intel.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks,
I fixed the headline and sent it as v5.
- Tong

On Thu, Mar 18, 2021 at 1:18 PM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> Just a minor comment on the commit message:
> crypto: qat: ADF_STATUS_PF_RUNNING ...
>            ^
> Patches to the qat driver have the following headline:
>         crypto: qat -
> not
>         crypto: qat :
>
> Regards,
>
> --
> Giovanni
>
> On Thu, Mar 18, 2021 at 12:21:05PM -0400, Tong Zhang wrote:
> > ADF_STATUS_PF_RUNNING is (only) used and checked by adf_vf2pf_shutdown()
> > before calling adf_iov_putmsg()->mutex_lock(vf2pf_lock), however the
> > vf2pf_lock is initialized in adf_dev_init(), which can fail and when it
> > fail, the vf2pf_lock is either not initialized or destroyed, a subsequent
> > use of vf2pf_lock will cause issue.
> > To fix this issue, only set this flag if adf_dev_init() returns 0.
> >
> > [    7.178404] BUG: KASAN: user-memory-access in __mutex_lock.isra.0+0x1ac/0x7c0
> > [    7.180345] Call Trace:
> > [    7.182576]  mutex_lock+0xc9/0xd0
> > [    7.183257]  adf_iov_putmsg+0x118/0x1a0 [intel_qat]
> > [    7.183541]  adf_vf2pf_shutdown+0x4d/0x7b [intel_qat]
> > [    7.183834]  adf_dev_shutdown+0x172/0x2b0 [intel_qat]
> > [    7.184127]  adf_probe+0x5e9/0x600 [qat_dh895xccvf]
> >
> > Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> > Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Fixes: 25c6ffb249f6 ("crypto: qat - check if PF is running")
> > Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > ---
> >  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 4 ++--
> >  drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 4 ++--
> >  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 4 ++--
> >  3 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
> > index 1d1532e8fb6d..067ca5e17d38 100644
> > --- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
> > +++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
> > @@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       if (ret)
> >               goto out_err_free_reg;
> >
> > -     set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> > -
> >       ret = adf_dev_init(accel_dev);
> >       if (ret)
> >               goto out_err_dev_shutdown;
> >
> > +     set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> > +
> >       ret = adf_dev_start(accel_dev);
> >       if (ret)
> >               goto out_err_dev_stop;
> > diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
> > index 04742a6d91ca..51ea88c0b17d 100644
> > --- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
> > +++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
> > @@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       if (ret)
> >               goto out_err_free_reg;
> >
> > -     set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> > -
> >       ret = adf_dev_init(accel_dev);
> >       if (ret)
> >               goto out_err_dev_shutdown;
> >
> > +     set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> > +
> >       ret = adf_dev_start(accel_dev);
> >       if (ret)
> >               goto out_err_dev_stop;
> > diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
> > index c972554a755e..29999da716cc 100644
> > --- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
> > +++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
> > @@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       if (ret)
> >               goto out_err_free_reg;
> >
> > -     set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> > -
> >       ret = adf_dev_init(accel_dev);
> >       if (ret)
> >               goto out_err_dev_shutdown;
> >
> > +     set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> > +
> >       ret = adf_dev_start(accel_dev);
> >       if (ret)
> >               goto out_err_dev_stop;
> > --
> > 2.25.1
> >
