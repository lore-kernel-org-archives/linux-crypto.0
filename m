Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EF02FB97B;
	Fri,  6 Mar 2026 13:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772804162; cv=none; b=kb6rmjEg8Gu9qF/Ix34lw0eRwfxA56PcmyqkMP83iwgUg/+gg5WXef1DyRI83GXYn7xSFaxuwLAlfXzeGGFHJcGsz3AXfc5lJdPPPwrOz9h6UsPm9eCyCM98lPMzmqfrQl4Dj2/YEazHX8nsCLwldC3VlLrJqQItJSM0J7sQ58k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772804162; c=relaxed/simple;
	bh=TWDXtJWdxpOQeGtw/5t2k2HNsAK+Wlpw4wGXYUyDegg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g8011agfF8TcphEy2CO0HHnmDxwIo7GEjtNctvduTOmahy4jXhyZbOaR+MqTQrUMIUoTEYb58VSbkbXa2kLb8cux3zJ69blUSJDtkohE5wKE6NtqFsFavZu85EfRcC9L5MKep4otk8S/d3f1wVAixPO5552iza+w3oAC0XLwNhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vIo3o4OB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vIo3o4OB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B93CC4CEF7;
	Fri,  6 Mar 2026 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772804162;
	bh=TWDXtJWdxpOQeGtw/5t2k2HNsAK+Wlpw4wGXYUyDegg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vIo3o4OB1dD7sZybxM+1696l84aWLmVXwtes2jvlyjJ+X7+JOkRrAgqCDv0QwwV+7
	 lDVWzxGTbJ4gi4oeu0AYDpk7tV6cINoneTtFmDgJHKfdgzbXS2kAe3tryIDdOUaqU8
	 tNWXeSi2sMlOVF5H53ilZKaTxUSC1Nne+7/07FhH/DNQ5+hTubFJOoBQO2Hs/3LzSU
	 wkQT8ogQRECgsYe4JS15mrl33raXhxKiYPu9Ka0uQDqsNfjZJjMW1J10iyGzKqeT2u
	 a8qtBo7cbLbExDNms/t9FNsx3owwv00ZX2eylKSzikdkMTxh8DDNNY5kmcKhmJvbQB
	 ctgeNcL0RHeTQ==
Date: Fri, 6 Mar 2026 13:35:58 +0000
From: Lee Jones <lee@kernel.org>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] mfd: loongson-se: Add multi-node support
Message-ID: <20260306133558.GL183676@google.com>
References: <20260226102225.19516-1-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226102225.19516-1-zhaoqunqin@loongson.cn>

On Thu, 26 Feb 2026, Qunqin Zhao wrote:

> On the Loongson platform, each node is equipped with a security engine
> device. However, due to a hardware flaw, only the device on node 0 can
> trigger interrupts. Therefore, interrupts from other nodes are forwarded
> by node 0. We need to check in the interrupt handler of node 0 whether
> this interrupt is intended for other nodes.
> 
> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> ---
>  drivers/mfd/loongson-se.c       | 38 +++++++++++++++++++++++++++------
>  include/linux/mfd/loongson-se.h |  3 +++
>  2 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index 3902ba377..40e18c212 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -37,6 +37,9 @@ struct loongson_se_controller_cmd {
>  	u32 info[7];
>  };
>  
> +static DECLARE_COMPLETION(node0);
> +static struct loongson_se *se_node[SE_MAX_NODES];

Really not keen on global variables.

Why are they _needed_?

>  static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
>  {
>  	u32 status;
> @@ -133,8 +136,8 @@ EXPORT_SYMBOL_GPL(loongson_se_init_engine);
>  static irqreturn_t se_irq_handler(int irq, void *dev_id)
>  {
>  	struct loongson_se *se = dev_id;
> -	u32 int_status;
> -	int id;
> +	u32 int_status, node_irq = 0;
> +	int id, node;
>  
>  	spin_lock(&se->dev_lock);
>  
> @@ -147,6 +150,11 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>  		writel(SE_INT_CONTROLLER, se->base + SE_S2LINT_CL);
>  	}
>  
> +	if (int_status & SE_INT_OTHER_NODE) {
> +		int_status &= ~SE_INT_OTHER_NODE;
> +		node_irq = 1;
> +	}
> +
>  	/* For engines */
>  	while (int_status) {
>  		id = __ffs(int_status);
> @@ -157,6 +165,14 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>  
>  	spin_unlock(&se->dev_lock);
>  
> +	if (node_irq) {
> +		writel(SE_INT_OTHER_NODE, se->base + SE_S2LINT_CL);
> +		for (node = 1; node < SE_MAX_NODES; node++) {
> +			if (se_node[node])
> +				se_irq_handler(irq, se_node[node]);
> +		}
> +	}
> +
>  	return IRQ_HANDLED;
>  }
>  
> @@ -189,6 +205,7 @@ static int loongson_se_probe(struct platform_device *pdev)
>  	struct loongson_se *se;
>  	int nr_irq, irq, err, i;
>  	dma_addr_t paddr;
> +	int node = dev_to_node(dev);
>  
>  	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
>  	if (!se)
> @@ -213,9 +230,16 @@ static int loongson_se_probe(struct platform_device *pdev)
>  
>  	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
>  
> -	nr_irq = platform_irq_count(pdev);
> -	if (nr_irq <= 0)
> -		return -ENODEV;
> +	if (node == 0 || node == NUMA_NO_NODE) {
> +		nr_irq = platform_irq_count(pdev);
> +		if (nr_irq <= 0)
> +			return -ENODEV;
> +	} else {
> +		/* Only the device on node 0 can trigger interrupts */
> +		nr_irq = 0;
> +		wait_for_completion_interruptible(&node0);
> +		se_node[node] = se;
> +	}
>  
>  	for (i = 0; i < nr_irq; i++) {
>  		irq = platform_get_irq(pdev, i);
> @@ -228,7 +252,9 @@ static int loongson_se_probe(struct platform_device *pdev)
>  	if (err)
>  		return err;
>  
> -	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
> +	complete_all(&node0);
> +
> +	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
>  				    ARRAY_SIZE(engines), NULL, 0, NULL);
>  }
>  
> diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
> index 07afa0c25..a80e06eb0 100644
> --- a/include/linux/mfd/loongson-se.h
> +++ b/include/linux/mfd/loongson-se.h
> @@ -20,6 +20,9 @@
>  
>  #define SE_INT_ALL			0xffffffff
>  #define SE_INT_CONTROLLER		BIT(0)
> +#define SE_INT_OTHER_NODE		BIT(31)
> +
> +#define SE_MAX_NODES			8
>  
>  #define SE_ENGINE_MAX			16
>  #define SE_ENGINE_RNG			1
> -- 
> 2.47.2
> 

-- 
Lee Jones [李琼斯]
