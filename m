Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575178;
	b=uxdBVHUn4AEMX0hHMyDkGrqi9jhOJqHFtRNK3I7X9KMh6kQdIkPDRwdVse5msEVhxG+B
	 uUdSiae3O6XCtBzhMYYj7+FEWQe0Zvwi4N3E9YisOjA8gBoD5Kg7gJFazIDNHMZ5nFA5w
	 HKb1uK9ljdvathH6lbh2K2MPzuClK/i5gcYxHGSAm8h2kL0+1h6XHkxN2JRwi8r4TLl1/
	 AMUdHzkFpDF/9B/yGUuaukbzX6Z5udygwrWgqgT2BY7kkVJZVngVDPdVbsPgAf197Oxdp
	 l5qpvFJxMeJgXipIzLRWneM2q1umG/ZHifG6tCNKzbyuJcuene6+z9rJTz6SXgledgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575178;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=jwHoe529S1Onorcf95sntE8Ze/cWn9Pu+Cx6R/UvQ6Y=;
	b=ZJ0ZEsD9DAMIvhHN7kJIvxxicUsaMXFCDQxyZgAPu6aUi1YEHAsaMbZOziTbf9N/wPT3
	 UADomQ7GpdWY4koohP+epTDKhq8CTTlahIZX5f+zmnhIdCSpbKE53J1GwJubUmKyvMiR/
	 JZLTsgHciPJIvrvt4R6N8mG9baGuiuk0F8XfotG/2RMcfbo9PHg3tNPkUE8qIChLwOwr8
	 xjs6zu2FY8M+36iT2bgo8THpQQmDu6HAzbcPV2hsYfzwh2ElReRj+SS5Yey4tM3pF9hmj
	 8JMlZvdySApVV6CInDCgNryZ3cEs9QwPWhJhMhf8N8bwEcZvj9tgICDeGTMiMYDJx/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=TmBLJlTh;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A50606A333;
	Fri, 13 Nov 2026 13:06:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38A50606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=TmBLJlTh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=jwHoe529S1Onorcf95sntE8Ze/cWn9Pu+Cx6R/UvQ6Y=; 
	b=TmBLJlTh1FeKjLkLPm+HHsGhV+fAsunf0ozVrHRPgqezsSYw0BattDdpIxDPoGTALZWrt2hQPBS
	VVfddYRhSfSSUlyCieeKf3kpCoIhagd0AQHUJglogq8CJVA70n0yNcYSflX1znFRp9b8XbyhojSrj
	OJGNTOeMrpjqod1nD6vCfWm5VzAwgunJAutqzQG5rlJcWnOTg6qd8eVQMirwMukLIdk6MBhq6vJtU
	OSERd2nB5lVgOJ1SILHUazjGbYK1sj/H2F9HjvUz89atDkt9fmGr3sqnQFsAnoUMbap7i3NTvV2Q4
	PfyXR/WfGd4/4PaqSqUqsr3t5+3B/u38OAiw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqyn-0000000EfIm-2qRf;
	Fri, 13 Nov 2026 21:06:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:06:09 +0800
Date: Fri, 13 Nov 2026 21:06:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 0/6] hwrng: starfive - fixes and JHB100 support
Message-ID: <avcLQWhT7gpR-Tym@gondor.apana.org.au>
References: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>

On Tue, Nov 03, 2026 at 03:32:46PM +0800, lianfeng.ouyang wrote:
> From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> 
> This series adds support for the TRNG on the StarFive JHB100 SoC. The
> JHB100 needs the clocks gated before the reset is asserted, so the
> driver grows per-compatible match data describing the power-down
> ordering.
> 
> Earlier versions of this series carried all of that in the JHB100
> patch, which made it hard to review. Since v10 it is split up:
> 
>   1: dt-bindings for the new compatible (unchanged)
>   2: runtime PM / power teardown fix
>   3: SEU reseed moved out of the interrupt handler, command
>      serialisation, IRQ lifecycle
>   4: include and cleanup tidy-up, no functional change
>   5: match data and the JHB100 compatible
>   6: MAINTAINERS
> 
> Changes in v1:
>  - Remove jh8100-trng and Fix the compatible description in .yaml
>  - add JHB100 and fix clk/reset teardown logic code
> 
> Changes in v2:
>  - Balance the PM via pm_runtime_set_active() in ->probe
>  - Add devm_add_action_or_reset() to register a resource rollback function
> 
> Changes in v3:
>  - Supplement .yaml commit message
>  - Add pm_runtime_get_if_active() to check PM in irq
>  - Balances pm_runtime_get/put calls in init, read, and cleanup paths
>  - Add per-compatible match data for the teardown order
> 
> Changes in v4:
>  - Modify .yaml commit information to non point description
>  - serialise the command sequences with a mutex.
> 
> Changes in v5:
>  - Run the reseed from a workqueue instead of hard IRQ context.
>  - Balance the probe reset_control_deassert() via a ->cleanup flag in the
>    PM suspend/resume callbacks (was skipped when already suspended).
>  - Use devm_pm_runtime_set_active_enabled() instead of manual PM enable.
>  - Register the IRQ after clk/reset/PM setup; reuse
>     starfive_trng_release() on request_irq() failure.
>  - Check reset_control_deassert();
>  - drop of_match_ptr() from the match table.
> 
> Changes in v6:
>  - check lock in starfive_trng_read() using mutex_trylock when wait is 0
> 
> Changes in v7:
>  - using mutex_trylock when wait is 0, otherwise use mutex_lock()
> 
> Changes in v8:
>  - rebase patches against the latest tree
> 
> Changes in v9:
>  - Fixed the PM runtime reference leak in starfive_trng_read()
>  - Drop redundant pm_runtime_get/put calls from the interrupt
>      handler (starfive_trng_irq).
>  - Use DEFINE_RUNTIME_DEV_PM_OPS() and pm_ptr() for power
>      management operations.
>  - Split clock/reset control into starfive_trng_power_on/off()
>  - Track power state with clk_on/rst_deassert/initialized/need_reseed
>       instead of open-coded clk control.
>  - IRQ now requested with IRQF_NO_AUTOEN and enabled only after init
>       succeeds.
>  - LFSR_LOCKUP no longer schedules work from hard IRQ: set need_reseed
>       flag and let starfive_trng_reseed_work() handle reseed on a
>       freezable workqueue.
>  - starfive_trng_cmd() takes timeout + wait args; read path checks idle,
>       reseeds on need_reseed, retries once on lockup, returns 0 for
>       non-blocking.
>  - Protect ctrl-cmd sequences with mutex + lockdep_assert_held.
>  - Cleanup/suspend disables IE, clears ISTAT, synchronize_irq() before
>       gating clocks/reset.
> 
> Changes in v10:
>  - Split the driver change into fixes, cleanup and the JHB100 addition.
>  - starfive_trng_init() only enables the interrupt line once and clears
>    trng->initialized on failure; starfive_trng_cleanup() only disables
>    the line if init left it enabled. Fixes the unbalanced enable_irq()
>    when the device is deselected and quickly reselected, and the double
>    disable_irq() after a failed init.
>  - Non-blocking reads re-queue the reseed work instead of assuming it
>    is pending, and starfive_trng_irq_clear() queues it when it clears a
>    lockup. Fixes the stall of non-blocking reads after a lockup seen
>    outside the interrupt handler or a failed reseed.
>  - Do not include <linux/mod_devicetable.h>, <linux/platform_device.h>
>    already provides struct of_device_id.
>  - Describe the header rearrangement in the commit log.
>  - Rebased on top of ace145efdd80.
> 
> Changes in v11:
>  - starfive_trng_cmd() acks RAND_RDY/SEED_DONE in ISTAT and calls
>    synchronize_irq() before re-arming its completion, so that the late
>    completion interrupt of a command that timed out cannot complete
>    the next command. The v10 commit log claimed this case was already
>    covered; it was not.
>  - starfive_trng_irq_clear() only queues the reseed work while the
>    device is initialised, so the suspend run from ->cleanup() and from
>    the runtime PM teardown on unbind can no longer queue the work after
>    it has been cancelled.
> 
> Lianfeng Ouyang (6):
>   dt-bindings: rng: starfive,jh7110-trng: add jhb100, drop jh8100
>   hwrng: starfive - fix runtime PM and power teardown handling
>   hwrng: starfive - move the SEU reseed out of the interrupt handler
>   hwrng: starfive - tidy up includes and drop unused code
>   hwrng: starfive - add JHB100 support
>   MAINTAINERS: update the StarFive TRNG driver maintainer
> 
>  .../bindings/rng/starfive,jh7110-trng.yaml    |  10 +-
>  MAINTAINERS                                   |   2 +-
>  drivers/char/hw_random/jh7110-trng.c          | 587 +++++++++++++-----
>  3 files changed, 434 insertions(+), 165 deletions(-)
> 
> --
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
