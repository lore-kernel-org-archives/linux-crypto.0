From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 1/9] kernel: add support for patchable function
 pointers
Date: Fri, 5 Oct 2018 16:14:33 +0200
Message-ID: <20181005141433.GS19272@hirez.programming.kicks-ass.net>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
 <20181005081333.15018-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 Samuel Neves <sneves@dei.uc.pt>, Paul Mackerras <paulus@samba.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Richard Weinberger <richard@nod.at>,
 Eric Biggers <ebiggers@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org,
 "David S. Miller" <davem@davemloft.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20181005081333.15018-2-ard.biesheuvel@linaro.org>
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

On Fri, Oct 05, 2018 at 10:13:25AM +0200, Ard Biesheuvel wrote:
> diff --git a/include/linux/ffp.h b/include/linux/ffp.h
> new file mode 100644
> index 000000000000..8fc3b4c9b38f
> --- /dev/null
> +++ b/include/linux/ffp.h
> @@ -0,0 +1,43 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __LINUX_FFP_H
> +#define __LINUX_FFP_H
> +
> +#include <linux/types.h>
> +#include <linux/compiler.h>
> +
> +#ifdef CONFIG_HAVE_ARCH_FFP
> +#include <asm/ffp.h>
> +#else
> +
> +struct ffp {
> +	void	(**fn)(void);
> +	void	(*default_fn)(void);
> +};
> +
> +#define DECLARE_FFP(_fn, _def)						\
> +	extern typeof(_def) *_fn;					\
> +	extern struct ffp const __ffp_ ## _fn
> +
> +#define DEFINE_FFP(_fn, _def)						\
> +	typeof(_def) *_fn = &_def;					\
> +	struct ffp const __ffp_ ## _fn					\
> +		= { (void(**)(void))&_fn, (void(*)(void))&_def };	\
> +	EXPORT_SYMBOL(__ffp_ ## _fn)
> +
> +static inline void ffp_set_target(const struct ffp *m, void *new_fn)
> +{
> +	WRITE_ONCE(*m->fn, new_fn);
> +}
> +
> +static inline void ffp_reset_target(const struct ffp *m)
> +{
> +	WRITE_ONCE(*m->fn, m->default_fn);
> +}
> +
> +#endif
> +
> +#define SET_FFP(_fn, _new)	ffp_set_target(&__ffp_ ## _fn, _new)
> +#define RESET_FFP(_fn)		ffp_reset_target(&__ffp_ ## _fn)
> +
> +#endif

I don't understand this interface. There is no wrapper for the call
site, so how are we going to patch all call-sites when you update the
target?
