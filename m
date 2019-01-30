Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB5CC282D5
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 08:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A94B2184D
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 08:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="LFkKmT9p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfA3IeL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 03:34:11 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:46569 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfA3IeK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 03:34:10 -0500
Received: by mail-io1-f67.google.com with SMTP id s8so18645326iob.13
        for <linux-crypto@vger.kernel.org>; Wed, 30 Jan 2019 00:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ckuC3ZQVRrVuPH+nAFncXNWtfLzpYSyWJJoM09owGmM=;
        b=LFkKmT9pxhM5w5Id+lWqN8LjFNiv8A/2D5nUsO/fu+/t1S6gs8+A22tVGTvKHhj5Yt
         saZaVWjC8J9TQIUzlen9YKFipM26J8FS0z2RCKq2AtOygsFOpuQpjLyULopEthUxW8rm
         3Ftq/Lyjt47bimkWdnhlqJDw4rcuR9vn4Ug50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ckuC3ZQVRrVuPH+nAFncXNWtfLzpYSyWJJoM09owGmM=;
        b=mVLs+QGiZZYbqOf8cBDY3SD/i08E9RVA661CTp+Vfb/P6pNjtqi/YaOJVsHd4E5iQo
         U6LTH4PQNU+cYDbkoanWyJ/JItubaPIBfuI3ujXvWnRn0XEgSdXaWV9PIO6CNCYs4vSm
         xERVTh2qIgo8tiNCJ7URvWPoV8Bvy4/pHYvIIDYWLO+8HSwL8mCLV+iV0ofFEvhXFQkF
         vcTdl1x/G0THeEvafaHJvOqeuc/jdz3u5mqsxcgV0b+f5OnxJnE0qHugIJhYPSsQgrA1
         ZtLNFoBUeWFH3WJGAm5RE95LfSexLCVzBDlx9tu7rhiWnQnBbujuXTz6P5DWq7ANlqL5
         EaKw==
X-Gm-Message-State: AHQUAubj3aFc/CCf+M3W18SWJs5lzAjMSZb+vHSdBKHFG3epwZJoXjQL
        9TpkyZ8BpisnCnEvQrmp50dz2eTUVp1qiztZ1UbwRA==
X-Google-Smtp-Source: AHgI3IaVd5RYshAFtY7mq4CrT8ycn9S+PqmXKMIfNC284bwd4CnMFb8YmObMXDBTmfOZA2xwgJlYnzRWgmhKMtCtfe8=
X-Received: by 2002:a5d:8410:: with SMTP id i16mr481607ion.173.1548837249850;
 Wed, 30 Jan 2019 00:34:09 -0800 (PST)
MIME-Version: 1.0
References: <20190130031444.28935-1-ebiggers@kernel.org>
In-Reply-To: <20190130031444.28935-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 30 Jan 2019 09:33:57 +0100
Message-ID: <CAKv+Gu95j-ZJC7vbUzJKqNczht1cjgx09sBiSRcwg+qn-HtXew@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] crypto: crct10dif assembly cleanup and optimizations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 30 Jan 2019 at 04:15, Eric Biggers <ebiggers@kernel.org> wrote:
>
> The x86, arm, and arm64 asm implementations of crct10dif are very
> difficult to understand partly because many of the comments, labels, and
> macros are named incorrectly: the lengths mentioned are usually off by a
> factor of two from the actual code.  Many other things are unnecessarily
> convoluted as well, e.g. there are many more fold constants than
> actually needed and some aren't fully reduced.
>
> This series therefore cleans up all these implementations to be much
> more maintainable.  I also made some small optimizations where I saw
> opportunities, resulting in slightly better performance.
>
> This is based on top of the pending patches from Ard Biesheuvel.
>
> These all pass the new extra self-tests.
>

Hi Eric,

As a FYI, the issue that broke ARM and arm64 with your updated
selftests was the 1 byte length special case that you also have
special handling for in the x86 version (but while fixing that, I
noticed my version was reading beyond the end of the input). I think
it hardly matters, though, given the way T10-DIF appears to be used in
practice (disk blocks), although it is hard to be sure from reading
the code, and the algo should be correct in any case.

So what remains is the way these implementations are encapsulated by
the crct10dif() library function, which is raster nasty, making
CRC-T10DIF an excellent use case to discuss whether we can make any
improvements to address some of the concerns that were also raised in
the zinc discussion. I threw some code together a while ago [0] (and
posted it as well, IIRC). In the mean time, a 'static call'
infrastructure is being proposed that could be used in a similar way
to avoid function pointers. I'm also interested in hearing opinions on
whether the indirect call overhead is actually significant in use
cases such as this one.

-- 
Ard.



[0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=crypto-crct10dif


> Changed since v2:
> - Removed the unnecessary '__LINUX_ARM_ARCH__ < 7' case.
> - Added Ard's Acked-by.
>
> Changed since v1:
> - Moved constants in arm implementation to .rodata.
> - Eliminated a few instructions from the x86 implementation.
> - Tweaked a few comments.
>
> Eric Biggers (3):
>   crypto: x86/crct10dif-pcl - cleanup and optimizations
>   crypto: arm/crct10dif-ce - cleanup and optimizations
>   crypto: arm64/crct10dif-ce - cleanup and optimizations
>
>  arch/arm/crypto/crct10dif-ce-core.S     | 552 ++++++++--------
>  arch/arm/crypto/crct10dif-ce-glue.c     |   2 +-
>  arch/arm64/crypto/crct10dif-ce-core.S   | 496 +++++++-------
>  arch/arm64/crypto/crct10dif-ce-glue.c   |   4 +-
>  arch/x86/crypto/crct10dif-pcl-asm_64.S  | 844 +++++++++---------------
>  arch/x86/crypto/crct10dif-pclmul_glue.c |   3 +-
>  6 files changed, 794 insertions(+), 1107 deletions(-)
>
> --
> 2.20.1
>
