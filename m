Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3DBCA9EB9
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 15:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F6020663
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 15:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i9YBDDSs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfJZPcI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 11:32:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33171 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfJZPcI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 11:32:08 -0400
Received: by mail-wm1-f65.google.com with SMTP id 6so6368088wmf.0
        for <linux-crypto@vger.kernel.org>; Sat, 26 Oct 2019 08:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7eL/Q6CJwzV4y80pnJNKU63D4qrd7HhYaSFbuj/Se+I=;
        b=i9YBDDSssWCGgcPMoSckEmP3ZiSDG2DVk67NhNH2kjdMv0DL2tpHm0xivNsNTrNS7U
         zWB1ImnpcDWm78HAeGbofscYcrp69bzyM/lo6DdrZI6xAQq+AqLzIRhyFGCuiPER6x/L
         nOCaigVqJXXzR62yU7i9Wje77JyeHaJKQowDUmSBF/xRNVSjpzX6asjlqI5oixXzBxVg
         NBeiMw9mSkh7QSyOEjhENNdJg9yfdzw/fR6jClXzIlJb6/LRTsNt5I3nl0hzNfi5GGQI
         MMdK4sBbejr9d/sLuogOU868rywj1uvrOKxRssK8tZGReWUPR0jOniNJqnh8GijoNqW6
         cOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7eL/Q6CJwzV4y80pnJNKU63D4qrd7HhYaSFbuj/Se+I=;
        b=a7E+VTzGhoN2n0EefvBpL7PL150yuebrJqPsLVFs4ZR1Xwf09DolCsCuP3TqtFGEs5
         wRL/7nE+nIZq2m1jR2AGGCGKdxFCGPPxuNSyIE9PoScdm8broD6NA/jZ6KZqzw9T2KWU
         50bApAv7UaQpihWE2ge2EstrXwUOYi/3BdqRYfU0D4rbcoVPee66enWKq6kbCvqOfJ13
         1nG6RrBY1ZB2jfYpuO/M2rgvdOMEdvNQ1MUPPH65yScOWoPufaCehhF0Rsfpvf4eq8z3
         TnWwEM7jkxM5IoTVy5CjrYF7C1xV2UAW34rutf/YDz53QuB4M5IacbqKNhA+FyffpiJX
         UEeg==
X-Gm-Message-State: APjAAAVU5MSopqDFeAXrDigAJ+nzCzzO4KKjcnGQhwsGPjzrHoDf5d9w
        XqLMP9oONCBA5b2MhZHSAEjEhBViYmtMTXBnHtwo4Q==
X-Google-Smtp-Source: APXvYqyyucGawlh8ezUs5XthXW8fnGvDRmtPpdIpMT1S25GmkhznLllTEvPT7VB88bIhPtIvqKR1S4riyRJTPJY7BXs=
X-Received: by 2002:a1c:64d6:: with SMTP id y205mr7672841wmb.136.1572103926694;
 Sat, 26 Oct 2019 08:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191025194113.217451-1-ebiggers@kernel.org>
In-Reply-To: <20191025194113.217451-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 26 Oct 2019 17:32:05 +0200
Message-ID: <CAKv+Gu8Y2AnWfz8Up9V6YF9v7n-s_BYsMXbxMQ7s4tMNw5eusQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: remove blkcipher
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 25 Oct 2019 at 21:45, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Now that all "blkcipher" algorithms have been converted to "skcipher",
> this series removes the blkcipher algorithm type.
>
> The skcipher (symmetric key cipher) algorithm type was introduced a few
> years ago to replace both blkcipher and ablkcipher (synchronous and
> asynchronous block cipher).  The advantages of skcipher include:
>
>   - A much less confusing name, since none of these algorithm types have
>     ever actually been for raw block ciphers, but rather for all
>     length-preserving encryption modes including block cipher modes of
>     operation, stream ciphers, and other length-preserving modes.
>
>   - It unified blkcipher and ablkcipher into a single algorithm type
>     which supports both synchronous and asynchronous implementations.
>     Note, blkcipher already operated only on scatterlists, so the fact
>     that skcipher does too isn't a regression in functionality.
>
>   - Better type safety by using struct skcipher_alg, struct
>     crypto_skcipher, etc. instead of crypto_alg, crypto_tfm, etc.
>
>   - It sometimes simplifies the implementations of algorithms.
>
> Also, the blkcipher API was no longer being tested.
>
> Eric Biggers (5):
>   crypto: unify the crypto_has_skcipher*() functions
>   crypto: remove crypto_has_ablkcipher()
>   crypto: rename crypto_skcipher_type2 to crypto_skcipher_type
>   crypto: remove the "blkcipher" algorithm type
>   crypto: rename the crypto_blkcipher module and kconfig option
>


For the series

Acked-by: Ard Biesheuvel <ardb@kernel.org>

although obviously, this needs to wait until my albkcipher purge
series is applied.

>  Documentation/crypto/api-skcipher.rst |  13 +-
>  Documentation/crypto/architecture.rst |   2 -
>  Documentation/crypto/devel-algos.rst  |  27 +-
>  arch/arm/crypto/Kconfig               |   6 +-
>  arch/arm64/crypto/Kconfig             |   8 +-
>  crypto/Kconfig                        |  84 ++--
>  crypto/Makefile                       |   7 +-
>  crypto/api.c                          |   2 +-
>  crypto/blkcipher.c                    | 548 --------------------------
>  crypto/cryptd.c                       |   2 +-
>  crypto/crypto_user_stat.c             |   4 -
>  crypto/essiv.c                        |   6 +-
>  crypto/skcipher.c                     | 124 +-----
>  drivers/crypto/Kconfig                |  52 +--
>  drivers/crypto/amlogic/Kconfig        |   2 +-
>  drivers/crypto/caam/Kconfig           |   6 +-
>  drivers/crypto/cavium/nitrox/Kconfig  |   2 +-
>  drivers/crypto/ccp/Kconfig            |   2 +-
>  drivers/crypto/hisilicon/Kconfig      |   2 +-
>  drivers/crypto/qat/Kconfig            |   2 +-
>  drivers/crypto/ux500/Kconfig          |   2 +-
>  drivers/crypto/virtio/Kconfig         |   2 +-
>  drivers/net/wireless/cisco/Kconfig    |   2 +-
>  include/crypto/algapi.h               |  74 ----
>  include/crypto/internal/skcipher.h    |  12 -
>  include/crypto/skcipher.h             |  27 +-
>  include/linux/crypto.h                | 426 +-------------------
>  net/bluetooth/Kconfig                 |   2 +-
>  net/rxrpc/Kconfig                     |   2 +-
>  net/xfrm/Kconfig                      |   2 +-
>  net/xfrm/xfrm_algo.c                  |   4 +-
>  31 files changed, 124 insertions(+), 1332 deletions(-)
>  delete mode 100644 crypto/blkcipher.c
>
> --
> 2.23.0
>
