Return-Path: <SRS0=nnFP=A5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8243C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Jul 2020 13:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3E342070E
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Jul 2020 13:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595078743;
	bh=Nri1J5QNkF+cfSGKegXfslfUL7umNwUoZ7RRimI2gW4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=YX6wR/i3mjHoJMdGvgV6wbV7OTDUevQjUEVj3PpkdXlU/JXql4l89tSmvSayCD+4d
	 CFhPlewD2dUzTXRzlDLcGC40dOapvnm9gcxvK+0v5VMtIwivAnqrZr6y+bAA3AmeCQ
	 1JRiVSqJZwXm4ZDviUTecEHFszemNmw3oalK11Xw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGRNZn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Jul 2020 09:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgGRNZm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Jul 2020 09:25:42 -0400
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F281C2070E
        for <linux-crypto@vger.kernel.org>; Sat, 18 Jul 2020 13:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595078742;
        bh=Nri1J5QNkF+cfSGKegXfslfUL7umNwUoZ7RRimI2gW4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lmbD8mYy+WPuEGugI7BypFFz9vPozTigZcnK+m72Wla4tLjSjE4GuPtuRZBusuxu/
         JIGO1z+4WvTCbBT6aE/a3DZTNxINP057ny8RnVQ0mk2kww1SUIWrfxdef2pmQP7Mjd
         XyGISRB9K83lulectcTC1Ro9kP+B+yzvHl8uk0qc=
Received: by mail-ot1-f49.google.com with SMTP id n24so8879388otr.13
        for <linux-crypto@vger.kernel.org>; Sat, 18 Jul 2020 06:25:41 -0700 (PDT)
X-Gm-Message-State: AOAM533+j3f3tW0QZm3ZfB0CWR/kW+7nJt5YsPtA2XQrs5KJiBMV3s40
        lswhm+BhdU6FeHdplLS7pMSOvITfyWuMNr0RsSQ=
X-Google-Smtp-Source: ABdhPJwu7eJUHPJZxLeyR3Z2kLA3SXMNHjp1JIlqZa1hNP84TaraxLDWIMqFeKa0jg1uY/qgBYi11i/lNcicJRVDpEM=
X-Received: by 2002:a9d:688:: with SMTP id 8mr12683938otx.108.1595078741340;
 Sat, 18 Jul 2020 06:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200718094330.omshxatmro4f2hys@SvensMacBookAir.sven.lan>
In-Reply-To: <20200718094330.omshxatmro4f2hys@SvensMacBookAir.sven.lan>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 18 Jul 2020 16:25:29 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFNFA6htycNvbMJEY6ik3o146Ac93i=kPjQSq9khqUd6A@mail.gmail.com>
Message-ID: <CAMj1kXFNFA6htycNvbMJEY6ik3o146Ac93i=kPjQSq9khqUd6A@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] inside-secure irq balance
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 18 Jul 2020 at 12:43, Sven Auhagen <Sven.Auhagen@voleatech.de> wrote:
>
> Balance the irqs of the inside secure driver over all
> available cpus.
> Currently all interrupts are handled by the first CPU.
>
> From my testing with IPSec AES-GCM 256
> on my MCbin with 4 Cores I get a 50% speed increase:
>
> Before the patch: 99.73 Kpps
> With the patch: 151.25 Kpps
>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
> v2:
> * use cpumask_local_spread and remove affinity on
>   module remove
>
>  drivers/crypto/inside-secure/safexcel.c | 13 +++++++++++--
>  drivers/crypto/inside-secure/safexcel.h |  3 +++
>  2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index 2cb53fbae841..fb8e0d8732f8 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1135,11 +1135,12 @@ static irqreturn_t safexcel_irq_ring_thread(int irq, void *data)
>
>  static int safexcel_request_ring_irq(void *pdev, int irqid,
>                                      int is_pci_dev,
> +                                    int ring_id,
>                                      irq_handler_t handler,
>                                      irq_handler_t threaded_handler,
>                                      struct safexcel_ring_irq_data *ring_irq_priv)
>  {
> -       int ret, irq;
> +       int ret, irq, cpu;
>         struct device *dev;
>
>         if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
> @@ -1177,6 +1178,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
>                 return ret;
>         }
>
> +       // Set affinity
> +       cpu = cp = cpumask_local_spread(ring_id, -1);

Please use the symbolic constant NUMA_NO_NODE here, so it is obvious
what the second argument means without  having to grep for it.

> +       irq_set_affinity_hint(irq, get_cpu_mask(cpu));
> +
>         return irq;
>  }
>
> @@ -1611,6 +1616,7 @@ static int safexcel_probe_generic(void *pdev,
>                 irq = safexcel_request_ring_irq(pdev,
>                                                 EIP197_IRQ_NUMBER(i, is_pci_dev),
>                                                 is_pci_dev,
> +                                               i,
>                                                 safexcel_irq_ring,
>                                                 safexcel_irq_ring_thread,
>                                                 ring_irq);
> @@ -1619,6 +1625,7 @@ static int safexcel_probe_generic(void *pdev,
>                         return irq;
>                 }
>
> +               priv->ring[i].irq = irq;
>                 priv->ring[i].work_data.priv = priv;
>                 priv->ring[i].work_data.ring = i;
>                 INIT_WORK(&priv->ring[i].work_data.work,
> @@ -1756,8 +1763,10 @@ static int safexcel_remove(struct platform_device *pdev)
>         clk_disable_unprepare(priv->reg_clk);
>         clk_disable_unprepare(priv->clk);
>
> -       for (i = 0; i < priv->config.rings; i++)
> +       for (i = 0; i < priv->config.rings; i++) {
> +               irq_set_affinity_hint(priv->ring[i].irq, NULL);
>                 destroy_workqueue(priv->ring[i].workqueue);
> +       }
>
>         return 0;
>  }
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> index 94016c505abb..7c5fe382d272 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -707,6 +707,9 @@ struct safexcel_ring {
>          */
>         struct crypto_async_request *req;
>         struct crypto_async_request *backlog;
> +
> +       /* irq of this ring */
> +       int irq;
>  };
>
>  /* EIP integration context flags */
> --
> 2.20.1
>
