From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2 15/17] crypto: talitos - Implementation of SEC1
Date: Mon, 9 Mar 2015 19:14:05 -0500
Message-ID: <20150309191405.d5494a29565ebd72d9bf33f0@freescale.com>
References: <20150306164226.331B51A241C@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-crypto@vger.kernel.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0136.outbound.protection.outlook.com ([207.46.100.136]:5730
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751769AbbCJATZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 20:19:25 -0400
In-Reply-To: <20150306164226.331B51A241C@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 6 Mar 2015 17:42:26 +0100
Christophe Leroy <christophe.leroy@c-s.fr> wrote:

> This patch adds talitos1.c and talitos1.h with all specificities needed
> to handle the SEC1 security engine found in MPC885 and MPC8272.
> 
> The SEC1 has several differences with its younger brother SEC2:
> * Several bits in registers have different locations
> * Many bits are missing
> * Some bits are in addition
> * SEC1 doesn't support scatter/gather
> * SEC1 has a different descriptor structure
> 
> We add a helper function for clearing the desc field in the descriptor as that field needs to be cleared on SEC1 and doesn't exist on SEC2.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Hi Christophe,

Thanks for rebasing on cryptodev-2.6, now I can easily see the
differences for review.

> +++ b/drivers/crypto/Kconfig
> @@ -211,7 +211,8 @@ config CRYPTO_DEV_TALITOS
>  	select CRYPTO_ALGAPI
>  	select CRYPTO_AUTHENC
>  	select HW_RANDOM
> -	select CRYPTO_DEV_TALITOS2
> +	select CRYPTO_DEV_TALITOS1 if PPC_8xx || PPC_82xx
> +	select CRYPTO_DEV_TALITOS2 if !CRYPTO_DEV_TALITOS1

This will set CONFIG_CRYPTO_DEV_TALITOS1=y on a kernel with both
PPC_82xx and PPC_83xx set, and will therefore break talitos when run
on an 83xx part.

The driver needs to work on both v1 and v2/3 SECs dynamically,
and behave accordingly depending on what version h/w is described in
the device tree ("fsl,secX").

So, barring making a completely new driver, a couple of points:

- A h/w version 1 vs 2 compatible priv variable can be allocated for
parts of the driver that need quicker access than calling
of_device_is_compatible().  Other parts that do better as complete
function rewrites (the scatter-gather mapping fns?) can be
abstracted away using pointers to the v1 vs. v2+ base functions.
The pointers would live in the device's priv struct, and be assigned
at module initialization time.

- instead of rewriting the structs talitos_ptr, talitos_desc, either
use the v2-named member as-is, or make unions.

E.g., instead of having a new struct talitos_ptr, either use the v2
h/w version as-is and shift the length into place, or, add a v1 len
via a union, and make to_talitos_ptr a pointer to a function, with
the v1 version of the function updating only the v1 len.

For struct talitos_desc, how about:

struct talitos_desc {
	__be32 hdr;
	struct talitos_ptr[8];
}

and have the desc->ptr[X] assigning code add 1 via a new macro iff
on a SEC2 compatible (the hdr_lo code would have to be hardcoded to
refer to ptr[0] instead of hdr_lo directly, and next_desc would be
ptr[7]).

talitos_edesc shouldn't need the extra ptr_{in,out}, rather allocate
the extra space when they're needed, and refer to them via aliases
to defines that cast and use link_tbl[0] as a base reference.

For IO register accesses, either a lookup table can be used, or,
since they're not frequent, define v1-specific defines in addition
to the v2 ones, and reference using the compatible variable.

Other than that, please make sure to use checkpatch.pl --strict,
sparse -D__CHECK_ENDIAN__, and that building as a module doesn't
break.

Thanks,

Kim
