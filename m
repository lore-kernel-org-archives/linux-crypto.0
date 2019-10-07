Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8A0C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 13:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1A532070B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 13:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLbSkVbZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfJGNHV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 09:07:21 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46317 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfJGNHV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 09:07:21 -0400
Received: by mail-qt1-f195.google.com with SMTP id u22so18936765qtq.13;
        Mon, 07 Oct 2019 06:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F8dZxRaNH/jTk2WwddGdWxxAukfIe2hFJ2pFxlk+cMU=;
        b=gLbSkVbZiRNZymJ1DZCylgrfvBaDMau1Lan3BbweKwtIOL+kMYU/xJpy7Plzp8b2xu
         xcfotllNn1i9sw2by8WcbYChXgwZuqBy31ebUdtjuM8Cb/vVV4YFswDFolflhDpvC01F
         5fLs23LGC6yrkWRnfO4jDEqz1LnSMuGZvlF19IrEFRKZfMA0xQEQMZAc68MBAkmsU9LY
         amzF8audIVYloaAWRG8Rjten4rq4ERsEaPIRxVWxsjZGktf6ufvltpEGeguFeUrbYO63
         yKRI2fyZagTGzKaNbHR6Vn4eS7mNQk0SGEy96TG5Cg4iJ/kshOUDTsc8X/oxNHtURe08
         eJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=F8dZxRaNH/jTk2WwddGdWxxAukfIe2hFJ2pFxlk+cMU=;
        b=Utw1wEdi7JeQxSmHRyw0FQwmWFw1AxJvTwUNSoE0qG7h0Vsz59orjDzBkW/VsYybVg
         3UFM5cG6AICURN4U9o68VA0HdFF7+gepYAmuaU9HM8kiJAQZjlX1sfsEbOhhi85f79hP
         wtFa0hRP4Uw8GbFlc/AvEfj19jBofd7Ha/jLCZf/uVIKm4gbYug/25L1z80T+W8jfkvx
         oDz3+htyI9A4wmGykBRYo53Ts+W8ISU15UOsAMo3cqWgtntwo8kkZdcHZHhroh1CPlLk
         kwW0iOgAZ1gZ2Ssx8BIO0d5btLgulIIPcbptqN9m11eC4YV66n6+HTkA/sZ5XOVauK0z
         0cQA==
X-Gm-Message-State: APjAAAULUVHGz5n6IKsoM1pB3DBQYSEakAUjIklmr5bNlMF2Z/MP7xle
        PsJHFdF1XUPrVYZgUt/HBYI=
X-Google-Smtp-Source: APXvYqyVPk9RdZ7GXXX3LYUAAVYnQTvfFw030zZX0IHP/0+DbuxpEBuNTwk5clW6dv1pnkv0jXt3Mg==
X-Received: by 2002:ac8:2d2c:: with SMTP id n41mr29616427qta.335.1570453639838;
        Mon, 07 Oct 2019 06:07:19 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id g25sm6475391qtp.96.2019.10.07.06.07.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 06:07:19 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Mon, 7 Oct 2019 09:07:17 -0400
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH 5.4 regression fix] x86/boot: Provide memzero_explicit
Message-ID: <20191007130716.GA269842@rani.riverdale.lan>
References: <20191007085501.23202-1-hdegoede@redhat.com>
 <65461301.CAtk0GNLiE@tauon.chronox.de>
 <284b70dd-5575-fee4-109f-aa99fb73a434@redhat.com>
 <12200313.ic8YZTgDOU@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12200313.ic8YZTgDOU@tauon.chronox.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 07, 2019 at 11:34:09AM +0200, Stephan Mueller wrote:
> Am Montag, 7. Oktober 2019, 11:06:04 CEST schrieb Hans de Goede:
> 
> Hi Hans,
> 
> > Hi Stephan,
> > 
> > On 07-10-2019 10:59, Stephan Mueller wrote:
> > > Am Montag, 7. Oktober 2019, 10:55:01 CEST schrieb Hans de Goede:
> > > 
> > > Hi Hans,
> > > 
> > >> The purgatory code now uses the shared lib/crypto/sha256.c sha256
> > >> implementation. This needs memzero_explicit, implement this.
> > >> 
> > >> Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
> > >> Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get
> > >> input, memzero_explicit") Signed-off-by: Hans de Goede
> > >> <hdegoede@redhat.com>
> > >> ---
> > >> 
> > >>   arch/x86/boot/compressed/string.c | 5 +++++
> > >>   1 file changed, 5 insertions(+)
> > >> 
> > >> diff --git a/arch/x86/boot/compressed/string.c
> > >> b/arch/x86/boot/compressed/string.c index 81fc1eaa3229..511332e279fe
> > >> 100644
> > >> --- a/arch/x86/boot/compressed/string.c
> > >> +++ b/arch/x86/boot/compressed/string.c
> > >> @@ -50,6 +50,11 @@ void *memset(void *s, int c, size_t n)
> > >> 
> > >>   	return s;
> > >>   
> > >>   }
> > >> 
> > >> +void memzero_explicit(void *s, size_t count)
> > >> +{
> > >> +	memset(s, 0, count);
> > > 
> > > May I ask how it is guaranteed that this memset is not optimized out by
> > > the
> > > compiler, e.g. for stack variables?
> > 
> > The function and the caller live in different compile units, so unless
> > LTO is used this cannot happen.
> 
> Agreed in this case.
> 
> I would just be worried that this memzero_explicit implementation is assumed 
> to be protected against optimization when used elsewhere since other 
> implementations of memzero_explicit are provided with the goal to be protected 
> against optimizations.
> > 
> > Also note that the previous purgatory private (vs shared) sha256
> > implementation had:
> > 
> >          /* Zeroize sensitive information. */
> >          memset(sctx, 0, sizeof(*sctx));
> > 
> > In the place where the new shared 256 code uses memzero_explicit() and the
> > new shared sha256 code is the only user of the
> > arch/x86/boot/compressed/string.c memzero_explicit() implementation.
> > 
> > With that all said I'm open to suggestions for improving this.
> 
> What speaks against the common memzero_explicit implementation? If you cannot 
> use it, what about adding a barrier in the memzero_explicit implementation? Or 
> what about adding some compiler magic as attached to this email?
> 

The common definition I think is the same as your attachment, i.e.
memset followed by barrier_data(). I don't think there is any reason not
to just copy that definition?

Alternatively, could the common definition not be made an inline or
macro? or is there a risk that could introduce unsafe optimizations to
eliminate it?
