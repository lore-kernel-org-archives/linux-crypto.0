From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Mon, 23 Mar 2015 19:26:03 +0100
Message-ID: <CAKv+Gu8qcVVTqy6Fd8PMA8ZTxiMssKz+TbMQW=fAhCBpUH2jTw@mail.gmail.com>
References: <20150316154835.GA31336@google.com>
	<20150323135009.GB820@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Polyakov <appro@openssl.org>
To: Sami Tolvanen <samitolvanen@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:36781 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbbCWS0E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Mar 2015 14:26:04 -0400
Received: by igbud6 with SMTP id ud6so50543299igb.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2015 11:26:03 -0700 (PDT)
In-Reply-To: <20150323135009.GB820@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(resending due to size bounce)

On 23 March 2015 at 14:50, Sami Tolvanen <samitolvanen@google.com> wrote:
> Add Andy Polyakov's optimized assembly and NEON implementations for
> SHA-256/224.
>
> The sha256-armv4.pl script for generating the assembly code is from
> OpenSSL commit 2ecd32a1f8f0643ae7b38f59bbaf9f0d6ef326fe.
>
> Compared to sha256-generic these implementations have the following
> tcrypt speed improvements on Motorola Nexus 6 (Snapdragon 805):
>
>   bs    b/u      sha256-neon  sha256-asm
>   16    16       x1.32        x1.19
>   64    16       x1.27        x1.15
>   64    64       x1.36        x1.20
>   256   16       x1.22        x1.11
>   256   64       x1.36        x1.19
>   256   256      x1.59        x1.23
>   1024  16       x1.21        x1.10
>   1024  256      x1.65        x1.23
>   1024  1024     x1.76        x1.25
>   2048  16       x1.21        x1.10
>   2048  256      x1.66        x1.23
>   2048  1024     x1.78        x1.25
>   2048  2048     x1.79        x1.25
>   4096  16       x1.20        x1.09
>   4096  256      x1.66        x1.23
>   4096  1024     x1.79        x1.26
>   4096  4096     x1.82        x1.26
>   8192  16       x1.20        x1.09
>   8192  256      x1.67        x1.23
>   8192  1024     x1.80        x1.26
>   8192  4096     x1.85        x1.28
>   8192  8192     x1.85        x1.27
>
> Where bs refers to block size and b/u to bytes per update.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Cc: Andy Polyakov <appro@openssl.org>
>

This builds fine and passes the tcrypt.ko tests in ARM and Thumb2 and
even in big-endian (ARM) mode, so

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Nice work!

Ard.

> ---
> Changes since v1:
>   Rebased to Herbert's cryptodev tree
>   Include sha256-armv4.pl and use it to generate sha256-core.S
>   Add integer-only assembly version as sha256-asm
>   Add support for SHA-224 to the glue code
>   Change priority for sha256/224-ce to 300
>
> ---
>  arch/arm/crypto/Kconfig               |    7
>  arch/arm/crypto/Makefile              |    8
>  arch/arm/crypto/sha2-ce-glue.c        |    4
>  arch/arm/crypto/sha256-armv4.pl       |  713 ++++++
>  arch/arm/crypto/sha256-core.S_shipped | 2775 ++++++++++++++++++++++++
>  arch/arm/crypto/sha256_glue.c         |  246 ++
>  arch/arm/crypto/sha256_glue.h         |   23
>  arch/arm/crypto/sha256_neon_glue.c    |  172 +
>  8 files changed, 3945 insertions(+), 3 deletions(-)
>
