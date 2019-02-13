Return-Path: <SRS0=2+RY=QU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0118CC282D7
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 21:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5190222B6
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 21:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cHVy7k1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbfBMVPP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Feb 2019 16:15:15 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:55732 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbfBMVPO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Feb 2019 16:15:14 -0500
Received: by mail-it1-f195.google.com with SMTP id j7so199823itl.5
        for <linux-crypto@vger.kernel.org>; Wed, 13 Feb 2019 13:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4145ZbldwvORm43NKeV7SwlE7vBlTKrU2VHjfmWGzuM=;
        b=cHVy7k1MWdJzdFztSPwphf1DGuvHVnsCciLPIL6fI4AK/utLesyIYwlgHLuS9S6Cgh
         4qEBNLd9NxJgqsAx8Q87Exs+xxwkygkEqe657jiuCeWtY0mbGcqK/yPivIh7Mwc4jTMj
         q5cWOVU/rG1WRKbhrd2lpPPPoqber4RsIti85B6j0aqBsriixmRzp0mGpg+EdcG8bBeu
         aOHt1TpdH9FsAzaR2yHlC5Og/mOWPDT/IhOcCs8fFENGtTpuMOROjz2Y7NR+/7krrLkc
         QGPSsfYgCQ3KO65nQHX9GHzCV94RROyOQX/17ewKf14s1nULpRk4k13D6k55eDTMhEVf
         zVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4145ZbldwvORm43NKeV7SwlE7vBlTKrU2VHjfmWGzuM=;
        b=X+dP/EkmRxn0a9GIJNytTchsYbFWXEv08/K0WAOc4jZ8t+LS3+EGoybnbSUMGEtjuk
         Dm92MK17rFHXVrgWJNWzhiAPt6FMaYBGsJ1oUHs4vWOTGE1usaS31YmA4PuL7KbBfXKc
         rME/TdJpO+8b4hFyF3EV7FSmk7FlYQ/h0n53kiB73pI9nJikzMBQCO8jnwjGFJqIqh2S
         DBA6NvmgjxuIlEjdBSbfH2fzMZiCwkVU6uE9VY51DIPFBnCOCEzU++nr+oTPZSm58kHG
         +ZLlavMwmUsCAPL5V/wca47tQhQrigSp5qD7iL5FN14WghjonZV1IB2Uqp9zHsAS7rU5
         Aw5g==
X-Gm-Message-State: AHQUAuZA/WCIM4MId2p1yhYTyL4FDDyEOgUSr4Tk0BC6ApEkRezVBpQF
        12HMRKQtqgyuFnqLV8tYZ2xVRmC2Dza5xCliaLgDAXPM
X-Google-Smtp-Source: AHgI3IYKh690jOsipFHujk48VDe4KeDGDUUEqSyJXvf+O2NlCAdcBkTGX0b1Bns7uH4hQQOK4r72QwXxTvNiLTBsccg=
X-Received: by 2002:a24:c3c4:: with SMTP id s187mr137246itg.158.1550092513533;
 Wed, 13 Feb 2019 13:15:13 -0800 (PST)
MIME-Version: 1.0
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208071635.5dkhabduambzzsu3@gondor.apana.org.au> <VI1PR0402MB3485ABA90793B50E7744A0A198690@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu9F3Uof+RfWsaB8qk_WuWxnopd_nA1kEXhbYP5ZCejvWQ@mail.gmail.com>
 <CAKv+Gu-bA-bZLGe+SFzkBXOL1xNa9SBFLGQBKrPAmM+aHuw8LA@mail.gmail.com> <HE1PR0402MB3484D933C4012C349E24C9D998660@HE1PR0402MB3484.eurprd04.prod.outlook.com>
In-Reply-To: <HE1PR0402MB3484D933C4012C349E24C9D998660@HE1PR0402MB3484.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 13 Feb 2019 22:15:02 +0100
Message-ID: <CAKv+Gu_zBQv_JfaV2=N8FpkZfchDk+6dJQUHwPk8Am__T6Pg4A@mail.gmail.com>
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

On Wed, 13 Feb 2019 at 21:48, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 2/12/2019 11:13 AM, Ard Biesheuvel wrote:
> > On Fri, 8 Feb 2019 at 09:55, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >>
> >> On Fri, 8 Feb 2019 at 09:41, Horia Geanta <horia.geanta@nxp.com> wrote:
> >>>
> >>> On 2/8/2019 9:16 AM, Herbert Xu wrote:
> >>>> On Mon, Feb 04, 2019 at 12:26:26PM +0000, Horia Geanta wrote:
> >>>>>
> >>>>> The root cause of the issue is cache line sharing.
> >>>>>
> >>>>> struct crypto_gcm_req_priv_ctx {
> >>>>>         u8 iv[16];
> >>>>>         u8 auth_tag[16];
> >>>>>      [...]
> >>>>> };
> >>>>>
> >>>>> Since caam does not support ghash on i.MX6, only ctr skcipher part of the gcm is
> >>>>> offloaded.
> >>>>> The skcipher request received by caam has req->src pointing to auth_tag[16] (1st
> >>>>> S/G entry) and req->iv pointing to iv[16].
> >>>>> caam driver:
> >>>>> 1-DMA maps req->src
> >>>>> 2-copies original req->iv to internal buffer
> >>>>> 3-updates req->iv (scatterwalk_map_and_copy from last block in req->src)
> >>
> >> This violates the DMA api, since you are touching memory that is owned
> >> by the device at this point (even though the addresses do not actually
> >> overlap). Note that on architectures that support non-cache coherent
> >> DMA, the kmalloc alignment is at least the cacheline size, for this
> >> exact reason.
> >>
> >
> > Actually, the driver does violate the DMA api in another way:
> > scatterwalk_map_and_copy() is accessing req->src after DMA mapping it.
> > Does the issue still exist if scatterwalk_map_and_copy() is done
> > before the DMA map?
> >
> > (On a non-cache coherent system, the DMA map will typically perform a
> > clean+invalidate, which means that the invalidate that occurs at unmap
> > time cannot corrupt adjacent data, but this only works if the CPU does
> > not write to the same cacheline while it is mapped for the device)
> >
> scatterwalk_map_and_copy() is reading from req->src.
> Are you saying it's forbidden for CPU to read from an area after it's DMA mapped?
>

OK, I read that the wrong way around. The DMA api does permit reading
from a region after it has been mapped for DMA.
