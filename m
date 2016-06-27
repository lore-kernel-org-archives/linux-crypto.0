From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2] hwrng: OMAP: Fix assumption that runtime_get_sync
 will always succeed
Date: Mon, 27 Jun 2016 17:05:37 +0800
Message-ID: <20160627090537.GC7140@gondor.apana.org.au>
References: <1466787040-26184-1-git-send-email-nm@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
	Deepak Saxena <dsaxena@plexity.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	s-anna@ti.com, Paul Walmsley <paul@pwsan.com>
To: Nishanth Menon <nm@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466787040-26184-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 24, 2016 at 11:50:39AM -0500, Nishanth Menon wrote:
> pm_runtime_get_sync does return a error value that must be checked for
> error conditions, else, due to various reasons, the device maynot be
> enabled and the system will crash due to lack of clock to the hardware
> module.
> 
> Before:
> 12.562784] [00000000] *pgd=fe193835
> 12.562792] Internal error: : 1406 [#1] SMP ARM
> [...]
> 12.562864] CPU: 1 PID: 241 Comm: modprobe Not tainted 4.7.0-rc4-next-20160624 #2
> 12.562867] Hardware name: Generic DRA74X (Flattened Device Tree)
> 12.562872] task: ed51f140 ti: ed44c000 task.ti: ed44c000
> 12.562886] PC is at omap4_rng_init+0x20/0x84 [omap_rng]
> 12.562899] LR is at set_current_rng+0xc0/0x154 [rng_core]
> [...]
> 
> After the proper checks:
> [   94.366705] omap_rng 48090000.rng: _od_fail_runtime_resume: FIXME:
> missing hwmod/omap_dev info
> [   94.375767] omap_rng 48090000.rng: Failed to runtime_get device -19
> [   94.382351] omap_rng 48090000.rng: initialization failed.
> 
> Fixes: 665d92fa85b5 ("hwrng: OMAP: convert to use runtime PM")
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> Changes in V2:
> 	- Added runtime_put_noidle when get_sync fails to ensure proper refcounting

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
