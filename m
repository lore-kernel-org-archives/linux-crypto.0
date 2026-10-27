Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=114.242.206.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793073590;
	b=L1SYTI+AI/9KGiMJtVVTB28/NazIQQbJBLJvGGHBs0F2YUh97QnbEGHdaQXwirS/1knS
	 3XHCD9XEiy2JFCwMGxhwCGA1/zVwhVq5JqVydmnFtD/fDgO0hczcV9LGwaHipvWeF/zQg
	 FyRx4XJ+7gzL4vQx9xcuuezVvyB3xsCc4DMJY4+vYoRX5MPSB2goA+aVOMeg0yzrqEoeC
	 ZpvAypPQ0STIzyRd8d/3yKgtpUHxZCwyOrcgwQ+rFa92BxNqk1tCC2WN9VvGAcruUP1c+
	 CPxA64TdgAdX2GQVBJ5TALudF5cVKEa+3rp6+D9TXxRgsuKLRcq9/hEqyRREQ8/rc8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793073590;
	h=DMARC-Filter:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:X-CM-SenderInfo:
	 X-Coremail-Antispam;
	bh=yNjVGzNCe/dUhA+Uvzx9OfKhmHV1qkPYX987us1hODA=;
	b=y6RiXFNVErz9Pn0s+7FoUofsKUOBOcSx8QyowrSdy6lgJ+k8zncO5Dltq+Ybc79oYr7Z
	 zkjbTTsMojHhsu22tkNyBRpGCCPOPlfOYJ1zsy2G4mOv6C3j2zk5OEAxJn2NwjSvp9ySM
	 iOa5/LpXJs6VPR74P2yipm/SgFWPMun6eB9Y3i4dZR71JVsikVi627HpXfusXdexhnqFu
	 uXJeIZG1KuziauNQi63bZJ3GdesiDYga9O3iuXcVRb1linW0Q8rPlF5ZKPUZ1kk3hdyNX
	 HxzRlcVt8RUW+iL3dQ7Ef2aHOIQfyn5LycqiXuaynu0lfEI9PLjukr1QS2XaSKRieCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=loongson.cn;
	spf=pass smtp.mailfrom=loongson.cn;
	arc=none smtp.remote-ip=114.242.206.163
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35180606A31A;
	Tue, 27 Oct 2026 03:59:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35180606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.102])
	by gateway (Coremail) with SMTP id _____8DxjdKxIeBqUbIZAA--.8827S3;
	Tue, 27 Oct 2026 11:59:45 +0800 (CST)
Received: from [127.0.0.1] (unknown [127.0.0.1])
	by front1 (Coremail) with SMTP id qMiowJBxpMyrIeBqK40wAA--.9167S2;
	Tue, 27 Oct 2026 11:59:42 +0800 (CST)
Message-ID: <aa36b32b-5702-42e9-b27a-19dcf373b777@loongson.cn>
Date: Tue, 27 Oct 2026 11:56:54 +0800
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/28] mfd: loongson-se: Stop controller and mask
 interrupts on teardown and shutdown
To: Lee Jones <lee@kernel.org>
Cc: Yinggang Gu <guyinggang@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, linux-crypto@vger.kernel.org, mfd@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261021121245.3111563-1-lee@kernel.org>
 <20261021121245.3111563-20-lee@kernel.org>
Content-Language: en-US
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
In-Reply-To: <20261021121245.3111563-20-lee@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxpMyrIeBqK40wAA--.9167S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3XrW7uF4DWF48Gw4ftryxJFc_yoW7Wr48pF
	4DAa4a9r4Yyr42kwsxXrZ09F1Y934ftry7CrZ7Ww4xCryDtw18Wry5KF18GFs3Cr4UXF48
	XrW8GrZ5CF48uFgCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j0sjUUUUUU=


在 2026/10/21 20:09, Lee Jones 写道:
> loongson_se_probe() enables hardware interrupts before registering IRQ
> handlers and starts the controller via loongson_se_init(), but provides
> no teardown or shutdown handler to stop the controller and mask
> interrupts.  If probe fails after loongson_se_init(), if the driver is
> unbound, or during a system reboot or kexec transition, the controller
> remains active with DMA configured to memory that is reclaimed.
>
> Clear pending interrupts before requesting IRQs, unmask interrupts only
> after IRQ handlers are registered, clean up on failure inside
> loongson_se_init(), register a devres action after loongson_se_init()
> succeeds to issue SE_CMD_STOP and mask interrupts on teardown, and wire
> up the platform driver .shutdown callback.
>
> Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
> Closes: https://sashiko.dev/#/bug/linux-15511672-7569-4eac-96a0-c08581925710
> Closes: https://sashiko.dev/#/bug/linux-e6ed8d33-d641-4969-a5ea-959f21ae3696
> Cc: stable@vger.kernel.org
> Signed-off-by: Lee Jones <lee@kernel.org>

Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>

Thanks for fixing this!


Best Regards,

Qunqin.

> ---
>  drivers/mfd/loongson-se.c       | 51 +++++++++++++++++++++++++++++----
>  include/linux/mfd/loongson-se.h |  1 +
>  2 files changed, 46 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index 10af13c3b7cc..bdbab4b91729 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -169,6 +169,23 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +static void loongson_se_stop(void *data)
> +{
> +	struct loongson_se *se = data;
> +	struct loongson_se_controller_cmd cmd = {};
> +
> +	mutex_lock(&se->engine_init_lock);
> +
> +	cmd.command_id = SE_CMD_STOP;
> +	loongson_se_send_controller_cmd(se, &cmd);
> +
> +	spin_lock_irq(&se->dev_lock);
> +	writel(0, se->base + SE_S2LINT_EN);
> +	spin_unlock_irq(&se->dev_lock);
> +
> +	mutex_unlock(&se->engine_init_lock);
> +}
> +
>  static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
>  {
>  	struct loongson_se_controller_cmd cmd = {};
> @@ -176,15 +193,23 @@ static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
>  
>  	cmd.command_id = SE_CMD_START;
>  	err = loongson_se_send_controller_cmd(se, &cmd);
> -	if (err)
> +	if (err) {
> +		writel(0, se->base + SE_S2LINT_EN);
>  		return err;
> +	}
>  
>  	cmd.command_id = SE_CMD_SET_DMA;
>  	cmd.info[0] = lower_32_bits(addr);
>  	cmd.info[1] = upper_32_bits(addr);
>  	cmd.info[2] = size;
>  
> -	return loongson_se_send_controller_cmd(se, &cmd);
> +	err = loongson_se_send_controller_cmd(se, &cmd);
> +	if (err) {
> +		loongson_se_stop(se);
> +		return err;
> +	}
> +
> +	return 0;
>  }
>  
>  static const struct mfd_cell engines[] = {
> @@ -192,6 +217,13 @@ static const struct mfd_cell engines[] = {
>  	{ .name = "tpm_loongson" },
>  };
>  
> +static void loongson_se_shutdown(struct platform_device *pdev)
> +{
> +	struct loongson_se *se = platform_get_drvdata(pdev);
> +
> +	loongson_se_stop(se);
> +}
> +
>  static int loongson_se_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -225,12 +257,12 @@ static int loongson_se_probe(struct platform_device *pdev)
>  	if (IS_ERR(se->base))
>  		return PTR_ERR(se->base);
>  
> -	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
> -
>  	nr_irq = platform_irq_count(pdev);
>  	if (nr_irq <= 0)
>  		return -ENODEV;
>  
> +	writel(SE_INT_ALL, se->base + SE_S2LINT_CL);
> +
>  	for (i = 0; i < nr_irq; i++) {
>  		irq = platform_get_irq(pdev, i);
>  		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
> @@ -238,10 +270,16 @@ static int loongson_se_probe(struct platform_device *pdev)
>  			dev_err(dev, "failed to request IRQ: %d\n", irq);
>  	}
>  
> +	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
> +
>  	err = loongson_se_init(se, paddr, se->dmam_size);
>  	if (err)
>  		return err;
>  
> +	err = devm_add_action_or_reset(dev, loongson_se_stop, se);
> +	if (err)
> +		return err;
> +
>  	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
>  				    ARRAY_SIZE(engines), NULL, 0, NULL);
>  }
> @@ -253,8 +291,9 @@ static const struct acpi_device_id loongson_se_acpi_match[] = {
>  MODULE_DEVICE_TABLE(acpi, loongson_se_acpi_match);
>  
>  static struct platform_driver loongson_se_driver = {
> -	.probe   = loongson_se_probe,
> -	.driver  = {
> +	.probe    = loongson_se_probe,
> +	.shutdown = loongson_se_shutdown,
> +	.driver   = {
>  		.name  = "loongson-se",
>  		.acpi_match_table = loongson_se_acpi_match,
>  	},
> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
> index 2d0a8b1e5c9e..dbe5992bd435 100644
> --- a/include/linux/mfd/loongson-se.h
> +++ b/include/linux/mfd/loongson-se.h
> @@ -11,6 +11,7 @@
>  #define SE_SEND_CMD_REG_LEN		0x8
>  /* Controller command ID */
>  #define SE_CMD_START			0x0
> +#define SE_CMD_STOP			0x1
>  #define SE_CMD_SET_DMA			0x3
>  #define SE_CMD_SET_ENGINE_CMDBUF	0x4
>  

