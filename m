From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 2/3] crypto: sahara: Add driver for SAHARA2 accelerator.
Date: Sat, 23 Feb 2013 21:16:23 +0100
Message-ID: <87zjyuiy5k.fsf@lebrac.rtp-net.org>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com>
	<1361449162-27302-3-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel@pengutronix.de, swarren@nvidia.com,
	herbert@gondor.apana.org.au, arnd@arndb.de, tony@atomide.com,
	linux-crypto@vger.kernel.org, shawn.guo@linaro.org,
	davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
	gcembed@gmail.com
To: Javier Martin <javier.martin@vista-silicon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lebrac.rtp-net.org ([88.191.135.105]:33490 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab3BWUSc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 Feb 2013 15:18:32 -0500
In-Reply-To: <1361449162-27302-3-git-send-email-javier.martin@vista-silicon.com>
	(Javier Martin's message of "Thu, 21 Feb 2013 13:19:21 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Javier Martin <javier.martin@vista-silicon.com> writes:

Hi,

> SAHARA2 HW module is included in the i.MX27 SoC from
> Freescale. It is capable of performing cipher algorithms
> such as AES, 3DES..., hashing and RNG too.
>
> This driver provides support for AES-CBC and AES-ECB
> by now.
>

[...]

> +	int irq;
> +	int err;
> +	int i;
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof(struct sahara_dev), GFP_KERNEL);
> +	if (dev == NULL) {
> +		dev_err(&pdev->dev, "unable to alloc data struct.\n");
> +		return -ENOMEM;
> +	}
> +
> +	dev->device = &pdev->dev;
> +	platform_set_drvdata(pdev, dev);
> +
> +	/* Get the base address */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to get memory region resource\n");
> +		return -ENODEV;
> +	}
> +
> +	if (devm_request_mem_region(&pdev->dev, res->start,
> +			resource_size(res), SAHARA_NAME) == NULL) {
> +		dev_err(&pdev->dev, "failed to request memory region\n");
> +		return -ENOENT;
> +	}
> +	dev->regs_base = devm_ioremap(&pdev->dev, res->start,
> +				      resource_size(res));
> +	if (!dev->regs_base) {
> +		dev_err(&pdev->dev, "failed to ioremap address region\n");
> +		return -ENOENT;
> +	}
> +
> +	/* Get the IRQ */
> +	irq = platform_get_irq(pdev,  0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "failed to get irq resource\n");
> +		return irq;
> +	}
> +
> +	if (devm_request_irq(&pdev->dev, irq, sahara_irq_handler,
> +		0, SAHARA_NAME, dev) < 0) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		return -ENOENT;
> +	}
> +
> +	/* clocks */
> +	dev->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
> +	if (IS_ERR(dev->clk_ipg)) {
> +		dev_err(&pdev->dev, "Could not get ipg clock\n");
> +		return PTR_ERR(dev->clk_ipg);
> +	}
> +
> +	dev->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
> +	if (IS_ERR(dev->clk_ahb)) {
> +		dev_err(&pdev->dev, "Could not get ahb clock\n");
> +		return PTR_ERR(dev->clk_ahb);
> +	}
> +
> +	/* Allocate HW descriptors */
> +	dev->hw_desc[0] = dma_alloc_coherent(&pdev->dev,
> +			SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
> +			&dev->hw_phys_desc[0], GFP_KERNEL);
> +	if (!dev->hw_desc[0]) {
> +		dev_err(&pdev->dev, "Could not allocate hw descriptors\n");
> +		return -ENOMEM;
> +	}
> +	dev->hw_desc[1] = dev->hw_desc[0] + 1;
> +	dev->hw_phys_desc[1] = dev->hw_phys_desc[0] +
> +				sizeof(struct sahara_hw_desc);
> +
> +	/* Allocate space for iv and key */
> +	dev->key_base = dma_alloc_coherent(&pdev->dev, 2 * AES_KEYSIZE_128,
> +				&dev->key_phys_base, GFP_KERNEL);
> +	if (!dev->key_base) {
> +		dev_err(&pdev->dev, "Could not allocate memory for key\n");
> +		err = -ENOMEM;
> +		goto err_key;
> +	}
> +	dev->iv_base = dev->key_base + AES_KEYSIZE_128;
> +	dev->iv_phys_base = dev->key_phys_base + AES_KEYSIZE_128;
> +
> +	/* Allocate space for HW links */
> +	dev->hw_link[0] = dma_alloc_coherent(&pdev->dev,
> +			SAHARA_MAX_HW_LINK * sizeof(struct sahara_hw_link),
> +			&dev->hw_phys_link[0], GFP_KERNEL);
> +	if (!dev->hw_link) {
> +		dev_err(&pdev->dev, "Could not allocate hw links\n");
> +		err = -ENOMEM;
> +		goto err_link;
> +	}
> +	for (i = 1; i < SAHARA_MAX_HW_LINK; i++) {
> +		dev->hw_phys_link[i] = dev->hw_phys_link[i - 1] +
> +					sizeof(struct sahara_hw_link);
> +		dev->hw_link[i] = dev->hw_link[i - 1] + 1;
> +	}
> +
> +	crypto_init_queue(&dev->queue, SAHARA_QUEUE_LENGTH);
> +
> +	dev_ptr = dev;
> +
> +	tasklet_init(&dev->queue_task, sahara_aes_queue_task,
> +		     (unsigned long)dev);
> +	tasklet_init(&dev->done_task, sahara_aes_done_task,
> +		     (unsigned long)dev);
> +
> +	init_timer(&dev->watchdog);
> +	dev->watchdog.function = &sahara_watchdog;
> +	dev->watchdog.data = (unsigned long)dev;
> +
> +	clk_prepare_enable(dev->clk_ipg);
> +	clk_prepare_enable(dev->clk_ahb);
> +
> +	version = sahara_read(dev, SAHARA_REG_VERSION);
> +	if (version != SAHARA_VERSION_3) {

According to fsl kernel tree on linaro.org, on imx5 (sahara 4), the
register layout is different so a new check should be added:
(version >> 8) & 0xff == 4

> +		dev_err(&pdev->dev, "SAHARA version %d not supported\n",
> +			version);
> +		err = -ENODEV;
> +		goto err_algs;
> +	}
> +
> +	sahara_write(dev, SAHARA_CMD_RESET | SAHARA_CMD_MODE_BATCH,
> +		     SAHARA_REG_CMD);
> +	sahara_write(dev, SAHARA_CONTROL_SET_THROTTLE(0) |
> +			SAHARA_CONTROL_SET_MAXBURST(8) |
> +			SAHARA_CONTROL_RNG_AUTORSD |
> +			SAHARA_CONTROL_ENABLE_INT,
> +			SAHARA_REG_CONTROL);
> +
> +	err = sahara_register_algs(dev);
> +	if (err)
> +		goto err_algs;
> +
> +	dev_info(&pdev->dev, "SAHARA version %d initialized\n", version);
> +
> +	return 0;
> +
> +err_algs:
> +	dev_ptr = NULL;
> +	kfree(dev->key_base);
> +	clk_disable_unprepare(dev->clk_ipg);
> +	clk_disable_unprepare(dev->clk_ahb);
> +err_link:
> +	kfree(dev->key_base);

you're freeing 2 time key_base but not hw_link

> +err_key:
> +	kfree(dev->hw_desc[0]);

This one makes my kernel oops. Can be also reproduced by unloading the
module.

> +	return err;
> +}
> +
> +static int __devexit sahara_remove(struct platform_device *pdev)

__devinit & __devexit are gone.

> +{
> +	struct sahara_dev *dev = platform_get_drvdata(pdev);
> +
> +	kfree(dev->key_base);
> +	kfree(dev->hw_desc[0]);

missing kfree for hw_link too ?

Other than the remarks above, I'm hitting this while loading the kernel:

kernel: [   49.305657] sahara 83ff8000.sahara: nbytes: 16, enc: 1, cbc: 0
kernel: [   53.625599] BUG: spinlock lockup suspected on CPU#0, cryptomgr_test/2040
kernel: [   53.625772]  lock: 0xc27a1824, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
kernel: [   53.625943] Backtrace: 
kernel: [   53.626061] [<c0010e34>] (dump_backtrace+0x0/0x10c) from [<c05173d0>] (dump_stack+0x18/0x1c)
kernel: [   53.626251]  r6:0fd84000 r5:c27a1824 r4:00000000 r3:c24f26c0
kernel: [   53.626444] [<c05173b8>] (dump_stack+0x0/0x1c) from [<c051ab18>] (spin_dump+0x80/0x94)
kernel: [   53.626621] [<c051aa98>] (spin_dump+0x0/0x94) from [<c01f680c>] (do_raw_spin_lock+0xe8/0x12c)
kernel: [   53.626792]  r5:00000000 r4:0fd84000
kernel: [   53.626913] [<c01f6724>] (do_raw_spin_lock+0x0/0x12c) from [<c051ed14>] (_raw_spin_lock_irqsave+0x64/0x70)
kernel: [   53.627133] [<c051ecb0>] (_raw_spin_lock_irqsave+0x0/0x70) from [<bf00d388>] (sahara_aes_crypt+0x7c/0x100 [sahara])
kernel: [   53.627363]  r6:00000001 r5:c20b8580 r4:c27a1810
kernel: [   53.627525] [<bf00d30c>] (sahara_aes_crypt+0x0/0x100 [sahara]) from [<bf00d538>] (sahara_aes_ecb_encrypt+0x48/0x4c [sahara])
kernel: [   53.627744]  r8:c2755d28 r7:df9f3000 r6:00000001 r5:c20b8b00 r4:c20b8580
kernel: [   53.627970] [<bf00d4f0>] (sahara_aes_ecb_encrypt+0x0/0x4c [sahara]) from [<c01cce08>] (__test_skcipher+0x22c/0x874)
kernel: [   53.628176]  r5:c0772794 r4:c0772794
kernel: [   53.628293] [<c01ccbdc>] (__test_skcipher+0x0/0x874) from [<c01ceb68>] (test_skcipher+0x2c/0x58)
kernel: [   53.628483] [<c01ceb3c>] (test_skcipher+0x0/0x58) from [<c01cec08>] (alg_test_skcipher+0x74/0xac)
kernel: [   53.628660]  r7:dfbfe9c0 r6:c0539aac r5:c20b8b00 r4:00000000
kernel: [   53.628840] [<c01ceb94>] (alg_test_skcipher+0x0/0xac) from [<c01ce54c>] (alg_test+0x154/0x1c8)
kernel: [   53.629014]  r7:ffffffff r6:00000185 r5:dfbfe9c0 r4:00000000
kernel: [   53.632986] [<c01ce3f8>] (alg_test+0x0/0x1c8) from [<c01cc280>] (cryptomgr_test+0x2c/0x50)

Despite this, the test seems to succeed and the sahara interrupt is
increasing so it may be working.


Arnaud
