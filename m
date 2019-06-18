Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419EBC31E5B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 00:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 029B320861
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 00:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BpSzT1nx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfFRAVP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 20:21:15 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40971 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfFRAVO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 20:21:14 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so25528346ioc.8;
        Mon, 17 Jun 2019 17:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f7qi6ptnZnKofJihvHQI91m4MgUr9Emtorcly9ZGcXU=;
        b=BpSzT1nxXb7PpD4Bp58AQ1+91csc/KOgUov0l2TR7KiL3Tl1dRFaym1cznsAUKUjPx
         yjpVzszAHXiNzva2lZ4Hhdgi2ga4h93Lg+4TKRg8HNlK8XMB3zMbZ+0FhNVYHyjeROxF
         dJCslj5uPJLNkMAeqqf7CbyZa3t8uxPkHlqBmW5sDV0WUUpaLRD9j4jFbt71bd9g0qmU
         QVrt7BbUwA13J9oRGsn+CFBaVxNCYQqOoQqK+ipO9UyffxnxZm1a7ygkwShepsGQ5Wmv
         cs6RWRtT1itAV/VGgEHAEAdPzOvdHPKi7Ub3m3zy6T3XF3Nh1KvWjQzJibqffseQfurD
         mTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f7qi6ptnZnKofJihvHQI91m4MgUr9Emtorcly9ZGcXU=;
        b=S3JVMVWqcRGG9yC1QGjzWZ5IOkUwQMxwJP1mCD2O+iG+GnqQtJzocpo+0qz90tL7YI
         fx+M+HjOdelnJeH4fhUxJa2HtuT2OOrXbJxjUH7OmM4mvQn1aeC5LUfkFva3WUio9fBU
         Mh/oN6jUG8VeXL2G6L1fsegRacZG7Cy87t6IPqqo8JVPTarxsKVdDMu1iYSl+pB8AUrX
         +zBu9hfi2vP54fA+3oVzsPyyvzJJUDsoEOojFMgOAxuHkZVqeHqRlAyCseG95Xug6L4X
         PWDNa3Cis23PxBj28YOZQ5gHqkLOg7XOCPVwhY2xELKIg/rYcj6BNFWEBxkDghwxnQHn
         LCaQ==
X-Gm-Message-State: APjAAAW2H8KGIqEnkUYlLNFi6oL5egXQs2sAt7O7ehmVlJRnIPJZ45xq
        qBPfH88+JpOdg2rCqeRHW2e6d3OmxuLKxshi4CM=
X-Google-Smtp-Source: APXvYqxna8rKBwQCboUHn2RCxNdpkwZijw84DPeCGnQ9ARISgRKOzilk0arBh1QefIcPOFbFfqIy5UlaHThI3XWgxvk=
X-Received: by 2002:a6b:4107:: with SMTP id n7mr19734595ioa.12.1560817273723;
 Mon, 17 Jun 2019 17:21:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190617160339.29179-1-andrew.smirnov@gmail.com>
 <20190617160339.29179-5-andrew.smirnov@gmail.com> <VI1PR04MB50556DE0057E1B5802E0DAA1EEEB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB50556DE0057E1B5802E0DAA1EEEB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 17 Jun 2019 17:21:01 -0700
Message-ID: <CAHQ1cqFLhj0N+qKFTYDjmCzAm5CaDeuvMM4ZWN+9CQNr0orXTA@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] crypto: caam - simplfy clock initialization
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 12:48 PM Leonard Crestez
<leonard.crestez@nxp.com> wrote:
>
> On 6/17/2019 7:04 PM, Andrey Smirnov wrote:
> > Simplify clock initialization code by converting it to use clk-bulk,
> > devres and soc_device_match() match table. No functional change
> > intended.
>
> Subject is misspelled.
>

Will fix.

> > +struct clk_bulk_caam {
> > +     const struct clk_bulk_data *clks;
> > +     int num_clks;
> > +};
>
> clks could be an array[0] at the end to avoid an additional allocation.
>

struct clk_bulk_caam is also used to declare caam_imx*_clk_data
variables, where this approach wouldn't work.

> > +static void disable_clocks(void *private)
> > +{
> > +     struct clk_bulk_caam *context = private;
> > +
> > +     clk_bulk_disable_unprepare(context->num_clks,
> > +                                (struct clk_bulk_data *)context->clks);
> > +}
>
> Not sure using devm for this is worthwhile. Maybe someday CAAM clks will
> be enabled dynamically?
>

I don't see a reason why this code can't be changed _if_ and when that
ever happens.

> It would be make sense to reference "clk" instead of "clocks".
>

I am not sure what you reference here. I'd rather we avoid discussing
trivial spelling aspects like this.

> > +static int init_clocks(struct device *dev,
> > +                    const struct clk_bulk_caam *data)
> > +{
> > +     struct clk_bulk_data *clks;
> > +     struct clk_bulk_caam *context;
> > +     int num_clks;
> > +     int ret;
> > +
> > +     num_clks = data->num_clks;
> > +     clks = devm_kmemdup(dev, data->clks,
> > +                         data->num_clks * sizeof(data->clks[0]),
> > +                         GFP_KERNEL);
> > +     if (!clks)
> > +             return -ENOMEM;
> > +
> > +     ret = devm_clk_bulk_get(dev, num_clks, clks);
> > +     if (ret) {
> > +             dev_err(dev,
> > +                     "Failed to request all necessary clocks\n");
> > +             return ret;
> > +     }
> > +
> > +     ret = clk_bulk_prepare_enable(num_clks, clks);
> > +     if (ret) {
> > +             dev_err(dev,
> > +                     "Failed to prepare/enable all necessary clocks\n");
> > +             return ret;
> > +     }
> > +
> > +     context = devm_kzalloc(dev, sizeof(*context), GFP_KERNEL);
> > +     if (!context)
> > +             return -ENOMEM;
>
> Aren't clks left enabled if this fails? Can move this allocation higher.
>

Good point, will do.

> > +     context->num_clks = num_clks;
> > +     context->clks = clks;
> > +
> > +     ret = devm_add_action_or_reset(dev, disable_clocks, context);
> > +     if (ret)
> > +             return ret;
> > +
> > +     return 0;
> > +}
>
> >   static int caam_probe(struct platform_device *pdev)
> >   {
> >       int ret, ring, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
> >       u64 caam_id;
> > -     static const struct soc_device_attribute imx_soc[] = {
> > -             {.family = "Freescale i.MX"},
> > -             {},
> > -     };
> > +     const struct soc_device_attribute *soc_attr;
>
> This "soc_attr" is difficult to understand, maybe rename to something
> like "imx_soc_match"?

Sure, will do in next version.

Thanks,
Andrey Smirnov
