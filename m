Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8113FF883;
	Mon, 27 Jul 2026 12:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785155849; cv=none; b=SO5E0wRC4LbCSl8rheoboxYjo/p7Oxt37VmQg0F/YiW0T9CfeSGIAjqZbfvMh1Zot/qgVN3yid7h7+zo9f2WIfA2QAzp2QjIzh+atPYIChw/YUxmaRkJH7NBkiXc0joIkX+lsmqWL6YwR8gI/qB7fYmEet16KUvrIwgbEQVAAO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785155849; c=relaxed/simple;
	bh=UeTQt5CGtw9ybdmtdA0C8dBB5r5/KloYJQtfZYwKKYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MIs9ScMo5NSPvPEWrcxSQhmt09BKoc2EeNUWcTgjwVuzuElLpzf5H164hvAUncMl3yHeHPBT7ji66+KdqyLfp0RsPy5qOSGhOH29J1TWZO4VOYsxtIl1oP73orcKapzo/ne/FsNNyV0dVqDfYR/YP9qWiScTgLcVIwcvXTLB8YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j1oFG6rN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j1oFG6rN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAC09143D;
	Mon, 27 Jul 2026 05:37:22 -0700 (PDT)
Received: from [10.2.212.23] (e121345-lin.cambridge.arm.com [10.2.212.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FF9B3F86F;
	Mon, 27 Jul 2026 05:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785155846; bh=UeTQt5CGtw9ybdmtdA0C8dBB5r5/KloYJQtfZYwKKYs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j1oFG6rNwHvvYxV8WwPrvst+lYXd6bDd5WGa7Rpjy/KciCMj4jPNf5vj1F25dJUE2
	 3YsB3+3zn5vLuzbivYvTDjdWROVWj8MZb1UKsWP0ycIumPxiQ9n3Rkue3466cG8waK
	 jhagSVEXeekGOVVDYgKY0Kq7+/aKs6ccIOnWrfjY=
Message-ID: <ec551e71-272e-4ea5-851e-840849fb913e@arm.com>
Date: Mon, 27 Jul 2026 13:37:24 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] crypto: cesa: check for sram_dma error
To: Rosen Penev <rosenp@gmail.com>, linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
 Bharat Bhushan <bbhushan2@marvell.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Boris Brezillon <bbrezillon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260717225831.1085313-1-rosenp@gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260717225831.1085313-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/07/2026 11:58 pm, Rosen Penev wrote:
> dma_map_resource() might fail. In such a case, don't call
> dma_unmap_resource()
> 
> Fixes: 37d728f76c41 ("crypto: marvell/cesa - Fix DMA API misuse")
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>   v2: use dma_mapping_error(). Fix Fixes tag.
>   drivers/crypto/marvell/cesa/cesa.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
> index 75d8ba23d9a2..92e977027c8a 100644
> --- a/drivers/crypto/marvell/cesa/cesa.c
> +++ b/drivers/crypto/marvell/cesa/cesa.c
> @@ -406,7 +406,8 @@ static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
>   	if (engine->pool)
>   		gen_pool_free(engine->pool, (unsigned long)engine->sram_pool,
>   			      cesa->sram_size);
> -	else
> +	else if (engine->sram &&

This is still not quite right if the 
devm_platform_get_and_ioremap_resource() call fails, since engine->sram 
will then be non-NULL (an ERR_PTR value), but engine->sram_dma is still 
untouched, and dma_mapping_error(0) is (usually) false.

Thanks,
Robin.

> +		 !dma_mapping_error(cesa->dev, engine->sram_dma))
>   		dma_unmap_resource(cesa->dev, engine->sram_dma,
>   				   cesa->sram_size, DMA_BIDIRECTIONAL, 0);
>   }

