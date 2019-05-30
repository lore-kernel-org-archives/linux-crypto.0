Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B17C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C779623B6B
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I4Grv9cb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfE3N0C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 09:26:02 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52941 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfE3N0B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 09:26:01 -0400
Received: by mail-it1-f194.google.com with SMTP id t184so9805451itf.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2019 06:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JxUw3iZ22R1E0zM0inHUfe/TavC7FtPb0IV4nJUDm3w=;
        b=I4Grv9cbNSQm3SKHatv7Nil6O+qdXxO0elQHoJgAkv4qevfCIWxHTMYivt2t9Qc6Tf
         REaTAZs7zv7ZZGZfWW4AdB0sV0GBFnZ8bnbk5NTAx8U5ZXQZpVoEU+/DhiNpuizdpteE
         qkYk4I9Xyjs7p6Cn6yicgH0zeMz2VUkWNTymxz6jdQa2Bmfjt8lAlc/CJ+0ou2s5pVLo
         RFycuuwngt7jZxb+HJlzuDdSZozXUbf0sGMa+bdU+wVdI99eoLzdix3rX6WQxMel3gtL
         CMfqKFcLBZ4vxdvFaPMowyGdiEcSZtxW/28c8JwGQ4IzrSMqIrBuJFadEGQwtRddmmPR
         cAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JxUw3iZ22R1E0zM0inHUfe/TavC7FtPb0IV4nJUDm3w=;
        b=i69ne0Y8sX+K4dVXKXyj1Z1da4tcd1sk8qYIJOUPHgy4fI5LWog+1xnPr09oMEL60A
         xUBjWZgbK5fb+bHbVwTc9TcfvZ+3pSPbu6yJSRSkf6VnvXpu0593OCtZFYJH8mvqfmZy
         sebQjjOcb1Gxp70T4ez5L4j7VpIhhneYUbsa6jMXMHU31cOCYMeu7poIyYTtDgptczXh
         ZETmJYVSwWqBVT3QLgNAJ2H8e6jRecBOA9EQMSFLL69f9QtNnON7kWZf73sUxDQJxJTQ
         kOXv+SzlfEP+PXzOzZgszjOs/eC9+Uh4hDg/m12PALGE0Ax0eGOOh+MY7hvcVIFoKINY
         /GOA==
X-Gm-Message-State: APjAAAWZDSlfcP8i69HhIfZvU5T3Nwt9+HPnIAH8Zd+4NFSto9b45hrH
        WFJCbV5ZPOX+5UeGI8O1CotTRLy3yyePld6oBu3S7MgmvQY=
X-Google-Smtp-Source: APXvYqyJiPA1Tsq2Mp/EEa1o2F2vB51GGKy8wNZi0k54umWRZaQ/hGK8HX9uPE/fKpSKMFwD9UDsuFVbKYGxl+IcYwg=
X-Received: by 2002:a24:ca84:: with SMTP id k126mr2680434itg.104.1559222760647;
 Thu, 30 May 2019 06:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com> <20190530053421.keesqb54yu5w7hgk@gondor.apana.org.au>
 <VI1PR0402MB3485ADA3C4410D61191582A498180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu84HndAnkn7DU=ykjCokw_+bAHEcF0Rm12-hnXhVy2u_Q@mail.gmail.com> <VI1PR0402MB34859577A96645E890BD8F3198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34859577A96645E890BD8F3198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 30 May 2019 15:25:47 +0200
Message-ID: <CAKv+Gu_ucBhuK0YgGZ+Qhv4zqvU868GVRpWY7KVaTsj0O8k3OQ@mail.gmail.com>
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

On Thu, 30 May 2019 at 15:18, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 5/30/2019 11:08 AM, Ard Biesheuvel wrote:
> > On Thu, 30 May 2019 at 09:46, Horia Geanta <horia.geanta@nxp.com> wrote:
> >>
> >> On 5/30/2019 8:34 AM, Herbert Xu wrote:
> >>> On Wed, May 29, 2019 at 01:27:28PM -0700, Eric Biggers wrote:
> >>>>
> >>>> So what about the other places that also pass an IV located next to the data,
> >>>> like crypto/ccm.c and crypto/adiantum.c?  If we're actually going to make this a
> >> Fix for ccm is WIP.
> >> We were not aware of adiantum since our crypto engine does not accelerate it.
> >>
> >>>> new API requirement, then we need to add a debugging option that makes the API
> >>>> detect this violation so that the other places can be fixed too.
> >>>>
> >> IMO this is not a new crypto API requirement.
> >> crypto API and its users must follow DMA API rules, besides crypto-specific ones.
> >>
> >> In this particular case, crypto/gcm.c is both an implementation and a crypto API
> >> user, since it uses underneath ctr(aes) (and ghash).
> >> Currently generic gcm implementation is breaking DMA API, since part of the dst
> >> buffer (auth_tag) provided to ctr(aes) is sharing a cache line with some other
> >> data structure (iv).
> >>
> >> The DMA API rule is mentioned in Documentation/DMA-API.txt
> >>
> >> .. warning::
> >>
> >>         Memory coherency operates at a granularity called the cache
> >>         line width.  In order for memory mapped by this API to operate
> >>         correctly, the mapped region must begin exactly on a cache line
> >>         boundary and end exactly on one (to prevent two separately mapped
> >>         regions from sharing a single cache line).
> >>
> >>
> >
> > This is overly restrictive, and not in line with reality. The whole
> > networking stack operates on buffers shifted by 2 bytes if
> > NET_IP_ALIGN is left at its default value of 2. There are numerous
> > examples in other places as well.
> >
> > Given that kmalloc() will take the cacheline granularity into account
> > if necessary, the only way this issue can hit is when a single kmalloc
> > buffer is written to by two different masters.
> >
> I guess there are only two options:
> -either cache line sharing is avoided OR
> -users need to be *aware* they are sharing the cache line and some rules /
> assumptions are in place on how to safely work on the data
>
> What you are probably saying is that 2nd option is sometimes the way to go.
>
> >>>> Also, did you consider whether there's any way to make the crypto API handle
> >>>> this automatically, so that all the individual users don't have to?
> >> That would probably work, but I guess it would come up with a big overhead.
> >>
> >> I am thinking crypto API would have to check each buffer used by src, dst
> >> scatterlists is correctly aligned - starting and ending on cache line boundaries.
> >>
> >>>
> >>> You're absolutely right Eric.
> >>>
> >>> What I suggested in the old thread is non-sense.  While you can
> >>> force GCM to provide the right pointers you cannot force all the
> >>> other crypto API users to do this.
> >>>
> >> Whose problem is that crypto API users don't follow the DMA API requirements?
> >>
> >>> It would appear that Ard's latest suggestion should fix the problem
> >>> and is the correct approach.
> >>>
> >> I disagree.
> >> We shouldn't force crypto implementations to be aware of such inconsistencies in
> >> the I/O data buffers (pointed to by src/dst scatterlists) that are supposed to
> >> be safely DMA mapped.
> >>
> >
> > I'm on the fence here. On the one hand, it is slightly dodgy for the
> > GCM driver to pass a scatterlist referencing a buffer that shares a
> > cacheline with another buffer passed by an ordinary pointer, and for
> > which an explicit requirement exists that the callee should update it
> > before returning.
> >
> > On the other hand, I think it is reasonable to require drivers not to
> > perform such updates while the scatterlist is mapped for DMA, since
> > fixing it in the callers puts a disproportionate burden on them, given
> > that non-coherent DMA only represents a small minority of use cases.
> >
> The problem with this approach is that the buffers in the scatterlist could
> hypothetically share cache lines with *any* other CPU-updated data, not just the
> IV in the crypto request (as it happens here).
> How could a non-coherent DMA implementation cope with this?
>

I don't think the situation is that bad. We only support allocations
in the linear map for DMA/scatterlists, and buffers in the linear map
can only share a cacheline if they were allocated using the same
kmalloc() invocation (on systems that support non-coherent DMA)

That does mean that it is actually more straightforward to deal with
this at the level where the allocation occurs, and that would justify
dealing with it in the callers.

However, from the callee's point of view, it simply means that you
should not dereference any request struct pointers for writing while
the 'dst' scatterlist is mapped for DMA.

As I said, I am on the fence. I think there are arguments for both sides ...
