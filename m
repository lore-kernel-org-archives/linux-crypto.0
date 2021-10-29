Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F838C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 17:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6F3361038
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 17:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhJ2Rm0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 13:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhJ2RmY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 13:42:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EDAC061714
        for <linux-crypto@vger.kernel.org>; Fri, 29 Oct 2021 10:39:55 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id c28so22391206lfv.13
        for <linux-crypto@vger.kernel.org>; Fri, 29 Oct 2021 10:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SXYZHrunVSca58xKvNCMYWyMo/I0/JX/EjDnzxanuYQ=;
        b=bvO4mvr2I2siAzVqu+IpyBzGbUAlBqVeEZwkANZiRfFAM21SFpA5loXvepjpKwWwgV
         3kbfhTHEsxDZs/xTsnguniHIFTJzs2jc/1wSQqKuiE6dTTIBXfyecfru0xG4WWHjIvdA
         beNbY7nls022JGN9HqZpEHd8pZNuYWMvAsEJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SXYZHrunVSca58xKvNCMYWyMo/I0/JX/EjDnzxanuYQ=;
        b=eYQfDX3No9jNy2CLtIVzG+hI4SEU9JleOSWCcK7ORNlHWRZt0o5VmZrZyEejkk2VXF
         bnCD6qaSglvgeZKqFJeBH5xKSCLyVwjCCEnKu1CXBNHnJo0Rrawmc8duAtgB4aH9JcuR
         bkBDT0boGXPc+U/dBnPtMEFeuLca9JEWhOiRRgxx+WdxlGSvJ4ED3Fu+PxdF/H85JO8X
         TqA8gL4N3Y5BCvszormSckazIRl1u0xDSYwbfGsqn2UtQDI3qj6A/DrhB5AJ3hUj+seB
         USPU1CattuV0R0dPH4pFWIYjNB5I86dQ1r2AZllVwVxIbO4QaiWk/gAef2gu1+t6AMo0
         attQ==
X-Gm-Message-State: AOAM531U35p8oMjsjd/jg/Ou4HO1Fm3rRFIoI+l8HmHRX6p1VKcMAG1r
        pczuC//ON0VCSxyY9NJOR7xLTUTis3lNe9aO/wA=
X-Google-Smtp-Source: ABdhPJy6Kjz61Bzls0aYZPBxveGB9gtKACUKd7+pKKR/uWUBseGWhLuTOW/1Nz6te1YdbjQqzBStYw==
X-Received: by 2002:a05:6512:1048:: with SMTP id c8mr11985074lfb.589.1635529193454;
        Fri, 29 Oct 2021 10:39:53 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id s25sm401320lfs.231.2021.10.29.10.39.52
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 10:39:52 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id u21so22454561lff.8
        for <linux-crypto@vger.kernel.org>; Fri, 29 Oct 2021 10:39:52 -0700 (PDT)
X-Received: by 2002:a19:f619:: with SMTP id x25mr11710609lfe.141.1635529191923;
 Fri, 29 Oct 2021 10:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200803044024.GA6429@gondor.apana.org.au> <20200830223304.GA16882@gondor.apana.org.au>
 <20201026011159.GA2428@gondor.apana.org.au> <20201227113221.GA28744@gondor.apana.org.au>
 <20210108035450.GA6191@gondor.apana.org.au> <20210708030913.GA32097@gondor.apana.org.au>
 <20210817013601.GA14148@gondor.apana.org.au> <20210929023843.GA28594@gondor.apana.org.au>
 <20211029041408.GA3192@gondor.apana.org.au>
In-Reply-To: <20211029041408.GA3192@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 29 Oct 2021 10:39:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=whEFkHvtecaUF5MEZMxW_UVUMn-bLmfAhcvx4t9Qia90A@mail.gmail.com>
Message-ID: <CAHk-=whEFkHvtecaUF5MEZMxW_UVUMn-bLmfAhcvx4t9Qia90A@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Fixes for 5.15
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 28, 2021 at 9:14 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This push fixes a build-time warning in x86/sm4.

Hmm..

> Tianjia Zhang (1):
>       crypto: x86/sm4 - Fix invalid section entry size

So I do wonder why the crypto code asm tends to use such complex
".section" directives.

Almost everythign else in the kernel just uses

     .section <name>,"a"

for data (and "ax" for text).

The crypto code uses that very subtle "M" flag which allows the linker
to merge data, but how much of a win is that added complexity? Now you
need to get the sizes exactly right, and you hit tooling issues.

Plus, I get the feeling that some people have just copied-and-pasted
those things, and don't necessarily realize just _how_ subtle 'M'
sections are.

How much of a data savings is it to have this complexity? Particularly
since I suspect most of the time these things end up being individual
modules, and never actually get linked together at all?

So I get this very strong feeling that the crypto code is doing
complicated and fragile things that cause tooling issues - and does so
for no good reason and no actual real-life upside.

I've pulled this, but I do suspect that all the fancy

   .section .rodata.xyz, "aM", @progbits, abc

could just as well be

    .section .rodata, "a"

instead, and you guys are only causing problems for yourself by trying
to be clever in pointless ways.

            Linus
