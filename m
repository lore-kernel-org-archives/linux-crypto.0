Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C43EC10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 21:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3A4820869
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 21:04:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ltcO7Qok"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfDLVEc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:04:32 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:32806 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfDLVEc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 17:04:32 -0400
Received: by mail-io1-f67.google.com with SMTP id b6so9757536iog.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2019 14:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qK/IDknbZvSng84vQB6uW8bSSLKD4tLbJLorA2G3dVg=;
        b=ltcO7QokKrQFEj1mqjZ3AOo259vnNfEtAqFbK/jFCCcuOlmfABNgRFxckh/CVZZ9X2
         IsEwfWYOh7f6D52yuxAOxPAlgr/7mm/LZjr9VWJsP/GCWjkTcWyCtrImCeNZ80vZImgx
         bNizzBeH6qc0EBpv643GdkC9gtAsX13sjk6Eh5tWQN5oJjdqDZnJVvRVkRiRTO7eEX/j
         fpqQqTaoHp/xakgJ/tZOvmYKlwq9M86UoaLXJENk9Y81zcwp80vd8k/Ntn77jGYoxgvd
         ELFqUDPCecNnNdMYbfvToUbJxhCmhKINeildrFYgBw+vXpzkuUdXSSvkz4oy1xHPr5EQ
         O1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qK/IDknbZvSng84vQB6uW8bSSLKD4tLbJLorA2G3dVg=;
        b=unNDmP9qj4A4jQXbuM40rqcyZI8zBtrzI8imbpRjXKNnz1GNSxaMl+9vKoCdtIkx9j
         KwDScUvg4ArQ62Fwj63iGwULFJk9kGrest78Am95yzLndD3h6gc6xrVT9bUpNg2gqh0i
         DTgOj2ncSSXOBdtdAhYi/KVm1E2UgsXsMMf61vNoekt70Gnu6OfshhmaA+3EB6TuZMQm
         uCuSUzP+ZwPLWJQok/t73of4R9zdn6qbnZTg6qK7/7DlD9kJAfsNOQfMwdK+wTAemgqU
         eQ8ySYvSvCbuZ3/eBJwY1OfVL+/PV/9sPyAoLJWr/v2CM0fJv2IDd0tTvUkxJLrxW/jZ
         r+zg==
X-Gm-Message-State: APjAAAVGa5t7IGTiCGGVWAh02CmsH9pLRmUP8+X3WkX1gnFV9sZm6DKK
        sIHsaepMwJcO9UFEMLlg/aPZ2gvHthQ0PpyeTj/kVQ==
X-Google-Smtp-Source: APXvYqxh1ehYn5BmAAnVzC2NC3IZdZ+Mwvj+0B470hqEMJ1oOYTIXu/+jqNsVCEyHgN3TkVo+srEuvMahFuGk1XNHi8=
X-Received: by 2002:a6b:f201:: with SMTP id q1mr32176909ioh.197.1555103071481;
 Fri, 12 Apr 2019 14:04:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190412045742.1725-1-ebiggers@kernel.org>
In-Reply-To: <20190412045742.1725-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 12 Apr 2019 14:04:20 -0700
Message-ID: <CAKv+Gu_CyA1NnkMFN9zJ4kJ5ACo5FD_ZvBAqcWu07WiWD0A93g@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] crypto: fuzz algorithms against their generic implementation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 11 Apr 2019 at 22:00, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hello,
>
> In the crypto API, all implementations of each algorithm are supposed to
> produce the same results.  However, testing of this is currently limited
> to the list of test vectors hardcoded for each algorithm.  Although
> after recent improvements the self-tests do much more with each test
> vector, hardcoded test vectors can never cover all cases.
>
> This series improves the situation by making the self-tests
> automatically generate random test vectors using the corresponding
> generic implementation, then run them against the algorithm under test.
> This detects bugs where the implementations don't match.
>
> This has already found many bugs and inconsistencies, including an
> integer overflow bug in the x86_64 implementation of Poly1305.
>
> These new fuzz tests are behind CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.
>
> Patch 1-6 are the testmgr changes themselves.  Patch 7 makes the generic
> implementations be registered earlier so that they're available when
> optimized implementations are being tested, when both are built-in.
> Note that even after this, for many algorithms it's still possible to
> make the generic implementation unset or modular.  Thus a missing
> generic implementation just causes the comparison tests to be skipped
> with a warning; they aren't failed.
>
> So far I've tested all generic, x86, arm, and arm64 algorithms, plus
> some PowerPC algorithms.  I have not tested hardware drivers.  I
> encourage people to run the tests on drivers and other architectures, as
> they will find more bugs.
>
> This can also be found in git at:
>
>         URL: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
>         Branch: cryptofuzz-vs-generic
>
> Changed since v1:
>
>     - Make cryptomgr use arch_initcall(), so we don't rely on the order
>       in which the object files are linked.
>
>     - Show the expected error code when a test fails due to the wrong
>       error code being returned.
>
>     - Generate zero-length associated data more often for AEADs
>       (about 1/4 of the time rather than about 1/256 of the time).
>
>     - A few other minor cleanups.
>
> Eric Biggers (7):
>   crypto: testmgr - expand ability to test for errors
>   crypto: testmgr - identify test vectors by name rather than number
>   crypto: testmgr - add helpers for fuzzing against generic
>     implementation
>   crypto: testmgr - fuzz hashes against their generic implementation
>   crypto: testmgr - fuzz skciphers against their generic implementation
>   crypto: testmgr - fuzz AEADs against their generic implementation
>   crypto: run initcalls for generic implementations earlier
>

This looks alright to me, but I have to admit I did not look at every
patch in great detail. I did put it through kernelci, though, and it
built and booted fine on all systems.

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


>  crypto/842.c                 |   2 +-
>  crypto/adiantum.c            |   2 +-
>  crypto/aegis128.c            |   2 +-
>  crypto/aegis128l.c           |   2 +-
>  crypto/aegis256.c            |   2 +-
>  crypto/aes_generic.c         |   2 +-
>  crypto/algboss.c             |   8 +-
>  crypto/ansi_cprng.c          |   2 +-
>  crypto/anubis.c              |   2 +-
>  crypto/arc4.c                |   2 +-
>  crypto/authenc.c             |   2 +-
>  crypto/authencesn.c          |   2 +-
>  crypto/blowfish_generic.c    |   2 +-
>  crypto/camellia_generic.c    |   2 +-
>  crypto/cast5_generic.c       |   2 +-
>  crypto/cast6_generic.c       |   2 +-
>  crypto/cbc.c                 |   2 +-
>  crypto/ccm.c                 |   2 +-
>  crypto/cfb.c                 |   2 +-
>  crypto/chacha20poly1305.c    |   2 +-
>  crypto/chacha_generic.c      |   2 +-
>  crypto/cmac.c                |   2 +-
>  crypto/crc32_generic.c       |   2 +-
>  crypto/crc32c_generic.c      |   2 +-
>  crypto/crct10dif_generic.c   |   2 +-
>  crypto/crypto_null.c         |   2 +-
>  crypto/ctr.c                 |   2 +-
>  crypto/cts.c                 |   2 +-
>  crypto/deflate.c             |   2 +-
>  crypto/des_generic.c         |   2 +-
>  crypto/dh.c                  |   2 +-
>  crypto/drbg.c                |   2 +-
>  crypto/ecb.c                 |   2 +-
>  crypto/ecdh.c                |   2 +-
>  crypto/echainiv.c            |   2 +-
>  crypto/fcrypt.c              |   2 +-
>  crypto/fips.c                |   2 +-
>  crypto/gcm.c                 |   2 +-
>  crypto/ghash-generic.c       |   2 +-
>  crypto/hmac.c                |   2 +-
>  crypto/jitterentropy-kcapi.c |   2 +-
>  crypto/keywrap.c             |   2 +-
>  crypto/khazad.c              |   2 +-
>  crypto/lrw.c                 |   2 +-
>  crypto/lz4.c                 |   2 +-
>  crypto/lz4hc.c               |   2 +-
>  crypto/lzo-rle.c             |   2 +-
>  crypto/lzo.c                 |   2 +-
>  crypto/md4.c                 |   2 +-
>  crypto/md5.c                 |   2 +-
>  crypto/michael_mic.c         |   2 +-
>  crypto/morus1280.c           |   2 +-
>  crypto/morus640.c            |   2 +-
>  crypto/nhpoly1305.c          |   2 +-
>  crypto/ofb.c                 |   2 +-
>  crypto/pcbc.c                |   2 +-
>  crypto/pcrypt.c              |   2 +-
>  crypto/poly1305_generic.c    |   2 +-
>  crypto/rmd128.c              |   2 +-
>  crypto/rmd160.c              |   2 +-
>  crypto/rmd256.c              |   2 +-
>  crypto/rmd320.c              |   2 +-
>  crypto/rsa.c                 |   2 +-
>  crypto/salsa20_generic.c     |   2 +-
>  crypto/seed.c                |   2 +-
>  crypto/seqiv.c               |   2 +-
>  crypto/serpent_generic.c     |   2 +-
>  crypto/sha1_generic.c        |   2 +-
>  crypto/sha256_generic.c      |   2 +-
>  crypto/sha3_generic.c        |   2 +-
>  crypto/sha512_generic.c      |   2 +-
>  crypto/sm3_generic.c         |   2 +-
>  crypto/sm4_generic.c         |   2 +-
>  crypto/streebog_generic.c    |   2 +-
>  crypto/tcrypt.c              |   2 +-
>  crypto/tea.c                 |   2 +-
>  crypto/testmgr.c             | 989 +++++++++++++++++++++++++++++++----
>  crypto/testmgr.h             |  22 +-
>  crypto/tgr192.c              |   2 +-
>  crypto/twofish_generic.c     |   2 +-
>  crypto/vmac.c                |   2 +-
>  crypto/wp512.c               |   2 +-
>  crypto/xcbc.c                |   2 +-
>  crypto/xts.c                 |   2 +-
>  crypto/zstd.c                |   2 +-
>  85 files changed, 986 insertions(+), 197 deletions(-)
>
> --
> 2.21.0
>
