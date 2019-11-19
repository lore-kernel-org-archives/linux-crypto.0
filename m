Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5A5C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30FDF2068F
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zYvdRFkl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfKSPe4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:34:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52674 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbfKSPe4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 10:34:56 -0500
Received: by mail-wm1-f65.google.com with SMTP id l1so3663750wme.2
        for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2019 07:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7hajhGKYbz9Pv9aUNy7fvHRk680trSNK3uThLWP18Ew=;
        b=zYvdRFklTkTIM/nbCvIgbmuFwwS45A2j3vrJeJMTpHqewCkKumtlhAFrekDupVBHQi
         CEsh1LBRD9ov/n4n2cfETo27X7EyWWA8KZuAjNZ1EKSmSvYwiwM9T5I4VGzAP9rd2v4r
         2AJ/445L5AhguLWDXP+86jZkN0OZBksfejQwnDxK8KMgava2HsRVSvmxnarEoR4P8Yoz
         PNbVAYHO4Zi/n6d/1JytooZup5T7KjrqA1eE57CqYrxsgUjaNI1GJsrXiQKwPFwT63zH
         L0YZWDTA3nkDtm5F8M1E/S7fPNXh8wjhRAa+ektTljAloWV5dt1PclBH7xfUzOHyQCf9
         7mGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7hajhGKYbz9Pv9aUNy7fvHRk680trSNK3uThLWP18Ew=;
        b=jzlDYkRtXJbz6M9X9wkU1vxPhbTkBw3nkrbxjCk14ucQ2g1kMFmPNbItZa4GqU7jmY
         5jv0GXaFtKwkCNfCczehTkD+gIBd6lGjaSIqa5lIbGjoQXYT4C2roXdcGQ0/3knAqfIZ
         GU8VkpylYW40LILSyOGsCmrP2ozZV89urDSPyFQtWPC2EqlM2ygv8qisnm/Mkc56yqi5
         W/G/w1eyAuoXXULLmhmA++QW+uVwDwMMCN38n9RqjKJ+O5apFLKPFMgWw1AneTRSAXkF
         iPNM36n+40/+azC/s4+Dc2W043CQu3JMDss6Z7FzNQek420Y6zMXuDTinCgX98RUQqWp
         ppEQ==
X-Gm-Message-State: APjAAAUT4pLq7wytm7Mjh8sRBqxDqE1L4cxgbyxeMKAJF9ukn0C0kVtP
        wj1fxxHeteZC+5+bnyAcYj894P7m73OAF5rdQIOn4A==
X-Google-Smtp-Source: APXvYqwoZ6I3uIszPGd2pVKgUsdhCgH2YwJEOyz4zGDzGyRq3wUwWWbotxgfY/vswwuDGDJ7A5YPrXhKgTPy67qz/SU=
X-Received: by 2002:a7b:c392:: with SMTP id s18mr5819447wmj.61.1574177693353;
 Tue, 19 Nov 2019 07:34:53 -0800 (PST)
MIME-Version: 1.0
References: <20191108122240.28479-1-ardb@kernel.org> <20191115060727.eng4657ym6obl4di@gondor.apana.org.au>
 <CAHmME9oOfhv6RN00m1c6c5qELC5dzFKS=mgDBQ-stVEWu00p_A@mail.gmail.com>
 <20191115090921.jn45akou3cw4flps@gondor.apana.org.au> <CAHmME9rxGp439vNYECm85bgibkVyrN7Qc+5v3r8QBmBXPZM=Dg@mail.gmail.com>
In-Reply-To: <CAHmME9rxGp439vNYECm85bgibkVyrN7Qc+5v3r8QBmBXPZM=Dg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 19 Nov 2019 16:34:42 +0100
Message-ID: <CAKv+Gu96xbhS+yHbEjx6dD-rOcB8QYp-Gnnc3WMWfJ9KVbJzcg@mail.gmail.com>
Subject: Re: [PATCH v5 00/34] crypto: crypto API library interfaces for WireGuard
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Jason,

On Tue, 19 Nov 2019 at 16:18, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hey Ard, Herbert, Dave,
>
> The series looks fine. Ard -- thanks so much for picking up the work
> and making this happen. As far as I'm concerned, this is "most" of
> Zinc, simply without calling it "Zinc", and minus a few other things
> that I think constitutes an okay compromise and good base for moving
> forward.
>
> Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
>

Thanks!

> The TODO list for me remains the same, and now I can get moving with that:
>
> - Zinc's generic C implementation of poly1305, which is faster and has
> separate implementations for u64 and u128.
> - x86_64 ChaCha20 from Zinc. Will be fun to discuss with Martin and Andy.
> - x86_64 Poly1305 from Zinc.

As I pointed out in the private discussions we had, there are two
aspects two AndyP's benchmarking that don't carry over 100% to the
Linux kernel:
- Every microarchitecture is given equal weight, regardless of the
likelihood that the code will actually run on it. This makes some
sense for OpenSSL, I guess, but not for the kernel.
- Benchmarks are typically based on the performance of the core
cryptographics transformation rather than a representative workload.
This is especially relevant for network use cases, where packet sizes
are not necessarily fixed and usually not a multiple of the block size
(as opposed to disk encryption, where every single call is the same
size and a power of 2)

So for future changes, could we please include performance numbers
based on realistic workloads?

> - Resurrecting the big_keys patch and receiving DavidH's review on that.

My concern here (but we can discuss it in the context of a repost) is
that this will pull the accelerated chacha20 and poly1305 code (if
enabled)  into the core kernel, given that big_keys is not a tristate
option. So perhaps we can park this one until we know how to proceed
with static calls or alternative approaches?

> - WireGuard! Hurrah!
>

I'm a bit surprised that this only appears at the end of your list :-)

> If you have any feedback on how you'd like this prioritized, please
> pipe up. For example Dave - would you like WireGuard *now* or sometime
> later? I can probably get that cooking this week, though I do have
> some testing and fuzzing of it to do on top of the patches that just
> landed in cryptodev.
>

We're at -rc8, and wireguard itself will not go via the crypto tree so
you should wait until after the merge window, rebase it onto -rc1 and
repost it.
