Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07DEC43465
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B893214F1
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 07:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="uQbRytZo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIUHqn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgIUHqn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:46:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A331CC061755
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2020 00:46:43 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k133so3545037pgc.7
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2020 00:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KEQZ+0+MjbwK1ElZms1Qgb4W3im9WPY9mb97cPZoGK0=;
        b=uQbRytZokTI9uAROSbK3E3kPhHy0k8+bTpZNDdwFsDvSZV9ClRnTaGzPeJl+3iL46B
         B/W1PYvR4awrXTO9WDeUI88a4/UFNeFxMrmqMDYXOB+ZSF/dCv2jPWqMZnfgtYmwsgVA
         tiYAfKvnau0HbFLtG4zTFIPFGIDhMDYYxIVkDn9TFoYUJAlUrA+ThMqO47z/LPDN8XwY
         l/iueAjhsKKKTrKAnXkxA1Yd+11IsSnnNywcrSMMUQzhvsXpBteBJVvuSax7CrXyep0j
         enckp5UJM3mwjWfsZyMJo1NBUXfDvdBDoGt4/OwUT0OGM6UtAQcnMTDN5habb2LtNXdZ
         LbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KEQZ+0+MjbwK1ElZms1Qgb4W3im9WPY9mb97cPZoGK0=;
        b=ECCA2OmVGOkimH0hmDHW/lMCPe8e34XYkEcnYst6vuP0wspwbKavHRQ2xiKCw/P08x
         8z23oWpp4TBg7DIn7ZhT+lQZpMLaxtkR+5z4YqkJ1uyezKv+NWon3SUEXuCpa0RxoQx0
         wCp7eYHVt/vkleMkf8ojfIle587zu0K9fZyS/oGJVg8cfqtJH+hitdnWn0KcxBEKLN9m
         qmquDvNSYAN2KvVgkYiyOEuB2BYw4pWLa2J+bG+rjz4msMMQsVKM8BJngfMNCOcb8rby
         Ux62ucSINUOXb/tC364Rui9EymxDT7nOepGVYgzzkFTxrnR9znNWspy3skSMEeNi1EnX
         4rzA==
X-Gm-Message-State: AOAM532bGwjmruOCrtsmltS5JbKfkd3rB5CjQ/BKSY0ySxc1W3CnEyzn
        Z5a3Dgc6us+ETXqg1wnNVG+1Q8JvfMmvBRnvP+GNLA==
X-Google-Smtp-Source: ABdhPJyQpA8ZjwSRlnLg26q0TprnPeXcNQVwncIaeBqK+eZsI4FvBtCOdSwD5EFWTY+UqkN7XkuLHtDjs+xndIYZS4M=
X-Received: by 2002:a17:902:758b:b029:d2:29fc:c841 with SMTP id
 j11-20020a170902758bb02900d229fcc841mr2054484pll.39.1600674403207; Mon, 21
 Sep 2020 00:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200916071950.1493-3-gilad@benyossef.com> <202009162154.fxQ0Z6wT%lkp@intel.com>
 <CAOtvUMdv9QNVdaU7N6wJVq27Asyrckuu9bf15fO=+oZUh5iKOg@mail.gmail.com> <CAKwvOdmW+n_g4C_pXnF+8wh2q0gZZyXAfaYR9cVNm3p1QeJ-xA@mail.gmail.com>
In-Reply-To: <CAKwvOdmW+n_g4C_pXnF+8wh2q0gZZyXAfaYR9cVNm3p1QeJ-xA@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 21 Sep 2020 10:46:32 +0300
Message-ID: <CAOtvUMe1zj+sGhZfvjYD=PciWDby9uKvH70i01FrfVVR6cC_Tg@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: ccree - add custom cache params from DT file
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Network Development <netdev@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Fri, Sep 18, 2020 at 10:39 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Thu, Sep 17, 2020 at 12:20 AM Gilad Ben-Yossef <gilad@benyossef.com> w=
rote:
> >
...
> >
> > I am unable to understand this warning. It looks like it is
> > complaining about a FIELD_GET sanity check that is always false, which
> > makes sense since we're using a constant.
> >
> > Anyone can enlighten me if I've missed something?
>
> Looked at some of this code recently.  I think it may have an issue
> for masks where sizeof(mask) < sizeof(unsigned long long).
>
> In your code, via 0day bot:
>
>    107          u32 cache_params, ace_const, val, mask;
> ...
> > 120          cache_params |=3D FIELD_PREP(mask, val);
>
> then in include/linux/bitfield.h, we have:
>
>  92 #define FIELD_PREP(_mask, _val)           \
>  93   ({                \
>  94     __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");  \
>
>  44 #define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)     \
> ...
>  52     BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,   \
>  53          _pfx "type of reg too small for mask"); \
>
> so the 0ULL in FIELD_PREP is important.  In __BF_FIELD_CHECK, the
> typeof(_reg) is unsigned long long (because 0ULL was passed).  So we
> have a comparison between a u32 and a u64; indeed any u32 can never be
> greater than a u64 that we know has the value of ULLONG_MAX.
>
> I did send a series splitting these up, I wonder if they'd help here:
> https://lore.kernel.org/lkml/20200708230402.1644819-3-ndesaulniers@google=
.com/
> --

Thanks!

This indeed explains this. It seems there is nothing for me to do
about it in the driver code though, as it seems the issue is in the
macro and you have already posted a fix for it.

Thanks again,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
