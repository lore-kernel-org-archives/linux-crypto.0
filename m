Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D12298CA6;
	Fri, 27 Jun 2025 10:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751021830; cv=none; b=WJk6NNu0O1kEetUtAYX/zZVjR7QF8pQViPndhG86HoHt/I19iYNiKk7DRHvlVotN1cRRAW+4h+NPmIz2jAwTYC+/gesZz2yaTbTY1bfTj4xWFea9M3NUzNAsg6sFKZ0StMNVvup8s/1ETqmNKNak7TcpRy6+KjhlqNV+2CY9jU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751021830; c=relaxed/simple;
	bh=6LeEQMY2R6fE0USThubcoc4+I+0HfqSLN2u+w0Br1jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WSeIiSI5HBKhL1pUaBM9jZxll8hk57DkvdgPWCABee4PmtiazmC19D5o5gSbWw8oaMJJw+A6PJkjEY7YE0LDzs3d3MUj2EP5pWenTveN1FvrUwKCN5A+e/k3/M0yu37Lhd8mPrhh+CFimcvO51yt3Hpo1Sqg2ndVhw4frzdCw7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqzx9QRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqzx9QRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0E9C4CEE3;
	Fri, 27 Jun 2025 10:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751021829;
	bh=6LeEQMY2R6fE0USThubcoc4+I+0HfqSLN2u+w0Br1jo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jqzx9QRSQtpb9W/z1Y82jvXOCIsqaYZard1+FI+q8nJL2Xus7nxBqgr3jG2lZurSV
	 +gkYt8PxwjlP8YmPSLAhIWqC8t3YikSRx9k6vcHwNiH7+laH7rkJiI+3Bx9rN0JOVe
	 XJUM28fcvCwaVMH41yw+8q8xy7u4o7mHdRH1k+qknypldjhDehYsywHIg/Fp9fEgwJ
	 k6eLTziDXvs/dg8f/E3oB3BpbdMZI4XQJG+A4yVIKIMblVoKDstSeCMp6XfQ7vs1+J
	 7WQ7zGFBZl4JLf2pn5hjjySDw4ZRS9+O4+rGHoGt8qMrVfmKKSIPG0t7wJfanr9lPn
	 ns6fkyShms6Tw==
Message-ID: <909f1a39-b614-4292-912a-624be5df6af1@kernel.org>
Date: Fri, 27 Jun 2025 11:57:07 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvmem: layouts: Switch from crc32() to crc32_le()
To: Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
 Srinivas Kandagatla <srini@kernel.org>
References: <20250620205027.23403-1-ebiggers@kernel.org>
Content-Language: en-US
From: Srinivas Kandagatla <srini@kernel.org>
In-Reply-To: <20250620205027.23403-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/20/25 9:50 PM, Eric Biggers wrote:
> u_boot_env_parse() calls crc32() from within a scope that has a uint32_t
> variable named crc32.  This works only because crc32() is actually a
> macro that expands to crc32_le().  I'm planning to make it an inline
> function instead, which will make the usual C scoping rules apply to it.
> Therefore, update u_boot_env_parse() to be compatible with that.  To do
> so, just call crc32_le() directly instead of using the crc32() alias.
> (An alternative would be to rename the local variable.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> I'm planning to apply this patch to crc-next, since my patch
> https://lore.kernel.org/r/20250619183414.100082-3-ebiggers@kernel.org/
> depends on this.


Acked-by: Srinivas Kandagatla <srini@kernel.org>

--srini

> 
>  drivers/nvmem/layouts/u-boot-env.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvmem/layouts/u-boot-env.c b/drivers/nvmem/layouts/u-boot-env.c
> index 436426d4e8f91..274e8a456e8c1 100644
> --- a/drivers/nvmem/layouts/u-boot-env.c
> +++ b/drivers/nvmem/layouts/u-boot-env.c
> @@ -146,11 +146,11 @@ int u_boot_env_parse(struct device *dev, struct nvmem_device *nvmem,
>  	crc32_addr = (__le32 *)(buf + crc32_offset);
>  	crc32 = le32_to_cpu(*crc32_addr);
>  	crc32_data_len = dev_size - crc32_data_offset;
>  	data_len = dev_size - data_offset;
>  
> -	calc = crc32(~0, buf + crc32_data_offset, crc32_data_len) ^ ~0L;
> +	calc = crc32_le(~0, buf + crc32_data_offset, crc32_data_len) ^ ~0L;
>  	if (calc != crc32) {
>  		dev_err(dev, "Invalid calculated CRC32: 0x%08x (expected: 0x%08x)\n", calc, crc32);
>  		err = -EINVAL;
>  		goto err_kfree;
>  	}
> 
> base-commit: e04c78d86a9699d136910cfc0bdcf01087e3267e

