Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77E8C4320E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Aug 2021 18:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F0D61221
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Aug 2021 18:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhHTS2b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Aug 2021 14:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhHTS2b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Aug 2021 14:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CCE26124C;
        Fri, 20 Aug 2021 18:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629484073;
        bh=bKkSyF0cIR7C2YqfM8yKj7Qp9nOnaWZgsyvjnNl53BI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QDmhDcr5RLG8KteL+FGyHFgWOAWE40/VW5F4h8utD1g+VxmZdTbDF9huphbCCp+Ta
         FidIR7HZRM+/1ss8nyoryVG9x71BlMsuGJEzOrDAtrlxMmF/LV/YOT5v00Ib46HdOE
         eUWufuhKaUJUKprf+MogP8oWx/N7rXNrP4xknPuXIPkx8rslUnhxphTKhivhgGIRct
         m1ozWbRNMnYVCOp8CqCzPD+qzIuqMZCa8BshvzLDonKMTX6BmPzem1XUcABurrXHYl
         plH8o7pn/7S14BiBjNXQjxHOSbmg5hkjig1RRXNHjHoI4nPq1bRALPpqfHAQj1D6C0
         HYwR6yAVNiSVg==
Received: by mail-ej1-f44.google.com with SMTP id d11so21892467eja.8;
        Fri, 20 Aug 2021 11:27:53 -0700 (PDT)
X-Gm-Message-State: AOAM533P5cz1oMe4nSAKxtqZFmBRHIr7NsPuUXSBpL36OqWw9Z22ODGu
        VAgyhw5ncl3kAOvr5TI/w7moEIw3U1YVMADFsw==
X-Google-Smtp-Source: ABdhPJwOYOWWMI4zSQFJ24B+WJkFRlio9QXgQqVaM4RY0hWlajQIWpruaO0OcC7vKJS6BHduuCFJ2xo7g+YB1b5UJkw=
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr22606820ejb.108.1629484071600;
 Fri, 20 Aug 2021 11:27:51 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210817221734eucas1p2e4a0aa41406137b90e49230371b92ac6@eucas1p2.samsung.com>
 <da43d243-35b0-2cc6-f8a0-a5d02c997301@canonical.com> <dleftjtujnemx7.fsf%l.stelmach@samsung.com>
In-Reply-To: <dleftjtujnemx7.fsf%l.stelmach@samsung.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 20 Aug 2021 13:27:39 -0500
X-Gmail-Original-Message-ID: <CAL_JsqK7MfUL8=0SfaKDoZmtN7qrgejdsZnNFENeEJpJVDuOKw@mail.gmail.com>
Message-ID: <CAL_JsqK7MfUL8=0SfaKDoZmtN7qrgejdsZnNFENeEJpJVDuOKw@mail.gmail.com>
Subject: Re: [PATCH 2/2] dt-bindings: rng: convert Samsung Exynos TRNG to dtschema
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 17, 2021 at 5:17 PM Lukasz Stelmach <l.stelmach@samsung.com> wr=
ote:
>
> It was <2021-08-17 wto 16:07>, when Krzysztof Kozlowski wrote:
> > On 17/08/2021 14:34, Lukasz Stelmach wrote:
> >> It was <2021-08-17 wto 12:05>, when Krzysztof Kozlowski wrote:
> >>> On 17/08/2021 11:55, Lukasz Stelmach wrote:
> >>>> It was <2021-08-11 =C5=9Bro 10:43>, when Krzysztof Kozlowski wrote:
> >>>>> Convert Samsung Exynos SoC True Random Number Generator bindings to=
 DT
> >>>>> schema format using json-schema.
> >>>>>
> >>>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.c=
om>
> >>>>> ---
> >>>>>  .../bindings/rng/samsung,exynos5250-trng.txt  | 17 -------
> >>>>>  .../bindings/rng/samsung,exynos5250-trng.yaml | 44 +++++++++++++++=
++++
> >>>>>  MAINTAINERS                                   |  2 +-
> >>>>>  3 files changed, 45 insertions(+), 18 deletions(-)
> >>>>>  delete mode 100644 Documentation/devicetree/bindings/rng/samsung,e=
xynos5250-trng.txt
> >>>>>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,e=
xynos5250-trng.yaml
> >>>>>
> >>>>> diff --git
> >>>>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
> >>>>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
> >>>>> deleted file mode 100644
> >>>>> index 5a613a4ec780..000000000000
> >>>>> --- a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng=
.txt
> >>>>> +++ /dev/null
> >>>>> @@ -1,17 +0,0 @@
> >>>>> -Exynos True Random Number Generator
> >>>>> -
> >>>>> -Required properties:
> >>>>> -
> >>>>> -- compatible  : Should be "samsung,exynos5250-trng".
> >>>>> -- reg         : Specifies base physical address and size of the re=
gisters map.
> >>>>> -- clocks      : Phandle to clock-controller plus clock-specifier p=
air.
> >>>>> -- clock-names : "secss" as a clock name.
> >>>>> -
> >>>>> -Example:
> >>>>> -
> >>>>> - rng@10830600 {
> >>>>> -         compatible =3D "samsung,exynos5250-trng";
> >>>>> -         reg =3D <0x10830600 0x100>;
> >>>>> -         clocks =3D <&clock CLK_SSS>;
> >>>>> -         clock-names =3D "secss";
> >>>>> - };
> >>>>> diff --git
> >>>>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yam=
l
> >>>>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yam=
l
> >>>>> new file mode 100644
> >>>>> index 000000000000..a50c34d5d199
> >>>>> --- /dev/null
> >>>>> +++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng=
.yaml
> >>>>> @@ -0,0 +1,44 @@
> >>>>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> >>>>> +%YAML 1.2
> >>>>> +---
> >>>>> +$id:
> >>>>> https://protect2.fireeye.com/v1/url?k=3Df38ca35b-ac179a0d-f38d2814-=
0cc47a31ce52-1faa1ecb65482b8a&q=3D1&e=3D8b3490f9-a5fc-4da0-b2ee-7b0aec78140=
3&u=3Dhttp%3A%2F%2Fdevicetree.org%2Fschemas%2Frng%2Fsamsung%2Cexynos5250-tr=
ng.yaml%23
> >>>>> +$schema:
> >>>>> https://protect2.fireeye.com/v1/url?k=3D9409519d-cb9268cb-9408dad2-=
0cc47a31ce52-12394c4409905980&q=3D1&e=3D8b3490f9-a5fc-4da0-b2ee-7b0aec78140=
3&u=3Dhttp%3A%2F%2Fdevicetree.org%2Fmeta-schemas%2Fcore.yaml%23
> >>>>> +
> >>>>> +title: Samsung Exynos SoC True Random Number Generator
> >>>>> +
> >>>>> +maintainers:
> >>>>> +  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> >>>>> +  - =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> >>>>> +
> >>>>> +properties:
> >>>>> +  compatible:
> >>>>> +    const: samsung,exynos5250-trng
> >>>>> +
> >>>>> +  clocks:
> >>>>> +    maxItems: 1
> >>>>
> >>>> How about copying description from above into the description: prope=
rty?
> >>>
> >>> But what to copy? There is no description except generic clock bindin=
gs.
> >>>
> >>
> >> The description that "was" in the txt file.
> >
> > But there was no description of fields except copy&paste of the core
> > schema. Do you describe C code like:
> >
> > ...
> > /* unsigned int is a integer number greater or equal 0 */
> > unsigned int i;
> > ...
>
> I believe having descriptions for reg and clocks
>
> >>>>> -- reg         : Specifies base physical address and size of the re=
gisters map.
> >>>>> -- clocks      : Phandle to clock-controller plus clock-specifier p=
air.
>
> right next to properties' formal definitions is beneficial for anyone
> browsing the YAML file. If you think otherwise, oh well, I am fine with
> that.

We have 2000 schemas currently (and 2300 still to convert). Of the
~2000, 1646 have 'reg' and 1005 have 'clocks' (I was going to guess
3/4 and 1/2, respectively, but with a nice uniform, parsable format we
don't have to guess). Do we need that many copies of variations of the
same description?

What I would like to have is generated documentation from the schemas.
With that we could either insert a description or a link on all the
common properties. There are already tools that generate documentation
out of json-schema, but I don't have the time to investigate them or
work on any of that.

My other idea is some sort of property grepping utility. While grep
generally works, it would be nice to have some tools aware of the
schema structure where you could just run 'dt-grep clocks' and have it
spit out the description. Another example would be to list all the
valid properties for a given compatible string. Lots of possibilities
with machine readable bindings.

Rob
