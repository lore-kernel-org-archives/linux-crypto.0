Return-Path: <SRS0=Odag=Z5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413B1C43603
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 10:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F5EE217BA
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Dec 2019 10:16:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dbq3UF2s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfLGKQC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Dec 2019 05:16:02 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40466 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfLGKQC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Dec 2019 05:16:02 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so10456240wrn.7
        for <linux-crypto@vger.kernel.org>; Sat, 07 Dec 2019 02:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=709fE3c650TonzHzahAFt1Pc91wzf/MhrdtH1N/sdjk=;
        b=Dbq3UF2sK7JR1TzFv95oJ9UIDDs8VdU5bHyIDI9WbiBt4ncH6BeDZ156CxotCimAnp
         HRPUT1qmIbauiqhnbT0D0jY9TSUqmyBF+Vkr+EvApclTUcKvZoiQcPmV3nAjrEtm0OqQ
         vesASRKHzulSwhmkvgmKUuQB703r7pgHZPcwjmYqeLHwu1dmZtcs7QNBAWw5V4k6s/h5
         wMVKUlSmw1TmQu56yPNwgRlvBYXmGAs6mD8aAXPYT5IXRGM7ZfPUynQSuzyvWzBjuhiK
         Z6Pr+RhTsxe6np6pr4xxi/w+cr6zC4xDEl2ulfJOKXwIlBnhIgsjOQp4qBqbbCNuKsGY
         JpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=709fE3c650TonzHzahAFt1Pc91wzf/MhrdtH1N/sdjk=;
        b=PUMHADnUnLPZgFxFOhp83Y6mVn63YV23uoVd7YgWxl0hEBGWRRw6qQ9gDax3yoz+g0
         EF21xyD2e/yqUAF/TJNhYhrqlhC9XCshb1g3ddcy7nexGHfoMmbx8VDL6QvqQMDfkQVi
         4w6YNLIvloi/fgNGU18QSvaUDulKjTk2a9jSIlQuvY6O6kBZ1hGkbqBd+E3dqiYuWEO6
         pNDb5D5Pl9wcaTbJ/nQ8OzizJvkAQF5m27tziQ8kLp2BBAGx3a8U9PLr/VWS8g/DC4+Z
         kyMhtB4UJ1hsxEsxmqJyZLzDlJIgZesIj2s//W5ixgHF0fif7UihEpkVDsSIAHUvYJYJ
         HVLA==
X-Gm-Message-State: APjAAAV835muggj31NL4SpP1zEK3m5XVDE+/GeN8HVp+eqTAAL4GLSLD
        T0NVUGHW/zyueeov1+L1HWUuF4GjJVHBuHK1WlE3kQ==
X-Google-Smtp-Source: APXvYqykfw+fOwAtE7n7kKl4Bc12M5CDn+fGH41U5u9b5At/hW+nZ8ktGXJhMW8E47yGS+pwU/Thda70TlR+MR874qE=
X-Received: by 2002:a5d:6652:: with SMTP id f18mr21042160wrw.246.1575713760038;
 Sat, 07 Dec 2019 02:16:00 -0800 (PST)
MIME-Version: 1.0
References: <20191207041937.97925-1-ebiggers@kernel.org>
In-Reply-To: <20191207041937.97925-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 7 Dec 2019 10:15:57 +0000
Message-ID: <CAKv+Gu8za_CcBdeeZhXC4ARZ6FakUbRrNKb6J8dycgqrc59Omw@mail.gmail.com>
Subject: Re: [PATCH] crypto: doc - remove references to ARC4
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 7 Dec 2019 at 04:20, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> arc4 is no longer considered secure, so it shouldn't be used, even as
> just an example.  Mention serpent and chacha20 instead.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  Documentation/crypto/devel-algos.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto/devel-algos.rst
> index f9d288015acc..fb6b7979a1de 100644
> --- a/Documentation/crypto/devel-algos.rst
> +++ b/Documentation/crypto/devel-algos.rst
> @@ -57,7 +57,7 @@ follows:
>  Single-Block Symmetric Ciphers [CIPHER]
>  ---------------------------------------
>
> -Example of transformations: aes, arc4, ...
> +Example of transformations: aes, serpent, ...
>
>  This section describes the simplest of all transformation
>  implementations, that being the CIPHER type used for symmetric ciphers.
> @@ -108,7 +108,7 @@ is also valid:
>  Multi-Block Ciphers
>  -------------------
>
> -Example of transformations: cbc(aes), ecb(arc4), ...
> +Example of transformations: cbc(aes), chacha20, ...
>
>  This section describes the multi-block cipher transformation
>  implementations. The multi-block ciphers are used for transformations
> --
> 2.24.0
>
