Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3666EC48BE6
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 08:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1439A61370
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 08:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhFNIOj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Jun 2021 04:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhFNIOj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Jun 2021 04:14:39 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312FDC061574
        for <linux-crypto@vger.kernel.org>; Mon, 14 Jun 2021 01:12:20 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id p184so14204206yba.11
        for <linux-crypto@vger.kernel.org>; Mon, 14 Jun 2021 01:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mWyjbWjzwsMzLa72tEccwSl/HTbQ8uYhU7FshMhUYXk=;
        b=wF/amHlTXPSifjsx29vDTMCcB25wEeN9P1V4iPallH3kXnTuyXKasGEW59PwI0a1Ii
         SzcUAujoKBfQL2n197j47NGgP654C53MPZrDWdDTJxAE6Kpj2DolR9OyYF4Yb7xhTna9
         DLEZgUGmzMqXlVpxTmHhD8UIH6NsOKvRm4Tj699FHuh00jTi2cu+HFfSy5JBEleeIHTh
         LqiQvBHJrDCy6kw/6Qn6miztadNXGqI8CS8ajln803juRxBsNduitZZZ5slB6U03S31G
         KFSbsXLvl4AkSxQ3ewYPqbCLZNJNSTKnAshl77HzDQCfeC1komrWfr/KF+piYqAuEeug
         92Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mWyjbWjzwsMzLa72tEccwSl/HTbQ8uYhU7FshMhUYXk=;
        b=IAif7o6mgflUyhyo6pdTIfE2fsBfLZyVRf8w+cBAlDnC6V0Z6lYhtWizNOT0lCU6hS
         YJW2wTtDUSq8P7uvgI91b9TtvLcKutkuQjrRBPWWbrrjuQyskrCcEG+cOou+MoUJ2PVH
         jageqDBy/GwyZuDmZD7SLuLYB1pKn3nAWiGKixhLHNS+EWXHIey2tUm8cljARVyYX3yv
         IJci9eld1a6iGE4C3u9iagcjnNwD9cMASlkLD45j5Fnx1/SUG62wc2eP1OlDe7zv0BoA
         LlGnGjghPjqfka9wVtf6ypCLluwEIRkEHbLRX2lzI+jZ0D92E0lQDIGSZBNObkeVT4fD
         eqqg==
X-Gm-Message-State: AOAM531fibdQxsvX9XNgK2OeYEc+RVQP/SkghTvGt3EmOyzIjkUMDb/+
        mINUvS1Zh4i4C/+keBch2XnfxjTg9BHmHJGzHK0K0w==
X-Google-Smtp-Source: ABdhPJwQ9d5siEs5Akj35O3tddxVGr5DulDlHhnxJY3FR00Ad4FvUDQ3hD3iPqJQY2/NYG+4RMc/IqBeeV2aG+e87i8=
X-Received: by 2002:a25:db86:: with SMTP id g128mr24390370ybf.193.1623658339326;
 Mon, 14 Jun 2021 01:12:19 -0700 (PDT)
MIME-Version: 1.0
References: <ab361a862755e281f5fef67b3f678d66ae201781.1623413974.git.geert+renesas@glider.be>
In-Reply-To: <ab361a862755e281f5fef67b3f678d66ae201781.1623413974.git.geert+renesas@glider.be>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 14 Jun 2021 11:12:08 +0300
Message-ID: <CAOtvUMe0tnTq9uuhs1u3USxFJR=nkbdR+7D18MU0acurRwzLFw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: crypto: ccree: Convert to json-schema
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Ofir Drang <Ofir.Drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Geert,

Thank you for taking the initiative to do this.

On Fri, Jun 11, 2021 at 3:20 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> Convert the Arm TrustZone CryptoCell cryptographic engine Device Tree
> binding documentation to json-schema.
>
> Document missing properties.
> Update the example to match reality.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../bindings/crypto/arm,cryptocell.yaml       | 53 +++++++++++++++++++
>  .../bindings/crypto/arm-cryptocell.txt        | 25 ---------
>  2 files changed, 53 insertions(+), 25 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/arm,cryptoce=
ll.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/arm-cryptoce=
ll.txt
>
> diff --git a/Documentation/devicetree/bindings/crypto/arm,cryptocell.yaml=
 b/Documentation/devicetree/bindings/crypto/arm,cryptocell.yaml
> new file mode 100644
> index 0000000000000000..9c97874a6dbd1db9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/arm,cryptocell.yaml
> @@ -0,0 +1,53 @@

I am fine with the change as a whole except this line:

> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)

Please keep it as as the rest of the ccree driver:
# SPDX-License-Identifier: GPL-2.0

This is not because I care about the difference so much but because
otherwise I need to authorize the change with my employer legal
department.

Thanks,
Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
