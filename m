Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008FDC43334
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jun 2022 04:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiFCE0x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jun 2022 00:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiFCE0t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jun 2022 00:26:49 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58ACB54
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jun 2022 21:26:47 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id p8so4820026qtx.9
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jun 2022 21:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fa0C+LCY84idsUWlo8HR0vK7eKKebloJfOXVdg8uv6I=;
        b=JERo+OyyoSagd/+5rww33kruhhmEsC77asJfLDqeJUTHChFWOgrP/4qpEu8nYUAczS
         +lh+pLDRL2m40j0mjqbzzW/EY5UMHa3IEQqkWiyPuGFonLtVHUyP1VEdRGa/ui0AJTi8
         8osNV2McSTMo/jwd2Si4zvcZTdClv1ZsWAat0eVml1o29+wzfAoq2oD59LhMAKvcmvkX
         Yf2ZphsxD20kCt4633FwRKUSpUg0leQuiCYPa3RoYQuzJMbhDB3CkbQsgwcDhcQttf7l
         hkAry5YRAh1Wv9iT/1uSenWVdgokfJntkrd+F6AXCpmeJkszcfnGvh1b5I5l3dCPb7Zt
         yveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fa0C+LCY84idsUWlo8HR0vK7eKKebloJfOXVdg8uv6I=;
        b=2kbk3bR0hpsHNM8Mic1cEyGP9bhBEAwawxv4/C+lX021MI8LfEChbYd9UXTseI9o5B
         8X+Ks1awnpxeJmH2x00WOFRnKMS/jzk91XpJy+DR4bslTLItYrbv+y6pWcwk7xpn6ic4
         GHLR8cFsXk9CRY4ZzPvHSN+2Nw/DNlgDh/ramw6NJ7St49+t7lsQ2Oby0H8jQreiBwBf
         B4CbPU9zD2IWiu4aWYqyX3IMmcThGtyBNN3hDTPTULdkH297ET0IRtTr1rhe+kTARUz9
         Tl1G4LQ+0DpjIirt3ZcOXHwpsRe0aS/g5PpoPtrozjFaVcSEpg5TZbJKoOsEn29YYn1R
         a81w==
X-Gm-Message-State: AOAM532lEsTTeIuaCJFGmLjiusfaJ8Y4zySJZzrbedvYTKFGAy6DYFUc
        YaFrAjKGyfXGnuwdBZmqWw==
X-Google-Smtp-Source: ABdhPJzAXqBG/kf/+EDON2XAQRabYKznH8F9gxX+LA16MDCyoopjmO6H7J7sSaM9zOOfo6MouQnZwQ==
X-Received: by 2002:a05:622a:90:b0:303:1b86:7238 with SMTP id o16-20020a05622a009000b003031b867238mr6046788qtw.599.1654230406766;
        Thu, 02 Jun 2022 21:26:46 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a430c00b006a37c908d33sm4797965qko.28.2022.06.02.21.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 21:26:45 -0700 (PDT)
Date:   Fri, 3 Jun 2022 00:26:44 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: Memory corruption related to skcipher code
Message-ID: <20220603042644.jj7wcvp2lzox25vs@moria.home.lan>
References: <20220603021134.ehlnluenrz3adpxc@moria.home.lan>
 <YplxLIfUjFUgJA0Z@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YplxLIfUjFUgJA0Z@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 02, 2022 at 07:25:48PM -0700, Eric Biggers wrote:
> What if the address is in the vmalloc area and spans a page boundary?  If the
> next page isn't physically contiguous, this will write to some random page.  A
> multi-element scatterlist would be needed to describe all the physical pages.

That's exactly it :) Can't believe I missed that, or that that bug was lurking
for so long.

> Note that in v5.5 and later, ChaCha20 support is available via the library
> function chacha20_crypt(), in addition to the skcipher API.  You should consider
> using the library function, as it seems to match your use case.

I'll check that out - that looks like exactly what I was looking for when I
originally wrote this code.

Thanks, I owe you a beer :)
