From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [RFC PATCH 1/2] crypto: move ablk_helper out of arch/x86
Date: Sat, 14 Sep 2013 10:26:33 +0300
Message-ID: <52340FA9.8010307@iki.fi>
References: <1379084886-1178-1-git-send-email-ard.biesheuvel@linaro.org> <1379084886-1178-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-arm@lists.infradead.org, linux-crypto@vger.kernel.org,
	nico@linaro.org, catalin.marinas@arm.com, steve.capper@arm.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50707 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab3INH0j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Sep 2013 03:26:39 -0400
In-Reply-To: <1379084886-1178-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13.09.2013 18:08, Ard Biesheuvel wrote:
> Move the ablk_helper code out of arch/x86 so it can be reused
> by other architectures. The only x86 specific dependency was
> a call to irq_fpu_usable(), this has been factored out and moved
> to crypto/ablk_helper_x86.c
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
..snip..
> diff --git a/crypto/ablk_helper_generic.c b/crypto/ablk_helper_generic.c
> new file mode 100644
> index 0000000..b63b800
> --- /dev/null
> +++ b/crypto/ablk_helper_generic.c
> @@ -0,0 +1,155 @@
> +/*
> + * Shared async block cipher helpers
> + *
> + * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> + *
> + * Based on aesni-intel_glue.c by:
> + *  Copyright (C) 2008, Intel Corp.
> + *    Author: Huang Ying <ying.huang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> + * USA
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/crypto.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/hardirq.h>
> +#include <crypto/algapi.h>
> +#include <crypto/cryptd.h>
> +#include <crypto/ablk_helper.h>
> +
> +/* can be overridden by the architecture if desired */
> +bool __weak ablk_can_run_sync(void)
> +{
> +	return !in_interrupt();
> +}

Why not have architecture specific header file that provides this function?
With architecture using in_interrupt for this, you would avoid extra function
call.

-Jussi
