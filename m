Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9698DC04FF3
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 13:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DEFF613CC
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 13:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhEXNtW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 May 2021 09:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232758AbhEXNtV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 May 2021 09:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23D046138C;
        Mon, 24 May 2021 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621864073;
        bh=qQUoDUl6eC5A6f31OVyNYo1Z1swM4KjwlNY4MNwlbKQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qrwGR21lN+hvcBmbdetqiqz2AtylccWXrIC+6KVe1kavN2Lfsx/vLRdZkCNFmDcM4
         bZyS7LXEYsUCzobpEcdZt/ZFRoLDNvVSa1haj/iFxT11EsKrrUglvak81PdhxD9a5U
         aIQusstrb5tD31jALGdu5drk+dLvkNxVZ2igseXzXdlJD9mzIgXeeZaelxCnSu3Tx8
         XPYJtJHL0T5qOlqETExMz8EmtnkiORYI1y3uHT6JBI458VeEWPOx4g6uGrQQXdYQG6
         ocvxAIvN8cvjCcD0bvN82ae8VZr+SH3L9g3mLv6SgmG3Jsq6D9AnXwR7xDyWNcmyg7
         jfU+eo1B88dWg==
Received: by mail-ed1-f42.google.com with SMTP id r11so31963479edt.13;
        Mon, 24 May 2021 06:47:53 -0700 (PDT)
X-Gm-Message-State: AOAM531E8lAcUuGhhNM4RRk29lZ+I5cPXeT9nJwBH1gaq1WtKIGAv5ve
        G1ockiF6+VXrVNVY+OGnFgkD59CSqq9oX1ySww==
X-Google-Smtp-Source: ABdhPJyrlldCn29/l6S09e/r21+EAvoErdXzwq16u0TiBGZuSvlancn6eRzneh2OotqVA1YEpADhqRRKjZ57S4S83as=
X-Received: by 2002:aa7:cd83:: with SMTP id x3mr25403134edv.373.1621864071778;
 Mon, 24 May 2021 06:47:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210520223020.731925-1-linus.walleij@linaro.org>
 <20210521172749.GA33272@robh.at.kernel.org> <CACRpkdbiKA13VoKLV2Dn-4irc4h5EULNmMptpTrKQDAHDaE4Ng@mail.gmail.com>
In-Reply-To: <CACRpkdbiKA13VoKLV2Dn-4irc4h5EULNmMptpTrKQDAHDaE4Ng@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 24 May 2021 08:47:39 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLOzSTS8uWKa+uyA7Q2Zd9DtsxPrAjwv=tB5ZjeRDzGBQ@mail.gmail.com>
Message-ID: <CAL_JsqLOzSTS8uWKa+uyA7Q2Zd9DtsxPrAjwv=tB5ZjeRDzGBQ@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] crypto: ixp4xx: Add DT bindings
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 22, 2021 at 11:26 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Fri, May 21, 2021 at 7:27 PM Rob Herring <robh@kernel.org> wrote:
>
> > > +  intel,npe:
> > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > +    minimum: 0
> > > +    maximum: 3
> > > +    description: phandle to the NPE this ethernet instance is using
> >
> > Not a phandle now.
> >
> > > +      and the instance to use in the second cell
> >
> > Maybe 'reg' works here? You can only have 1 thing you address though if
> > you use reg here.
>
> Good idea, I'll try that.
>
> > How are other NPE instances used? Are you going to need to have a
> > reference to them?
>
> They are used by phandle from the combined ethernet and phy
> instances.

So 'intel,npe' property? Then we should probably just keep that. For
sure, we don't want a given property to have 2 different types. (Some
day I intend to check for that.)

> They are accelerators with firmware which have direct
> access to the ethernet and phy port, and one of the NPE:s can
> additionally contain a crypto engine.
