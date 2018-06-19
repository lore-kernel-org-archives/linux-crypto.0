From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm/speck - fix building in Thumb2 mode
Date: Tue, 19 Jun 2018 08:38:13 +0200
Message-ID: <CAKv+Gu-P3_zn41jeTmh=vojcoBhF_g_2FvYTq_8A3PJku3efVA@mail.gmail.com>
References: <20180618223323.130072-1-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Stefan Agner <stefan@agner.ch>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180618223323.130072-1-ebiggers@google.com>
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

On 19 June 2018 at 00:33, Eric Biggers <ebiggers@google.com> wrote:
> Building the kernel with CONFIG_THUMB2_KERNEL=y and
> CONFIG_CRYPTO_SPECK_NEON set fails with the following errors:
>
>     arch/arm/crypto/speck-neon-core.S: Assembler messages:
>
>     arch/arm/crypto/speck-neon-core.S:419: Error: r13 not allowed here -- `bic sp,#0xf'
>     arch/arm/crypto/speck-neon-core.S:423: Error: r13 not allowed here -- `bic sp,#0xf'
>     arch/arm/crypto/speck-neon-core.S:427: Error: r13 not allowed here -- `bic sp,#0xf'
>     arch/arm/crypto/speck-neon-core.S:431: Error: r13 not allowed here -- `bic sp,#0xf'
>
> The problem is that the 'bic' instruction can't operate on the 'sp'
> register in Thumb2 mode.  Fix it by using a temporary register.  This
> isn't in the main loop, so the performance difference is negligible.
> This also matches what aes-neonbs-core.S does.
>
> Reported-by: Stefan Agner <stefan@agner.ch>
> Fixes: ede9622162fa ("crypto: arm/speck - add NEON-accelerated implementation of Speck-XTS")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/arm/crypto/speck-neon-core.S | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/crypto/speck-neon-core.S b/arch/arm/crypto/speck-neon-core.S
> index 3c1e203e53b9..57caa742016e 100644
> --- a/arch/arm/crypto/speck-neon-core.S
> +++ b/arch/arm/crypto/speck-neon-core.S
> @@ -272,9 +272,11 @@
>          * Allocate stack space to store 128 bytes worth of tweaks.  For
>          * performance, this space is aligned to a 16-byte boundary so that we
>          * can use the load/store instructions that declare 16-byte alignment.
> +        * For Thumb2 compatibility, don't do the 'bic' directly on 'sp'.
>          */
> -       sub             sp, #128
> -       bic             sp, #0xf
> +       sub             r12, sp, #128
> +       bic             r12, #0xf
> +       mov             sp, r12
>
>  .if \n == 64
>         // Load first tweak

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
