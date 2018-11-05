Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:34073 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeKEVed (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 16:34:33 -0500
Received: by mail-io1-f66.google.com with SMTP id d80-v6so6324460iof.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 04:15:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1541419502-7286-1-git-send-email-gilad@benyossef.com>
References: <1541419502-7286-1-git-send-email-gilad@benyossef.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 5 Nov 2018 13:15:04 +0100
Message-ID: <CAKv+Gu8cmGbJVCe4HJ0Jsyh4bB=X0psk02cFkq9e20ev9C-Opg@mail.gmail.com>
Subject: Re: [PATCH] crypto: cts: document NIST standard status
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5 November 2018 at 13:05, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> cts(cbc(aes)) as used in the kernel has been added to NIST
> standard as CBC-CS3. Document it as such.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Suggested-by: Stephan Mueller <smueller@chronox.de>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/Kconfig | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index f7a235d..9176023 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -430,11 +430,14 @@ config CRYPTO_CTS
>         help
>           CTS: Cipher Text Stealing
>           This is the Cipher Text Stealing mode as described by
> -         Section 8 of rfc2040 and referenced by rfc3962.
> -         (rfc3962 includes errata information in its Appendix A)
> +         Section 8 of rfc2040 and referenced by rfc3962
> +         (rfc3962 includes errata information in its Appendix A) or
> +         CBC-CS3 as defined by NIST in Sp800-38A addendum from Oct 2010.
>           This mode is required for Kerberos gss mechanism support
>           for AES encryption.
>
> +         See: https://csrc.nist.gov/publications/detail/sp/800-38a/addendum/final
> +
>  config CRYPTO_ECB
>         tristate "ECB support"
>         select CRYPTO_BLKCIPHER
> --
> 2.7.4
>
