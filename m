Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F14EC43381
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 14:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E1864F88
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 14:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhCDO63 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 09:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbhCDO6S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 09:58:18 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56455C061574;
        Thu,  4 Mar 2021 06:57:38 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id f12so24179875wrx.8;
        Thu, 04 Mar 2021 06:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=VoPx2Cdxwn60O0M6Vi5u1Ygt08JDUk/3AjCskxZyugQ=;
        b=Rxnisa3mPdPHv7NNTjmf51YPOHNbAi/xTRBJeTM5zxCilomemS7p+h8DW66PIzPBoQ
         7wwKbiZLOLdV7XBMCg3txRoFf+emEUV2RJhnggO3ZfOO8bHeU9/AmsWHX3ceoVhZkYyT
         rYeJYyHgeYY6iPqr4QTOcjut4W8SrBVjq1xPc5DhWbXd1mXXdA+gKpZmds+52zcd8h3y
         Yy1NNo2hWDMMmazgiBuCfKBHuINfSOgUSL0X0hdFGD3uK4S4+m2pgZ0JmQswinbHPhgt
         pb4n6t9ED8V1pFJgG7k+drVBjmyyEwnMbF/9zIO60elVwZWD3PTyJigSfv+Pu4EKKBi2
         4jkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=VoPx2Cdxwn60O0M6Vi5u1Ygt08JDUk/3AjCskxZyugQ=;
        b=nj9+Nkbm2tFwUVOVGQxcUu0fvSW/yhfTQCv/1IL4irHHiy/3Y227fwlf0JSQyxKscA
         Npj3Lr/AennbQjJRyzzNMBrZHkVgRZkFY+WLrVPAR7TmMyXdcwTUxAV/Ah/i8F4WuOd/
         wHxLZnmRUO/xi2jaQY//uSDjfVItrVumVG2V35YXOyfJBHBB5rvghezQ7QRn9HjxxQ7Y
         3SkG50cbZxb3QudhQ2G2zI6b9FtAGTnsDuwjRG3n+HJ49edGf3ekSduCRqQ0nB92rSZr
         yOirGyvjehISyqOC7sbRR3hT7m3jnw5bBWCcvndc8nqkSmvsnxh6XlLAj5eq++IM35x8
         8e8g==
X-Gm-Message-State: AOAM532QcIJoElUIKtxKh/Km4gpCni8hRQZbGLgMNecrbOIsiX7smlW6
        WuyxNbQSigICTCMJ1JH31R8=
X-Google-Smtp-Source: ABdhPJyBS18SvzoNqUADJrKfF34ApnOWPmd4o1EiF+kk+KM0ZRbpeTw7Dm3eUpT8m8TD4tPcEqyPbw==
X-Received: by 2002:adf:ff8c:: with SMTP id j12mr4370114wrr.297.1614869857011;
        Thu, 04 Mar 2021 06:57:37 -0800 (PST)
Received: from macbook-pro-alvaro.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id s83sm1236045wmf.26.2021.03.04.06.57.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Mar 2021 06:57:36 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: bcm2835: document reset support
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <c750ae9f6c55011c07868ba563ac8e5af3e01a2a.camel@suse.de>
Date:   Thu, 4 Mar 2021 15:57:36 +0100
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nfraprado@protonmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <91B364C3-022E-4FB8-905C-C5B6EB74E784@gmail.com>
References: <20210222194510.14004-1-noltari@gmail.com>
 <20210223170006.29558-1-noltari@gmail.com>
 <20210223170006.29558-2-noltari@gmail.com>
 <d6e5b3be7e2add03b8d00a931b7fe254cd39077e.camel@suse.de>
 <419CC9A9-1C14-4D44-8305-3F7DFF656C1F@gmail.com>
 <c750ae9f6c55011c07868ba563ac8e5af3e01a2a.camel@suse.de>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Nicolas,

> El 4 mar 2021, a las 14:30, Nicolas Saenz Julienne =
<nsaenzjulienne@suse.de> escribi=C3=B3:
>=20
> On Thu, 2021-03-04 at 13:18 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas =
wrote:
>>=20
>>> El 4 mar 2021, a las 13:07, Nicolas Saenz Julienne =
<nsaenzjulienne@suse.de> escribi=C3=B3:
>>>=20
>>> Hi Alvaro,
>>>=20
>>> On Tue, 2021-02-23 at 18:00 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas =
wrote:
>>>> Some devices may need to perform a reset before using the RNG, such =
as the
>>>> BCM6368.
>>>>=20
>>>> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
>>>> ---
>>>>  v3: make resets required if brcm,bcm6368-rng.
>>>>  v2: document reset support.
>>>>=20
>>>>  .../devicetree/bindings/rng/brcm,bcm2835.yaml   | 17 =
+++++++++++++++++
>>>>  1 file changed, 17 insertions(+)
>>>>=20
>>>> diff --git =
a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml =
b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
>>>> index c147900f9041..11c23e1f6988 100644
>>>> --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
>>>> +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
>>>> @@ -37,6 +37,21 @@ required:
>>>> =20
>>>>=20
>>>>=20
>>>>  additionalProperties: false
>>>=20
>>> I can't claim I fully understand all the meta stuff in shemas, so I =
generally
>>> just follow the patterns already available out there.
>>=20
>> Well, that makes two of us :).
>>=20
>>> That said, shoudln't this be at the end, just before the examples?
>>=20
>> I don=E2=80=99t know but I can move it there =C2=AF\_(=E3=83=84)_/=C2=AF=

>=20
> Yes please do. See commit 7f464532b05 ("dt-bindings: Add missing
> 'additionalProperties: false'") which expands on why it is needed, and =
why it
> should be at the end.
>=20
>>> Maybe the cause of that odd warning
>>> you got there?
>>=20
>> Which odd warning?
>=20
> The one pointed out by Rob Herring's script, which I can reproduce too =
BTW. On
> the other hand I can't really tell what's wrong right away.

Well, I can=E2=80=99t reproduce that locally and I don=E2=80=99t know =
what=E2=80=99s wrong either, I think that the best option is to remove =
the full if block.

>=20
>> I don=E2=80=99t get any warnings when running (or at least warnings =
related to rig, because I get warnings related to other yamls):
>> make dt_binding_check =
DT_SCHEMA_FILES=3DDocumentation/devicetree/bindings/rng/brcm,bcm2835.yaml
>>=20
>>>=20
>>>> +if:
>>>> +  properties:
>>>> +    compatible:
>>>> +      enum:
>>>> +        - brcm,bcm6368-rng
>>>> +then:
>>>> +  properties:
>>>> +    resets:
>>>> +      maxItems: 1
>>>> +  required:
>>>> +    - resets
>>>=20
>>> I belive you can't really make a property required when the bindings =
for
>>> 'brcm,bcm6368-rng' were already defined. This will break the schema =
for those
>>> otherwise correct devicetrees.
>>=20
>> Why not?
>> Wouldn=E2=80=99t just be required for brcm,bcm6368-rng?
>=20
> Well, do all 'brcm,bcm6368-rng' users absolutely need the reset =
controller? If
> so, the original binding is wrong, which should be mentioned and a =
'Fixes:' tag
> should be added to the commit message. Otherwise, the requirement is =
optional.

I=E2=80=99m not sure about this...

>=20
> Regards,
> Nicolas

Best regards,
=C3=81lvaro.=
