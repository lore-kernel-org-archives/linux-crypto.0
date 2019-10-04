Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F170C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 435D320873
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MZarUObc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388892AbfJDOIH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:08:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35586 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388376AbfJDOIH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:08:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id y21so6024315wmi.0
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IpvBzPUgYAhrXazs0bJv+8iaRH4w1hOUIGacKnKP0NE=;
        b=MZarUObcVgtLvlaqMaX1d84hh+1MVtCgX9CyLlCGBc/Yb0jtArTae7g+InC7bbkCJz
         e9b4rke8FkBrNz8SvxuvPNnQ3mPPn/F7cL+qL8ofk8IBd0q+sUUxXQ55CnLup2YXHsxQ
         Z8BeYDcf/QvFpZDPjl+M/zi/eAZoCf8AKgteITbGpy/ic1+pzNFLLr9BZRFSir2O7zXu
         hzb2FV7/mP/fRYTtMAdpe3yGxKQGqVZjhkjrSgscV3IEqyjg/01yXmMLgTEtBalM++H7
         QgPS09FrTlNN0fEvZXuiESiE6oeQgyS+rdNI5howYZ7xGmwnTprKraTaYRTbdvSO7Ug3
         gYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IpvBzPUgYAhrXazs0bJv+8iaRH4w1hOUIGacKnKP0NE=;
        b=B6PTS504HELbPsZ1x3N/eFkGE9Ib8qxLcjCwlfWRFNDqAtIccozlGZXcP5w+3rFB2L
         7b62sAwWrEwH5YL/oQ9/demu9I34UpO/6m7IwWKeHRCMG8jHnXLIgv+22dfGnmoL4ZlI
         +F9ZM9iVgyjmTAhZnyJej3dyx6mPyx8nXtOn8wnGO2KdflycGl0bygmI/BKZcIqude/u
         QtozXJOgzf4Xpx55rg2361MI9d8gGUwW+NVaXKsZjDkDowKlKNO8opORqjK5MVZhULjy
         9+SWggePrrtpw+dEwiQ1EI7gq00jIKdXEqnm9NBJd3cZLWVUcl9StUkyg8NA+0IkYS3V
         L3GA==
X-Gm-Message-State: APjAAAVae62k3AoplMUFHfh5bC19JPF+JDO2AJwIuraF5+ZWiBU8DHna
        /sC4b8eVxiiAnW5NPc4R7i+/1YKxGt5TXQ6QzLEhgQ==
X-Google-Smtp-Source: APXvYqximdy5xpCtA+6pTc51KYWwhuQGVBN2hb4P9FPODtjQWoNuBc31cq7l0AkbS52dDuzirHdOI7osy4nfYixC1Ag=
X-Received: by 2002:a1c:e906:: with SMTP id q6mr10396694wmc.136.1570198085062;
 Fri, 04 Oct 2019 07:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-21-ard.biesheuvel@linaro.org> <20191004140350.GC114360@zx2c4.com>
In-Reply-To: <20191004140350.GC114360@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 16:07:53 +0200
Message-ID: <CAKv+Gu-VZT4caxAs5S88k+CVNaZh=K2ZDnj+gUArG959FEaMpQ@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] crypto: lib/chacha20poly1305 - reimplement
 crypt_from_sg() routine
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 16:03, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Oct 02, 2019 at 04:17:13PM +0200, Ard Biesheuvel wrote:
> > Reimplement the library routines to perform chacha20poly1305 en/decryption
> > on scatterlists, without [ab]using the [deprecated] blkcipher interface,
> > which is rather heavyweight and does things we don't really need.
> >
> > Instead, we use the sg_miter API in a novel and clever way, to iterate
> > over the scatterlist in-place (i.e., source == destination, which is the
> > only way this library is expected to be used). That way, we don't have to
> > iterate over two scatterlists in parallel.
>
> Nice idea. Probably this will result in a real speedup, as I suspect
> those extra prior kmaps weren't free. Looking forward to benching it.

They weren't only non-free, they were also using kmap_atomic()
unconditionally, which means that these routines were running with
preemption disabled even with non-SIMD crypto on non-highmem
architectures.
