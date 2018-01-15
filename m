From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: aes-generic - fix aes-generic regression on powerpc
Date: Mon, 15 Jan 2018 16:58:36 +0100
Message-ID: <CAK8P3a2Tsnw489oBrcRWM7BLd06kOFuYiQC-7r541NcnQwLvsA@mail.gmail.com>
References: <20180115155550.210622-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:40141 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbeAOP6h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 10:58:37 -0500
In-Reply-To: <20180115155550.210622-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 15, 2018 at 4:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -99,7 +99,7 @@ obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
>  obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
>  CFLAGS_serpent_generic.o := $(call cc-option,-fsched-pressure)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
>  obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
> -CFLAGS_aes_generic.o := $(call cc-ifversion, -ge, 0701, -Os) # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
> +CFLAGS_aes_generic.o := $(call cc-option,fno-code-hosting) # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356

Please disregard this version, it adds a typo that I noticed the second after I
had sent the patch.

         Arnd
