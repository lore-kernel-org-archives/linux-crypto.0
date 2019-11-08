Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BCFFA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FF4F2178F
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 09:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x5VaPJJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbfKHJTk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 04:19:40 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40182 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbfKHJTk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 04:19:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id f3so5400532wmc.5
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 01:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ouMwsMlEiNGlppR6/Zfyl7B6UWYbphLKd4qLcZ70Vkw=;
        b=x5VaPJJcvhwM7VuUw6uKJ5URotRdoKLUMsdEsg3980lOpgGY9dxGsRFj5FeDpX4a2d
         qnx/M/hlHT0qJx1hdYluT7Qqsy9BdwT4ZSvclPqbhyZ6gMV/9satY36TGk3LI75280S6
         uFw8uZsPcJf+MD0Pgvl+z7zCWnzUbNzVu62GAk9xt4+Y+F/y1tqAKIx4SXTzjvTvpPjL
         Xp91jagr1zIjKpYFQtzbGfcVx3KhO0ilyyrhJ58ULrc1JxZaFeE1mirWChyxBg+Nji3K
         UW/Vwgpx7MgSTWaPviWh0F8CpArnh8Bpoua2gG7MAjY7xYPGMZg4XkgNtaZpraU0VPzt
         eoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ouMwsMlEiNGlppR6/Zfyl7B6UWYbphLKd4qLcZ70Vkw=;
        b=GzN80R3J71s+aISRZ8mTg+Sr+sd8SVc8KuhQ77co4IzlqOsb/o01xe+zGZSRGigHrj
         NFfb2G73EXj5VDv+/u7JCfLpuYKV5gZzyDKdWocUKEVDW6WWzXBhgTfYENaCIoKwZVrL
         5ZxifZGx7iPIKVsiEN4e5SX/Yiwjd1b4t7yGrs0thdRTCauP2gPRah8EIVDVdD1Tm/cJ
         XU55qDvl7mHhXPEB7d80zg7BbdSPmuU+STvX4glCj3at11taUbRgEgBHLNdsjaO0HKKP
         Ao+wC4zusTanirISHQu7H2b5ZBumt/hepCewoaCnfV5hBScdq07/xXmqG/OIYMGsaq7h
         yThA==
X-Gm-Message-State: APjAAAXFyE+c8wuzsaA6HF/0Sfy+wyTCMdot07LccbJhdtv0TDY2BtsG
        AHe3yRXcD3C/5wK7r3dSDYGeaD757ZAnzJOSnj8BlQ==
X-Google-Smtp-Source: APXvYqxQL3I6TTB0YYnv925sfBS8BjCsHEa7RJl86LyoGaWLXbDQVhlw9J47S1quhiM/Rc3YnGSs4fwLgX9L9wIiCj8=
X-Received: by 2002:a7b:c392:: with SMTP id s18mr6531796wmj.61.1573204778116;
 Fri, 08 Nov 2019 01:19:38 -0800 (PST)
MIME-Version: 1.0
References: <1573203234-8428-1-git-send-email-pvanleeuwen@verimatrix.com>
 <CAKv+Gu9SahVL815i+8_f_fQPM2JP=3rpz3GLFhxLaAUrhz3HWA@mail.gmail.com> <MN2PR20MB2973987E78F4A4F6A63C430ACA7B0@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973987E78F4A4F6A63C430ACA7B0@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 8 Nov 2019 10:19:27 +0100
Message-ID: <CAKv+Gu9+=Pee-CTWT1V2HWgL7ZeG91Mgo2VUrvFSR0=rd0BMyg@mail.gmail.com>
Subject: Re: [PATCHv3] crypto: inside-secure - Fixed authenc w/ (3)DES fails
 on Macchiatobin
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Nov 2019 at 10:02, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Sent: Friday, November 8, 2019 9:58 AM
> > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > Cc: open list:HARDWARE RANDOM NUMBER GENERATOR CORE <linux-crypto@vger.kernel.org>;
> > Antoine Tenart <antoine.tenart@bootlin.com>; Herbert Xu <herbert@gondor.apana.org.au>;
> > David S. Miller <davem@davemloft.net>; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Subject: Re: [PATCHv3] crypto: inside-secure - Fixed authenc w/ (3)DES fails on
> > Macchiatobin
> >
> > On Fri, 8 Nov 2019 at 09:57, Pascal van Leeuwen <pascalvanl@gmail.com> wrote:
> > >
> > > Fixed 2 copy-paste mistakes in the commit mentioned below that caused
> > > authenc w/ (3)DES to consistently fail on Macchiatobin (but strangely
> > > work fine on x86+FPGA??).
> > > Now fully tested on both platforms.
> > >
> > > changes since v1:
> > > - added Fixes: tag
> > >
> > > changes since v2:
> > > - moved Fixes: tag down near other tags
> > >
> >
> > Please put the changelog below the ---
> > It does not belong in the commit log itself.
> >
> Really? I've always done it like that (just checked some of my previous
> patches) and this is the first time someone complains about it ...
>

Well, the point is that formatting your patch correctly will make it
easier for the maintainer to apply it, without having to open it in an
editor and move things around or deleting them ('git am' automatically
drops the content below ---)


> >
> > > Fixes: 13a1bb93f7b1c9 ("crypto: inside-secure - Fixed warnings on
> > > inconsistent byte order handling")
> > >
> > > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > > ---
> > >  drivers/crypto/inside-secure/safexcel_cipher.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-
> > secure/safexcel_cipher.c
> > > index 98f9fc6..c029956 100644
> > > --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> > > +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> > > @@ -405,7 +405,8 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8
> > *key,
> > >
> > >         if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
> > >                 for (i = 0; i < keys.enckeylen / sizeof(u32); i++) {
> > > -                       if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
> > > +                       if (le32_to_cpu(ctx->key[i]) !=
> > > +                           ((u32 *)keys.enckey)[i]) {
> > >                                 ctx->base.needs_inv = true;
> > >                                 break;
> > >                         }
> > > @@ -459,7 +460,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8
> > *key,
> > >
> > >         /* Now copy the keys into the context */
> > >         for (i = 0; i < keys.enckeylen / sizeof(u32); i++)
> > > -               ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
> > > +               ctx->key[i] = cpu_to_le32(((u32 *)keys.enckey)[i]);
> > >         ctx->key_len = keys.enckeylen;
> > >
> > >         memcpy(ctx->ipad, &istate.state, ctx->state_sz);
> > > --
> > > 1.8.3.1
> > >
>
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com
