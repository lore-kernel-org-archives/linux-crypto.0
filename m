Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F66C433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 20:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91A8564F78
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 20:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhCDT7r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 14:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237162AbhCDT7Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 14:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23E1064F73;
        Thu,  4 Mar 2021 19:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614887916;
        bh=5eVG1QojNvi5xJz0510TStz08VpthyxwTc2HsKYiG14=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FRzQI6ByFfv7SALpWHRZwcT0PxN9SvISIr0q2GP73qW+ZMo4nWYdj5J6KWG+6V603
         DCOBlq+BjwjCFkKCDkLVjyZe+40VKpIfgmG+ZxGnu3YdHFSyoWeBWP+fIBDYKiUryi
         E7XrH1hOPD2hsLW8wKuRs2rLMPkwCwlITleYeWgbUJanxe7VdfaDK6uOCaXm1UljQ7
         zW/qW8Tne2Z464Utz4YUolea9a3KD++b74/P66ts/w7R0neAfMz9ms7wT5HAOvNGox
         tMgf/QzsJhau867OniE3kL4IzvmQ4A0xWZUYvNhGeP+7VPEBUuTAnY0le8srzTx4sJ
         D+mB1OcKYgEQg==
Received: by mail-ej1-f45.google.com with SMTP id w17so3906636ejc.6;
        Thu, 04 Mar 2021 11:58:36 -0800 (PST)
X-Gm-Message-State: AOAM533bD06rfF2eKeJ35M5iQ/QaQWEQ0XFgeL4f2dJdN+TGv+y6lCFd
        aCCBX0ZGm9IDk3tfru0N0GMvTIr0JIN2+prXNg==
X-Google-Smtp-Source: ABdhPJzzk280RX8Y/hNoVgVVF7BJlQJEkkZZ8rREmHwhKb7GjB7zG9V1c/YqRPom6zwb7aD5tDoPwk42uNMvar/us/c=
X-Received: by 2002:a17:906:c405:: with SMTP id u5mr6110312ejz.341.1614887914676;
 Thu, 04 Mar 2021 11:58:34 -0800 (PST)
MIME-Version: 1.0
References: <20210222194510.14004-1-noltari@gmail.com> <20210223170006.29558-1-noltari@gmail.com>
 <20210223170006.29558-2-noltari@gmail.com> <d6e5b3be7e2add03b8d00a931b7fe254cd39077e.camel@suse.de>
In-Reply-To: <d6e5b3be7e2add03b8d00a931b7fe254cd39077e.camel@suse.de>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 4 Mar 2021 13:58:21 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+o73atGxyj2Xpwb8rFj5m0AEQrvJWEyEU1UCXqnm5k1A@mail.gmail.com>
Message-ID: <CAL_Jsq+o73atGxyj2Xpwb8rFj5m0AEQrvJWEyEU1UCXqnm5k1A@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: bcm2835: document reset support
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM BCM7XXX ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?B?TsOtY29sYXMgRi4gUi4gQS4gUHJhZG8=?= 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, devicetree@vger.kernel.org,
        "moderated list:BROADCOM BCM2835 ARM ARCHITECTURE" 
        <linux-rpi-kernel@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 4, 2021 at 6:07 AM Nicolas Saenz Julienne
<nsaenzjulienne@suse.de> wrote:
>
> Hi Alvaro,
>
> On Tue, 2021-02-23 at 18:00 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas wrote=
:
> > Some devices may need to perform a reset before using the RNG, such as =
the
> > BCM6368.
> >
> > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > ---
> >  v3: make resets required if brcm,bcm6368-rng.
> >  v2: document reset support.
> >
> >  .../devicetree/bindings/rng/brcm,bcm2835.yaml   | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/=
Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> > index c147900f9041..11c23e1f6988 100644
> > --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> > +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> > @@ -37,6 +37,21 @@ required:
> >
> >
> >  additionalProperties: false
>
> I can't claim I fully understand all the meta stuff in shemas, so I gener=
ally
> just follow the patterns already available out there. That said, shoudln'=
t this
> be at the end, just before the examples? Maybe the cause of that odd warn=
ing
> you got there?

Yes, 'resets' needs to be defined under 'properties' as
additionalProperties can't 'see' into if/then schemas. The top level
needs to define everything and then if/then schema just add additional
constraints.

>
> > +if:
> > +  properties:
> > +    compatible:
> > +      enum:
> > +        - brcm,bcm6368-rng
> > +then:
> > +  properties:
> > +    resets:
> > +      maxItems: 1
> > +  required:
> > +    - resets
>
> I belive you can't really make a property required when the bindings for
> 'brcm,bcm6368-rng' were already defined. This will break the schema for t=
hose
> otherwise correct devicetrees.

Right, unless not having the property meant the device never would have wor=
ked.

Rob
