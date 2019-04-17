Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A712C282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 20:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E604C20651
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 20:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tRgRRpZe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfDQUQJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 16:16:09 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:50737 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfDQUQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 16:16:09 -0400
Received: by mail-it1-f195.google.com with SMTP id q14so6927066itk.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 13:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a1oWGKP3YkEE06qK+20uUz17L9mflCsdumtYenM2xWY=;
        b=tRgRRpZeTi6nR2F33KQw/zpaT9/27yYRmP+WtLoa5d6VOePDEb3aJ4MsUHghCC/gyA
         ww3yscTyqH4EuN+gy2ZJJrYq/i93gyynvwqXORtjKVjeJ/gims+RJal/STwdDK8S+zNX
         i3r+qCj+Mz+uTY7QfOHIDtBvuJHaQtBFoJNN1+uaIb3ITcImMZufJcfhmLTqQtP8LOgj
         sYECJ91+3jI/guLWip6S9EqqQkWsDUgkTwEl876Jsl0UCe9OfE9Hrto+GHLDewxEc0Bo
         P8IM28cZNtCVO/VELLJezylQJSboLVkM1fBBcT4Pg+K+RzGIXGZRvcadHW9QwNjHRbje
         sc+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a1oWGKP3YkEE06qK+20uUz17L9mflCsdumtYenM2xWY=;
        b=FSoxRkNLVaaQD6jHZVn1qcRysC20l3q+z80aqhC23AeL6OasHHyutNl16PD9fQYz8n
         riexvZK/+0djyUsNckAs7N7XAXWRPODE6454X1LvhmHfxEzv9pKNTfSgYHYLQp1WlU+N
         dj8hQegiA4Y8YXfNEI/jQzokmpHixpWeyGNJZd9tHP0dE8N9M6DlD9qfi2c61CHE4PYN
         Zf5pm8jow4P5GY20fV+C4SAqXAV8/XTwl/mO2myJMc2pkYs23jpkQwepMM088mRPw/xR
         KWgHCNteOSYdPsUjLfWeOwVzdjRJh+86el89SP081OI2MYc35YW2bOVhD7PRwg5cdyUz
         gV4Q==
X-Gm-Message-State: APjAAAUK2eOwZvFbykTj599QIfjtip3ib557PYPoEJmbzbTWb0jIu+c0
        7iPCrYvY+XpSVRiQEtvoaZ+60R/SB5WfbU5AgTahOw==
X-Google-Smtp-Source: APXvYqypKZD1Gt1rUyQm2rcJSSfxLsZWie5bkgDx8AqPZOc9oi57PkCPBRiBOE+BeR8+VjyBH8+bPvj6eAEHOrkkLDA=
X-Received: by 2002:a05:660c:4c2:: with SMTP id v2mr384704itk.71.1555532168832;
 Wed, 17 Apr 2019 13:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 17 Apr 2019 13:15:57 -0700
Message-ID: <CAKv+Gu8000sDAX89=cre2uZ07vJC86FVjcoKagyk_Qqyrkbytw@mail.gmail.com>
Subject: Re: Question regarding crypto scatterlists / testmgr
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 17 Apr 2019 at 12:51, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> Hi,
>
> I'm trying to fix the inside-secure driver to pass all testmgr
> tests and I have one final issue remaining with the AEAD ciphers.
> As it was not clear at all what the exact problem was, I spent
> some time reverse engineering testmgr and I got the distinct
> impression that it is using scatter particles that cross page
> boundaries. On purpose, even.
>
> While the inside-secure driver is built on the premise that
> scatter particles are continuous in device space. As I can't
> think of any reason why you would want to scatter/gather other
> than to handle virtual-to-physical address translation ...
> In any case, this should affect all other other operations as
> well, but maybe those just got "lucky" by getting particles
> that were still contiguous in device space, despite the page
> crossing (to *really* verify this, you would have to fully
> randomize your page allocation!)
>
> Anyway, assuming that I *should* be able to handle particles
> that are *not* contiguous in device space, then there should
> probably already exist some function in the kernel API that
> converts a scatterlist with non-contiguous particles into a
> scatterlist with contiguous particles, taking into account the
> presence of an IOMMU? Considering pretty much every device
> driver would need to do that?
> Does anyone know which function(s) to use for that?
>

Hello Pascal,

Scatterlists are made up of struct page/offset tuples, and so they
should map transparently onto physical ranges.

It looks like the AEAD skcipher walk API lacks a *_async() variant
setting the SKCIPHER_WALK_PHYS bit, like we have for the ordinary
block ciphers. Plumbing that into crypto/skcipher.c should be rather
straight-forward.

-- 
Ard.
