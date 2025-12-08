Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C47B31A577;
	Mon,  8 Dec 2025 09:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765184679; cv=none; b=nzqSxj8RGUpd2lZLFcNPtY3MCHTAF3upe2tH9q1NAyzeWlYbVcaDWmtDj4XXdBHJilAbvf5zY4jePynWv4OM3I3HT0/Mxs3wMdMlO+ijHLS264cgqRCLWKHmKOsuKwf/RgKfYJP+keRi4SKQwbv7DVbpY0isqGcOaFgvyPxfN6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765184679; c=relaxed/simple;
	bh=97fkJuvk4urH6ZjaZGkVq1tPn6sD2BuLWQdXOI7/owE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JpJRdDnBgggT2bG/VRfJbn31bwlTcnl24HZ1kVmQJdLjBkSZKwaki78O1LN97n3YsHxXMSnXIrVuavdDJJuXNtvZ9oKo5N/+DYfBhMjENc9r0Z9CWpBi3+B8gqcK2Lko12n7lC4nuINInquTg2mTV241ImZ46ZKO+F0dU6w/nWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from martin by akranes.kaiser.cx with local (Exim 4.96)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1vSWnE-001fnq-1l;
	Mon, 08 Dec 2025 09:40:28 +0100
Date: Mon, 8 Dec 2025 09:40:28 +0100
From: Martin Kaiser <lists@kaiser.cx>
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: ansuelsmth@gmail.com, olivia@selenic.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: airoha: Fix wait_for_completion_timeout return
 value check
Message-ID: <aTaO_EWbszgGeqz-@akranes.kaiser.cx>
References: <20251208080836.1010-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208080836.1010-1-vulab@iscas.ac.cn>
Sender: "Martin Kaiser,,," <martin@akranes.kaiser.cx>

Thus wrote Haotian Zhang (vulab@iscas.ac.cn):

> wait_for_completion_timeout() returns an unsigned long
> representing remaining jiffies, not an int. It returns
> 0 on timeout and a positive value on completion, never
> a negative error code.

> Change the type of ret to unsigned long, and update the
> check to == 0 to correctly detect timeouts.

> Fixes: e53ca8efcc5e ("hwrng: airoha - add support for Airoha EN7581 TRNG")
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
> ---
>  drivers/char/hw_random/airoha-trng.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/char/hw_random/airoha-trng.c b/drivers/char/hw_random/airoha-trng.c
> index 1dbfa9505c21..3e94233e1389 100644
> --- a/drivers/char/hw_random/airoha-trng.c
> +++ b/drivers/char/hw_random/airoha-trng.c
> @@ -76,7 +76,7 @@ static int airoha_trng_irq_unmask(struct airoha_trng *trng)
>  static int airoha_trng_init(struct hwrng *rng)
>  {
>  	struct airoha_trng *trng = container_of(rng, struct airoha_trng, rng);
> -	int ret;
> +	unsigned long ret;
>  	u32 val;

>  	val = readl(trng->base + TRNG_NS_SEK_AND_DAT_EN);
> @@ -88,7 +88,7 @@ static int airoha_trng_init(struct hwrng *rng)
>  	writel(0, trng->base + TRNG_HEALTH_TEST_SW_RST);

>  	ret = wait_for_completion_timeout(&trng->rng_op_done, BUSY_LOOP_TIMEOUT);
> -	if (ret <= 0) {
> +	if (ret == 0) {
>  		dev_err(trng->dev, "Timeout waiting for Health Check\n");
>  		airoha_trng_irq_mask(trng);
>  		return -ENODEV;
> -- 
> 2.50.1.windows.1

Reviewed-by: Martin Kaiser <martin@kaiser.cx>
