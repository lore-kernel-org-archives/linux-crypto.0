Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F0DC4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A564420673
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B9udUHxd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbfJNMxu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:53:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45677 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731471AbfJNMxt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:53:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so19558938wrm.12
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7K03ojuhZUEPufhw8dvRl32iX1dIUuNh6+Mii0jm8s=;
        b=B9udUHxdqqZFbwa3QaYJihbJ92a/4zyCUfTCoMoH3snFDeKWCDFvz7+QYn4yc5sibq
         8NHLm/7Ib6oboGCi7SSbOn0FdI1E+hm83mJVKzEt5zEFQ+4c+1gUeKNHNcLySy1VJipU
         K0kosp9H7LRKqnzz/eWmCeMdsBAdVY0UMY70i4tbWD2mc1Rf2c9HfpPL+EUdxKTp1rJN
         Gd7JmVON/TwIU7ECGnImQvkXS2hRg8mQs66EskEGgzU98bpTyg3Qq51hDevjg53U6PTz
         kUDyYQW6re87E7vIDWbLXlpoHhkKqOS5AgPMrIyXDx+LQJcjseYoYwpVp8r/xSSKa5SB
         Nv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O7K03ojuhZUEPufhw8dvRl32iX1dIUuNh6+Mii0jm8s=;
        b=ktt10SLhrAe8y8DBxMLksJblDvfXslsZX51u6VN+R22IruDpUMLHk3jL3KzZMF8ITg
         z6Uo4+UHNC/cvBfA3Urje+aQjelAIjxPbQ76KqAcRVSWDjWxQGUbFAPSZ3YZYDck4AQ7
         aQatVl5GdLhXCLBSKhbppCYMcY7F8xbIyfZ1TAD61XqOZIypYtqxJhfaPLP4SrC78g9b
         ZAlLs8c6Ec5wq9gLKP4s1delkh+ckDNdLyDJ9ah4WlcrDiGWGIkxeldbnEXMnEQ5lmOA
         Oi1m3pg6JYC159qyS0TDF36RKnRFEE5Uy+dnZ7/a0PJxjRNPUnzBaRy7cXkFWsKlLF7L
         J31Q==
X-Gm-Message-State: APjAAAXGSW207RJbPfMmoLjBAEui8BhqAJpkNBejdi8AmKdfw9t81hwh
        qQ7gPamCRFiXqz8aSHGdCDDgfMC+X4CgheE6snzgmA==
X-Google-Smtp-Source: APXvYqz1g1K3bZw+Yaf4FiZgz4EcDEjg2qtRzDMh9qVgwR+/GOFLHIGXYIr3PKpRqDaZ1w6YrLqviMG8/pyFspJEeJg=
X-Received: by 2002:adf:9f08:: with SMTP id l8mr24595014wrf.325.1571057626382;
 Mon, 14 Oct 2019 05:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-22-ard.biesheuvel@linaro.org> <20191011060232.GB23882@sol.localdomain>
 <20191011164550.GA203415@zx2c4.com>
In-Reply-To: <20191011164550.GA203415@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 14 Oct 2019 14:53:35 +0200
Message-ID: <CAKv+Gu9R25f+jxMLDPD2PTvrH5n9PPLx_Sb1foo4mUgm8A3D6Q@mail.gmail.com>
Subject: Re: [PATCH v3 21/29] crypto: BLAKE2s - generic C library
 implementation and selftest
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 11 Oct 2019 at 18:46, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Oct 10, 2019 at 11:02:32PM -0700, Eric Biggers wrote:
> > FYI, I had left a few review comments on Jason's last version of this patch
> > (https://lkml.kernel.org/linux-crypto/20190326173759.GA607@zzz.localdomain/),
> > some of which Jason addressed in the Wireguard repository
> > (https://git.zx2c4.com/WireGuard) but they didn't make it into this patch.
> > I'd suggest taking a look at the version there.
>
> Indeed I hadn't updated the Zinc patchset since then, but you can see
> the changes since ~March here:
>
> https://git.zx2c4.com/WireGuard/log/src/crypto
>
> There are actually quite a few interesting Blake changes.

I've picked up a recent version of your Blake2s sources for my v4 series.

Thanks,
Ard.
