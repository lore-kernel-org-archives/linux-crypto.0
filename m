Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C026CA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 09:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E29921872
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 09:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yzL0gp6+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390518AbfJWJBl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 05:01:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38892 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732361AbfJWJBk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 05:01:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id v9so9882897wrq.5
        for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2019 02:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zKA2yt/mOAtXmJcD13lyptJqZL8K+Y2yOfZEZ10ZchA=;
        b=yzL0gp6+4cMyiKnWvYNBRq3yeZoBXCDGzSEMgGa1oinUQgNnymkg9FVOd8wWmTTEOo
         xjZo/1WG+xOhpfTiTFpNwZmGAHn/obrkLwoE/iUskWO+zm5SC37PpLh7u5akPksbNukB
         4fApgcSlsXkhB5MutWIDz5wU2yboRbezXAcUS4LvwSK9t4i2KdeINWDyrne7eA/wqjF9
         DSMkreRSHVyi+h8CXCizoellGVbptSvsma5KiQOsPOfKwOA2I9ITvcr7hGQvkLJiskHe
         t+9zeKJoOf7qGto8CLXPnrO51UBqmzls/yoniwS3pO5lqR4N/Y7zDUkeC92miiQPtMsm
         uvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zKA2yt/mOAtXmJcD13lyptJqZL8K+Y2yOfZEZ10ZchA=;
        b=jdg4RS5AUpRvL8xObjikg4BXoyQfRCT/+d2K1sTPD/O/Bf+cQzkRrDPDXEf2zVS5dj
         zsKKJD29SDFHvtuVmx+cnDkMkHpSsGDjmY7LfGl1h2XA9RgA1TLTCLkfa8QQBPmH7Qzk
         TxW01dJQ+QRwwNsriYVL/SXl4PU+UKADrANvScJPWIAdUes26CecPuLOvlHzeLpc2iOw
         dozlxTMnpo03R3AmbHnHwJQ+sM+Xo5WrQ0W3YgeYGmrOJ7Soii44c7MEdOhCLH18wU3p
         JMMzP0f62yi7J/xsMPOKFp+xs43NGsoYrnsbaZrM6nideGN+YpR6McakWXxhpH0q8yYG
         PYWw==
X-Gm-Message-State: APjAAAWnYvDAsSdisbO6ov6tqg+iUpUuuJcX32CE7cCcDVKCn/nfvPu9
        yLGA3jTzaialtq0WqEluMMx+GXBnMjEJZOBZ9EIggDXmLV221w==
X-Google-Smtp-Source: APXvYqx0H5xX8gqSchs8cQu2ttN78EyA6GddEwpL+a0Kdg1H2vMgf1bZ1Djp+dqNqFvlgsQenWNzF5aim3fQGse1QZQ=
X-Received: by 2002:adf:9f08:: with SMTP id l8mr7002124wrf.325.1571821297091;
 Wed, 23 Oct 2019 02:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571788861.git.dsterba@suse.com>
In-Reply-To: <cover.1571788861.git.dsterba@suse.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 23 Oct 2019 11:01:25 +0200
Message-ID: <CAKv+Gu_yhm2hL+Sx6ZC3xWLcWuJLn+0erQaK6_NpL-aZo72AbA@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] BLAKE2b generic implementation
To:     David Sterba <dsterba@suse.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 23 Oct 2019 at 02:12, David Sterba <dsterba@suse.com> wrote:
>
> The patchset adds blake2b reference implementation and test vectors.
>
> V6:
>
> Patch 2/2: test vectors fixed to actually match the proposed table of
> key and plaintext combinations. I shamelessly copied the test vector
> value format that Ard uses for the blake2s test vectors. The array
> blake2b_ordered_sequence can be shared between 2s and 2b but as the
> patchsets go separate, unification would have to happen once both
> are merged.
>
> Tested on x86_64 with KASAN and SLUB_DEBUG.
>

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org> # arm64 big-endian


> V1: https://lore.kernel.org/linux-crypto/cover.1569849051.git.dsterba@suse.com/
> V2: https://lore.kernel.org/linux-crypto/e31c2030fcfa7f409b2c81adf8f179a8a55a584a.1570184333.git.dsterba@suse.com/
> V3: https://lore.kernel.org/linux-crypto/e7f46def436c2c705c0b2cac3324f817efa4717d.1570715842.git.dsterba@suse.com/
> V4: https://lore.kernel.org/linux-crypto/cover.1570812094.git.dsterba@suse.com/
> V5: https://lore.kernel.org/linux-crypto/cover.1571043883.git.dsterba@suse.com/
>
> David Sterba (2):
>   crypto: add blake2b generic implementation
>   crypto: add test vectors for blake2b
>
>  crypto/Kconfig           |  17 ++
>  crypto/Makefile          |   1 +
>  crypto/blake2b_generic.c | 413 +++++++++++++++++++++++++++++++++++++++
>  crypto/testmgr.c         |  28 +++
>  crypto/testmgr.h         | 307 +++++++++++++++++++++++++++++
>  include/crypto/blake2b.h |  46 +++++

Final nit: do we need this header file at all? Could we move the
contents into crypto/blake2b_generic.c? Or is the btrfs code going to
#include it?



>  6 files changed, 812 insertions(+)
>  create mode 100644 crypto/blake2b_generic.c
>  create mode 100644 include/crypto/blake2b.h
>
> --
> 2.23.0
>
