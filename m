From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: crypto: marvell/CESA: Issues with non cache-line aligned buffers
Date: Fri, 3 Jul 2015 14:10:59 +0100
Message-ID: <20150703131059.GX7557@n2100.arm.linux.org.uk>
References: <20150703114305.15611807@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Will Deacon <will.deacon@arm.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45586 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbbGCNLT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jul 2015 09:11:19 -0400
Content-Disposition: inline
In-Reply-To: <20150703114305.15611807@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

BTW, off-topic for this thread... but I notice from Mark Brown's builder
that mv_cesa is causing build errors in mainline now:

        arm-allmodconfig
../drivers/crypto/mv_cesa.c:1037:2: error: implicit declaration of function 'of_get_named_gen_pool' [-Werror=implicit-function-declaration]

        arm-multi_v5_defconfig
../drivers/crypto/mv_cesa.c:1037:2: error: implicit declaration of function 'of_get_named_gen_pool' [-Werror=implicit-function-declaration]

It seems it was fine on July 2nd, but the above was introduced today.

A few other things I notice when looking at this code:

        /* Not all platforms can gate the clock, so it is not
           an error if the clock does not exists. */
        cp->clk = clk_get(&pdev->dev, NULL);
        if (!IS_ERR(cp->clk))
                clk_prepare_enable(cp->clk);

So, if clk_get() returns PTR_ERR(-EPROBE_DEFER) we treat that clock as
missing?  Is that really the behaviour you want there?

        ret = request_irq(irq, crypto_int, 0, dev_name(&pdev->dev),
                        cp);

What happens if crypto_int() is called when request_irq() unlocks its
spinlock, before the clock has been found?  Eg, because we're booting
from a kexec'd kernel.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
