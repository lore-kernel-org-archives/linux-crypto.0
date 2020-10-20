Return-Path: <SRS0=SXL7=D3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DBFC388F7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 14:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78EB3208C3
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 14:07:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nP+etFNq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407774AbgJTOHa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Oct 2020 10:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407765AbgJTOHa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Oct 2020 10:07:30 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F65EC061755;
        Tue, 20 Oct 2020 07:07:30 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id z2so2348389ilh.11;
        Tue, 20 Oct 2020 07:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1lBTu54CE46HbIpamog6b+bIOObBI3JzssghUHuWI3o=;
        b=nP+etFNqv0sHkZDmtCRhJ1xgocs2Q6P+ogmJvNJhHcdiITJjln9o6gzzxriLngcTXh
         R54cDMtdADlowipqvFCmfZRUVWIGeF02z8ewIbx0JgrpfiDX5Q8GsyaBA7O78Hv8pUgh
         vzwX61iBHQw90LWfBUJd7uKhY2PILiTI0/qz5YAGFjlAqrv5Ua+BzywyTWIcp76Qng1G
         R5P5gWu/G1mnf5FR7W/86gBMXQPuveVmRY+/ceRvxmxcVa1O3EHSdRzpClwPEMEJSnqQ
         +00rktb5vH+FwNvgj6TsjNYAhwNuj827mnJB7cjRd6CiTUDGhwhAd0LqZgFLGWU/pdZP
         S4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1lBTu54CE46HbIpamog6b+bIOObBI3JzssghUHuWI3o=;
        b=skngr64QqavHRJaFGSsNBHx9xNCBIwyvJ3XJhlsJbi/atqMjs5hFpenxhZZovnSKWz
         CS4XkBXD2jLF4U64VsgCubZ5M2UYjomZCl37VOR/6X0LZCXy+0yBvW0KV0wXa5r2Wibm
         ha3xGeXl56LyXf4n4PcsNjfuB7H8+bY6YaatRodnyt0xC2AReO+x2NQlwkgJwZSAa2ak
         Kst0mAvLSjJlipe4IcY7wR75aXliIQMw8qnWyF/ahSiUS5u1aG1BNd92ViJczrE/2jRo
         I21JqywmIXkJqI+y8IWtp9vp/58KZxp52DQiyiWEO5ysy3c+KavzvI8J9Z4zOPUl8yN8
         N1sQ==
X-Gm-Message-State: AOAM530Wvfw9M/Ep5TaxZbXmtLgzFRmfWQuAPWi5gDmxXY77faJe4u7f
        hGhEbkyUJ5XxLZTKKQV114I=
X-Google-Smtp-Source: ABdhPJwwUjL7yZ2R75M5d9LbePEMBc5lyYqPoG87sntcDFZDMD1wFGg2h6O3XdgXZuCZwotMsygBXA==
X-Received: by 2002:a05:6e02:970:: with SMTP id q16mr2132632ilt.69.1603202849775;
        Tue, 20 Oct 2020 07:07:29 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id f13sm2132026ilf.85.2020.10.20.07.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 07:07:28 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Tue, 20 Oct 2020 10:07:26 -0400
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Arvind Sankar' <nivedita@alum.mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] crypto: lib/sha256 - Unroll SHA256 loop 8 times
 intead of 64
Message-ID: <20201020140726.GB2996696@rani.riverdale.lan>
References: <20201019153016.2698303-1-nivedita@alum.mit.edu>
 <20201019153016.2698303-5-nivedita@alum.mit.edu>
 <1324eb3519d54ddd9469d30a94c11823@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1324eb3519d54ddd9469d30a94c11823@AcuMS.aculab.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 20, 2020 at 07:41:33AM +0000, David Laight wrote:
> From: Arvind Sankar> Sent: 19 October 2020 16:30
> > To: Herbert Xu <herbert@gondor.apana.org.au>; David S. Miller <davem@davemloft.net>; linux-
> > crypto@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Subject: [PATCH 4/5] crypto: lib/sha256 - Unroll SHA256 loop 8 times intead of 64
> > 
> > This reduces code size substantially (on x86_64 with gcc-10 the size of
> > sha256_update() goes from 7593 bytes to 1952 bytes including the new
> > SHA256_K array), and on x86 is slightly faster than the full unroll.
> 
> The speed will depend on exactly which cpu type is used.
> It is even possible that the 'not unrolled at all' loop
> (with the all the extra register moves) is faster on some x86-64 cpu.

Yes, I should have mentioned this was tested on a Broadwell Xeon, at
least on that processor, no unrolling is a measurable performance loss.
But the hope is that 8x unroll should be generally enough unrolling that
64x is unlikely to speed it up more, and so has no advantage over 8x.

> 
> > 
> > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> > ---
> >  lib/crypto/sha256.c | 164 ++++++++------------------------------------
> >  1 file changed, 28 insertions(+), 136 deletions(-)
> > 
> > diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> > index c6bfeacc5b81..9f0b71d41ea0 100644
> > --- a/lib/crypto/sha256.c
> > +++ b/lib/crypto/sha256.c
> > @@ -18,6 +18,17 @@
> >  #include <crypto/sha.h>
> >  #include <asm/unaligned.h>
> ...
> > 
> > +#define SHA256_ROUND(i, a, b, c, d, e, f, g, h) do {		\
> > +	u32 t1, t2;						\
> > +	t1 = h + e1(e) + Ch(e, f, g) + SHA256_K[i] + W[i];	\
> > +	t2 = e0(a) + Maj(a, b, c);    d += t1;    h = t1 + t2;	\
> 
> Split to 3 lines.

This was the way the code was before, but I can reformat it, sure.

> 
> If you can put SHA256_K[] and W[] into a struct then the
> compiler can use the same register to address into both
> arrays (using an offset of 64*4 for the second one).
> (ie keep the two arrays, not an array of struct).
> This should reduce the register pressure slightly.

I can try that, could copy the data in sha256_update() so it's amortized
over the whole input.

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
