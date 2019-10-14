Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CF4C4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ABA520673
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:47:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hEqY218f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbfJNMrK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:47:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55640 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730733AbfJNMrK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:47:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id a6so17113673wma.5
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TTkA/5vTH9Kh1+XMRC6xhgxSKGDJRglBVbRfMO0b/uY=;
        b=hEqY218fHzvciuduGiB8zmFUf3M0b55irActkL0tbSl4V9ZW4yb2Gr8EbVZxRMUsak
         2EEDG50n39iM1awJUJkvRG97oYZz4tX+EHLKLEWOvREf7Z+JrfkMUrZOYLfZRc00jEkg
         nrVFXNnLewGGtjWGzUsToPdaKNUKUpRuEKib7gDmcS3p2OjkfxvwZJ7CXQm3Ih8mEHBm
         GE6vtINAN+YDEePf/L+gWdG50qaKyATPJGNdeMnaVlUF12tOrKmIn987WhZLHvqp1FAU
         g75RQPG+tf4W76LB+oak+hQgOfGxgfngYrv3QwPf32ZJjQA1ssRuMpJ0Z6fobZCq9RKG
         rJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TTkA/5vTH9Kh1+XMRC6xhgxSKGDJRglBVbRfMO0b/uY=;
        b=rXpek6rSIQzyuMVelxqf6kYutioFeRSf0uFbRyryXeGQQng7rre5bEp7u3mE9OBH8k
         /h0xIlUO0Tt2pBjoygrj+JG5eIyp2IMBez1Ml3CWy59S+W66oVVxqEabDVOQDSXUNn7t
         oPv5n1tf2mGb1Vb4nfqltFCQc1C5mAEM9EFrm2D+5Y1IUxyCMkIMZiuAHDEdlv+1JTeF
         DF/RD67M6tW1oCJP3ngEdfF50/YrADW1Xw7lZtANZT4Y34QgHi/Js5jXzhUjRMpKgVQC
         hdv7EFM47ijLZlYdbR7XuweGkn4WTR5S+G7tY3/nwldLUJ2WZmpi4iKnjrX1Sxz1HMUI
         DElw==
X-Gm-Message-State: APjAAAXS3hc8ckLuKKZvvGawNKT3pLhQzgfAaNXmEAcAkL0rIS/tS/Uq
        KaYmStXq57R2IcOEIr3Mwiz5yUg23azCbu7O3GG9zw==
X-Google-Smtp-Source: APXvYqyE7O3ty6hTTmcwGxRp3tsZOYJcvZhkhjALW6bQaoAI0SUEL4togKyAb9MuENgPYvjAUi4POYXXDr99Yki0TjM=
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr15281643wml.10.1571057226626;
 Mon, 14 Oct 2019 05:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191012201809.160500-1-ebiggers@kernel.org>
In-Reply-To: <20191012201809.160500-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 14 Oct 2019 14:46:55 +0200
Message-ID: <CAKv+Gu_HWop7ry=PKMjYrY8EcZN2dmJnqWRE=VPR2ep7OFEBVw@mail.gmail.com>
Subject: Re: [RFT PATCH 0/3] crypto: s390 - convert to skcipher API
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 12 Oct 2019 at 22:20, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series converts the glue code for the S390 CPACF implementations of
> AES, DES, and 3DES modes from the deprecated "blkcipher" API to the
> "skcipher" API.  This is needed in order for the blkcipher API to be
> removed.
>
> I've compiled this patchset, and the conversion is very similar to that
> which has been done for many other crypto drivers.  But I don't have the
> hardware to test it, nor is S390 CPACF supported by QEMU.  So I really
> need someone with the hardware to test it.  You can do so by setting:
>
> CONFIG_CRYPTO_HW=y
> CONFIG_ZCRYPT=y
> CONFIG_PKEY=y
> CONFIG_CRYPTO_AES_S390=y
> CONFIG_CRYPTO_PAES_S390=y
> CONFIG_CRYPTO_DES_S390=y
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_DEBUG_KERNEL=y
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_XTS=y
>
> Then boot and check for crypto self-test failures by running
> 'dmesg | grep alg'.
>
> If there are test failures, please also check whether they were already
> failing prior to this patchset.
>
> This won't cover the "paes" ("protected key AES") algorithms, however,
> since those don't have self-tests.  If anyone has any way to test those,
> please do so.
>
> Eric Biggers (3):
>   crypto: s390/aes - convert to skcipher API
>   crypto: s390/paes - convert to skcipher API
>   crypto: s390/des - convert to skcipher API
>

These look fine to me:

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

but i cannot test them either.
