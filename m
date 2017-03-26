From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 0/7] crypto: aes - allow generic AES to be omitted
Date: Sun, 26 Mar 2017 15:59:38 -0400 (EDT)
Message-ID: <alpine.LFD.2.20.1703261556390.2304@knanqh.ubzr>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers3@gmail.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:34000 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdCZT7l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 15:59:41 -0400
Received: by mail-it0-f53.google.com with SMTP id y18so14507789itc.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2017 12:59:40 -0700 (PDT)
In-Reply-To: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 26 Mar 2017, Ard Biesheuvel wrote:

> The generic AES driver uses 16 lookup tables of 1 KB each, and has
> encryption and decryption routines that are fully unrolled. Given how
> the dependencies between this code and other drivers are declared in
> Kconfig files, this code is always pulled into the core kernel, even
> if it is usually superseded at runtime by accelerated drivers that
> exist for many architectures.
> 
> This leaves us with 25 KB of dead code in the kernel, which is negligible
> in typical environments, but which is actually a big deal for the IoT
> domain, where every kilobyte counts.
> 
> For this reason, this series refactors the way the various AES
> implementations are wired up, to allow the generic version in
> crypto/aes_generic.c to be omitted from the build entirely.

I'm not a cryptographer but I do agree with the above goal.

Acked_by: Nicolas Pitre <nico@linaro.org>

> 
> Patch #1 removes some bogus 'select CRYPTO_AES' statement.
> 
> Patch #2 introduces CRYPTO_NEED_AES which can be selected by driver that
> require an AES cipher to be available, but don't care how it is implemented.
> 
> Patches #3 and #4 make some preparatory changes that allow dependencies on
> crypto_aes_expand_key to be fulfilled by the new (and much smaller) fixed
> time AES driver. (#5)
> 
> Patch #6 splits the generic AES driver into a core containing the precomputed
> sub/shift/mix tables and the key expansion routines on the one hand, and the
> encryption/decryption routines and the crypto API registration on the other.
> 
> Patch #7 introduces the CRYPTO_HAVE_AES Kconfig symbol, and adds statements to
> various AES implementations that can fulfil the CRYPTO_NEED_AES dependencies
> added in patch #2. The introduced Kconfig logic allows CRYPTO_AES to be
> deselected even if AES dependencies exist, as long as one of these alternatives
> is selected.
> 
> Ard Biesheuvel (7):
>   drivers/crypto/Kconfig: drop bogus CRYPTO_AES dependencies
>   crypto: aes - add new Kconfig symbol for soft dependency on AES
>   crypto: aes/x86 - eliminate set_key() handling for IRQ context
>   crypto: aes/arm64 - eliminate dependency on crypto_aes_set_key()
>   crypto: aes - move crypto_aes_expand_key() to fixed-time AES driver
>   crypto: aes - split off shared AES tables and key expansion routines
>   crypto: aes - allow alternative AES drivers to fulfil AES dependency
> 
>  arch/arm/crypto/Kconfig                      |    5 +-
>  arch/arm64/crypto/Kconfig                    |    5 +-
>  arch/arm64/crypto/aes-glue.c                 |   12 +-
>  arch/x86/crypto/aesni-intel_glue.c           |   14 +-
>  crypto/Kconfig                               |   25 +-
>  crypto/Makefile                              |    1 +
>  crypto/aes_core.c                            | 1302 ++++++++++++++++++++
>  crypto/aes_generic.c                         | 1239 -------------------
>  crypto/aes_ti.c                              |    7 +-
>  drivers/block/Kconfig                        |    2 +-
>  drivers/crypto/Kconfig                       |   21 +-
>  drivers/net/Kconfig                          |    2 +-
>  drivers/net/wireless/cisco/Kconfig           |    2 +-
>  drivers/net/wireless/intel/ipw2x00/Kconfig   |    2 +-
>  drivers/net/wireless/intersil/hostap/Kconfig |    2 +-
>  drivers/staging/rtl8192e/Kconfig             |    2 +-
>  drivers/usb/wusbcore/Kconfig                 |    2 +-
>  fs/ceph/Kconfig                              |    2 +-
>  fs/cifs/Kconfig                              |    2 +-
>  fs/crypto/Kconfig                            |    2 +-
>  net/Kconfig                                  |    2 +-
>  net/bluetooth/Kconfig                        |    2 +-
>  net/ceph/Kconfig                             |    2 +-
>  net/mac80211/Kconfig                         |    2 +-
>  net/mac802154/Kconfig                        |    2 +-
>  net/sunrpc/Kconfig                           |    3 +-
>  security/keys/Kconfig                        |    4 +-
>  27 files changed, 1377 insertions(+), 1291 deletions(-)
>  create mode 100644 crypto/aes_core.c
> 
> -- 
> 2.7.4
> 
> 
