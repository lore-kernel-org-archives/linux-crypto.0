Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941B4C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 23:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6373A2086A
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 23:43:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PvBbnjaf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfK0XnG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 18:43:06 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:40231 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfK0XnG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 18:43:06 -0500
Received: by mail-vk1-f195.google.com with SMTP id i18so721319vkk.7
        for <linux-crypto@vger.kernel.org>; Wed, 27 Nov 2019 15:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5V1U7K9kHqSmBC9GKmbu10OmsvEfDZWHZBAkdynx/3A=;
        b=PvBbnjafdCvEjlwAHLsw4Jkf5UKDz6s7witD5jd3/x70kOObX+EhN8IhEu1l0vMDao
         eyFB2VR6+BiVNsnhas396vPiie5zwGNVANUKDHufBAXVc0+9hKfbW030dFWNG3Cv/J7l
         hqmrKydCIurQVBzzegb3UutaspJwhtGXO/gKSvIA6Sq2HhXhwRAghpC1UbE1oDheTz8S
         qX4ZaH6B1tEQxHPimTogvOFaHeUSQzd1sKhIPU+fef2bGXQspLHe1EyC9nEza/asyLzJ
         b/YquzQ4e8aWWFpfl2u+fQMt+7m4lbuhnN1p9eHjdQdOaCsEYyXNqrWJj/1kRgyr8e+w
         v8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5V1U7K9kHqSmBC9GKmbu10OmsvEfDZWHZBAkdynx/3A=;
        b=Q9FjgMgoSUApOtLea4yd4x957/f1wh19wSdpatJlraIWJZRTWykPQAyPNS3aY07q03
         QLurYqBVp76Fd+hRsfT0av2yoT7U8crBUE83FPMT65AVpRMbmIksPKKtlGLiMFNQQTNA
         j/J8RwerP+MGKE3JQu4bq7pLXsxBbuq/L97gWQJKk/TBJTJwp+xdBs6SuYKL/SsbYbP3
         9vf2gC0Y5xbApCMZxtj/JaG/nhxhkyZz8M0Ip5AWi/XfkSsKfCtUuari+C/vL8QpMSN3
         D5W8vdFkJ5PrUtvanQgEaaBcZREZRKT/9ZDWX2cSo5OJglQiiqBP02KC221iqjmQokz+
         YNew==
X-Gm-Message-State: APjAAAXmpgT17hWkm2myaQrO/fuXrbrA0GpJXQlgtO+XwuNmcWVXFgVF
        5FTIfXo+SbUmlJUiNKVKMmK/7RQgXU30HuT/unsXPA==
X-Google-Smtp-Source: APXvYqx1i0KATXqkxu2iu7n10l5sJYYFz7lSnecvNV9HWF093zCgA7YZz4hfleScYvfvsSSdbbjLOGlrCFIaftAte+A=
X-Received: by 2002:a1f:7d88:: with SMTP id y130mr4689848vkc.71.1574898185282;
 Wed, 27 Nov 2019 15:43:05 -0800 (PST)
MIME-Version: 1.0
References: <20191112223046.176097-1-samitolvanen@google.com>
 <20191119201353.2589-1-samitolvanen@google.com> <20191127181940.GB49214@sol.localdomain>
In-Reply-To: <20191127181940.GB49214@sol.localdomain>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Wed, 27 Nov 2019 15:42:53 -0800
Message-ID: <CABCJKud-JRT8mNmP8yMobeFajk1gU_iwss9w43keZyX9jasPXw@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: arm64/sha: fix function types
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 27, 2019 at 10:19 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Nov 19, 2019 at 12:13:53PM -0800, Sami Tolvanen wrote:
> > +static void __sha1_ce_transform(struct sha1_state *sst, u8 const *src,
> > +                             int blocks)
> > +{
> > +     return sha1_ce_transform(container_of(sst, struct sha1_ce_state, sst),
> > +                              src, blocks);
> > +}
> > +
>
> 'return' isn't needed in functions that return void.
>
> Likewise everywhere else in this patch.
>
> Otherwise this patch looks fine.

Thanks for taking a look, Eric. I'll send out v4 with this fixed.

Sami
