Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B71C2BD09
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 19:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E4372464E
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 19:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoabJm/V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfLFTz4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 14:55:56 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40657 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfLFTzz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 14:55:55 -0500
Received: by mail-il1-f196.google.com with SMTP id b15so7256592ila.7;
        Fri, 06 Dec 2019 11:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DTgSv4IR0PpwmqQTfS7L4oC63RYA+jjFi0H391aqaRo=;
        b=FoabJm/VAHEA72IkwsIyNnv2Lb0OAfzfxwsi0xcKcZSGC/zIOq4hoVvRBGyq823LgA
         5QvG4cpHa9qGCS74ERmwipoNQna4LCng8AHcMhbc9m4BhXQOHxQ6mvZZKk2bfFIAgEz5
         yCdmoq909w9OxHbSYp6/VZGJWug7Qzv815CNhPRhlrmZQyJsut/ofMwtRpnhdfr7L7wq
         e3kd9xPjIxAq2hPa/iqD9PA8SldEqPRF8KjCeHFmqZPRC67+2/7pHKP/RieCINQwe0Sq
         slOAoDOnpoUgeBlKBoO7eu77aInhlnhWoBvQWjxkNfgsBIjtEme8zib6OybCBex/+M/j
         8jrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DTgSv4IR0PpwmqQTfS7L4oC63RYA+jjFi0H391aqaRo=;
        b=IqvrTrTMHwXnenBcq54jPxyCDc+Hr1tArxiBtAiBkJpY7zkW9EngArG82STfRPtEVh
         DZuqVHzKSPZZnr+JB1oLfVHKTdCSH1J2zZmPuP1fVe66efuVmGyekiAX61w4GWkNWZhl
         sF4uE2BYdM8tXoqtmxNWJAELxUJMYJKsKJYCaDePyxXbedCBPzQ0M338cU4kHiwqNWEb
         AzMR9GKZTkCR2F07m+VUqvsBKNvZ2BVM2n+dm/XVgvLVotRvj3tvTnpPkcyvAPs50AH+
         XnLn120sml3RE7lDr6vNfZDfSofMocl3J5WWN2RPYEypsg6xI7xP0h9GxqqBfWqQNGAk
         m1NQ==
X-Gm-Message-State: APjAAAVue1tbEoRUZeNbZmc54dsnfaSTV3zuWdn2VliibsW4jPjbKe5y
        WgqHJv/rbsdI+3n7WwYk2+3MM0pJDVf/Zp0e/Dc=
X-Google-Smtp-Source: APXvYqxfst5CvLGkDYX1hM+1pCwvA12wTlx4CfhcmvnK7rSdpwqjzuJODINqQZ2f1SUQGfzkdM7TqkiZnSP6UkBHKvE=
X-Received: by 2002:a92:1588:: with SMTP id 8mr15690935ilv.276.1575662154375;
 Fri, 06 Dec 2019 11:55:54 -0800 (PST)
MIME-Version: 1.0
References: <20191130225153.30111-1-aford173@gmail.com> <e8e429dd-4508-9835-fd01-825d2de8871e@kontron.de>
In-Reply-To: <e8e429dd-4508-9835-fd01-825d2de8871e@kontron.de>
From:   Adam Ford <aford173@gmail.com>
Date:   Fri, 6 Dec 2019 13:55:43 -0600
Message-ID: <CAHCN7xLkV1WC=9ACj1Mi8+uE8kRCEjCEe+Y36pXwkNeNrgrNVg@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: caam: Change the i.MX8MQ check support all
 i.MX8M variants
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 4, 2019 at 5:38 AM Schrempf Frieder
<frieder.schrempf@kontron.de> wrote:
>
> Hi Adam,
>
> On 30.11.19 23:51, Adam Ford wrote:
> > The i.MX8M Mini uses the same crypto engine as the i.MX8MQ, but
> > the driver is restricting the check to just the i.MX8MQ.
> >
> > This patch lets the driver support all i.MX8M Variants if enabled.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
>
> What about the following lines in run_descriptor_deco0()? Does this
> condition also apply to i.MX8MM?

I think that's a question for NXP.  I am not seeing that in the NXP
Linux Release, and I don't have an 8MQ to compare.

I was able to get the driver working on the i.MXMM with the patch.

NXP  Team,

Do you have any opinions on this?

adam
>
> drivers/crypto/caam/ctrl.c:
>
>         if (ctrlpriv->virt_en == 1 ||
>             /*
>              * Apparently on i.MX8MQ it doesn't matter if virt_en == 1
>              * and the following steps should be performed regardless
>              */
>             of_machine_is_compatible("fsl,imx8mq")) {
>                 clrsetbits_32(&ctrl->deco_rsr, 0, DECORSR_JR0);
>
>                 while (!(rd_reg32(&ctrl->deco_rsr) & DECORSR_VALID) &&
>                        --timeout)
>                         cpu_relax();
>
>                 timeout = 100000;
>         }
>
> Regards,
> Frieder
>
> >
> > diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> > index db22777d59b4..1ce03f8961b6 100644
> > --- a/drivers/crypto/caam/ctrl.c
> > +++ b/drivers/crypto/caam/ctrl.c
> > @@ -527,7 +527,7 @@ static const struct soc_device_attribute caam_imx_soc_table[] = {
> >       { .soc_id = "i.MX6UL", .data = &caam_imx6ul_data },
> >       { .soc_id = "i.MX6*",  .data = &caam_imx6_data },
> >       { .soc_id = "i.MX7*",  .data = &caam_imx7_data },
> > -     { .soc_id = "i.MX8MQ", .data = &caam_imx7_data },
> > +     { .soc_id = "i.MX8M*", .data = &caam_imx7_data },
> >       { .family = "Freescale i.MX" },
> >       { /* sentinel */ }
> >   };
> >
