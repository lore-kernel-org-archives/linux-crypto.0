Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27FEC433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Sep 2021 20:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBAF61056
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Sep 2021 20:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhISUIy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Sep 2021 16:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhISUIx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Sep 2021 16:08:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144FDC061574
        for <linux-crypto@vger.kernel.org>; Sun, 19 Sep 2021 13:07:28 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id q3so52524240edt.5
        for <linux-crypto@vger.kernel.org>; Sun, 19 Sep 2021 13:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ju0kO6Sc7bStNoeex9OGswN16igUgEBg+yxA3VBWAk4=;
        b=clubKcKxMoX47ZhaXjsGeTaoUBv3AwKZJfFKDlARwk9f1DnMwyOI03FJSBvL3XZ+Li
         sOQC177t4QdjJDFRwIhusoD6mLHgpE7dXRsapTbPDullDElHA8M4jGbYFDIDYbO86m77
         Opu21eS624GwKeoNrLzt51EfV/KUN914KFnR1NCnXnYjOacmOiZZwQ6gYnOyUNslHfEn
         JPdXBYvkcAglHBab5YcpElR5qF4GN3kWCSEKsD/bK2cWuwrvuuNJ0YrdV5qwj+Lplo6J
         KMRF6SXSPojUSgUzKIREeqRMDh0xt8UFPvQTvqPoiLgAwlJ3RzVUBbvSjFfDL0ykErQl
         YpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ju0kO6Sc7bStNoeex9OGswN16igUgEBg+yxA3VBWAk4=;
        b=lmoH4hqrnB5n2t3asBQuLpnp1ylMSGLc3TjW+O5djfZPxbvoXOlkBY2yPAXIBTXDvs
         DJ0FbeSxPIzx6qN6rOT9mtdn3HdUwqo8R+tAREdT94ffJrXM4sBDrsGrwLQBXrZO/S9O
         jJheW2JZTWMxAtNOOwOapd6Flp/qxej5yBCkOd3xbcmWR1rLWmVTTR8GgrYiUtxdGfXA
         g2pA7OIvn0LrLBZ+3TiSz58+z1owx23RT9EanVywL9fpvp+k3+OZR7nkzv0VLdI4l3nt
         ErJzJkAa9ASwsYAnDOAbx2r+GTx0k4GhCtMUMNHTE6NJyM/ATt6b54su8c1TIDle6f2W
         nQ4w==
X-Gm-Message-State: AOAM5321e8kwUom6LqVvOTMzXChiLoJbtiCCpZRPJNwbXUVW7Gg2TyjM
        x4uXfrbauIS1s/KlwGN9tdytV4TKyo8EA4qq/Uw=
X-Google-Smtp-Source: ABdhPJzybjleeR39eCj9mdNyWJV9a4UnK/zq/PCBrx98z1W9NcTKcEAzfXYyPOvtFwXsoYsabiYCoyMI9FWbIeBV5dE=
X-Received: by 2002:a05:6402:358f:: with SMTP id y15mr24667243edc.67.1632082046514;
 Sun, 19 Sep 2021 13:07:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210914142428.57099-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20210914142428.57099-1-u.kleine-koenig@pengutronix.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 19 Sep 2021 22:07:15 +0200
Message-ID: <CAFBinCAFp1FfRdQqKu3j3R1zsDFaeomcFB2DJOEjjKV6jJepTg@mail.gmail.com>
Subject: Re: [PATCH] hwrng: meson - Improve error handling for core clock
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Uwe,

On Tue, Sep 14, 2021 at 4:24 PM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
[...]
> -       data->core_clk =3D devm_clk_get(dev, "core");
> -       if (IS_ERR(data->core_clk))
> -               data->core_clk =3D NULL;
> +       data->core_clk =3D devm_clk_get_optional(dev, "core");
> +       if (IS_ERR(data->core_clk)) {
> +               ret =3D PTR_ERR(data->core_clk);
> +               if (ret !=3D -EPROBE_DEFER)
> +                       dev_err(dev, "Failed to get core clock: %pe\n",
> +                               data->core_clk);
> +
> +               return ret;
I suggest simplifying this by using dev_err_probe as this:
- allows you to get rid of the if (ret !=3D -EPROBE_DEFER)
- means that the message is shown in debugfs' "devices_deferred"


Best regards,
Martin
