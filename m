From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Mon, 20 Mar 2017 12:19:32 +0530
Message-ID: <CANc+2y5gv2ygSM4HF69XCW7Bb8UUHN+qJKq0os-mOvYknH+SeQ@mail.gmail.com>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:33565 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdCTGte (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Mar 2017 02:49:34 -0400
Received: by mail-ua0-f181.google.com with SMTP id u30so70994131uau.0
        for <linux-crypto@vger.kernel.org>; Sun, 19 Mar 2017 23:49:33 -0700 (PDT)
In-Reply-To: <20170318092554.lggkhfg5eko23o3k@kozik-lap>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I looked at Exynos Pseudo Random Nubmer Generator driver
> (drivers/char/hw_random/exynos-rng.c) and noticed that it always seeds
> the device with jiffies.  Then I looked at few other drivers and found
> that they do not seed themself (or at least I couldn't find this).

HW random interface is meant for true RNG, not pseudo RNG. Actually
PRNGs should use AF_ALG interface. I think exynos-rng.c should follow
the same.

> I think the hw_random API does not provide generic infrastructure for
> seeding.
>
> What is the preferred approach for seeding a PRNG device? Use jiffies or
> a fixed value?
>
> Or maybe the interface should be abandoned in favor of crypto API?

AF_ALG interface for rng does have seeding support. I think hw_random
does not provide seeding support intentionally as I understand that
True RNG need not require seeding (please correct me if I am wrong).

Regards,
PrasannaKumar
