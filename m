Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBA93BFE4A;
	Thu, 18 Jun 2026 09:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781776795; cv=none; b=WXfc64lm1vNksVhZkaJd6wztphkzIc9saixCpsWsj9QiMwBNJMfdCbx2lYyfA9TrhjwqE2Bmd+c8ZxGg3az1zxeSssozXvHdV9jbF4d83NkKK3SLRXKwCJ2Ygt8NNkv357y/e4tFy3sg/2qUdLs+Bn80WcwBhLP5+yRmi6ME1y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781776795; c=relaxed/simple;
	bh=ZMUFwh1rdhBRwejhWnvx/At8/Ih16Eds2ZtOMSzmBQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AthlLzkYr0QWuolFiRtAfJJ6bXuJQ79pB/GcxJPdk+Dhfb3nx+DpqLVku4SHNzXE0Qd+l0Rss3U68ptlHlDxnusuHOor+M4IG1CH/bl0i1UCVZf1QvvY6NLE7gF0UWQ4aL4gnvoSPRoJyGCISwlcXEDSxZVrwNE2DgOcuJxqxRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Apq6h9lp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Apq6h9lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6881F000E9;
	Thu, 18 Jun 2026 09:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781776794;
	bh=0dlGudfFAC3otFWacI21RRWCZ1fDq0nS+7CfWTl1NZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Apq6h9lpffqdMZ6E45Jn6kccXqd4TjkpRHCmeLBCjCAkxCOrTPTgXLcK6kQvuQqHh
	 WXuqAcmcom58vLtYQFUBvgMsmsKIMKgtwiL7dzSZR+6M10GUC1AABR4cHktOEYnbgb
	 dm3qo5/RX72N8iAjnGsTkoZGjiKrCh7J/LdKph7li8onJPY7ZdiUkbD2hbFegf+3Cy
	 0OuFEBzPky1tZneNvyj7YDGIzrWqytXipPyJq0l8R9TqYbxxLHSAD86Si1pGGlwkM4
	 QKTJR1B/AUpYmxLLsXQ9xD9enwRkxv+r6/LJmzv1ANnAoXPtVTZf+oklJhqYGWDFF/
	 EN3hkzZ+lIecQ==
Date: Thu, 18 Jun 2026 10:59:49 +0100
From: Lee Jones <lee@kernel.org>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: chenhuacai@kernel.org, xry111@xry111.site, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] mfd: loongson-se: Add multi-node support
Message-ID: <20260618095949.GB1672911@google.com>
References: <20260610151354.32617-1-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610151354.32617-1-zhaoqunqin@loongson.cn>

/* Sashiko Automation: Issues Found (7 Findings) */

Worth chewing through.

> On the Loongson platform, each node is equipped with a security engine
> device. However, due to a hardware flaw, only the device on node 0 can
> trigger interrupts. Therefore, interrupts from other nodes are forwarded
> by node 0. We need to check in the interrupt handler of node 0 whether
> this interrupt is intended for other nodes, this can be accomplished via
> shared interrupt handling.
> 
> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> ---
> V3: 
> Using shared interrupts (IRQF_SHARED) instead of manually
> iterating through all devices to check for interrupts.
> 
> Link to v2:
> https://lore.kernel.org/all/20260427165133.23350-1-zhaoqunqin@loongson.cn/
> 
>  drivers/mfd/loongson-se.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index 3902ba377d6..e63ea40d5db 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -219,7 +219,7 @@ static int loongson_se_probe(struct platform_device *pdev)
>  
>  	for (i = 0; i < nr_irq; i++) {
>  		irq = platform_get_irq(pdev, i);
> -		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
> +		err = devm_request_irq(dev, irq, se_irq_handler, IRQF_SHARED, "loongson-se", se);

[Severity: High]
With IRQF_SHARED now being used, does se_irq_handler() need to return
IRQ_NONE when it doesn't process any interrupts?

drivers/mfd/loongson-se.c:se_irq_handler() {
...
	/* For engines */
	while (int_status) {
		id = __ffs(int_status);
		complete(&se->engines[id].completion);
		int_status &= ~BIT(id);
		writel(BIT(id), se->base + SE_S2LINT_CL);
	}

	spin_unlock(&se->dev_lock);

	return IRQ_HANDLED;
}

If another device sharing the IRQ line triggers an interrupt and
int_status is 0, the handler will skip processing but unconditionally
return IRQ_HANDLED.

This defeats the spurious interrupt detection mechanism in
note_interrupt(), which could lead to a system lockup if an interrupt
storm occurs on the shared line.



[Severity: Critical]
This is a pre-existing issue, but does se_irq_handler() lack bounds
checking when accessing the engines array?

drivers/mfd/loongson-se.c:se_irq_handler() {
...
	/* For engines */
	while (int_status) {
		id = __ffs(int_status);
		complete(&se->engines[id].completion);
...

The driver enables all 32 possible interrupts by writing SE_INT_ALL
(0xffffffff) to SE_S2LINT_EN in loongson_se_probe(). The engines array
has a fixed size of SE_ENGINE_MAX (16).

If the hardware sets any interrupt bit from 16 to 31, id will be >= 16,
resulting in an out-of-bounds memory write when calling complete().
Could this corrupt adjacent heap memory?



[Severity: Critical]
This isn't a bug introduced by this patch, but is it safe to use
devm_kmalloc() with GFP_KERNEL here instead of devm_kzalloc()?

drivers/mfd/loongson-se.c:loongson_se_probe() {
...
	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
...
	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
...
	err = devm_request_irq(dev, irq, se_irq_handler, IRQF_SHARED, "loongson-se", se);
...

The se->engines array contains uninitialized garbage because it is
allocated with devm_kmalloc(). Hardware interrupts are globally enabled
and the IRQ handler is registered before the engine completions are
initialized.

If a leftover interrupt from a prior hardware state is pending when the
handler registers, se_irq_handler() could execute
complete(&se->engines[id].completion) on random, uninitialized memory.


>  		if (err)
>  			dev_err(dev, "failed to request IRQ: %d\n", irq);
>  	}

[Severity: High]
This is a pre-existing issue, but should the probe function return an
error if devm_request_irq() fails?

If devm_request_irq() fails, the loop continues without returning an
error code. Immediately after, loongson_se_init() issues a hardware
command and calls wait_for_completion_interruptible(&se->cmd_completion).

Since no interrupt handler is registered to signal complete(), the
worker thread executing the probe will hang indefinitely.


> @@ -228,7 +228,7 @@ static int loongson_se_probe(struct platform_device *pdev)
>  	if (err)
>  		return err;
>  
> -	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
> +	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
>  				    ARRAY_SIZE(engines), NULL, 0, NULL);
>  }

[Severity: High]
This isn't a bug introduced by this patch, but is a reinit_completion()
needed before waiting on the completions?

drivers/mfd/loongson-se.c:loongson_se_send_engine_cmd() {
...
	return wait_for_completion_interruptible(&engine->completion);
}

If a user process executing this is interrupted by a signal, it returns
-ERESTARTSYS immediately while the hardware command continues executing.
When the hardware eventually finishes, the interrupt handler calls
complete(), incrementing the completion counter.

Because reinit_completion() is never called before initiating the next
command, the subsequent wait_for_completion_interruptible() will
immediately return success before the new hardware command has actually
finished, breaking hardware synchronization.



[Severity: High]
This is a pre-existing issue, but does loongson_se_init() write
uninitialized stack memory to the device registers?

drivers/mfd/loongson-se.c:loongson_se_init() {
	struct loongson_se_controller_cmd cmd;
	int err;

	cmd.command_id = SE_CMD_START;
	err = loongson_se_send_controller_cmd(se, &cmd);
...

For SE_CMD_START, only cmd.command_id is initialized, leaving the
cmd.info array uninitialized. loongson_se_send_controller_cmd() then
unconditionally writes SE_SEND_CMD_REG_LEN (8) u32 words to the device
via writel().

This writes 28 bytes of uninitialized kernel stack contents directly to
the device MMIO registers.



[Severity: High]
This isn't a bug introduced by this patch, but does the platform driver
declaration lack a .remove callback to properly halt the hardware?

drivers/mfd/loongson-se.c:
...
static struct platform_driver loongson_se_driver = {
	.probe   = loongson_se_probe,
	.driver  = {
		.name  = "loongson-se",
		.acpi_match_table = loongson_se_acpi_match,
	},
};

During driver unbind or module removal, devres will automatically free
the DMA buffer and the IRQ. Because there is no explicit teardown step
to send a stop command or disable hardware interrupts, the controller
remains fully active.

If the hardware continues to process and writes to the now-freed DMA
memory, could it cause memory corruption or trigger IOMMU faults?

>  
> 
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> -- 
> 2.47.2
> 

-- 
Lee Jones
