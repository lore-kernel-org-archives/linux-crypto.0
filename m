Return-Path: <SRS0=/8o3=XH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE98C4CEC6
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 20:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9192081B
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Sep 2019 20:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfILUhc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Sep 2019 16:37:32 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36380 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbfILUhc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Sep 2019 16:37:32 -0400
Received: by mail-ed1-f68.google.com with SMTP id f2so18785653edw.3;
        Thu, 12 Sep 2019 13:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pbP4i7DzdLdyPu+ieiqhNKpjgH4J8e/evjCuf6/AIwk=;
        b=mo/2XukZxATvTrfvCSUwzZeVQ8hxBESzGn8ekcLi0NaAw9GCryX3wt270WEWRWNhPx
         bpy30uYM2yOrfK176RbbMVKTwTWRemgN9kl24ttvObCVgt2XYjnUs74wsAr/6mUxstTP
         rr7LCm7LDp6fwmmFc7jGsoK2m8gxge4/eZDwGS00KW56R4tAVAeZHrt4u8t6eRDQIQ+w
         okHDbwZyOONEFOpzwsk97ZgQXUNtlRXXsKY8R4mu4lCsoQYkcwVB5vib9+akNNV/Pdxb
         ybwWL81E88U8MmUCC9fDeTT5r16EJf9mOfoYyj7TQRJ7GPpEgKbiW2y5TrMqSQxrr2ai
         5tgw==
X-Gm-Message-State: APjAAAUjz7MbkD+1i+TjZsAnLmcLYS0FyTxodUwESgceTxoCDbyy1hFA
        nTxngz3TzR8It0+T4p81yuzHgomZM5Q=
X-Google-Smtp-Source: APXvYqzb3g+N0wE6Q3z5iPkdPtUq5pAoaIrjZ1ltbL2kXLRNHt2KdJy7pNq/nbc2ArwI1SUfCywKRQ==
X-Received: by 2002:a17:906:80cd:: with SMTP id a13mr36904639ejx.155.1568320650545;
        Thu, 12 Sep 2019 13:37:30 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id r23sm4975774edx.1.2019.09.12.13.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2019 13:37:30 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id a11so20081428wrx.1;
        Thu, 12 Sep 2019 13:37:30 -0700 (PDT)
X-Received: by 2002:adf:c613:: with SMTP id n19mr37053716wrg.109.1568320649865;
 Thu, 12 Sep 2019 13:37:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-4-clabbe.montjoie@gmail.com> <20190907040116.lib532o2eqt4qnvv@flea>
 <20190911183158.GA8264@Red> <20190912093737.s6iu63sdncij2qib@localhost.localdomain>
 <CAGb2v678WGQm5PNy8GhOTpz+fYeLP3k0dnR0F00yyZpSRcA4yA@mail.gmail.com> <20190912203301.is4ubixhk64dl5t7@localhost.localdomain>
In-Reply-To: <20190912203301.is4ubixhk64dl5t7@localhost.localdomain>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Thu, 12 Sep 2019 21:37:17 +0100
X-Gmail-Original-Message-ID: <CAGb2v646YkM93BAo=hrpL+tgDU-JJ49-uMCMGECUbouoJrpg=w@mail.gmail.com>
Message-ID: <CAGb2v646YkM93BAo=hrpL+tgDU-JJ49-uMCMGECUbouoJrpg=w@mail.gmail.com>
Subject: Re: [PATCH 3/9] dt-bindings: crypto: Add DT bindings documentation
 for sun8i-ce Crypto Engine
To:     Maxime Ripard <mripard@kernel.org>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <linux@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 12, 2019 at 9:33 PM Maxime Ripard <mripard@kernel.org> wrote:
>
> On Thu, Sep 12, 2019 at 09:26:27PM +0100, Chen-Yu Tsai wrote:
> > > >
> > > >   clock-names:
> > > >     items:
> > > >       - const: ahb
> > > >       - const: mod
> > > >       - const: mbus
> > >
> > > And here as well
> > >
> > > Something I missed earlier though was that we've tried to unify as
> > > much as possible the ahb / apb / axi clocks around the bus name, it
> > > would be great if you could do it.
> >
> > I think we also want to standardize "mbus" as "dram"?
>
> Do we? The only user so far seems to be sun9i-de, while mbus has more
> users. I don't really care though, both mbus and dram are pretty
> generic to me. What makes you prefer dram over mbus?

Argh... it's actually "ram" we use the most. Both "dram" and "mbus"
have only one instance each.

ChenYu
