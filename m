From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>
Subject: Re: [PATCH] dm: switch dm-verity to async hash crypto API
Date: Thu, 26 Jan 2017 12:34:13 +0100
Message-ID: <CAAUqJDsC8BVnudsirn96O2qTHh4jMmYYe4YBiO83UW-PGfy+Qg@mail.gmail.com>
References: <1485268704-31033-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-crypto@vger.kernel.org, gilad.benyossef@arm.com,
        Ofir <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36525 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdAZLef (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 06:34:35 -0500
Received: by mail-lf0-f66.google.com with SMTP id h65so23368532lfi.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Jan 2017 03:34:34 -0800 (PST)
In-Reply-To: <1485268704-31033-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Gilad,

2017-01-24 15:38 GMT+01:00 Gilad Ben-Yossef <gilad@benyossef.com>:
> -       v->tfm = crypto_alloc_shash(v->alg_name, 0, 0);
> +       v->tfm = crypto_alloc_ahash(v->alg_name, 0, CRYPTO_ALG_ASYNC);

I believe you should pass zero as the mask here. When flags == 0 and
mask == CRYPTO_ALG_ASYNC, you are basically saying "I want only algs
that have flags & CRYPTO_ALG_ASYNC == 0", which means you should only
get ahash tfms that are always synchronous (see [1]). However, since
you set a non-NULL callback in verity_hash_init, I don't think this
was your intention. By setting the mask to zero, you should be able to
get also an actual async tfm.

Thanks,
Ondrej

[1] https://lkml.org/lkml/2016/12/13/904
