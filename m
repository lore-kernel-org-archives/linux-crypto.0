Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7D4C7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50A23206B8
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 09:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mQyXqpJF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfG2Jcr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 05:32:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40857 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727679AbfG2Jcr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 05:32:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so52824760wmj.5
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2019 02:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lj8AjTwflrfArE149CoaJCc3xkJOGuf3DDiH8DOcDug=;
        b=mQyXqpJF8i0I6N7F/xmiC+oo/eXSj/CsNPfzbhDwMB/U3c8gillHthF4KIrkEDkqYo
         P1NLUpZ7dr7JB1j9om5vmD05Qo5n02y97MFg7Mbq/2bfJ84XLLmLqleMt9FAOaazvrVH
         MNScB+ENjwAOVsimf5dBy5q2X+DRj+5GMRoptVPk6pfiilZRNoywhfsHjH1BV1Pkc7sY
         7y+lh1cHhFw6gCD7lknAI22L6479Emw12FMWWYnjlJIz8xuzgUYG1oOhbpEEtBrC3hXw
         IhpaVs5lAklNi5vw6hxD5xVov4cZHRS6/9k4tUN7hcTvP9bKyoC4Jw/m+cL/eJCwR999
         gixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lj8AjTwflrfArE149CoaJCc3xkJOGuf3DDiH8DOcDug=;
        b=MYGF3sDYtW7Z3cYCq0FghBVogfWCMh5Gy/sNv9sNxaRjseelg2u0gych6dKHmDDe0+
         ACHdHOZ8RxSYgKIpqpGlcyNLHk3ZgcqMKAd0tgL/d9TBCLkkOy4KZcnVh+k4uOqSIFJL
         7P6a278G7+/GVahnXGp5pKVN4D/Dp7rjSp4s56l7M1wbY1eVHEzwPx4gtbvbKD8rtiOs
         IuYceHK6ZYmYU58E5t2QR3o5Spj2VYY8DxigR7UUtl3bTe0N6/+OOqS2uCgVIYYoT4LG
         by+DwR8cIGmxPMCd5cI6whHYtFv4vt3rxcgSEbRU5qxir3QPVxji7cYL97duJt31lZlB
         knqw==
X-Gm-Message-State: APjAAAWKOFu52TzWjZyK4V8gCAQwypzTyvYc7i7fgXM30RI8GgL/SxRS
        XLnVjZnxhiN+bAZEsrwTAAJ0QTU/iW67HBqbRxKP/A==
X-Google-Smtp-Source: APXvYqzoqspgak3L3VIK5UqHPX0HBLRLGp8RGhvPZ/6uv9YFxaMzyN/FkzSAoRpqmirNXTiqC7x7xUBtb09hivDYmVk=
X-Received: by 2002:a1c:b706:: with SMTP id h6mr95875793wmf.119.1564392765019;
 Mon, 29 Jul 2019 02:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190729074434.21064-1-ard.biesheuvel@linaro.org>
 <20190729091204.GA32006@gondor.apana.org.au> <CAKv+Gu9WW_wGKZaXHjLxgUF0zNYBpEFZnjVyFy0tGmiGmb0-ag@mail.gmail.com>
 <20190729092149.GA32129@gondor.apana.org.au>
In-Reply-To: <20190729092149.GA32129@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 29 Jul 2019 12:32:33 +0300
Message-ID: <CAKv+Gu8sVb9HTgiyV101W1kd9fVn=2kEG+mKNePi+UKC0YQ+pQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128 - deal with missing simd.h header on
 some architecures
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 29 Jul 2019 at 12:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jul 29, 2019 at 12:15:20PM +0300, Ard Biesheuvel wrote:
> >
> > It is simply a matter of adding simd.h to the various
> > arch/<...>/include/asm/Kbuild files, but we'd have to do that for all
> > architectures.
>
> How does errno.h get added then? It doesn't appear to be in the
> m68k (or arm) Kbuild file either.
>

This seems to work

diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 6f4536d70b8e..adff14fcb8e4 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -3,3 +3,5 @@
 # asm headers that all architectures except um should have
 # (This file is not included when SRCARCH=um since UML borrows several
 # asm headers from the host architecutre.)
+
+mandatory-y += simd.h
