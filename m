From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86 - remove SHA multibuffer routines and mcryptd
Date: Tue, 4 Sep 2018 13:19:52 +0800
Message-ID: <20180904051952.d23crymm6ve7sect@gondor.apana.org.au>
References: <20180822085144.4872-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiggers@google.com, Megha Dey <megha.dey@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180822085144.4872-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 22, 2018 at 10:51:44AM +0200, Ard Biesheuvel wrote:
> As it turns out, the AVX2 multibuffer SHA routines are currently
> broken [0], in a way that would have likely been noticed if this
> code were in wide use. Since the code is too complicated to be
> maintained by anyone except the original authors, and since the
> performance benefits for real-world use cases are debatable to
> begin with, it is better to drop it entirely for the moment.
> 
> [0] https://marc.info/?l=linux-crypto-vger&m=153476243825350&w=2
> 
> Suggested-by: Eric Biggers <ebiggers@google.com>
> Cc: Megha Dey <megha.dey@linux.intel.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  MAINTAINERS                                   |    8 -
>  arch/m68k/configs/amiga_defconfig             |    1 -
>  arch/m68k/configs/apollo_defconfig            |    1 -
>  arch/m68k/configs/atari_defconfig             |    1 -
>  arch/m68k/configs/bvme6000_defconfig          |    1 -
>  arch/m68k/configs/hp300_defconfig             |    1 -
>  arch/m68k/configs/mac_defconfig               |    1 -
>  arch/m68k/configs/multi_defconfig             |    1 -
>  arch/m68k/configs/mvme147_defconfig           |    1 -
>  arch/m68k/configs/mvme16x_defconfig           |    1 -
>  arch/m68k/configs/q40_defconfig               |    1 -
>  arch/m68k/configs/sun3_defconfig              |    1 -
>  arch/m68k/configs/sun3x_defconfig             |    1 -
>  arch/s390/configs/debug_defconfig             |    1 -
>  arch/s390/configs/performance_defconfig       |    1 -
>  arch/x86/crypto/Makefile                      |    3 -
>  arch/x86/crypto/sha1-mb/Makefile              |   14 -
>  arch/x86/crypto/sha1-mb/sha1_mb.c             | 1011 ----------------
>  arch/x86/crypto/sha1-mb/sha1_mb_ctx.h         |  134 ---
>  arch/x86/crypto/sha1-mb/sha1_mb_mgr.h         |  110 --
>  .../crypto/sha1-mb/sha1_mb_mgr_datastruct.S   |  287 -----
>  .../crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S   |  304 -----
>  .../crypto/sha1-mb/sha1_mb_mgr_init_avx2.c    |   64 -
>  .../crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S  |  209 ----
>  arch/x86/crypto/sha1-mb/sha1_x8_avx2.S        |  492 --------
>  arch/x86/crypto/sha256-mb/Makefile            |   14 -
>  arch/x86/crypto/sha256-mb/sha256_mb.c         | 1013 ----------------
>  arch/x86/crypto/sha256-mb/sha256_mb_ctx.h     |  134 ---
>  arch/x86/crypto/sha256-mb/sha256_mb_mgr.h     |  108 --
>  .../sha256-mb/sha256_mb_mgr_datastruct.S      |  304 -----
>  .../sha256-mb/sha256_mb_mgr_flush_avx2.S      |  307 -----
>  .../sha256-mb/sha256_mb_mgr_init_avx2.c       |   65 -
>  .../sha256-mb/sha256_mb_mgr_submit_avx2.S     |  214 ----
>  arch/x86/crypto/sha256-mb/sha256_x8_avx2.S    |  598 ----------
>  arch/x86/crypto/sha512-mb/Makefile            |   12 -
>  arch/x86/crypto/sha512-mb/sha512_mb.c         | 1047 -----------------
>  arch/x86/crypto/sha512-mb/sha512_mb_ctx.h     |  128 --
>  arch/x86/crypto/sha512-mb/sha512_mb_mgr.h     |  104 --
>  .../sha512-mb/sha512_mb_mgr_datastruct.S      |  281 -----
>  .../sha512-mb/sha512_mb_mgr_flush_avx2.S      |  297 -----
>  .../sha512-mb/sha512_mb_mgr_init_avx2.c       |   69 --
>  .../sha512-mb/sha512_mb_mgr_submit_avx2.S     |  224 ----
>  arch/x86/crypto/sha512-mb/sha512_x4_avx2.S    |  531 ---------
>  crypto/Kconfig                                |   62 -
>  crypto/Makefile                               |    1 -
>  crypto/mcryptd.c                              |  675 -----------
>  include/crypto/mcryptd.h                      |  114 --
>  47 files changed, 8952 deletions(-)
>  delete mode 100644 arch/x86/crypto/sha1-mb/Makefile
>  delete mode 100644 arch/x86/crypto/sha1-mb/sha1_mb.c
>  delete mode 100644 arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
>  delete mode 100644 arch/x86/crypto/sha1-mb/sha1_mb_mgr.h
>  delete mode 100644 arch/x86/crypto/sha1-mb/sha1_mb_mgr_datastruct.S
>  delete mode 100644 arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.S
>  delete mode 100644 arch/x86/crypto/sha1-mb/sha1_mb_mgr_init_avx2.c
>  delete mode 100644 arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.S
>  delete mode 100644 arch/x86/crypto/sha1-mb/sha1_x8_avx2.S
>  delete mode 100644 arch/x86/crypto/sha256-mb/Makefile
>  delete mode 100644 arch/x86/crypto/sha256-mb/sha256_mb.c
>  delete mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_ctx.h
>  delete mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr.h
>  delete mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr_datastruct.S
>  delete mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr_flush_avx2.S
>  delete mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr_init_avx2.c
>  delete mode 100644 arch/x86/crypto/sha256-mb/sha256_mb_mgr_submit_avx2.S
>  delete mode 100644 arch/x86/crypto/sha256-mb/sha256_x8_avx2.S
>  delete mode 100644 arch/x86/crypto/sha512-mb/Makefile
>  delete mode 100644 arch/x86/crypto/sha512-mb/sha512_mb.c
>  delete mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
>  delete mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr.h
>  delete mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr_datastruct.S
>  delete mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr_flush_avx2.S
>  delete mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c
>  delete mode 100644 arch/x86/crypto/sha512-mb/sha512_mb_mgr_submit_avx2.S
>  delete mode 100644 arch/x86/crypto/sha512-mb/sha512_x4_avx2.S
>  delete mode 100644 crypto/mcryptd.c
>  delete mode 100644 include/crypto/mcryptd.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
