Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F0EC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 12:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC09B23B70
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 12:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgLJMUW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 07:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbgLJMUM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 07:20:12 -0500
X-Gm-Message-State: AOAM533y3unPK8KqCX0H71TuIRD2uuiVWTeefqfdXh//+MnaDRtylZNj
        iM5hOBbiZsLjSFMl0WlR9iziRPttC2UXTJRGGOg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607602770;
        bh=fo8ld373C6zHqSeWe67m7KvLDbRIm0wGsfnedisyKx4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=afqEMCDvkaZy1QMb5zxfFlK7I8EcdSUZ1F5XGfJ7CP1L3FRkUZbWQIA7ww8Q2idHE
         NZhHJgw2Sk28/YmlgfNV5v+C1cx3MgQvF1Z+V0hr7AKzUgDDtntC9qzTtidGMoths5
         jCVmb794jlCgpigQi77LNTAty6PmmdrmIZXcer2LP2FvNYe55f9LHThW3I7TltlnUC
         2gqfm8okzwIVa9jV9PVeSs//2lajb9NEMGiTQP57JH7kzLFxeOJW97wxokreJYwvi9
         OPaOCd1I+c/DfAjxgEDtOnTZ1iU5X027qe6OZM5kKweN8F0dySFgHXR+TRxydxt8pw
         mI9CzsMHJIFmw==
X-Google-Smtp-Source: ABdhPJylBtwpgVtdP3ZMJugMR3Ll7VH7xBOish8vbMRt7187HrpX2GcLujaEMBPwpkvUZHATFlr9WPHAtxjLxzpecro=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr5509447otu.77.1607602769297;
 Thu, 10 Dec 2020 04:19:29 -0800 (PST)
MIME-Version: 1.0
References: <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au> <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au> <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
 <20201210024342.GA26428@gondor.apana.org.au> <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
 <20201210111427.GA28014@gondor.apana.org.au> <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
 <20201210121627.GB28441@gondor.apana.org.au>
In-Reply-To: <20201210121627.GB28441@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 10 Dec 2020 13:19:18 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
Message-ID: <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 10 Dec 2020 at 13:16, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Dec 10, 2020 at 01:03:56PM +0100, Ard Biesheuvel wrote:
> >
> > But we should probably start policing this a bit more. For instance, we now have
> >
> > drivers/net/macsec.c:
> >
> > /* Pick a sync gcm(aes) cipher to ensure order is preserved. */
> > tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
> >
> > (btw the comment is bogus, right?)
> >
> > TLS_SW does the same thing in net/tls/tls_device_fallback.c.
>
> Short of us volunteering to write code for every user out there
> I don't see a way out.
>
> > Async is obviously needed for h/w accelerators, but could we perhaps
> > do better for s/w SIMD algorithms? Those are by far the most widely
> > used ones.
>
> If you can come up with a way that avoids the cryptd model without
> using a fallback obviously that would be the ultimate solution.
>

Could we disable softirq handling in these regions?
