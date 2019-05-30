Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA419C46460
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 08:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B06CE25706
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 08:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FJU2ZnF7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfE3IIh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 04:08:37 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:39221 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfE3IIh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 04:08:37 -0400
Received: by mail-it1-f196.google.com with SMTP id j204so2681885ite.4
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2019 01:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uhATQPJSNTCMowVFk8RS0eyAucGgi+lBjsF7DlqvU5Y=;
        b=FJU2ZnF7rvCzqS2ruJWUcu1tibbF9MfXHIVsy5ZkhxzKE2PduyDwe0nqDS886Ruo4Q
         0Xf348dXwhUflq4MaHxWgLJbNeov2ZUxnfBaB2N6IgR+kjGOUA5+T/8Ne3LvwtSK4xO9
         gcj+OQl5IYSKWxU/m0dzEsLX2I3HolzCkGoibrn0qRmBub9NR1nC0B3NiJ+eMTwjMm2c
         n8dhAWfVS9vKjnSbhKC+0U35ZpHpl+Js046GLpyRBQcxBOwQR15FgYgx6bxUbTCRNs7k
         YTVUgWunpGYv445IvEgxE0QFpXA9N2x92xuARuDMWjNxwhP2dQCw6Bz03FRUskJDSfSo
         ge6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uhATQPJSNTCMowVFk8RS0eyAucGgi+lBjsF7DlqvU5Y=;
        b=T1rrMILD+7hkhz8fEY5ZXUH9Isb6OvFV5xhkVt2Na69lbBOTqeFbTwNrFnOG9304Ec
         0t2iPVphlWzCypS8gBv6jfvhZsDR+docQ/606sLKhBTLdJHE8eRxwNTKrUoKiL2MtrvJ
         TkA4mH+c6HWo8VKlFQY44Pa5F46xHjbVa4gNWX2EO4lATw8GBAD4EwvmjoVG9ZGaB75E
         ION+om5K3nyK/g5k++r6zGRv2n4njrGCOrS10xgTpPe3WM6rqzbQYNK7WOc4npQLEmwn
         PLUPfKAuuBnJNvtAsx9X3rKRy6S+y4958TTNw3DYpDERPDqWSB/oCZaEgGVjHzAvfWHC
         JOZw==
X-Gm-Message-State: APjAAAUPYD/jOUPLa0pKHyShOdBhHxMKUDlZY2r7ZNYPGYZLAgDlRi3E
        MsMutTHGXJZ0Bn0P5Q9MXAusqWpvEgo5oJXCTpTsng==
X-Google-Smtp-Source: APXvYqy4+Xt68oesIIciXkhTP1lixxkoR9l+Brf6z52pkjk12vcRFS7olRf0M3doNsE9oTywISw01h9vnhNupOD11nQ=
X-Received: by 2002:a24:910b:: with SMTP id i11mr2065671ite.76.1559203715644;
 Thu, 30 May 2019 01:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com> <20190530053421.keesqb54yu5w7hgk@gondor.apana.org.au>
 <VI1PR0402MB3485ADA3C4410D61191582A498180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485ADA3C4410D61191582A498180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 30 May 2019 10:08:22 +0200
Message-ID: <CAKv+Gu84HndAnkn7DU=ykjCokw_+bAHEcF0Rm12-hnXhVy2u_Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 30 May 2019 at 09:46, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 5/30/2019 8:34 AM, Herbert Xu wrote:
> > On Wed, May 29, 2019 at 01:27:28PM -0700, Eric Biggers wrote:
> >>
> >> So what about the other places that also pass an IV located next to the data,
> >> like crypto/ccm.c and crypto/adiantum.c?  If we're actually going to make this a
> Fix for ccm is WIP.
> We were not aware of adiantum since our crypto engine does not accelerate it.
>
> >> new API requirement, then we need to add a debugging option that makes the API
> >> detect this violation so that the other places can be fixed too.
> >>
> IMO this is not a new crypto API requirement.
> crypto API and its users must follow DMA API rules, besides crypto-specific ones.
>
> In this particular case, crypto/gcm.c is both an implementation and a crypto API
> user, since it uses underneath ctr(aes) (and ghash).
> Currently generic gcm implementation is breaking DMA API, since part of the dst
> buffer (auth_tag) provided to ctr(aes) is sharing a cache line with some other
> data structure (iv).
>
> The DMA API rule is mentioned in Documentation/DMA-API.txt
>
> .. warning::
>
>         Memory coherency operates at a granularity called the cache
>         line width.  In order for memory mapped by this API to operate
>         correctly, the mapped region must begin exactly on a cache line
>         boundary and end exactly on one (to prevent two separately mapped
>         regions from sharing a single cache line).
>
>

This is overly restrictive, and not in line with reality. The whole
networking stack operates on buffers shifted by 2 bytes if
NET_IP_ALIGN is left at its default value of 2. There are numerous
examples in other places as well.

Given that kmalloc() will take the cacheline granularity into account
if necessary, the only way this issue can hit is when a single kmalloc
buffer is written to by two different masters.

> >> Also, doing a kmalloc() per requset is inefficient and very error-prone.  In
> >> fact there are at least 3 bugs here: (1) not checking the return value, (2)
> >> incorrectly using GFP_KERNEL when it may be atomic context, and (3) not always
> For (2) I assume this means checking for CRYPTO_TFM_REQ_MAY_SLEEP flag.
>
> >> freeing the memory.  Why not use cacheline-aligned memory within the request
> >> context, so that a separate kmalloc() isn't needed?
> >>
> If you check previous discussion referenced in the commit message:
> Link:
> https://lore.kernel.org/linux-crypto/20190208114459.5nixe76xmmkhur75@gondor.apana.org.au/
>
> or (probably easier) look at the full thread:
> https://patchwork.kernel.org/patch/10789697/
>
> you'll see that at some point I proposed changing crypto_gcm_req_priv_ctx struct
> as follows:
> -       u8 auth_tag[16];
> +       u8 auth_tag[16] ____cacheline_aligned;
>
> Ard suggested it would be better to kmalloc the auth_tag.
>
> I am open to changing the fix, however I don't think the problem is in the
> implementation (caam driver).
>

I remember that. But in the discussion that followed, I did ask about
accessing the memory while the buffer is mapped for DMA, and I
misunderstood the response. The scatterwalk_map_and_copy writes to the
request while it is mapped for DMA.

> >> Also, did you consider whether there's any way to make the crypto API handle
> >> this automatically, so that all the individual users don't have to?
> That would probably work, but I guess it would come up with a big overhead.
>
> I am thinking crypto API would have to check each buffer used by src, dst
> scatterlists is correctly aligned - starting and ending on cache line boundaries.
>
> >
> > You're absolutely right Eric.
> >
> > What I suggested in the old thread is non-sense.  While you can
> > force GCM to provide the right pointers you cannot force all the
> > other crypto API users to do this.
> >
> Whose problem is that crypto API users don't follow the DMA API requirements?
>
> > It would appear that Ard's latest suggestion should fix the problem
> > and is the correct approach.
> >
> I disagree.
> We shouldn't force crypto implementations to be aware of such inconsistencies in
> the I/O data buffers (pointed to by src/dst scatterlists) that are supposed to
> be safely DMA mapped.
>

I'm on the fence here. On the one hand, it is slightly dodgy for the
GCM driver to pass a scatterlist referencing a buffer that shares a
cacheline with another buffer passed by an ordinary pointer, and for
which an explicit requirement exists that the callee should update it
before returning.

On the other hand, I think it is reasonable to require drivers not to
perform such updates while the scatterlist is mapped for DMA, since
fixing it in the callers puts a disproportionate burden on them, given
that non-coherent DMA only represents a small minority of use cases.
