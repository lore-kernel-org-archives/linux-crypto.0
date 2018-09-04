From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: remove Speck
Date: Tue, 4 Sep 2018 12:55:59 +0800
Message-ID: <20180904045559.jfzqhwcfyq42x2cs@gondor.apana.org.au>
References: <20180807011937.GA133621@gmail.com>
 <20180807062225.6331-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Greg Kaiser <gkaiser@google.com>,
 Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
 Samuel Neves <samuel.c.p.neves@gmail.com>,
 Michael Halcrow <mhalcrow@google.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
 linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Paul Crowley <paulcrowley@google.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180807062225.6331-1-Jason@zx2c4.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 07, 2018 at 08:22:25AM +0200, Jason A. Donenfeld wrote:
> These are unused, undesired, and have never actually been used by
> anybody. The original authors of this code have changed their mind about
> its inclusion. While originally proposed for disk encryption on low-end
> devices, the idea was discarded [1] in favor of something else before
> that could really get going. Therefore, this patch removes Speck.
> 
> [1] https://marc.info/?l=linux-crypto-vger&m=153359499015659
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Acked-by: Eric Biggers <ebiggers@google.com>
> Cc: stable@vger.kernel.org
> ---
>  Documentation/filesystems/fscrypt.rst |  10 -
>  arch/arm/crypto/Kconfig               |   6 -
>  arch/arm/crypto/Makefile              |   2 -
>  arch/arm/crypto/speck-neon-core.S     | 434 ---------------
>  arch/arm/crypto/speck-neon-glue.c     | 288 ----------
>  arch/arm64/crypto/Kconfig             |   6 -
>  arch/arm64/crypto/Makefile            |   3 -
>  arch/arm64/crypto/speck-neon-core.S   | 352 ------------
>  arch/arm64/crypto/speck-neon-glue.c   | 282 ----------
>  arch/m68k/configs/amiga_defconfig     |   1 -
>  arch/m68k/configs/apollo_defconfig    |   1 -
>  arch/m68k/configs/atari_defconfig     |   1 -
>  arch/m68k/configs/bvme6000_defconfig  |   1 -
>  arch/m68k/configs/hp300_defconfig     |   1 -
>  arch/m68k/configs/mac_defconfig       |   1 -
>  arch/m68k/configs/multi_defconfig     |   1 -
>  arch/m68k/configs/mvme147_defconfig   |   1 -
>  arch/m68k/configs/mvme16x_defconfig   |   1 -
>  arch/m68k/configs/q40_defconfig       |   1 -
>  arch/m68k/configs/sun3_defconfig      |   1 -
>  arch/m68k/configs/sun3x_defconfig     |   1 -
>  arch/s390/defconfig                   |   1 -
>  crypto/Kconfig                        |  14 -
>  crypto/Makefile                       |   1 -
>  crypto/speck.c                        | 307 -----------
>  crypto/testmgr.c                      |  24 -
>  crypto/testmgr.h                      | 738 --------------------------
>  fs/crypto/fscrypt_private.h           |   4 -
>  fs/crypto/keyinfo.c                   |  10 -
>  include/crypto/speck.h                |  62 ---
>  include/uapi/linux/fs.h               |   4 +-
>  31 files changed, 2 insertions(+), 2558 deletions(-)
>  delete mode 100644 arch/arm/crypto/speck-neon-core.S
>  delete mode 100644 arch/arm/crypto/speck-neon-glue.c
>  delete mode 100644 arch/arm64/crypto/speck-neon-core.S
>  delete mode 100644 arch/arm64/crypto/speck-neon-glue.c
>  delete mode 100644 crypto/speck.c
>  delete mode 100644 include/crypto/speck.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
