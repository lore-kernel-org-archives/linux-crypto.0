From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: crypto: marvell/CESA: Issues with non cache-line aligned
 buffers
Date: Fri, 3 Jul 2015 16:19:10 +0200
Message-ID: <20150703161910.5089bcb2@bbrezillon>
References: <20150703114305.15611807@bbrezillon>
	<20150703131059.GX7557@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Will Deacon <will.deacon@arm.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:37507 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932082AbbGCOTQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jul 2015 10:19:16 -0400
In-Reply-To: <20150703131059.GX7557@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Russel,

On Fri, 3 Jul 2015 14:10:59 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> BTW, off-topic for this thread... but I notice from Mark Brown's builder
> that mv_cesa is causing build errors in mainline now:
> 
>         arm-allmodconfig
> ../drivers/crypto/mv_cesa.c:1037:2: error: implicit declaration of function 'of_get_named_gen_pool' [-Werror=implicit-function-declaration]
> 
>         arm-multi_v5_defconfig
> ../drivers/crypto/mv_cesa.c:1037:2: error: implicit declaration of function 'of_get_named_gen_pool' [-Werror=implicit-function-declaration]
> 
> It seems it was fine on July 2nd, but the above was introduced today.

It has been fixed by Stephen in linux-next (see [1]).

> 
> A few other things I notice when looking at this code:
> 
>         /* Not all platforms can gate the clock, so it is not
>            an error if the clock does not exists. */
>         cp->clk = clk_get(&pdev->dev, NULL);
>         if (!IS_ERR(cp->clk))
>                 clk_prepare_enable(cp->clk);
> 
> So, if clk_get() returns PTR_ERR(-EPROBE_DEFER) we treat that clock as
> missing?  Is that really the behaviour you want there?

Nope, I'll fix that.

> 
>         ret = request_irq(irq, crypto_int, 0, dev_name(&pdev->dev),
>                         cp);
> 
> What happens if crypto_int() is called when request_irq() unlocks its
> spinlock, before the clock has been found?  Eg, because we're booting
> from a kexec'd kernel.

I don't know, and I agree that we should either request the clock
before registering the irq, or disable the IRQ using the
SEC_ACCEL_INT_MASK before calling request_irq. Ideally we should do
both.

Note that none of my patches changed the clk_get(), request_irq() calls
order, or the clk_get() error path ;-).

Anyway, I'll propose a patch fixing the problem.

Thanks for the feedback,

Boris

[1]https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/crypto/mv_cesa.c?id=7e6ce3db5329a32c83da9753bae162eb3f22dfca

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
