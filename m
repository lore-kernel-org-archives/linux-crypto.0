Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30301E5B9A;
	Sat, 15 Aug 2026 01:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757222; cv=none; b=mFpLL3/jW+wvDMVGBduzzO6EjXrrSvS9eRVTARjomP+Gnr0bAV1R9amjzdDJ4qO9sp3h9m46h93PtDFmlnf8/84P84uatzmYV1z0gVJMkRDJO2Y3yQcd0qGcPth+zVasTgNzpG5wOV3LjLaNvVddFAE19hW0rZPwdeimd1hr6Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757222; c=relaxed/simple;
	bh=+G50YCHHbEN06tdwCSAMqPXsLpjx7OaWGQlvmyZAg+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHfxjnV0ENJATWxuqyplRb9MGSPBl+Ag3RWje6s/hFnmVji8Xc+IF24XT1c5cDgAgFWKGUL3FHpitFDcik1DLq46XH5dAngtQXv3R2GG/8yrdnHAfdaJYYnFxKWMz6gevCzfNcBsChjSa886Zp7Lh/cY+RQvqKxgfkjZzHirqKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KTgBlA6F; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KTgBlA6F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0qkeR263YxR4hWYqdFtntPvc2SVb6lAl5QEmclgG2S0=; 
	b=KTgBlA6FnFNVhLrzeM/CLczdDMoUKZ7Lh23Mwjklos/gJO++M1yxwn6vADUzITTZjEXtqtbuA3u
	4tvKh1tYeJPHWfV3bv+R/fBvmhdsOlyS8/upkEjh8W/wPG0XeosBn7PLuU1a4llcJhwq8GSUh57/6
	sfbzoRvhuuifZqG74yIYWzj1b7O9ojsrqHuPEmvLli4mhT9bNznITX7N8n0hl9ypFGAf4UZZsL74d
	97sB6e1AelJhTv+Q1WwvRsFE079JJiVOa9vG12yClZD/6xpm0vEmiushi7qhtlvewSy3fVcQ0QS/M
	8W5KEUIOgLTXGy9pom7ymgLUCcsDQ9H8IrCQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv3Ai-000000054x7-1Nnu;
	Sat, 15 Aug 2026 09:26:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:26:52 +1000
Date: Sat, 15 Aug 2026 11:26:52 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Thomas Richard (TI)" <thomas.richard@bootlin.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregory.clement@bootlin.com, richard.genoud@bootlin.com,
	u-kumar1@ti.com, a-kumar2@ti.com
Subject: Re: [PATCH v5] hwrng: core - Stop/start hwrng_fillfn() kthread
 before/after suspend-resume
Message-ID: <an_AXHglpwoXqv1S@gondor.apana.org.au>
References: <20260804-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v5-1-c4769b3c007b@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v5-1-c4769b3c007b@bootlin.com>

On Tue, Aug 04, 2026 at 12:01:09PM +0200, Thomas Richard (TI) wrote:
> The hwrng_fillfn() kernel thread accesses the RNG device directly. During
> suspend and resume sequences, hwrng_fillfn() may attempt to access the RNG
> device while it is suspended. To address this, the hwrng_fillfn() kernel
> thread is stopped before suspend, and restarted after resume. This is done
> using the pm_notifier mechanism.
> 
> Issue was found while doing suspend-to-ram on J721S2 EVM board with
> omap-rng driver.
> 
> echo mem > /sys/power/state
> [   27.922259] PM: suspend entry (deep)
> [   27.927191] Filesystems sync: 0.000 seconds
> [   27.933858] Freezing user space processes
> [   27.939119] Freezing user space processes completed (elapsed 0.001 seconds)
> [   27.946090] OOM killer disabled.
> [   27.949315] Freezing remaining freezable tasks
> [   27.954887] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
> [   27.963337] GFP mask restricted
> [   27.967069] omap_rng 4e10000.rng: PM: calling platform_pm_suspend @ 195, parent: 4e00000.crypto
> [   27.967072] mmcblk mmc1:9fb0: PM: calling mmc_bus_suspend @ 122, parent: mmc1
> [   27.968636] mmcblk mmc1:9fb0: PM: mmc_bus_suspend returned 0 after 1546 usecs
> [   27.975778] omap_rng 4e10000.rng: PM: platform_pm_suspend returned 0 after 3 usecs
> ...
> [   33.510667] ti-sci 44083000.system-controller: PM: ti_sci_suspend_noirq returned 0 after 0 usecs
> [   33.510671] SError Interrupt on CPU0, code 0x00000000bf000000 -- SError
> [   33.510681] CPU: 0 UID: 0 PID: 132 Comm: hwrng Tainted: G   M    W           7.0.0-12695-g8923b7a6e11d #19 PREEMPT
> [   33.510690] Tainted: [M]=MACHINE_CHECK, [W]=WARN
> [   33.510693] Hardware name: Texas Instruments J721S2 EVM (DT)
> [   33.510697] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   33.510701] pc : omap_rng_do_read+0x3c/0xe0
> [   33.510709] lr : omap_rng_do_read+0x58/0xe0
> [   33.510712] sp : ffff80008942be00
> [   33.510713] x29: ffff80008942be00 x28: 0000000000000000 x27: 0000000000000000
> [   33.510719] x26: 0000000000000010 x25: 0000000000000010 x24: ffff0008065644e8
> [   33.510724] x23: ffff8000878b3370 x22: ffff00080148b2c0 x21: 0000000000000000
> [   33.510728] x20: ffff000806564480 x19: 0000000000000064 x18: 0000000000000000
> [   33.510732] x17: 6573752031207265 x16: 7466612030206465 x15: 6e72757465722071
> [   33.510737] x14: ffff0008062c8080 x13: 000031702bc0da42 x12: 0000000000000001
> [   33.510741] x11: 00000000000000c0 x10: 0000000000000b30 x9 : ffff80008942bc80
> [   33.510745] x8 : ffff0008062c8b90 x7 : ffff000b7dfa34c0 x6 : 0000000805ca16c1
> [   33.510749] x5 : 0000000000000000 x4 : ffff800080e17bfc x3 : ffff800087389c68
> [   33.510753] x2 : 0000000000000000 x1 : 0000000000000010 x0 : 000000000000a7c6
> [   33.510759] Kernel panic - not syncing: Asynchronous SError Interrupt
> [   33.510762] CPU: 0 UID: 0 PID: 132 Comm: hwrng Tainted: G   M    W           7.0.0-12695-g8923b7a6e11d #19 PREEMPT
> [   33.510767] Tainted: [M]=MACHINE_CHECK, [W]=WARN
> [   33.510768] Hardware name: Texas Instruments J721S2 EVM (DT)
> [   33.510770] Call trace:
> [   33.510772]  show_stack+0x18/0x24 (C)
> [   33.510780]  dump_stack_lvl+0x34/0x8c
> [   33.510788]  dump_stack+0x18/0x24
> [   33.510792]  vpanic+0x47c/0x4dc
> [   33.510799]  do_panic_on_target_cpu+0x0/0x1c
> [   33.510803]  add_taint+0x0/0xbc
> [   33.510807]  arm64_serror_panic+0x70/0x80
> [   33.510812]  do_serror+0x3c/0x70
> [   33.510815]  el1h_64_error_handler+0x34/0x50
> [   33.510823]  el1h_64_error+0x6c/0x70
> [   33.510827]  omap_rng_do_read+0x3c/0xe0 (P)
> [   33.510831]  hwrng_fillfn+0x98/0x330
> [   33.510834]  kthread+0x130/0x13c
> [   33.510845]  ret_from_fork+0x10/0x20
> [   33.510850] SMP: stopping secondary CPUs
> [   33.519442] Kernel Offset: disabled
> [   33.519444] CPU features: 0x04000000,800a0008,00040001,0400421b
> [   33.519448] Memory Limit: none
> [   33.732904] ---[ end Kernel panic - not syncing: Asynchronous SError Interrupt ]---
> 
> Signed-off-by: Thomas Richard (TI) <thomas.richard@bootlin.com>
> ---
> In this fifth iteration, after the PM notifier stops the hwrng_fillfn()
> kthread, release the mutex so userspace can set a RNG device or read data
> before the kernel freezes all threads. Add a hwrng_fillfn_stopped flag to
> prevent the hwrng_fillfn() kthread from restarting after being stopped by
> the PM notifier and before threads freezing completes.
> ---
> Changes in v5:
> - release rng_mutex once hwrng_fillfn() kthread is stopped
> - add hwrng_fillfn_stopped flag to prevent hwrng_fillfn() kthread restarting
> - Link to v4: https://lore.kernel.org/r/20260713-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v4-1-b5fb4c520b05@bootlin.com
> 
> Changes in v4:
> - use lockdep_assert_held() instead of BUG_ON()
> - Link to v3: https://lore.kernel.org/r/20260703-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v3-1-b7165cb9cf38@bootlin.com
> 
> Changes in v3:
> - use pm_notifier to stop/start the hwrng_fillfn() kthread before/after
>   suspend-resume.
> - Link to v2: https://lore.kernel.org/r/20260601-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v2-1-667ce5da32ee@bootlin.com
> 
> Changes in v2:
> - Initialize rc variable.
> - Link to v1: https://lore.kernel.org/r/20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v1-1-b12551c1c7dd@bootlin.com
> 
> To: Olivia Mackall <olivia@selenic.com>
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/char/hw_random/core.c | 101 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 86 insertions(+), 15 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
