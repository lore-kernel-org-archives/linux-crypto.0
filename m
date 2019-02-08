Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CF1C282CC
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 08:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F46A21924
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 08:55:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UoHkGnRR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfBHIzd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:55:33 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:53632 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfBHIzd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 03:55:33 -0500
Received: by mail-it1-f193.google.com with SMTP id g85so7074022ita.3
        for <linux-crypto@vger.kernel.org>; Fri, 08 Feb 2019 00:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VsHQykba9A0KdOQmFdpbSVkZMj0eEwSyWIX3mgzEbzA=;
        b=UoHkGnRRqWM5mhE3Ibj4lzPzArk2tmpM1ZnrNzB8F0x2Ap98K0I0iKiSOorUBnI4DM
         vnnv5FhXg/RBmqMpOHN2aUOfB+iuQWe2nWNMu/84Ql282bR8ZBw5fSLQGRWAM5WNNQVf
         pIGKIuao5YL9nljFzw16+f7i6kcofgvARPmIaGCCAGgF5VSRbk9jfZkaudYH43aijGrF
         HXIlOLEyfYXmkGjm34iXTrXi0Vrr0MzZ2Tco/wLnBENOu6z8qcUE7MDV6wI7sPR3ViNh
         7uF+VyrzTSL1sOujJ6nDOb2ZWz45Q9oyLAsRocQwPz/ZlWh8RE/CJ1HR4YN45U2zWOVB
         rmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VsHQykba9A0KdOQmFdpbSVkZMj0eEwSyWIX3mgzEbzA=;
        b=otrjM2L/xo4zl2Btn7YHJqSllZtmr0iVyo1gM+tDNP8GCXIRABo/V5y1FS1HgtifLH
         MxfkVs4dFw0Jey8f7a6z+V8LbsUUKWeKh9SnDszYpwrYiHzEyqzRpSZVphH3cBbYYtDk
         a0Z5ZtezwPqD9LkUSwhD8GJQ7jc3g/A5ljYzOQDucEi44CkRpLqVfe0gkIf5dFYST3pL
         iHCd7oTTZwFzRYBD/WPHfUXPop81pl3AUeh4CCHV3C2nkjcSO1pCbH33E4fdikRdIRq7
         0SYhAmv2Ii0VMeOxdwH/Ne2gjVu7LNicbFUXSldfJQivwVE8jG7Dj3zt+IruzTdsNrs/
         ecYw==
X-Gm-Message-State: AHQUAuYm6DQTLdAGtyXscm7FNPzez1exv1OWtQmFPlnG5iOAH3yC0tVK
        mGgiK7lrovxu9HZKdxtZJnfV7BZWz4CduqvhDcKhXQ==
X-Google-Smtp-Source: AHgI3IYdX+pMWCh8QwDX4UqwUoux+11S/GfD104U3HLIAvGHPG+oEd2j3tZEe1zUaYJ8Nzmsf1GPn4eKLo51VCYfJ9U=
X-Received: by 2002:a5e:9704:: with SMTP id w4mr4333522ioj.60.1549616131887;
 Fri, 08 Feb 2019 00:55:31 -0800 (PST)
MIME-Version: 1.0
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208071635.5dkhabduambzzsu3@gondor.apana.org.au> <VI1PR0402MB3485ABA90793B50E7744A0A198690@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485ABA90793B50E7744A0A198690@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 8 Feb 2019 09:55:19 +0100
Message-ID: <CAKv+Gu9F3Uof+RfWsaB8qk_WuWxnopd_nA1kEXhbYP5ZCejvWQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Feb 2019 at 09:41, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 2/8/2019 9:16 AM, Herbert Xu wrote:
> > On Mon, Feb 04, 2019 at 12:26:26PM +0000, Horia Geanta wrote:
> >>
> >> The root cause of the issue is cache line sharing.
> >>
> >> struct crypto_gcm_req_priv_ctx {
> >>         u8 iv[16];
> >>         u8 auth_tag[16];
> >>      [...]
> >> };
> >>
> >> Since caam does not support ghash on i.MX6, only ctr skcipher part of the gcm is
> >> offloaded.
> >> The skcipher request received by caam has req->src pointing to auth_tag[16] (1st
> >> S/G entry) and req->iv pointing to iv[16].
> >> caam driver:
> >> 1-DMA maps req->src
> >> 2-copies original req->iv to internal buffer
> >> 3-updates req->iv (scatterwalk_map_and_copy from last block in req->src)

This violates the DMA api, since you are touching memory that is owned
by the device at this point (even though the addresses do not actually
overlap). Note that on architectures that support non-cache coherent
DMA, the kmalloc alignment is at least the cacheline size, for this
exact reason.

However, it should not be the driver's job to figure out whether
kernel pointers may alias cachelines that are covered by a
scatterlist.

So I would argue that the generic GCM driver should ensure that
whatever it passes into scatterlists is safe for non-cache coherent
DMA. Blowing up the struct like this is probably not the right answer,
instead, we should probably have an auth_tag pointer and a separate
kmalloc buffer so we don't affect cache coherent architectures too
much.


> >> 4-sends job to crypto engine
> >>
> >> Problem is that operation 3 above is writing iv[16], which is on the same cache
> >> line as auth_tag[16] that was previously DMA mapped.
> >>
> >> I've checked that forcing auth_tag and iv to be on separate cache lines
> >> -       u8 auth_tag[16];
> >> +       u8 auth_tag[16] ____cacheline_aligned;
> >> solves the issue.
> >>
> >> OTOH, maybe the fix should be done in caam driver, by avoiding any writes
> >> (touching any data, even seemingly unrelated req->iv) after DMA mapping
> >> req->src, req->dst etc.
> >> Having req->iv and req->src sharing the same cache line is unfortunate.
> >>
> >> Herbert, what do you think?
> >
> > Well just like the other cases if your input is a kernel pointer you
> > must not perform DMA on it.  Only SG lists can be used for DMA.
> >
> As I said at point 2 above, req->iv is copied to an internal buffer, which is
> allocated using kmalloc.
>
> > So the IV needs to be copied on completion.
> >
> Is it mandatory to be copied *on completion*?
> In some cases implementations could update req->iv before completion - for e.g.
> in case of cbc decryption the last block from req->src is copied into req->iv
> before the engine performs decryption (to avoid in-place decryption, where the
> last block would be overwritten).
>
> I'll try to explain issue at hand in more detail.
>
> ------------------
> |       IV       |
> ------------------
> |  input buffer  |
> ------------------
>
> Consider that the skcipher implementation receives, via crypto API, a request
> with req->IV pointing to "IV" and, for simplicity, a 1-entry req->src
> scatterlist pointing at "input buffer".
>
> In caam's particular case (and for decryption):
> a-req->src is DMA mapped
> b-req->iv is overwritten with last block of req->src
> c-crypto engine executes decryption (using the original value of req->iv)
>
> If IV and input buffer are on the same cache line, there is a problem when the
> device is non-coherent (i.MX case) since CPU is touching part of the cache line
> (writing the IV) after DMA API mapping was called for the same cacheline
> (req->src -> input buffer).
>
> I don't think we could ask an implementation to be aware of the memory layout of
> req->iv and req->src (and req->dst etc.) buffers.
>
> If I am not mistaken, req->src for skcipher request in crypto/gcm.c is breaking
> one of the DMA API rules - Documentation/DMA-API.txt:
>
> .. warning::
>
>         Memory coherency operates at a granularity called the cache
>         line width.  In order for memory mapped by this API to operate
>         correctly, the mapped region must begin exactly on a cache line
>         boundary and end exactly on one (to prevent two separately mapped
>         regions from sharing a single cache line).
>
> So if there is a real intention to support offloading skcipher, as this old
> commit suggests:
>
> 84c911523020 ("[CRYPTO] gcm: Add support for async ciphers")
>     This patch adds the necessary changes for GCM to be used with async
>     ciphers.  This would allow it to be used with hardware devices that
>     support CTR.
>
> then we must take special care when building skcipher req->src and avoid having
> it's first entry (auth_tag[16] in crypto_gcm_req_priv_ctx structure) sharing a
> cache line with req->iv.
>
