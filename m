Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AE9C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 07:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A6DE61B31
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 07:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhJCHG6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 03:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhJCHG5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 03:06:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3FBC061780
        for <linux-crypto@vger.kernel.org>; Sun,  3 Oct 2021 00:05:10 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d26so23873507wrb.6
        for <linux-crypto@vger.kernel.org>; Sun, 03 Oct 2021 00:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8lu3kFOg7t4FR7CfBL0ZvoqUsjF/kK+A/wTTbRTrjyo=;
        b=B6wMNsiZBN2UHBXjNfxVjKyT166Q/6N5Je5yCT1t1WUt1bg9nIn7QBkZFuxA4FgNSR
         wnEO8BnnuHJekKY5iDNbxar+kqRGd1P+5PF4UX3pdOeJ6VhdfM81nIpIom9barw3twIV
         r2qdAhgKYdhWZE/drw2sbIKEX62OWlBqOOCJAF7wuc79toPHXxJZ9roKYx6ro1q3eh1b
         n3DhCVBxWk+7+PKQxupVQtUzaDbdJCPiHr+D3ZspFmxFiZtotiMaPHzVVqCumIH/JI4G
         KZc7L6O+GuawfH/Q6Bnbg5KDPlEOro265B7FDiYcMmNlJt2ARWX2TA50f6JQ+8LfbtEl
         BR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8lu3kFOg7t4FR7CfBL0ZvoqUsjF/kK+A/wTTbRTrjyo=;
        b=ouBKj0eCO7bQXYWz8UlWfYfC2ZhflJFqTqkoj6RO2fefgELa+pBduhTmlDAu/chzrI
         aBJCSSoH1LwAidpbQq748ASQ1fhoqYkR+oLLAlFGXHJkf9+d+Pgjph9DAvg6G3ZQIot6
         hh6c2retUVhZmaC1YPO2jUVjnZEKIu89iQEZ+9tUo+xbC3Gxih6rNa6wBjxNAdj75PEp
         xpMtLl60y/WbxHozGIugbJCNS01iQidw2Fq/067nPda797NEXF1dd77IQvnc3OHYQGFK
         HQl7nfJswA1PZ8xg1X3+m3HR4m+Vtrcr6bfHMyBCkL2v1nt9XfK29M42MXDg48YfQ0wz
         pXAg==
X-Gm-Message-State: AOAM530isftYilVLjosZu46pyVntZZl3jFsYgmhoBCopZbxsps9URI4B
        UKK5cTvQz+4XQ3weQgdEZ+enV6EgNr94tcrS6y3YsJBDCsg=
X-Google-Smtp-Source: ABdhPJwY/FsUgWGNWkXur/QvOHke1Ks9cFiMw78lp+CrV0LjYrWWEZce14l8YjyxqV37MBuaeMTd0QPgiqvNvpWjcU4=
X-Received: by 2002:a5d:6b46:: with SMTP id x6mr6978093wrw.192.1633244709063;
 Sun, 03 Oct 2021 00:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <CACXcFm=-E_wnDdRPztKJwDo8hvt6ENf84D90iFUXReuw2s0kuQ@mail.gmail.com>
 <378733E4-D976-4E2D-BE14-AD900C901CE8@callas.org>
In-Reply-To: <378733E4-D976-4E2D-BE14-AD900C901CE8@callas.org>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Sun, 3 Oct 2021 15:04:56 +0800
Message-ID: <CACXcFm=40HCSvhkagsFn0WFnjrjbhk+Ah7Y=3tfFf5xxOW6A8g@mail.gmail.com>
Subject: Re: [Cryptography] [RFC] random: add new pseudorandom number generator
To:     Jon Callas <jon@callas.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Cryptography <cryptography@metzdowd.com>,
        "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jon Callas <jon@callas.org> wrote:

> > On Sep 16, 2021, at 20:18, Sandy Harris <sandyinchina@gmail.com> wrote:
> >
> > I have a PRNG that I want to use within the Linux random(4) driver. It
> > looks remarkably strong to me, but analysis from others is needed.
>
> A good block cipher in counter mode makes a pretty-okay PRNG. I say prett=
y-okay only because I would like my PRNG not to be invertible.

I'm using counter mode inside an Even-Mansour XOR-permutation-XOR
structure which, among other things, makes it non-invertible.

> Iterated hash functions are better. However, they are slower, and a prope=
rty you want in a PRNG is that it's fast. I did a system PRNG that was inte=
ntionally faster than arc4random() and close to linear-congruential because=
 then there's no excuse for not using it. A mildly evil person would replac=
e both of those with a fast real PRNG. (Mildly evil because if some user kn=
ew the internals and was counting on it acting the way the internals specif=
ied, they might be disappointed.)

I'm doing this within the Linux random(4) driver which iterates chacha
to generate output. This prng will only generate values for internal
use, like rekeying chacha or dumping data into the input pool. In
fact, if an instruction like Intel RDRAND or a hardware rng exist the
code mostly uses those, only injecting xtea output once in a while to
avoid tructing the other source completely or falling back to xtea if
the other fails.

> XTEA is an okay block cipher. Not great, okay. Probably good enough for a=
 PRNG.

With the Even-Mansour construction it seems good enough to me. Code
includes this comment:

 * Even and Mansour proved proved a lower bound
 * for an XOR-permutation-XOR sequence.
 * S. Even, Y. Mansour, Asiacrypt 1991
 * A Construction of a Cipher From a Single Pseudorandom Permutation
 *
 * For an n-bit cipher and D known or chosen plaintexts,
 * time T to break it is bounded by DT >=3D 2^n.
 *
 * This applies even if the enemy knows the permutation,
 * for a block cipher even if he or she knows the key.
 * All the proof requires is that the permutation be
 * nonlinear.
 *
 * The main calling function does a full rekey (update
 * key, mask and counter) when xtea_iterations >=3D 127
 * We therefore have D ~=3D 2^7 and T >=3D 2^57 to break
 * each sequence of 127 outputs between rekeyings.
 *
 * Assuming proper keying and that the enemy cannot
 * peek into the running kernel, this can be
 * considered effectively unbreakable, even if
 * xtea itself were found to be flawed.

> But -- why wouldn't you use AES? An obvious answer is that you don't have=
 it in hardware ...

I wanted something that would be reasonably fast on anything Linux
runs on & wanted to avoid using kernel memory for the S-box & round
keys.
