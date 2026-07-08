Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6429A3DD521;
	Wed,  8 Jul 2026 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783523015; cv=none; b=N/smBYPcPaSww6oT3iTYoWxyYzv6JGKW+eLaACDUEC6F8Xmn6HlH9v/uLWee6vSsPdsI45OQmldAHfTQm30ch2yIBHuHEzEfEp3JoIJEgnb/EKCTudw0u92ZTAV5M9zJ5fuVEzdsR4jZ+f49i7qToTDWWqh7to1/t6askQeE60I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783523015; c=relaxed/simple;
	bh=0cBkKjyrciEKUZkMuOe34r1fAT+m9IVhg3Sl31NikLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lxFuqVFRRi5y+o6VWwzfm/S+/oKuG7vGZmm6P35vVXAR+1KclPcwaHxgKzwlq4wDxBHlGLmAQ6t5hEAA3S1+BytWSdwWN5xTB7xnP2RJ4KPoDZjtg86MENN1vPEQs90YTpbqhKCg4TBErIG4e4PAEGNYvyN34VLFvpE0WMCJ/2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqDMDpQf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqDMDpQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2EA1F00A3D;
	Wed,  8 Jul 2026 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783523014;
	bh=/QagJEoC0CuwHGgxS2TQOOJJq+6D8ca2QfC4ut6ZhKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aqDMDpQfD2Jb1qSZay12CsvGQic4T+CYcDuI43jHnfh+EKvaLqXFSFMF8mWdBB6Gj
	 4htk5cA+3GG9cua+CFYJ4HORJ/2SuFp33nxYtoEcCk+iOSycIagCugxq+SZ09zNd3m
	 Dz9o+j1Exhma1tuOThbq0w8z/5H4ayUNi7XmbI7gygNITYFlvucojYrDjGypWyGFxO
	 tsxdS1uStccWzVgnwn5rFpRuZ5ZYNYzlK/VCaJQ4iGevwC1gNpD7Q3xkdAfwiGU0pj
	 QnDOcp3XjBo5G/+BF/a5E6nqKW1Bp8LkyAYdG7NP8JvzElcaL9OWDXieo2uSR8GCe1
	 RisaaO5A9SJJQ==
Date: Wed, 8 Jul 2026 16:03:29 +0100
From: Lee Jones <lee@kernel.org>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: chenhuacai@kernel.org, xry111@xry111.site, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mfd: loongson-se: Fix miscellaneous issues
Message-ID: <20260708150329.GH2108533@google.com>
References: <20260629071109.7341-1-zhaoqunqin@loongson.cn>
 <20260629071109.7341-2-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629071109.7341-2-zhaoqunqin@loongson.cn>

Oof, that's a lot of findings.  Please review and remedy each.

/* Sashiko Automation: Issues Found (10 Findings) */

On Mon, 29 Jun 2026, Qunqin Zhao wrote:

> Address multiple historical driver issues discovered by the Sashiko
> Automation system within the loongson_se_probe() initialization flow
> and the driver's interrupt service routines [1].
> 
> - Add an explicit bounds check for 'id' before accessing the fixed-size
>   'engines' array in se_irq_handler() to prevent potential out-of-bounds
>   memory writes.
> 
> - Switch the allocations from devm_kmalloc() to devm_kzalloc() to
>   guarantee the descriptor structures are properly zero-initialized.
> 
> - Return an error code from loongson_se_probe() if devm_request_irq()
>   fails, preventing an indefinite hang during completion waits.
> 
> - Add a reinit_completion() before waiting on the completions to ensure
>   proper hardware synchronization.
> 
> - Prevent writing uninitialized stack memory to device registers in
>   loongson_se_init() by properly initializing local command structures.
> 
> - Add a .remove callback to the platform driver to properly halt the
>   hardware.
> 
> Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/ [1]
> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> ---
>  drivers/mfd/loongson-se.c       | 23 +++++++++++++++++++----
>  include/linux/mfd/loongson-se.h |  1 +
>  2 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index 3902ba377d..aa34e663c4 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -85,6 +85,8 @@ int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
>  	if (err)
>  		return err;
>  
> +	reinit_completion(&engine->completion);
> +

[Severity: High]
If a fast hardware completion occurs between loongson_se_poll() signaling the
hardware to start and this reinit_completion(), the IRQ handler runs and sets
the completion to done. Will this reinit_completion() then immediately clear
the done state, causing the subsequent wait_for_completion_interruptible()
to block indefinitely?


>  	return wait_for_completion_interruptible(&engine->completion);
>  }

[Severity: High]
This is a pre-existing issue, but controller commands also rely on
wait_for_completion_interruptible() without reinitializing the completion
structure. If loongson_se_send_controller_cmd() is interrupted by a signal,
it returns -ERESTARTSYS, and the hardware eventually sets the completion state
to done. Will the next controller command see the completion as already done
and return success without actually waiting?



[Severity: High]
This is a pre-existing issue, but does loongson_se_poll() hold an
irq-disabling spinlock for up to 10 milliseconds?

loongson_se_poll() acquires a spinlock with spin_lock_irq(), and then uses
readl_relaxed_poll_timeout_atomic() with a 10,000 us timeout. Could this
cause severe scheduling latency spikes or trigger hard lockup panics if the
hardware is slow?



>  EXPORT_SYMBOL_GPL(loongson_se_send_engine_cmd);
> @@ -150,7 +152,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>  	/* For engines */
>  	while (int_status) {
>  		id = __ffs(int_status);
> -		complete(&se->engines[id].completion);
> +		if (id < SE_ENGINE_MAX)
> +			complete(&se->engines[id].completion);
>  		int_status &= ~BIT(id);
>  		writel(BIT(id), se->base + SE_S2LINT_CL);
>  	}
> @@ -162,7 +165,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>  
>  static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
>  {
> -	struct loongson_se_controller_cmd cmd;
> +	struct loongson_se_controller_cmd cmd = {0};
>  	int err;
>  
>  	cmd.command_id = SE_CMD_START;
> @@ -190,7 +193,7 @@ static int loongson_se_probe(struct platform_device *pdev)
>  	int nr_irq, irq, err, i;
>  	dma_addr_t paddr;
>  
> -	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
> +	se = devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);

[Severity: Critical]
This is a pre-existing issue, but switching to devm_kzalloc() without calling
init_completion() for the engines array leaves the completion structs
improperly initialized.

A zeroed struct list_head inside swait_queue_head evaluates as non-empty in
list_empty(). If an interrupt fires before a child driver calls
loongson_se_init_engine(), se_irq_handler() will pass the new bounds check
and call complete(), which dereferences a NULL list head. Can this cause a
deterministic kernel panic on spurious interrupts?



>  	if (!se)
>  		return -ENOMEM;
>  
> @@ -220,8 +223,10 @@ static int loongson_se_probe(struct platform_device *pdev)
>  	for (i = 0; i < nr_irq; i++) {
>  		irq = platform_get_irq(pdev, i);

[Severity: High]
This is a pre-existing issue, but the probe function returns -ENODEV if
platform_irq_count() fails earlier:

    nr_irq = platform_irq_count(pdev);
    if (nr_irq <= 0)
        return -ENODEV;

Does overwriting the return value of platform_irq_count() break probe deferral
if it returns -EPROBE_DEFER when the interrupt provider is not yet available?



[Severity: High]
This is a pre-existing issue, but earlier in probe, writel(SE_INT_ALL, ...)
enables all device interrupts before devm_request_irq() registers the handler.
If an interrupt fires in this window, no handler is present.

Additionally, if probe fails after this point, interrupts are never disabled.
Can this leave the hardware asserting unhandled interrupts and cause a system
lockup?


>  		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
> -		if (err)
> +		if (err) {
>  			dev_err(dev, "failed to request IRQ: %d\n", irq);
> +			return err;
> +		}
>  	}
>  
>  	err = loongson_se_init(se, paddr, se->dmam_size);

[Severity: High]
This is a pre-existing issue, but is the driver blindly trusting the
firmware's dmam_size property without minimum bound checks?

In loongson_se_init_engine(), command buffers are placed at fixed offsets:

    engine->command = se->dmam_base + id * (2 * SE_ENGINE_CMD_SIZE);

If the provided dmam_size is smaller than the required space for all engines,
could these calculations yield pointers outside the allocated DMA buffer and
cause memory corruption?


> @@ -232,6 +237,15 @@ static int loongson_se_probe(struct platform_device *pdev)
>  				    ARRAY_SIZE(engines), NULL, 0, NULL);
>  }

[Severity: High]
This is a pre-existing issue, but if the devm_mfd_add_devices() call fails,
probe returns an error without sending SE_CMD_STOP to the already-started
controller.

Since devres will free the DMA buffers, can the still-running hardware
continue to access the freed memory and cause corruption?


>  
> +static void loongson_se_remove(struct platform_device *pdev)
> +{
> +	struct loongson_se *se = dev_get_drvdata(&pdev->dev);
> +	struct loongson_se_controller_cmd cmd = {0};
> +
> +	cmd.command_id = SE_CMD_STOP;
> +	loongson_se_send_controller_cmd(se, &cmd);

[Severity: High]
Because the child devices were registered via devm_mfd_add_devices(), their
unbind sequence happens later in the devres teardown phase, after this remove
callback returns.

If this halts the hardware controller before its child MFD devices are
unbound, will the child drivers still be fully active? Could any hardware
access by the children during their own remove callbacks fail or hang?



[Severity: High]
loongson_se_send_controller_cmd() waits using
wait_for_completion_interruptible(). If the thread executing the removal
receives a signal, the wait aborts immediately and returns -ERESTARTSYS.

Since this remove function ignores the return value, can devres free the
DMA buffers while the hardware is still processing the STOP command, leading
to DMA memory corruption?


> +}
> +
>  static const struct acpi_device_id loongson_se_acpi_match[] = {
>  	{ "LOON0011", 0 },
>  	{ }
> @@ -240,6 +254,7 @@ MODULE_DEVICE_TABLE(acpi, loongson_se_acpi_match);
>  
>  static struct platform_driver loongson_se_driver = {
>  	.probe   = loongson_se_probe,
> +	.remove  = loongson_se_remove,
>  	.driver  = {
>  		.name  = "loongson-se",
>  		.acpi_match_table = loongson_se_acpi_match,
> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
> index 07afa0c252..8237ccab7b 100644
> --- a/include/linux/mfd/loongson-se.h
> +++ b/include/linux/mfd/loongson-se.h
> @@ -9,6 +9,7 @@
>  #define SE_SEND_CMD_REG_LEN		0x8
>  /* Controller command ID */
>  #define SE_CMD_START			0x0
> +#define SE_CMD_STOP			0x1
>  #define SE_CMD_SET_DMA			0x3
>  #define SE_CMD_SET_ENGINE_CMDBUF	0x4
>  
> -- 
> 2.47.2
> 

-- 
Lee Jones
