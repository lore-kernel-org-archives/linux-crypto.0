Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58CCC433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Dec 2020 06:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D85123B7D
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Dec 2020 06:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgLIGro (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Dec 2020 01:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgLIGro (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Dec 2020 01:47:44 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BEBC0613CF
        for <linux-crypto@vger.kernel.org>; Tue,  8 Dec 2020 22:47:04 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id t13so250960ybq.7
        for <linux-crypto@vger.kernel.org>; Tue, 08 Dec 2020 22:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VHlNP5J/XSEkBY/Rz0LLE1N8qPSMQR0jctb3I4aJUKs=;
        b=kyrACNoWg1YLtzk/9UGB5XgzkYhL06D/bq2rG80LQQYmxjBTQ/dseMNCYMArseFfv3
         Dvv/vtikGg8H1U40FUr8ey6HDRSPCAL/oLeDzZ37RJmkR6qK0+IHnj1jJQG7SdNfoMEA
         3OXofSOCkNnh/limOFZGP7CTcgA2Jf/HxcHYZmAk33j+mqZNIs8FOhU1wEmW8UB1IdQy
         MWcQX6TT7LllEdu7cli5jZ+6MKnDFHJo7ucxOidWlLhHm23EOtg8cMigLmGjQhK4vi4Z
         amnrAjIoHFRSfp83S+lB12a4KhJLnNG+zf+/Jqkhs8o6Oh42tHxHMZHQtCgIfrc6vCji
         ZH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VHlNP5J/XSEkBY/Rz0LLE1N8qPSMQR0jctb3I4aJUKs=;
        b=rh6GVcStqsVh6amiJy5GYbyF6W7wpxCEflmU1hNpugecVorneRwQ7/98DqKzLEklCL
         VFmCABc3d/nYRIFAvEmDpZ6lWn8sA54SNjqkfWP4awM2e1OuUw9mhqifZT2NXsh/W5io
         p5PIgS4Zy+yHBnUP9HOmncIEX2QDwda7/5TX8tHcOT9lf2na6Hip3QRSrFVuDqFhSUb6
         aEOQKzz6wEoqha2HwYX+/VbliWMD2S+Sd1i8CRtJ9yzUsKJ05kNgCX2ABu/FC++DkZkE
         sGA9svg6Ry8Z1jOxo09ESsiZkUdH36VweErKPmJ05vW0xQdkrbACucKZnLz6qqZeoPFW
         nvzg==
X-Gm-Message-State: AOAM531D0OvZttUnsuPldtN7/Mtb+3J3K/IS8JKzWxS1HQ8hjmxAhDSe
        yPiWeLOJhzqUSNSXwXXrR5qhac7OHuVvvE47rxwx5g==
X-Google-Smtp-Source: ABdhPJxlkPZmha6RgCSBVG2OBO36xhKA8Wna/KtpzDImkcHDFe9QN9pHFG5XhpJhapTJuGgV+SfbTEpt86cs+l492DI=
X-Received: by 2002:a25:abd0:: with SMTP id v74mr1644136ybi.193.1607496422978;
 Tue, 08 Dec 2020 22:47:02 -0800 (PST)
MIME-Version: 1.0
References: <20201207085931.661267-1-allen.lkml@gmail.com> <20201207085931.661267-8-allen.lkml@gmail.com>
In-Reply-To: <20201207085931.661267-8-allen.lkml@gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 9 Dec 2020 08:46:47 +0200
Message-ID: <CAOtvUMeAQYwoB_9jmMdwi8tTYtD8=-r5T7RFTiKgEnDHgkbP+g@mail.gmail.com>
Subject: Re: [RESEND 07/19] crypto: ccree: convert tasklets to use new
 tasklet_setup() API
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, jesper.nilsson@axis.com,
        lars.persson@axis.com,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        Arnaud Ebalard <arno@natisbad.org>, schalla@marvell.com,
        Matthias Brugger <matthias.bgg@gmail.com>, heiko@sntech.de,
        krzk@kernel.org, vz@mleia.com, k.konieczny@samsung.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Allen,

Thank you for the patch.

Please make sure to CC maintainers on changes to drivers they
maintain, otherwise it's hard to keep track. Thanks!

On Mon, Dec 7, 2020 at 11:02 AM Allen Pais <allen.lkml@gmail.com> wrote:
>
> From: Allen Pais <apais@microsoft.com>
>
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
>
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@microsoft.com>
> ---
>  drivers/crypto/ccree/cc_fips.c        |  6 +++---
>  drivers/crypto/ccree/cc_request_mgr.c | 12 ++++++------
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fip=
s.c
> index 702aefc21447..bad228a36776 100644
> --- a/drivers/crypto/ccree/cc_fips.c
> +++ b/drivers/crypto/ccree/cc_fips.c
> @@ -109,9 +109,9 @@ void cc_tee_handle_fips_error(struct cc_drvdata *p_dr=
vdata)
>  }
>
>  /* Deferred service handler, run as interrupt-fired tasklet */
> -static void fips_dsr(unsigned long devarg)
> +static void fips_dsr(struct tasklet_struct *t)

Sorry for the nitpick, but I would really prefer to have a more
meaningful name for this parameter than just 't'.

tasklet, task, tsk... any descriptive name is fine.

>  {
> -       struct cc_drvdata *drvdata =3D (struct cc_drvdata *)devarg;
> +       struct cc_drvdata *drvdata =3D from_tasklet(drvdata, t, tasklet);
>         u32 irq, val;
>
>         irq =3D (drvdata->irq & (CC_GPR0_IRQ_MASK));
> @@ -143,7 +143,7 @@ int cc_fips_init(struct cc_drvdata *p_drvdata)
>         p_drvdata->fips_handle =3D fips_h;
>
>         dev_dbg(dev, "Initializing fips tasklet\n");
> -       tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata=
);
> +       tasklet_setup(&fips_h->tasklet, fips_dsr);
>         fips_h->drvdata =3D p_drvdata;
>         fips_h->nb.notifier_call =3D cc_ree_fips_failure;
>         atomic_notifier_chain_register(&fips_fail_notif_chain, &fips_h->n=
b);
> diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree=
/cc_request_mgr.c
> index 33fb27745d52..ec0f3bf00d33 100644
> --- a/drivers/crypto/ccree/cc_request_mgr.c
> +++ b/drivers/crypto/ccree/cc_request_mgr.c
> @@ -70,7 +70,7 @@ static const u32 cc_cpp_int_masks[CC_CPP_NUM_ALGS][CC_C=
PP_NUM_SLOTS] =3D {
>           BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_7_INT_BIT_SHIFT) }
>  };
>
> -static void comp_handler(unsigned long devarg);
> +static void comp_handler(struct tasklet_struct *t);
>  #ifdef COMP_IN_WQ
>  static void comp_work_handler(struct work_struct *work);
>  #endif
> @@ -140,8 +140,7 @@ int cc_req_mgr_init(struct cc_drvdata *drvdata)
>         INIT_DELAYED_WORK(&req_mgr_h->compwork, comp_work_handler);
>  #else
>         dev_dbg(dev, "Initializing completion tasklet\n");
> -       tasklet_init(&req_mgr_h->comptask, comp_handler,
> -                    (unsigned long)drvdata);
> +       tasklet_setup(&req_mgr_h->comptask, comp_handler);
>  #endif
>         req_mgr_h->hw_queue_size =3D cc_ioread(drvdata,
>                                              CC_REG(DSCRPTR_QUEUE_SRAM_SI=
ZE));
> @@ -611,11 +610,12 @@ static inline u32 cc_axi_comp_count(struct cc_drvda=
ta *drvdata)
>  }
>
>  /* Deferred service handler, run as interrupt-fired tasklet */
> -static void comp_handler(unsigned long devarg)
> +static void comp_handler(struct tasklet_struct *t)
>  {
> -       struct cc_drvdata *drvdata =3D (struct cc_drvdata *)devarg;
>         struct cc_req_mgr_handle *request_mgr_handle =3D
> -                                               drvdata->request_mgr_hand=
le;
> +                               from_tasklet(request_mgr_handle, t, compt=
ask);
> +       struct cc_drvdata *drvdata =3D container_of((void *)request_mgr_h=
andle,
> +                                    typeof(*drvdata), request_mgr_handle=
);
>         struct device *dev =3D drvdata_to_dev(drvdata);
>         u32 irq;
>
> --
> 2.25.1
>

Other than that it looks good to me.

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
