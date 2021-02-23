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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8114CC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 20:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55A0564E2E
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 20:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhBWUtV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbhBWUtP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 15:49:15 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D07C061786;
        Tue, 23 Feb 2021 12:48:35 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d11so4570741wrj.7;
        Tue, 23 Feb 2021 12:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IwGJDPT+SCO3TP6Ah2cHRHOVWak7YyozOHAEaSbKdwg=;
        b=Wl482oRv5jnplVEjFf7SQ4dRjo/lOqwhRRpqYCtarAAIrICrYf2MCgfIYiOQsB0Y2K
         FYq0cWgXWadDy33L/sur+3Hqif6G+Tkp55n3cO69uYzelnusv53L0PGBf/7ds+YuKQFZ
         BHGYgligaF+SNcYoeWyOzroHZWoEUkVFYHsEtLfgn5MJnsYDlDZYOgSxaUDQvOuqBfAg
         qBLZ8ZhrvUMtLlInAdhTfoc228HVPmhNrxCEjsnATsbXKa9sy6G6gVWw+UcOGIO2rlGG
         UvAoCm6q7BtR0Obag+wPq/V1W6qRfJP2CZBz9X9R2jPoaxw0pH5ceIuhqg7cq8Lt6ueE
         aLUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IwGJDPT+SCO3TP6Ah2cHRHOVWak7YyozOHAEaSbKdwg=;
        b=POYv5i0ExJJb0Xzuo2A/sxiDd+t6chIadge3r8wXBElasdbQCepeWlUsmX+oiIFNFv
         S82VMG4CJ6SO5OW1LPsUFZ1oJ/f4Q1bcenz0Nm3jpSwTFmjQCaJv6VxzGiwbiE5zwgZU
         Qzyz0lH1s/hw7UOT84tynS3AUMJ1V3CxEJshMQKXYXPaxsmQrh21c08rqNsPzo3KD39r
         sYs+pasjfKI+N+vYfKD5cXcbcHL5o/X7Q6uU+4K++4zwIs9MAnDltEaNHzcFybBN6sHh
         ahO0Ej4KUw8RcvKnLFRzx0Qv4As1mGlsA2QxqtXC2UGsykjKtZ/fjCK7emQfNj/Abm9g
         gMyQ==
X-Gm-Message-State: AOAM530/KO/vp9kHnJKQ7wbCJJ781rEw3LGgKldHYNMG8VR3AOzBWl8n
        eqAbxt+mF7wSClCWufYDiYs=
X-Google-Smtp-Source: ABdhPJywDFh7II8TtTv0qO1KG+JhZ2rfXzJHnoBhk9aD5kz4P9f+w36/4wUQNMlq08zQ1DFPRU+KOw==
X-Received: by 2002:adf:fd85:: with SMTP id d5mr15876551wrr.423.1614113313727;
        Tue, 23 Feb 2021 12:48:33 -0800 (PST)
Received: from macbook-pro-alvaro.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id b15sm168179wmd.41.2021.02.23.12.48.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Feb 2021 12:48:33 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: bcm2835: document reset support
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <1614108850.556529.4116106.nullmailer@robh.at.kernel.org>
Date:   Tue, 23 Feb 2021 21:48:32 +0100
Cc:     Guenter Roeck <linux@roeck-us.net>,
        linux-rpi-kernel@lists.infradead.org,
        Matt Mackall <mpm@selenic.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?utf-8?B?Ik7DrWNvbGFzIEYuIFIuIEEuIFByYWRvIg==?= 
        <nfraprado@protonmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-crypto@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        linux-arm-kernel@lists.infradead.org,
        Scott Branden <sbranden@broadcom.com>,
        Mark Brown <broonie@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D1C5E1F2-42EC-4716-9740-1DDA8DE6CE8D@gmail.com>
References: <20210222194510.14004-1-noltari@gmail.com>
 <20210223170006.29558-1-noltari@gmail.com>
 <20210223170006.29558-2-noltari@gmail.com>
 <1614108850.556529.4116106.nullmailer@robh.at.kernel.org>
To:     Rob Herring <robh@kernel.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Rob,

> El 23 feb 2021, a las 20:34, Rob Herring <robh@kernel.org> escribi=C3=B3=
:
>=20
> On Tue, 23 Feb 2021 18:00:05 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas =
wrote:
>> Some devices may need to perform a reset before using the RNG, such =
as the
>> BCM6368.
>>=20
>> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
>> ---
>> v3: make resets required if brcm,bcm6368-rng.
>> v2: document reset support.
>>=20
>> .../devicetree/bindings/rng/brcm,bcm2835.yaml   | 17 =
+++++++++++++++++
>> 1 file changed, 17 insertions(+)
>>=20
>=20
> My bot found errors running 'make dt_binding_check' on your patch:
>=20
> yamllint warnings/errors:
>=20
> dtschema/dtc warnings/errors:
> =
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/rng/b=
rcm,bcm2835.example.dt.yaml: rng@10004180: 'resets' does not match any =
of the regexes: 'pinctrl-[0-9]+'
> 	=46rom schema: =
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/rng/b=
rcm,bcm2835.yaml

I don=E2=80=99t get what=E2=80=99s wrong here...

>=20
> See https://patchwork.ozlabs.org/patch/1443582
>=20
> This check can fail if there are any dependencies. The base for a =
patch
> series is generally the most recent rc1.
>=20
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up =
to
> date:
>=20
> pip3 install dtschema --upgrade
>=20
> Please check and re-submit.
>=20

Best regards,
=C3=81lvaro.=
