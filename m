Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A7EC432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 12:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A91D2068E
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 12:39:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Il9yVdFZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLCMjd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 07:39:33 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37479 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfLCMjc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 07:39:32 -0500
Received: by mail-wm1-f67.google.com with SMTP id f129so3294672wmf.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2019 04:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MyMcdHp2K0H8Xf4kwbcIc/jJgvEd2T5X4YN8iU45gmA=;
        b=Il9yVdFZzbZaPUj1ohbbehmm9zRyot/JUqKTlcpSKSCspMmzjGZxIfFTZgQXrozzHa
         FD+l8AZZBZGnOE17aI88s3cZ8SGiMkoQc9jMNPg3yXUxrmYq7twGOMV5bOERLIQgm9f9
         LuYqu0ikgz6AoXLfkv/WdGBU3p5cuyB3neCeG+aU48EOAOePXUxkCJoFhzJs9oit5R/d
         oJiCQqmnjVtWBoEnPihnXREUvQsGkgDtEI2c2lk+kQp4e276le/jBoP+Bj5SwjaOgeCc
         5F5DDhxmuGiYDWi4iX2RdRRANKqsP2V0U6qFBQpMx7KuKdQTOneq/ZKJS5IA/G5NPHDq
         yugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MyMcdHp2K0H8Xf4kwbcIc/jJgvEd2T5X4YN8iU45gmA=;
        b=kNtJSn4hHnd7JOCBItAYFToF9cC1rlRb36YRKZ5Xz24KviKHQkGbdra3zHJIOuXoH6
         oe41IzG8p57Q+8hcVsmRIz2Lcs9OM+YXBpdGjVfPaNVvFmeyAW/FwKKbS1SZzFcnB6pT
         prdLR84zlOsaxu5EXcXXDOILRy5lz57Z2fh/AkX2CArFyBfcEhsh2+M/Bzh083mv0SZ6
         dID+g2S18OD0W4HRK9hVO80m4dob+pwDyoFsoOKF750ph+gjs1NJHZd6E7SPN8J1TxPx
         d5u583m0t4KjeY6UjSSm4D7pIa7IdySnkzq369YSp86yvJbvBUzhVE2UvGUGn2iiXFlP
         CJhg==
X-Gm-Message-State: APjAAAUpJZAyauC321wXCHUWxYgEWc/u7u1j6qsnTqtjwQJb2ARQYT6L
        UaQizmsbMWv/CISZR+Othu0Sux8T8ZQNcktb6GGr1Q==
X-Google-Smtp-Source: APXvYqyUqfjZ4/YpIPYAOpn0Bs0d8xQOBDYqDS5qXtol4klWnmapYeMk+XHbTblTFbpC4KPmir0iIVWWWBegOOigomk=
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr32330206wmf.136.1575376770518;
 Tue, 03 Dec 2019 04:39:30 -0800 (PST)
MIME-Version: 1.0
References: <20191201215330.171990-1-ebiggers@kernel.org>
In-Reply-To: <20191201215330.171990-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 3 Dec 2019 12:39:26 +0000
Message-ID: <CAKv+Gu_5pcDeXxLnG_5_jMPc0VDBT3CFr5Hnpb-e4irPLu8JDg@mail.gmail.com>
Subject: Re: [PATCH 0/7] crypto: more self-test improvements
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 1 Dec 2019 at 21:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series makes some more improvements to the crypto self-tests, the
> largest of which is making the AEAD fuzz tests test inauthentic inputs,
> i.e. cases where decryption is expected to fail due to the (ciphertext,
> AAD) pair not being the correct result of an encryption with the key.
>
> It also updates the self-tests to test passing misaligned buffers to the
> various setkey() functions, and to check that skciphers have the same
> min_keysize as the corresponding generic implementation.
>
> I haven't seen any test failures from this on x86_64, arm64, or arm32.
> But as usual I haven't tested drivers for crypto accelerators.
>
> For this series to apply this cleanly, my other series
> "crypto: skcipher - simplifications due to {,a}blkcipher removal"
> needs to be applied first, due to a conflict in skcipher.h.
>
> This can also be retrieved from git at
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> tag "crypto-self-tests_2019-12-01".
>
> Eric Biggers (7):
>   crypto: aead - move crypto_aead_maxauthsize() to <crypto/aead.h>
>   crypto: skcipher - add crypto_skcipher_min_keysize()
>   crypto: testmgr - don't try to decrypt uninitialized buffers
>   crypto: testmgr - check skcipher min_keysize
>   crypto: testmgr - test setting misaligned keys
>   crypto: testmgr - create struct aead_extra_tests_ctx
>   crypto: testmgr - generate inauthentic AEAD test vectors
>

I've dropped this into kernelci again, let's see if anything turns out
to be broken.

For this series,

Acked-by: Ard Biesheuvel <ardb@kernel.org>

>  crypto/testmgr.c               | 574 +++++++++++++++++++++++++--------
>  crypto/testmgr.h               |  14 +-
>  include/crypto/aead.h          |  10 +
>  include/crypto/internal/aead.h |  10 -
>  include/crypto/skcipher.h      |   6 +
>  5 files changed, 461 insertions(+), 153 deletions(-)
>
> --
> 2.24.0
>
