Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F270CA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 15:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4105721906
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 15:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fwPybnN6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390589AbfJWPET (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 11:04:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40776 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390431AbfJWPET (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 11:04:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id o28so22487296wro.7
        for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2019 08:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xs3N+qjJoZjVu9sdk04MwffIZjMXK0GCiruavAYOf4M=;
        b=fwPybnN6kV22dKMCK3eau6fN2Q5L8kkDhjI7ivAG/k4MNUsTHSUFlTETkWn7pohdQ2
         RnZOKi32xvCpyNBF21lTx1TjcIX2PZUdDC0yIdyt6PvbmJp9DOpx2nutI77/GvJAVhv9
         JW84vVTfurHan6eBjI3vZOBRJ7PrSB2vexlTZVDL8KtS2bIXlKZY/PD8fT/A//kFARzk
         AKNPaRumFb/5+apcN/lsFUTBlxQ3jR7V4LNEvzWWmyvBj2JBDPZYSaeHR/7hAzK4O8iX
         7MgP4Gj80Z0xrHfCfF9L0Dqj9g67x0PNv0Puj1sQelzJA4KYVcXua5662+tMZ8D9iElk
         4B9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xs3N+qjJoZjVu9sdk04MwffIZjMXK0GCiruavAYOf4M=;
        b=GgQ78OHGYhYtA18QBhF66mOJXr+SQN4U1WjKe4qh0u5rYGaKjtMFCXRIpHnZ3E40ZX
         sD3RCd2dEHDDvbzCfk+ukI/T1jdDyHnu/0Fd52JsY7qXNz1h5zVYkE2m2Km0rZhaTRXF
         xeIvbufdprdtN4As7Ff3UqpCEvX26fY6zuhnK9WxNPh+vIzhjO8Zdhk65qctoPnPQbC+
         qAIHDaQ2chjJYIcWd889ZGSMsvvPlot4ZmLKNBPuItpkHj/y4+fNCkp57XMTPkqPjfyd
         uM+pQcQ44tHSRpJWVt4FMe0NT/lnnlWE/FSP4MXAYQOuEpE/6wjSORyq++U2M1aJA4TV
         gDuA==
X-Gm-Message-State: APjAAAWQSjoUg4e/BxgfJ4BPGIBb4t7h11hEV079yeX1FkX5zBzYfkb4
        ggf8am+qJ0FPx3hlKiHyGu5Vrs5Ckh61vKqctTa9JyVKMSvpwg==
X-Google-Smtp-Source: APXvYqwr6sIxE/kB+KhhtGVAbL+wI10fRC0nAmLI1RpXXM1yt7LSymP3SpckLgiVf8s2MNaH6tV6By+K8xzfnRPKvxw=
X-Received: by 2002:a5d:6b0a:: with SMTP id v10mr8393910wrw.32.1571843056877;
 Wed, 23 Oct 2019 08:04:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-26-ard.biesheuvel@linaro.org> <20191023045511.GC361298@sol.localdomain>
 <CAHmME9oei5_9CpXoeMgD2MO5JWGc=Sm_pXJpmUfOuipbFRSTsg@mail.gmail.com>
In-Reply-To: <CAHmME9oei5_9CpXoeMgD2MO5JWGc=Sm_pXJpmUfOuipbFRSTsg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 23 Oct 2019 17:04:05 +0200
Message-ID: <CAKv+Gu9P=ui+qZnMOxD5nyOURK=5i2W+MxxoxfPRn=dH0tjpaA@mail.gmail.com>
Subject: Re: [PATCH v4 25/35] crypto: BLAKE2s - x86_64 SIMD implementation
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 23 Oct 2019 at 16:08, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Oct 23, 2019 at 6:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > There are no comments in this 685-line assembly language file.
> > Is this the original version, or is it a generated/stripped version?
>
> It looks like Ard forgot to import the latest one from Zinc, which is
> significantly shorter and has other improvements too:
>
> https://git.zx2c4.com/WireGuard/tree/src/crypto/zinc/blake2s/blake2s-x86_64.S

I can pick that up for v5. But that doesn't address Eric's question though.
