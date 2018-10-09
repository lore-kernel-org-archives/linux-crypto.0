From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 1/3] crypto: memneq - use unaligned accessors for aligned
 fast path
Date: Mon, 8 Oct 2018 20:34:56 -0700
Message-ID: <20181009033455.GA718@sol.localdomain>
References: <20181008211554.5355-1-ard.biesheuvel@linaro.org>
 <20181008211554.5355-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, jason@zx2c4.com,
 linux-crypto@vger.kernel.org, arnd@arndb.de, herbert@gondor.apana.org.au
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20181008211554.5355-2-ard.biesheuvel@linaro.org>
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

Hi Ard,

On Mon, Oct 08, 2018 at 11:15:52PM +0200, Ard Biesheuvel wrote:
> On ARM v6 and later, we define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> because the ordinary load/store instructions (ldr, ldrh, ldrb) can
> tolerate any misalignment of the memory address. However, load/store
> double and load/store multiple instructions (ldrd, ldm) may still only
> be used on memory addresses that are 32-bit aligned, and so we have to
> use the CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS macro with care, or we
> may end up with a severe performance hit due to alignment traps that
> require fixups by the kernel.
> 
> Fortunately, the get_unaligned() accessors do the right thing: when
> building for ARMv6 or later, the compiler will emit unaligned accesses
> using the ordinary load/store instructions (but avoid the ones that
> require 32-bit alignment). When building for older ARM, those accessors
> will emit the appropriate sequence of ldrb/mov/orr instructions. And on
> architectures that can truly tolerate any kind of misalignment, the
> get_unaligned() accessors resolve to the leXX_to_cpup accessors that
> operate on aligned addresses.
> 
> So switch to the unaligned accessors for the aligned fast path. This
> will create the exact same code on architectures that can really
> tolerate any kind of misalignment, and generate code for ARMv6+ that
> avoids load/store instructions that trigger alignment faults.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/memneq.c | 24 ++++++++++++++------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/crypto/memneq.c b/crypto/memneq.c
> index afed1bd16aee..0f46a6150f22 100644
> --- a/crypto/memneq.c
> +++ b/crypto/memneq.c
> @@ -60,6 +60,7 @@
>   */
>  
>  #include <crypto/algapi.h>
> +#include <asm/unaligned.h>
>  
>  #ifndef __HAVE_ARCH_CRYPTO_MEMNEQ
>  
> @@ -71,7 +72,10 @@ __crypto_memneq_generic(const void *a, const void *b, size_t size)
>  
>  #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>  	while (size >= sizeof(unsigned long)) {
> -		neq |= *(unsigned long *)a ^ *(unsigned long *)b;
> +		unsigned long const *p = a;
> +		unsigned long const *q = b;
> +
> +		neq |= get_unaligned(p) ^ get_unaligned(q);
>  		OPTIMIZER_HIDE_VAR(neq);
>  		a += sizeof(unsigned long);
>  		b += sizeof(unsigned long);
> @@ -95,18 +99,24 @@ static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
>  
>  #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	if (sizeof(unsigned long) == 8) {
> -		neq |= *(unsigned long *)(a)   ^ *(unsigned long *)(b);
> +		unsigned long const *p = a;
> +		unsigned long const *q = b;
> +
> +		neq |= get_unaligned(p++) ^ get_unaligned(q++);
>  		OPTIMIZER_HIDE_VAR(neq);
> -		neq |= *(unsigned long *)(a+8) ^ *(unsigned long *)(b+8);
> +		neq |= get_unaligned(p) ^ get_unaligned(q);
>  		OPTIMIZER_HIDE_VAR(neq);
>  	} else if (sizeof(unsigned int) == 4) {
> -		neq |= *(unsigned int *)(a)    ^ *(unsigned int *)(b);
> +		unsigned int const *p = a;
> +		unsigned int const *q = b;
> +
> +		neq |= get_unaligned(p++) ^ get_unaligned(q++);
>  		OPTIMIZER_HIDE_VAR(neq);
> -		neq |= *(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4);
> +		neq |= get_unaligned(p++) ^ get_unaligned(q++);
>  		OPTIMIZER_HIDE_VAR(neq);
> -		neq |= *(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8);
> +		neq |= get_unaligned(p++) ^ get_unaligned(q++);
>  		OPTIMIZER_HIDE_VAR(neq);
> -		neq |= *(unsigned int *)(a+12) ^ *(unsigned int *)(b+12);
> +		neq |= get_unaligned(p) ^ get_unaligned(q);
>  		OPTIMIZER_HIDE_VAR(neq);
>  	} else
>  #endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */

This looks good, but maybe now we should get rid of the
!CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS path too?
At least for the 16-byte case:

static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
{
	const unsigned long *p = a, *q = b;
	unsigned long neq = 0;

	BUILD_BUG_ON(sizeof(*p) != 4 && sizeof(*p) != 8);
	neq |= get_unaligned(p++) ^ get_unaligned(q++);
	OPTIMIZER_HIDE_VAR(neq);
	neq |= get_unaligned(p++) ^ get_unaligned(q++);
	OPTIMIZER_HIDE_VAR(neq);
	if (sizeof(*p) == 4) {
		neq |= get_unaligned(p++) ^ get_unaligned(q++);
		OPTIMIZER_HIDE_VAR(neq);
		neq |= get_unaligned(p++) ^ get_unaligned(q++);
		OPTIMIZER_HIDE_VAR(neq);
	}
	return neq;
}
