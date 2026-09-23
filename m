Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A836045C6E0;
	Wed, 23 Sep 2026 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790179016; cv=none; b=cARqz9YeSkEQjjbdcirhqeuWg/ZCIfi3sjmn73b4b7HQ2suHWAcM++YGc0NiIiZVF5oMs1iOVkXJHuVcqiyOfDAjNOUUmbwyQSQ1FRxFNdE9R758/NHb9vntUJ2uMnxl6dyALLQHpvR0kwWrFgPjwOFFsoocDixwnhfJSqBL0e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790179016; c=relaxed/simple;
	bh=/FpLeywFakr66tyZtygmudWEDeCblAzYOgiRGXwjdU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iaorwsvwcoz+rhVSAqNoYObHiZsL4LC6NpiWA3XprmdELmYDOf6b0LOzmIbysFKOE70ASnRGkrAtXfkAJbtnkfMjZM0MDTu81yKYQFHv+Sg0geHyedOk6/cxtbTkDKUF6O9WuEhfTYKl6uFaEECthURogUOEk2v4BrAuEK4hMYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojSxbjbO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojSxbjbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B541F000FF;
	Wed, 23 Sep 2026 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790179013;
	bh=xMJCztkb++DIu4FkVGc3EOyCHobio6pWpbZKkC50C1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ojSxbjbO2xBhK41KhWk7HAu6SgNQ/YUdnYIh6T1/jcZBB82dhr1G2iANV2rYHKB41
	 cZyEtyQs/0s1o2q8liazCWJcjTYWBzkKBvE+pSAfGb8chJTRGc0D8aV5DZXgdYhktd
	 poj/gCnIMCqd6dTVW4mZO6rD3z4iLJO+SCGM2vC3N5TKciMDJPeV/YWgbSVIr5VcYl
	 tPkhEiM0GLbJPybQWIG6NqZkaymHpWJmmtW7DkjK8J9wb5Cb+mSGe5h5IFPZ1NC7Fo
	 oEIT5Ska6RadE4AY04XWDt78E+42Nla0citF9/eyvLOuehAryvQQFCn5qOde5WHjxP
	 cGVV635fDN6Ig==
Date: Wed, 23 Sep 2026 16:56:49 +0100
From: Lee Jones <lee@kernel.org>
To: Qunqin Zhao <zhaoqunqin@163.com>
Cc: zhaoqunqin@loongson.cn, chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org, mfd@lists.linux.dev
Subject: Re: [PATCH v7 1/2] mfd: loongson-se: Add multi-node support
Message-ID: <20260923155649.GK3864833@google.com>
References: <20260911090256.7834-1-zhaoqunqin@163.com>
 <20260911090256.7834-2-zhaoqunqin@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911090256.7834-2-zhaoqunqin@163.com>

On Fri, 11 Sep 2026, Qunqin Zhao wrote:

> From: Qunqin Zhao <zhaoqunqin@loongson.cn>
> 
> On the Loongson platform, each node is equipped with a security engine
> device. However, due to a hardware flaw, only the device on node 0 can
> trigger interrupts. Therefore, interrupts from other nodes are forwarded
> by node 0. We need to check in the interrupt handler of node 0 whether
> this interrupt is intended for other nodes, this can be accomplished via
> shared interrupt handling.
> 
> Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
> ---
>  drivers/mfd/loongson-se.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
> index 3902ba377..7f552a8ee 100644
> --- a/drivers/mfd/loongson-se.c
> +++ b/drivers/mfd/loongson-se.c
> @@ -140,6 +140,11 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
>  
>  	int_status = readl(se->base + SE_S2LINT_STAT);
>  

Nit: Checks should follow immediately from the call that allocated them.

Thus, remove this empty line please.

> +	if (int_status == 0) {
> +		spin_unlock(&se->dev_lock);
> +		return IRQ_NONE;
> +	}
> +
>  	/* For controller */
>  	if (int_status & SE_INT_CONTROLLER) {
>  		complete(&se->cmd_completion);
> @@ -211,24 +216,26 @@ static int loongson_se_probe(struct platform_device *pdev)
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
> -		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
> +		err = devm_request_irq(dev, irq, se_irq_handler, IRQF_SHARED, "loongson-se", se);
>  		if (err)
>  			dev_err(dev, "failed to request IRQ: %d\n", irq);
>  	}
>  
> +	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
> +
>  	err = loongson_se_init(se, paddr, se->dmam_size);
>  	if (err)
>  		return err;
>  
> -	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
> +	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
>  				    ARRAY_SIZE(engines), NULL, 0, NULL);
>  }
>  
> -- 
> 2.47.2
> 

-- 
Lee Jones
