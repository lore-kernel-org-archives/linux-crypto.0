Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97DCC4321A
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C650964F4B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345713AbhCDAHU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239938AbhCCOHn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 09:07:43 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3C1C06178C;
        Wed,  3 Mar 2021 06:06:52 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id w7so5277213wmb.5;
        Wed, 03 Mar 2021 06:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=409MBK1RaSBcBkFgX0waobAB/KXrYT6ZhARjSd5/LV4=;
        b=BTj8PkS+lJX313eZ+w7j8EzNUUB4UBS47RsvJERmHyIPz/ib70p9xFKn71mcwZHMDf
         9X+6x90V8YqHlaU9967fH45mqBr1h+sV17t6AUYEQazBY8agivTDPQr9Nhq6DZotRsdL
         Pa21rl6GnpDJnZqqqe6GunoPgympsZft9I07fhUwKnAqiVIQGTRtHYzJFNGDAvCcGGwT
         f7vSHpEGsvigd1szOL3CPi1jQi6VqgdhMnqirGxMuAGdQgJ/P6RmvpXIiChCCUsAwA7Z
         sSNtpcBkWcj5ay+fy67/PbLjBvr5YdI034Q9qxLofCS67e70b65fhhVjKxUPF1uDs7x5
         D67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=409MBK1RaSBcBkFgX0waobAB/KXrYT6ZhARjSd5/LV4=;
        b=h//yFT0/0G3FONA6kxIXCTcxhT8Z01xrpjrhw7VvaJYeLJerJiQ0Xs9MGTYL38Vbd7
         xWtnn3YFImInqsu66olmIrG4rF7/ipXjdp/hzKRzHq077/UQ6rGqBS6Rx6M+FOn+u3AC
         Kaq7+oo8ws/sAIWsj6mhyJOqDHFl8C4Dj13XBsySUK2JQtgLqlfvM8yWOUYgCcGxVhqO
         C4T0i5ByF9TEOKsMMVQVETdM/sEPL8D2wcgP6R87FI63lC72hKlt/pE4L2ErhL7DBppN
         7JmCOX3JyJeZUlWw3njSzY/osaZ3TrRWNRFTMMd5bLpqOaPxX/KjNZ/EU+bElnKxFqhn
         eEjg==
X-Gm-Message-State: AOAM531SyIJYbDhpvJgkmTHsMkZ54tFVgjcZOIxd03wCFEliUhokTnVD
        DB6b+f2VjXSiqseNYpymydc=
X-Google-Smtp-Source: ABdhPJxfUJRv37iA5SKz2sl4zvjmxoD5SO9XMgNmlkAeXz68F/mUm0OH/Poju7RD9jaM+2dccvuhdg==
X-Received: by 2002:a7b:c755:: with SMTP id w21mr9539940wmk.89.1614780411113;
        Wed, 03 Mar 2021 06:06:51 -0800 (PST)
Received: from macbook-pro-alvaro.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id c35sm5698479wmp.3.2021.03.03.06.06.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Mar 2021 06:06:49 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v4 2/2] hwrng: bcm2835: add reset support
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <cb7e29012e15ff10916374f911c74430fc3f5b32.camel@pengutronix.de>
Date:   Wed, 3 Mar 2021 15:06:48 +0100
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?utf-8?B?Ik7DrWNvbGFzIEYuIFIuIEEuIFByYWRvIg==?= 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7B6F49A9-A31D-4126-8CB1-11EE3B2B7950@gmail.com>
References: <20210223160131.29053-1-noltari@gmail.com>
 <20210224082230.29015-1-noltari@gmail.com>
 <20210224082230.29015-3-noltari@gmail.com>
 <cb7e29012e15ff10916374f911c74430fc3f5b32.camel@pengutronix.de>
To:     Philipp Zabel <p.zabel@pengutronix.de>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Philipp,

> El 3 mar 2021, a las 14:52, Philipp Zabel <p.zabel@pengutronix.de> =
escribi=C3=B3:
>=20
> Hi =C3=81lvaro,
>=20
> On Wed, 2021-02-24 at 09:22 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas =
wrote:
> [...]
>> @@ -115,6 +121,8 @@ static void bcm2835_rng_cleanup(struct hwrng =
*rng)
>> 	/* disable rng hardware */
>> 	rng_writel(priv, 0, RNG_CTRL);
>>=20
>> +	reset_control_rearm(priv->reset);
>> +
>> 	if (!IS_ERR(priv->clk))
>> 		clk_disable_unprepare(priv->clk);
>> }
>> @@ -159,6 +167,10 @@ static int bcm2835_rng_probe(struct =
platform_device *pdev)
>> 	if (PTR_ERR(priv->clk) =3D=3D -EPROBE_DEFER)
>> 		return -EPROBE_DEFER;
>>=20
>> +	priv->reset =3D devm_reset_control_get_optional_exclusive(dev, =
NULL);
>> +	if (IS_ERR(priv->reset))
>> +		return PTR_ERR(priv->reset);
>> +
>> 	priv->rng.name =3D pdev->name;
>> 	priv->rng.init =3D bcm2835_rng_init;
>> 	priv->rng.read =3D bcm2835_rng_read;
>=20
> That doesn't seem right. reset_control_rearm() doesn't do anything if
> the reset control is exclusive. Either the reset control should be
> requested as shared, or the _rearm should be removed.

In only added reset_control_rearm() because Florian requested it=E2=80=A6
I think it=E2=80=99s not needed, so we can use v3, since it was the only =
change between v3 and v4...

>=20
> regards
> Philipp

Best regards,
=C3=81lvaro.=
