From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] crypto: arm/sha512 - accelerated SHA-512 using ARM
 generic ASM and NEON
Date: Fri, 8 May 2015 11:04:44 +0200
Message-ID: <CAKv+Gu9KE25a7b3g=cTzhfckSQ9JuvW17MR_8c9HKWPBQdh4zg@mail.gmail.com>
References: <1431074782-22141-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35582 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbEHJEp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 May 2015 05:04:45 -0400
Received: by ieczm2 with SMTP id zm2so58760248iec.2
        for <linux-crypto@vger.kernel.org>; Fri, 08 May 2015 02:04:44 -0700 (PDT)
In-Reply-To: <1431074782-22141-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8 May 2015 at 10:46, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> This replaces the SHA-512 NEON module with the faster and more
> versatile implementation from the OpenSSL project. It consists
> of both a NEON and a generic ASM version of the core SHA-512
> transform, where the NEON version reverts to the ASM version
> when invoked in non-process context.
>
> This patch is based on the OpenSSL upstream version b1a5d1c65208
> of sha512-armv4.pl, which can be found here:
>
>   https://git.openssl.org/gitweb/?p=openssl.git;h=b1a5d1c65208
>
> Performance relative to the generic implementation (measured
> using tcrypt.ko mode=306 sec=1 running on a Cortex-A57 under
> KVM):
>
>   input size    block size      asm     neon    old neon
>
>   16            16              1.39    2.54    2.21
>   64            16              1.32    2.33    2.09
>   64            64              1.38    2.53    2.19
>   256           16              1.31    2.28    2.06
>   256           64              1.38    2.54    2.25
>   256           256             1.40    2.77    2.39
>   1024          16              1.29    2.22    2.01
>   1024          256             1.40    2.82    2.45
>   1024          1024            1.41    2.93    2.53
>   2048          16              1.33    2.21    2.00
>   2048          256             1.40    2.84    2.46
>   2048          1024            1.41    2.96    2.55
>   2048          2048            1.41    2.98    2.56
>   4096          16              1.34    2.20    1.99
>   4096          256             1.40    2.84    2.46
>   4096          1024            1.41    2.97    2.56
>   4096          4096            1.41    3.01    2.58
>   8192          16              1.34    2.19    1.99
>   8192          256             1.40    2.85    2.47
>   8192          1024            1.41    2.98    2.56
>   8192          4096            1.41    2.71    2.59
>   8192          8192            1.51    3.51    2.69
>
> Acked-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>
> As agreed, I am resending this now for the next merge window.
>

In case the patch size is a concern again:
https://git.linaro.org/people/ard.biesheuvel/linux-arm.git/shortlog/refs/heads/arm-crypto

[...]
