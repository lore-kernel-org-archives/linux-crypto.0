From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH] lib/mpi: call cond_resched() from mpi_powm() loop
Date: Tue, 7 Nov 2017 10:38:30 -0800 (PST)
Message-ID: <alpine.OSX.2.21.1711070921100.18896@afarcy-mobl1.amr.corp.intel.com>
References: <20171107061951.861-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33780 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755910AbdKGSib (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 13:38:31 -0500
In-Reply-To: <20171107061951.861-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Eric,

On Mon, 6 Nov 2017, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
>
> On a non-preemptible kernel, if KEYCTL_DH_COMPUTE is called with the
> largest permitted inputs (16384 bits), the kernel spends 10+ seconds
> doing modular exponentiation in mpi_powm() without rescheduling.  If all
> threads do it, it locks up the system.  Moreover, it can cause
> rcu_sched-stall warnings.
>
> Notwithstanding the insanity of doing this calculation in kernel mode
> rather than in userspace, fix it by calling cond_resched() as each bit
> from the exponent is processed.  It's still noninterruptible, but at
> least it's preemptible now.

cond_resched() is in the outer loop and gets called every BITS_PER_LONG 
bits. That seems to be often enough for the system that was taking 10+ 
seconds, and might be ok for slower processors.

Was your intent to call cond_resched() for every bit as you described in 
the commit message?

Thanks for the fix.


Mat


>
> Cc: stable@vger.kernel.org # v4.12+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> lib/mpi/mpi-pow.c | 3 +++
> 1 file changed, 3 insertions(+)
>
> diff --git a/lib/mpi/mpi-pow.c b/lib/mpi/mpi-pow.c
> index e24388a863a7..f089a52dbbdb 100644
> --- a/lib/mpi/mpi-pow.c
> +++ b/lib/mpi/mpi-pow.c
> @@ -26,6 +26,7 @@
>  *	 however I decided to publish this code under the plain GPL.
>  */
>
> +#include <linux/sched.h>
> #include <linux/string.h>
> #include "mpi-internal.h"
> #include "longlong.h"
> @@ -263,6 +264,8 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
> 				break;
> 			e = ep[i];
> 			c = BITS_PER_MPI_LIMB;
> +
> +			cond_resched();
> 		}
>
> 		/* We shifted MOD, the modulo reduction argument, left MOD_SHIFT_CNT
> -- 
> 2.15.0
>
>
