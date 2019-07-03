Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2535C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 18:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C6AE2080C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 18:52:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z0A2IZXv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfGCSwn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 14:52:43 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:45299 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCSwn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 14:52:43 -0400
Received: by mail-vs1-f67.google.com with SMTP id h28so439367vsl.12
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2019 11:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P0SISqd7qFyjhRi5JarUDePhzft4Z4i+5vbeE4zvvxU=;
        b=Z0A2IZXvOXLsg1odRNUeBrz7ZcO4EAPhrYFZ7WAO/QhULoFwTj7iUF+GaQeaWmBfyV
         6rTZePW0/N8jC7NJUuidcJzDUjf8WAtcfpiJxeU8ERX1tlMTtF9ssI/hijDVkKo7SnpG
         YovYtd6FO6WPIucKX9/XzNtoaOVJe8wrIpDRzTJBWoxtDs89s595HzFUptAFRqt9GfSv
         oHsREl0GfjCtmQ7Q9wybaOdmfTbD1zUjwNf622/1IcB5j3Ssci6lwZAktOzSl8hHBmhq
         OJ/dObDAwQi3PS+Gk/OTEUUC4NZVsXeAk1Twt5zzMV0TumItK+LmFndsRhPy95nBSIGI
         dp2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P0SISqd7qFyjhRi5JarUDePhzft4Z4i+5vbeE4zvvxU=;
        b=GFAugXW9ER3c2iZlGEL5KYIKL8mSmI8yEkaOasB0/17KyAIdVcYHfuYQw14jXP1LVZ
         DWkcbLP6eZHRlg+MsCOr/byTQGT0dB+0MgKWes0Vq4pCr7kpC523ASzAkV5SZCH34RUn
         8UMztXUbPsmPHjMSpsFBTdSd38FXKfoLPADr1BXQkAyI3kj0SDDEKXPRZ3JeaX6qM4dK
         6o5D8EQiFWJyCEAmq4/XnKHzIsMCaLIo/xcMFhQmdllB2DB/y12ziQWwLLRVzAVXaqCw
         C+pcSL8nhxrW6zxLgSTQYDPYTfAz5XHw6OHpv/sCN0BHNbHw06IQoJOd843zIqb/stXC
         J59g==
X-Gm-Message-State: APjAAAVfIlaFxARzXydqf5hPDZ48Vr/axggVE+OO801flgJbYywXn8xg
        h9iMu5s+2UGwc6tOn3/XIv8m3+5BPJste2p/VXQQuA==
X-Google-Smtp-Source: APXvYqwow0EX2nyZZd89sH/ASsLdenmsD9V5maq7itCJN9Qc7Ac2Ud+QnFafzlq6NM/zolR9djHtqgB4WM88JURYqe8=
X-Received: by 2002:a67:ee96:: with SMTP id n22mr10128140vsp.33.1562179962108;
 Wed, 03 Jul 2019 11:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
 <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com>
 <20190617182256.GB92263@gmail.com> <CA+icZUV8693G8jgHw2t9qUay4_Ad-7BgNOkL6z+4z8xNXyL=cA@mail.gmail.com>
 <20190703161456.GC21629@sol.localdomain>
In-Reply-To: <20190703161456.GC21629@sol.localdomain>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 3 Jul 2019 11:52:31 -0700
Message-ID: <CAKwvOdmRdef1PD9NQnOhfeNC_LWAp8a-oYcnxXo1WWGoWnyn0w@mail.gmail.com>
Subject: Re: crypto: x86/crct10dif-pcl - cleanup and optimizations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Peter Smith <peter.smith@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 3, 2019 at 9:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
> Sorry, I am still confused.  Are you saying that something still needs to be
> fixed in the kernel code, and if so, why?  To reiterate, the byteshift_table
> doesn't actually *need* any particular alignment.  Would it avoid the confusion
> if I changed it to no alignment?  Or is there some section merging related
> reason it actually needs to be 32?

Looks like the section merging of similarly named sections of
differing alignment in LLD just got reverted:
https://bugs.llvm.org/show_bug.cgi?id=42289#c8
I wasn't able to find any documentation that said alignment must match
entity size, but if there's not a functional reason for them to differ
then it seems like LLD need not even support such a particularly
non-common case.

-- 
Thanks,
~Nick Desaulniers
