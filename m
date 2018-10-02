From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net-next v6 21/23] crypto: port ChaCha20 to Zinc
Date: Tue, 2 Oct 2018 11:26:09 +0800
Message-ID: <20181002032609.o5i2hmphuqtkqgc4@gondor.apana.org.au>
References: <20180925145622.29959-22-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Jason@zx2c4.com, sneves@dei.uc.pt,
        luto@kernel.org, jeanphilippe.aumasson@gmail.com,
        ebiggers@google.com
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925145622.29959-22-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Now that ChaCha20 is in Zinc, we can have the crypto API code simply
> call into it. The crypto API expects to have a stored key per instance
> and independent nonces, so we follow suite and store the key and
> initialize the nonce independently.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Samuel Neves <sneves@dei.uc.pt>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
> Cc: Eric Biggers <ebiggers@google.com>
> ---
> arch/arm/configs/exynos_defconfig       |   1 -
> arch/arm/configs/multi_v7_defconfig     |   1 -
> arch/arm/configs/omap2plus_defconfig    |   1 -
> arch/arm/crypto/Kconfig                 |   6 -
> arch/arm/crypto/Makefile                |   2 -
> arch/arm/crypto/chacha20-neon-core.S    | 521 --------------------
> arch/arm/crypto/chacha20-neon-glue.c    | 127 -----
> arch/arm64/configs/defconfig            |   1 -
> arch/arm64/crypto/Kconfig               |   6 -
> arch/arm64/crypto/Makefile              |   3 -
> arch/arm64/crypto/chacha20-neon-core.S  | 450 -----------------
> arch/arm64/crypto/chacha20-neon-glue.c  | 133 -----
> arch/x86/crypto/Makefile                |   3 -
> arch/x86/crypto/chacha20-avx2-x86_64.S  | 448 -----------------
> arch/x86/crypto/chacha20-ssse3-x86_64.S | 630 ------------------------
> arch/x86/crypto/chacha20_glue.c         | 146 ------
> crypto/Kconfig                          |  17 +-
> crypto/Makefile                         |   2 +-
> crypto/chacha20_generic.c               | 136 -----
> crypto/chacha20_zinc.c                  |  90 ++++
> crypto/chacha20poly1305.c               |   8 +-
> include/crypto/chacha20.h               |  12 -
> 22 files changed, 96 insertions(+), 2648 deletions(-)
> delete mode 100644 arch/arm/crypto/chacha20-neon-core.S
> delete mode 100644 arch/arm/crypto/chacha20-neon-glue.c
> delete mode 100644 arch/arm64/crypto/chacha20-neon-core.S
> delete mode 100644 arch/arm64/crypto/chacha20-neon-glue.c
> delete mode 100644 arch/x86/crypto/chacha20-avx2-x86_64.S
> delete mode 100644 arch/x86/crypto/chacha20-ssse3-x86_64.S
> delete mode 100644 arch/x86/crypto/chacha20_glue.c
> delete mode 100644 crypto/chacha20_generic.c
> create mode 100644 crypto/chacha20_zinc.c

Oh nice, so you did the conversion of the existing crypto code.

I presume someone has done the numbers and verified that there
is no performance regression?

If so it would be good to include those numbers somewhere in this
submission (within a patch description so that it goes into git).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
