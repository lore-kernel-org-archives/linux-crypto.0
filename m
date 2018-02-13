From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm/aes-cipher - move S-box to .rodata section
Date: Tue, 13 Feb 2018 10:57:25 +0000
Message-ID: <CAKv+Gu93OdaWyMcm3nqV38-RmoYoCceQ4f4DfT65t9amRm_gFA@mail.gmail.com>
References: <20180212135237.GA3011@pjb1027-Latitude-E5410>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Jinbum Park <jinb.park7@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33911 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934077AbeBMK50 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 05:57:26 -0500
Received: by mail-it0-f67.google.com with SMTP id j21so9223253ita.1
        for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2018 02:57:26 -0800 (PST)
In-Reply-To: <20180212135237.GA3011@pjb1027-Latitude-E5410>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 February 2018 at 13:52, Jinbum Park <jinb.park7@gmail.com> wrote:
> Move the AES inverse S-box to the .rodata section
> where it is safe from abuse by speculation.
>
> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/aes-cipher-core.S | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
> index 54b3840..184d6c2 100644
> --- a/arch/arm/crypto/aes-cipher-core.S
> +++ b/arch/arm/crypto/aes-cipher-core.S
> @@ -174,6 +174,16 @@
>         .ltorg
>         .endm
>
> +ENTRY(__aes_arm_encrypt)
> +       do_crypt        fround, crypto_ft_tab, crypto_ft_tab + 1, 2
> +ENDPROC(__aes_arm_encrypt)
> +
> +       .align          5
> +ENTRY(__aes_arm_decrypt)
> +       do_crypt        iround, crypto_it_tab, __aes_arm_inverse_sbox, 0
> +ENDPROC(__aes_arm_decrypt)
> +
> +       .section        ".rodata", "a"
>         .align          L1_CACHE_SHIFT
>         .type           __aes_arm_inverse_sbox, %object
>  __aes_arm_inverse_sbox:
> @@ -210,12 +220,3 @@ __aes_arm_inverse_sbox:
>         .byte           0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26
>         .byte           0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
>         .size           __aes_arm_inverse_sbox, . - __aes_arm_inverse_sbox
> -
> -ENTRY(__aes_arm_encrypt)
> -       do_crypt        fround, crypto_ft_tab, crypto_ft_tab + 1, 2
> -ENDPROC(__aes_arm_encrypt)
> -
> -       .align          5
> -ENTRY(__aes_arm_decrypt)
> -       do_crypt        iround, crypto_it_tab, __aes_arm_inverse_sbox, 0
> -ENDPROC(__aes_arm_decrypt)
> --
> 1.9.1
>
