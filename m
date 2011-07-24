From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH 2/2] crypto, x86: SSSE3 based SHA1 implementation for x86-64
Date: Sun, 24 Jul 2011 19:29:46 +0200
Message-ID: <CA+rthh_CM=phRxZsBOav4iOiEkpbkxcFT1jgRGSfqA7=Kn6zQQ@mail.gmail.com>
References: <1310820253-5702-1-git-send-email-minipli@googlemail.com>
	<1310820253-5702-3-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64613 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1GXR3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Jul 2011 13:29:47 -0400
Received: by vws1 with SMTP id 1so2550485vws.19
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2011 10:29:46 -0700 (PDT)
In-Reply-To: <1310820253-5702-3-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jul 16, 2011 at 2:44 PM, Mathias Krause <minipli@googlemail.com=
> wrote:
> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index c04f1b7..a80be92 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_CRYPTO_AES_NI_INTEL) +=3D aesni-intel.=
o
> =A0obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) +=3D ghash-clmulni-intel=
=2Eo
>
> =A0obj-$(CONFIG_CRYPTO_CRC32C_INTEL) +=3D crc32c-intel.o
> +obj-$(CONFIG_CRYPTO_SHA1_SSSE3) +=3D sha1-ssse3.o
>
> =A0aes-i586-y :=3D aes-i586-asm_32.o aes_glue.o
> =A0twofish-i586-y :=3D twofish-i586-asm_32.o twofish_glue.o
> @@ -25,3 +26,10 @@ salsa20-x86_64-y :=3D salsa20-x86_64-asm_64.o sals=
a20_glue.o
> =A0aesni-intel-y :=3D aesni-intel_asm.o aesni-intel_glue.o fpu.o
>
> =A0ghash-clmulni-intel-y :=3D ghash-clmulni-intel_asm.o ghash-clmulni=
-intel_glue.o
> +
> +# enable AVX support only when $(AS) can actually assemble the instr=
uctions
> +ifeq ($(call as-instr,vpxor %xmm0$(comma)%xmm1$(comma)%xmm2,yes,no),=
yes)
> +AFLAGS_sha1_ssse3.o +=3D -DSHA1_ENABLE_AVX_SUPPORT

This should have been

    AFLAGS_sha1_ssse3_asm.o +=3D -DSHA1_ENABLE_AVX_SUPPORT

instead. Sorry, a missing adjustment for a "last minute file rename".
I'll post a new version of the series with a wider target audience
since there have been no reply so far for a week.

> +CFLAGS_sha1_ssse3_glue.o +=3D -DSHA1_ENABLE_AVX_SUPPORT
> +endif
> +sha1-ssse3-y :=3D sha1_ssse3_asm.o sha1_ssse3_glue.o
> diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_=
ssse3_asm.S
> new file mode 100644
> index 0000000..8fb0ba6


Thanks,
Mathias
