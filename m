Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8BE4AEE0;
	Tue, 29 Oct 2024 18:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730226163; cv=none; b=gw/Jc3ZnUab8F356MJlxOz0FywgkkFOhC9EkQFsUHDQpxwurWRmQFOmKw+p5Tr3Jpt1rraPvY3xM07c4SFJ3LQhLh70goSMx1WrWaaXJdt15VOyQRWoVPPntW5xqx5CuoHM23WCt2dv66YGhqAiANcO5xthtW6nBXM6GZjotVuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730226163; c=relaxed/simple;
	bh=cDN+Kio485uI1+mHZTMvXjvfikGTUIEBVb/zNwaom8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMkdSNgdmFEanuR5Vni0WX9GuvDc5UdCX2+yBl3NK/F0qvJOYvtBzJCpc4nD3izKWMht+x6i2lGtOmZH9LOYAXvwR2+7jOZYfdDXgcTsQ20TnKlgTrJinpAIG5RBUavahuiduUK9cpeFRwKW1UTaHcBmhER6ETxrPXUoWle3uoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=UzMiqvUr; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="UzMiqvUr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=SiVr3pgC9/d36AWyRc73mxkAo1EYW9orAH0ljPOv1w8=; b=UzMiqvUrPx/kuL7j
	J2Z+DEND4542a672OjGgtH0sf2XyfPWYtSH0LJfqLrHq/i3tb5d/PVpn7BmVl6KiaPnReZGwS2mdf
	HgMlL8IL6lb4zImc9Ahodvc2fBe9zOw7raVq/oKcuk0gnjn8Pfp+UlFOtRqtW8kPS1WWiyVGwwkxP
	oAQsRBY1ysBBj9iRQLK6zaX96JkxzN3ujB4aHgbsB2PqA75Zcu/Z1JoXLDgvHd0u6+PHnIiKZS3RA
	cbcvY+513++6r5iKgB4dcDYV+xjEdblo2z4jXjp4C0K4wJV639/XukPuqJk2qvCdmf+EMJa+/6OXr
	0ElIJBTA2fN2iCbUgg==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1t5qrN-00EImw-2u;
	Tue, 29 Oct 2024 18:22:29 +0000
Date: Tue, 29 Oct 2024 18:22:29 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: dan.j.williams@intel.com, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] async_xor: Remove unused 'async_xor_val'
Message-ID: <ZyEn5f8w8Ez2Szw3@gallifrey>
References: <20240929132148.44792-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240929132148.44792-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 18:22:11 up 174 days,  5:36,  1 user,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> async_xor_val has been unused since commit
> a7c224a820c3 ("md/raid5: convert to new xor compution interface")
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Ping.

Thanks,

Dave

> ---
>  crypto/async_tx/async_xor.c | 26 --------------------------
>  include/linux/async_tx.h    |  5 -----
>  2 files changed, 31 deletions(-)
> 
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index 1a3855284091..2c499654a36c 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -389,32 +389,6 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
>  }
>  EXPORT_SYMBOL_GPL(async_xor_val_offs);
>  
> -/**
> - * async_xor_val - attempt a xor parity check with a dma engine.
> - * @dest: destination page used if the xor is performed synchronously
> - * @src_list: array of source pages
> - * @offset: offset in pages to start transaction
> - * @src_cnt: number of source pages
> - * @len: length in bytes
> - * @result: 0 if sum == 0 else non-zero
> - * @submit: submission / completion modifiers
> - *
> - * honored flags: ASYNC_TX_ACK
> - *
> - * src_list note: if the dest is also a source it must be at index zero.
> - * The contents of this array will be overwritten if a scribble region
> - * is not specified.
> - */
> -struct dma_async_tx_descriptor *
> -async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
> -	      int src_cnt, size_t len, enum sum_check_flags *result,
> -	      struct async_submit_ctl *submit)
> -{
> -	return async_xor_val_offs(dest, offset, src_list, NULL, src_cnt,
> -			len, result, submit);
> -}
> -EXPORT_SYMBOL_GPL(async_xor_val);
> -
>  MODULE_AUTHOR("Intel Corporation");
>  MODULE_DESCRIPTION("asynchronous xor/xor-zero-sum api");
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
> index 5cc73d7e5b52..1ca9f9e05f4f 100644
> --- a/include/linux/async_tx.h
> +++ b/include/linux/async_tx.h
> @@ -167,11 +167,6 @@ async_xor_offs(struct page *dest, unsigned int offset,
>  		struct page **src_list, unsigned int *src_offset,
>  		int src_cnt, size_t len, struct async_submit_ctl *submit);
>  
> -struct dma_async_tx_descriptor *
> -async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
> -	      int src_cnt, size_t len, enum sum_check_flags *result,
> -	      struct async_submit_ctl *submit);
> -
>  struct dma_async_tx_descriptor *
>  async_xor_val_offs(struct page *dest, unsigned int offset,
>  		struct page **src_list, unsigned int *src_offset,
> -- 
> 2.46.2
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
