Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB797C432C2
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 22:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A91EC205F4
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569450189;
	bh=6gvMWUyvMtt8R0eMu2h/zZdmg1teTv+hXnKb9zzWM0g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=GhehJOmRPpeHAtPWBE+k7GD6R+LEiizChx0N2/6E4JPgwXCegciqLnxb7fMMQWorw
	 J3ajJOYtuIFOF0seirNr/wkkyPxopEquHUoDUr5Zly1pD4ytO/QY4YNueqOiczCV/z
	 fhFYR7RfEWES5wrV4qRkdmVjMTVbwIRTRuyNV4FA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfIYWXI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 18:23:08 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40027 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfIYWXI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 18:23:08 -0400
Received: by mail-lf1-f68.google.com with SMTP id d17so152841lfa.7
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 15:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v5qOYcXhFbVAr9ok1la3aDcJNeyfwo4nMbHDTfn7B8k=;
        b=BC9rIMQ8jDC8E5RYdrmbTTws/8Ex8klxwwHit6B1Xey1ht2vUc5LFQN2i9CsZuf1Yl
         JbQcs5O2Mi5rd5J130Nrl1fe+qewldtiQi/8jb5iFdcQE/rZoQ9ClYd9ru0/LF/GE9sY
         PoLue1+l+DGJJXSfAABo09GAeg105zLL5q0uM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v5qOYcXhFbVAr9ok1la3aDcJNeyfwo4nMbHDTfn7B8k=;
        b=lSZ5q7ef1EzBxkqi66GTMZ/jZK1+WM25CNxiby4z5uJXUfyMtP8CZEjK8KYTgYHWFV
         pWCl5vF8PPwEjxmWMnCm4Flz0sVVTu82qG2TNKc8FaF1IHvhEl+HsAHJhVrGBRyyuliy
         eGIrKlp2HUkpIoa4aQf3euPzwmc+6HEqR/NFzBXJRYwSGWgx8V5kt/aIJNWjhozR9dwk
         APeaPM4TX+o6l188QE2GpkzzwnPD5PDlkn8iZS/SSTDFSYBenXQT2dSoNpsbFYboQdoI
         gOCsIKWpDPEknKxp0dH+xTWRJnZgLX2iIghn1ijk/0Zuwz75UzwVdHaqvFE2tipVJ+ga
         lh3A==
X-Gm-Message-State: APjAAAVMMuWVpWZlfYSudg0mYSht3S56znzCHno6O1b3i7oCtpFCP+ZR
        5WOHPAAiKB/akVdy9kHAJ3eOY8NvNAI=
X-Google-Smtp-Source: APXvYqwnkEVfc7g3ahz0V3Zf9Nxns6HhDfq9DuBztAfBqA1HvXQa7R2G+ga1zqI9Mtn3Wqung+bPgw==
X-Received: by 2002:ac2:52a9:: with SMTP id r9mr163017lfm.172.1569450186137;
        Wed, 25 Sep 2019 15:23:06 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id x17sm28740lji.62.2019.09.25.15.23.04
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 15:23:05 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id u28so160095lfc.5
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 15:23:04 -0700 (PDT)
X-Received: by 2002:a19:2489:: with SMTP id k131mr171406lfk.52.1569450184592;
 Wed, 25 Sep 2019 15:23:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
In-Reply-To: <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 25 Sep 2019 15:22:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=widERJcUqSSe3HoQ4-YE6HuXz7QuKyE6-2-wbXbn7PwZQ@mail.gmail.com>
Message-ID: <CAHk-=widERJcUqSSe3HoQ4-YE6HuXz7QuKyE6-2-wbXbn7PwZQ@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 25, 2019 at 3:15 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I don't really have a dog in this fight, but on the whole I really
> liked the series. But this 18/18 raised my heckles, and I think I
> understand why it might raise the heckles of the wireguard people.

To be honest, I guess I _do_ have a dog in the fight, namely the thing
that I'd love to see wireguard merged.

And this series otherwise looked non-offensive to me. Maybe not
everybody is hugely happy with all the details, but it looks like a
good sane "let's use as much of the existing models as possible" that
nobody should absolutely hate.

                   Linus
