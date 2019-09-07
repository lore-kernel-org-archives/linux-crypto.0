Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A81C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 02:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76AC120842
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 02:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YwNQSYo7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392040AbfIGCO7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 22:14:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32854 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732445AbfIGCO7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 22:14:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id r17so8581005wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 19:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJnW/KuQoChfPogSaDfAl5iy509ebzzJ553OmUi7tHE=;
        b=YwNQSYo77EaGAg9/Y4cUcfJlLXSrQKaMbbPWIIOl7BTKRx/GAAM8PMH4lcA5x4oh1q
         7a2k+8KixyOGsvZTwXzDZXu0MqhmNzyfkyeswL+kpKpkRpr/S4I8Cc+2Xu2wuw5eUSMg
         mztI/d0KRyGelmJD7RNbKDsB+FnQVoiTW5HEkW8IRAbZNzNUh1XvNZW0jHPtUakepiDy
         JoGeOuikv6BUJJthMufe35IdLICG2shQcINFPMMJGQiS0sp8MYdWkLN3EOd93Yu12YlF
         R0P5TgL+sa9PkcHuntDcLTnB+pxU2HN4jgyxBWim9BdKRPDsGwaPfywqCi6xnwVHiQPI
         rp5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJnW/KuQoChfPogSaDfAl5iy509ebzzJ553OmUi7tHE=;
        b=jdXHX9mni8qERzLxSMIPBFWnR3TnYzQn1NnT386tqWpaTq1VmE4WvRjj0jtWUExRMp
         Occn5jx7o4Vw3rY8DajKEtNlVtbWTa19pYSHl0U3kMY2cZCkLCJrc4AtipUA3QZpsuSB
         lnGYyrjjpt7SYblMhe31HzjxttOewWmaNxUd0R7zZTEv4HTOPFBRgGhvohbgAkeq5qJQ
         ucNUFP1UhNDm7D0NWiwdNIrR8C4euLcJ9BJxZ6/VgD6ZBpbbZT713y/KE+dxHoXekhH5
         oyiWfpOh713NyODC4qf6EQKgGRIabsuclZmgIKjFptEq4DmuJB4+jtJJAFwh2ZJAnpno
         3/vw==
X-Gm-Message-State: APjAAAXNLQ2EgtoCaMHZeHD1RpOjmmbfp0fxTgzxv53Yq4LKNcQZsTFJ
        zRxWIs31haQQE0+71yy0zJpkfGR0NRTrTcijpEtHcw==
X-Google-Smtp-Source: APXvYqzYTFfZJTsKsh37sw0OvYXj2g5EuHjYXg4hUtyWIKQP89BWzWxshInTb1ye4eyOEAifOxaYWLyx/lWpEtfEutM=
X-Received: by 2002:a1c:3cc3:: with SMTP id j186mr9249442wma.119.1567822496941;
 Fri, 06 Sep 2019 19:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190903135020.GB5144@zzz.localdomain> <20190903223641.GA7430@gondor.apana.org.au>
 <20190905052217.GA722@sol.localdomain> <20190905054032.GA3022@gondor.apana.org.au>
 <20190906015753.GA803@sol.localdomain> <20190906021550.GA17115@gondor.apana.org.au>
 <20190906031306.GA20435@gondor.apana.org.au> <CAKv+Gu8n5AtzzRG-avEsAjcrNSGKKcs73VRneDTJeTsNc+fUrA@mail.gmail.com>
 <20190907011940.GA8663@gondor.apana.org.au> <CAKv+Gu85brKkLPJLs_uk5F6fO=+hiej7KojLH8deDtzTeYbUqA@mail.gmail.com>
 <20190907015559.GA10773@gondor.apana.org.au>
In-Reply-To: <20190907015559.GA10773@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 6 Sep 2019 19:14:40 -0700
Message-ID: <CAKv+Gu9ark7z3=x+QC_z3TzfTBgvbWWd4xY7-yNYcL8C0BAmHg@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: skcipher - Unmap pages after an external error
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 6 Sep 2019 at 18:56, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Sep 06, 2019 at 06:32:29PM -0700, Ard Biesheuvel wrote:
> >
> > The point is that doing
> >
> > skcipher_walk_virt(&walk, ...);
> > skcipher_walk_done(&walk, -EFOO);
> >
> > may clobber your data if you are executing in place (unless I am
> > missing something)
>
> You mean encrypting in place? If you're encrypting in place you're
> usually on the zero-copy fast path so whatever is left-behind by the
> algorithm will be visible anyway without any copying.
>
> > If skcipher_walk_done() is called with an error, it should really just
> > clean up after it self, but not copy back the unknown contents of
> > temporary buffers.
>
> We're not copying uninitialised kernel memory.  The temporary space
> starts out as a copy of the source and we're just copying it to the
> destination.
>

Right. In that case, I guess it is safe.

I've tested my XTS/CTS changes (which call skcipher_walk_done() with
an error value in some cases) with Eric's fuzz testing enabled, and it
all works fine, so

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks,
Ard.
