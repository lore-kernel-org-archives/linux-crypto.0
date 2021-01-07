Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCD2C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFAE2336D
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbhAGMmU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728548AbhAGMlg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:41:36 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CDBC0612F4;
        Thu,  7 Jan 2021 04:40:55 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id y4so5998992ybn.3;
        Thu, 07 Jan 2021 04:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zl7djwpmLjy1jW3E6hQqnHl0pgGL/6JJGeNBRQUFtSk=;
        b=Sf23TslIOPqi97T41MqT/ab7uO7ZH1EtgRAhrqCB6/z0svychJId4hLcJDku/lkuIP
         a7joyUW2CnXbQZ/rvnD6z0S+zbXTJLP5sHumk4BIubMeauREgHQllQmoH6g+MMUNqV2G
         JImw9VIiMzSr2ug+Rqy3eH6ClegXoIwhkV3Ohy+n5tyJB93LAqKyA9AY26vc7yjrBQUc
         BneoG5/iP4a+JdanRqCyZqh+zEaB8fkJP/Ij9jgtZ8Ls1pw2/o5gZ71358ZwGvtcpTGX
         0I1KmBpEYf9xlCpbC355FvzTdXYYfl86UTfWYcCX+KxVyTTxQ6legY0EU4sikZTHCerc
         G7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zl7djwpmLjy1jW3E6hQqnHl0pgGL/6JJGeNBRQUFtSk=;
        b=rsuOwIe2p9wE6TzSdx6IcCUbiqXERe17jkFn0Vn3HYRJr0ktov/LDPMf/3ZPY1oEp0
         fqo14ftTN5+hP6gzRmng/3rPGTqohMRF/veAR7g9jvG047a2r1F1M5OApKsKYawVJNXE
         qeaiJd+lW+SF1W/bQO8VnbvcWXTwgJhERpcxqATp7nVrH1GafiYQ7puWXOy2gaGAN5/j
         6brGffi0IuRIwxY/a7gG0zZ64msMi1vOW9EoXDIBCOK8i81KHadY/g/tJk+56rvof22u
         KrG/NupYhbk0yKmZI4Y6oQ6EXSQgCx9QGAf00PB/2mEM1CVAobTlGQn139MMYWStzbRY
         b4rg==
X-Gm-Message-State: AOAM530PewFOfiHRD9NvHh3OyZsEAZ5oDGib6ads4Qb8C2GfHB7W0vwz
        oO7BC0alfeEF0WQH3YimgmfLQLcpUs+1InqmuJQ=
X-Google-Smtp-Source: ABdhPJxh6gtG+4rw4nSBsZz6+SLG8nuO5voOBfKuehN1oHdQz46lJI85Zc3J8QEOrzFnmzOe/kNboxHRTFnYNfn0VD0=
X-Received: by 2002:a25:4d83:: with SMTP id a125mr13172761ybb.371.1610023254761;
 Thu, 07 Jan 2021 04:40:54 -0800 (PST)
MIME-Version: 1.0
References: <20210107122944.16363-1-allen.lkml@gmail.com> <20210107122944.16363-13-allen.lkml@gmail.com>
In-Reply-To: <20210107122944.16363-13-allen.lkml@gmail.com>
From:   Emil Renner Berthing <emil.renner.berthing@gmail.com>
Date:   Thu, 7 Jan 2021 13:40:43 +0100
Message-ID: <CANBLGcziNt5R9H2eh=3y=jUUjFzHJo+G1FgVVYRgxZpfE8W-6Q@mail.gmail.com>
Subject: Re: [PATCH v2 16/19] crypto: rockchip: convert tasklets to use new
 tasklet_setup() API
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     herbert@gondor.apana.org.au, giovanni.cabiddu@intel.com,
        alexandre.belloni@bootlin.com, aymen.sghaier@nxp.com,
        Heiko Stuebner <heiko@sntech.de>, qat-linux@intel.com,
        jamie@jamieiles.com, jesper.nilsson@axis.com,
        linux-samsung-soc@vger.kernel.org, horia.geanta@nxp.com,
        k.konieczny@samsung.com, schalla@marvell.com, krzk@kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        ludovic.desroches@microchip.com, thomas.lendacky@amd.com,
        arno@natisbad.org, vz@mleia.com, gilad@benyossef.com,
        gcherian@marvell.com, linux-mediatek@lists.infradead.org,
        lars.persson@axis.com, matthias.bgg@gmail.com,
        Allen Pais <apais@linux.microsoft.com>, john.allen@amd.com,
        bbrezillon@kernel.org, nicolas.ferre@microchip.com,
        linux-crypto@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Allen,

On Thu, 7 Jan 2021 at 13:32, Allen Pais <allen.lkml@gmail.com> wrote:
>
> From: Allen Pais <apais@linux.microsoft.com>
>
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
>
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
> ---
>  drivers/crypto/rockchip/rk3288_crypto.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
> index 35d73061d156..af6ad9f49009 100644
> --- a/drivers/crypto/rockchip/rk3288_crypto.c
> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
> @@ -201,9 +201,9 @@ static int rk_crypto_enqueue(struct rk_crypto_info *dev,
>         return ret;
>  }
>
> -static void rk_crypto_queue_task_cb(unsigned long data)
> +static void rk_crypto_queue_task_cb(struct tasklet_struct *T)
>  {
> -       struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
> +       struct rk_crypto_info *dev = from_tasklet(dev, t, queue_task);

This doesn't look right. First it's called T and then t. I wonder how
this even compiles..

>         struct crypto_async_request *async_req, *backlog;
>         unsigned long flags;
>         int err = 0;
> @@ -231,9 +231,9 @@ static void rk_crypto_queue_task_cb(unsigned long data)
>                 dev->complete(dev->async_req, err);
>  }
>
> -static void rk_crypto_done_task_cb(unsigned long data)
> +static void rk_crypto_done_task_cb(struct tasklet_struct *t)
>  {
> -       struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
> +       struct rk_crypto_info *dev = from_tasklet(dev, t, done_task);
>
>         if (dev->err) {
>                 dev->complete(dev->async_req, dev->err);
> @@ -389,10 +389,8 @@ static int rk_crypto_probe(struct platform_device *pdev)
>         crypto_info->dev = &pdev->dev;
>         platform_set_drvdata(pdev, crypto_info);
>
> -       tasklet_init(&crypto_info->queue_task,
> -                    rk_crypto_queue_task_cb, (unsigned long)crypto_info);
> -       tasklet_init(&crypto_info->done_task,
> -                    rk_crypto_done_task_cb, (unsigned long)crypto_info);
> +       tasklet_setup(&crypto_info->queue_task, rk_crypto_queue_task_cb);
> +       tasklet_setup(&crypto_info->done_task, rk_crypto_done_task_cb);
>         crypto_init_queue(&crypto_info->queue, 50);
>
>         crypto_info->enable_clk = rk_crypto_enable_clk;
> --
> 2.25.1
>
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
