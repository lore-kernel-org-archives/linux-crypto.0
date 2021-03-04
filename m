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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E826C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 12:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 674F564F11
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 12:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhCDMT3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240404AbhCDMTF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 07:19:05 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DCDC061574;
        Thu,  4 Mar 2021 04:18:24 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id u14so27415390wri.3;
        Thu, 04 Mar 2021 04:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KNlstPTDN9pTEJEKpuf+h3ME6Y8QWCswm7ow88tpM0k=;
        b=A0ZYW4QSFB86QnM5sFtGcxGb2+OQ7FAl8POI6u8LMPpLEuhBkm6f+VOiQ3KQpFT8q+
         sRuGfdQC8wJzeEbgWLoNbpdasSVEduD2cOXvRNDNlsSomgZQ0O2BAswao5T28W25MVF+
         VjNg73mrzXj1eYMyIxGQW+5H+uC/E9DEY9x/bvQFLKZ1ZN7YqXGw7tOtnZDx5Ol+NRPw
         o9PQ2B3waOvnvxTnWMANfrr1+7eLEEU5sDVrIhasyXxtDHyUGrjTr5x4Yfz3kXkGDvnH
         YNBZciYNPLco65Xi10wifn4lq6XPhIvAexoKLg8R+i/AqPZ4Ns1e7mB6CH9F3d/fKTuf
         Oerw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KNlstPTDN9pTEJEKpuf+h3ME6Y8QWCswm7ow88tpM0k=;
        b=rgnPT0H1ZotRDaliyq9X8lJDNbcchFnO9cYxk0j+MHHHE6KzrgiE8zN5dMx1fCyCXm
         ry3qdJfgZ5qYInEBSXT23sG9yjQXEmZ0daZC81pWNsLGXeVO+9D6XhfHUTa+3pqZlQCt
         GFW16ctq5V/CkSj61GmyjDXPwluYzHuMsmq3SaxTxVaYbMeKNUqOYYx9vZPmR53RMmOu
         phwvy4Ns7ZcBgfPwBlk59cGbweJdb2EJFEbqGndIMm9fd+8XF3zkykjikMqidVFQT8r2
         1PR+slNFPrK8JRTbp9EBDcxVUVsJqU3q2MKsAFY/+UuiNhrkGGaUp/GhccdaTMDIR54/
         zHAA==
X-Gm-Message-State: AOAM533P3qTtI8W/umSVYfSDvOHDMvu9wSSp0R000xZ3jn1JkToKv9Ji
        gh5mTKgUmNgFbTbl2vnKGvgD+lW3PVx3NjSI
X-Google-Smtp-Source: ABdhPJzwpYxSmJP2GVlgTeDei3xg+qCNoyBN4f+Kv+fT5+DSZOSJclDLtTs2GQd4aD38gQiC4pgQtg==
X-Received: by 2002:adf:ec0b:: with SMTP id x11mr3601812wrn.175.1614860303494;
        Thu, 04 Mar 2021 04:18:23 -0800 (PST)
Received: from macbook-pro-alvaro.lan (170.red-88-1-105.dynamicip.rima-tde.net. [88.1.105.170])
        by smtp.gmail.com with ESMTPSA id y205sm12232542wmc.18.2021.03.04.04.18.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Mar 2021 04:18:23 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v3 1/2] dt-bindings: rng: bcm2835: document reset support
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <d6e5b3be7e2add03b8d00a931b7fe254cd39077e.camel@suse.de>
Date:   Thu, 4 Mar 2021 13:18:22 +0100
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
        =?utf-8?B?Ik7DrWNvbGFzIEYuIFIuIEEuIFByYWRvIg==?= 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <419CC9A9-1C14-4D44-8305-3F7DFF656C1F@gmail.com>
References: <20210222194510.14004-1-noltari@gmail.com>
 <20210223170006.29558-1-noltari@gmail.com>
 <20210223170006.29558-2-noltari@gmail.com>
 <d6e5b3be7e2add03b8d00a931b7fe254cd39077e.camel@suse.de>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> El 4 mar 2021, a las 13:07, Nicolas Saenz Julienne =
<nsaenzjulienne@suse.de> escribi=C3=B3:
>=20
> Hi Alvaro,
>=20
> On Tue, 2021-02-23 at 18:00 +0100, =C3=81lvaro Fern=C3=A1ndez Rojas =
wrote:
>> Some devices may need to perform a reset before using the RNG, such =
as the
>> BCM6368.
>>=20
>> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
>> ---
>>  v3: make resets required if brcm,bcm6368-rng.
>>  v2: document reset support.
>>=20
>>  .../devicetree/bindings/rng/brcm,bcm2835.yaml   | 17 =
+++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>=20
>> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml =
b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
>> index c147900f9041..11c23e1f6988 100644
>> --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
>> +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
>> @@ -37,6 +37,21 @@ required:
>> =20
>>=20
>>  additionalProperties: false
>=20
> I can't claim I fully understand all the meta stuff in shemas, so I =
generally
> just follow the patterns already available out there.

Well, that makes two of us :).

> That said, shoudln't this be at the end, just before the examples?

I don=E2=80=99t know but I can move it there =C2=AF\_(=E3=83=84)_/=C2=AF

> Maybe the cause of that odd warning
> you got there?

Which odd warning?
I don=E2=80=99t get any warnings when running (or at least warnings =
related to rig, because I get warnings related to other yamls):
make dt_binding_check =
DT_SCHEMA_FILES=3DDocumentation/devicetree/bindings/rng/brcm,bcm2835.yaml

>=20
>> +if:
>> +  properties:
>> +    compatible:
>> +      enum:
>> +        - brcm,bcm6368-rng
>> +then:
>> +  properties:
>> +    resets:
>> +      maxItems: 1
>> +  required:
>> +    - resets
>=20
> I belive you can't really make a property required when the bindings =
for
> 'brcm,bcm6368-rng' were already defined. This will break the schema =
for those
> otherwise correct devicetrees.

Why not?
Wouldn=E2=80=99t just be required for brcm,bcm6368-rng?

Anyway, I can omit this, since it would be the same for clocks and those =
aren=E2=80=99t required either.

>=20
>> +else:
>> +  properties:
>> +    resets: false
>> +
>>  examples:
>>    - |
>>      rng@7e104000 {
>> @@ -58,4 +73,6 @@ examples:
>> =20
>>=20
>>          clocks =3D <&periph_clk 18>;
>>          clock-names =3D "ipsec";
>> +
>> +        resets =3D <&periph_rst 4>;
>>      };
>=20
> Regards,
> Nicolas

Best regards,
=C3=81lvaro.=
