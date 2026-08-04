Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B2741D64C
	for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2026 07:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827476; cv=none; b=ZvsBryYlm8bDSWCJpPYdGuUnI8IPFOp1+IYZpXyDmhf03DagFG1SiYJjJqGr/V6UZJs0A4NRkOf7gFH45dasDVhAhWn2hF5rljok/bRrSPZjDlopg4prVLKjT83nr9OwrrPvRR15Ctm+lDWS+sZzFTYYfeEyvtLlUDr9tdxbpRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827476; c=relaxed/simple;
	bh=CvrJJuKxBRl4Nasl6M3rj9BrxLN7b9BUK0l3FiU0AeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ngXyTssnFGPOVfXtxtLpj52lRDw6cLrSyCFSBP+5yz4FsaU8exSD6TqGJ5y7e9W8aphhvdH2a24yfxjI0bgJdwWTUY3kmRv0lodX9+b38ti/IDiKjKJXKJwvU7dUVVV2VHsWd+qyc6eIUR//QmznPJI8/UPbVp8JHX4KItq6dNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtW3kz5Y; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ECyj4/vS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtW3kz5Y";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ECyj4/vS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785827473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pj335Adan148/UDPm7Hpp1sOZ1q9DMsEy5KTwm1oaEY=;
	b=WtW3kz5YEX2bt7hZb+1EVEpXHsIa2nUOekTmxdAdCoalOAgeTiARqDSg5eKZJYlgP4ZS3J
	bEcKmP5zSGTh5XKSpVu9f3E0txWpz7QZ/Z/J/FNF85YkV8N0al9QwaifJAI8wUHSBsUiuP
	+UqPvfAyv5AnExQMzbPxKmJR3GQ5OIA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-7EW_a_VdN0OaA_-8yDjyBQ-1; Tue, 04 Aug 2026 03:11:00 -0400
X-MC-Unique: 7EW_a_VdN0OaA_-8yDjyBQ-1
X-Mimecast-MFC-AGG-ID: 7EW_a_VdN0OaA_-8yDjyBQ_1785827459
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4955e865174so16766065e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2026 00:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785827459; x=1786432259; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pj335Adan148/UDPm7Hpp1sOZ1q9DMsEy5KTwm1oaEY=;
        b=ECyj4/vSaNUEGeWo1xxde4mtb3T4CVrJijvwlEREEO303MMZhLybUQoONxBJz1D/Yw
         wERlXhqMMD3rpdwz4EzZ8GeUpw2+lXOCGacDEXzznOJAvE4Iy1rVTwWc1WLkEc7M8TlB
         9cRJi2pg9nf2iQ4p993cmdzUKljl6MIdkrp55yvMH3Z3/2z2gvykoedLZ1njdT/ppjOD
         xwAYgU2QwWz+g10vRirDInyAyCu3m2NB6kPwEvJfX2wjck8c/+SiVyb/nT1VV3e7LMkb
         vywZ9qIafr91kg7lzRgilMMoIOKUXLiLT12f8o/GK1P7NMqh2jwOwfMr+rRX/OUlKeTe
         KvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785827459; x=1786432259;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pj335Adan148/UDPm7Hpp1sOZ1q9DMsEy5KTwm1oaEY=;
        b=Zz66U0TPHIbaq8ulwdn00h/MoVv8vaOVKGuHrpCaDaLfAtBuPS90Zz7FJPUWLgYenp
         i0A3irxek1XUcIWTzQ/QWp1VV6UMAc1ThbPXzPUNL7/4Ji8fo2urmGzyNOSvdGAywvcI
         YDdR4yaYa3x1X1ZdVKZEyKdrSwsFNVfCvo+jeeQC7jfZGx3sx2ait85xpyrJQ/PvDIP2
         BVBpyDRHzU43p3ZKLrH2eWOERlZUDlXe7VW9PBlD7yG7Tf0K/ZSs0SiUmFp4hmQE/vrz
         Aa0W0ZKNGwwPqxApX8bMfGMtP8uMb/DrSKfqWOkurSK8cN7iB1CJhHxwdOMZOpctup2l
         In5g==
X-Forwarded-Encrypted: i=1; AHgh+Rq0rjkk7NjT0soFTd4j3Ah22Q9HR82ZPuXOYIfY0sv6M6Z3csmWcwgmf9pkdZnv5eE3vthGGzi+QbJjhkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFjSmFcNq9UeygB9cojm8/2+gRmQ+/pDMWTQ7bvbqM9NF2ewhH
	ocSfydpmXRMROdouTHsSu0E2Se1XiD/sXS1vYltXEs8St4PjWPykNNxNJx6pKlj6Dp+DkhPkiHR
	gYVxbPQ3bDpRDMxRQ3HbsBo0S9sRx0Y2mR9Ht3Ech/PR1CIjedE01w1u8X95bODCmgQ==
X-Gm-Gg: AR+sD12K4JmwCMb7so++0JSaa4PiM4lxazMMwple70gB1FCm3mp3OzDAxrXO2Smv9I8
	kQ0OyltBZagq30Q8ldX5ZAVf8jMlSt5wHD94O2R4W6CmxdPcBxqIbolbTtcHzfQVqDISFblh0gm
	us1+8R5Cf2pTH0v1gDlGcQfPMnHGFof8EV68fehFd3tHog3tKVx1ydM1Bz8VAGKziCp+W2k7mlo
	VkeqV6kNq2MDwsVAet613i9ZdA8w0z7SBCgRClJ0fKHnplunhZ5mzdPjWR5nXdIvrYtabCkoV8O
	qhItHZEYxh5J1PX/VqmDBRot9/zDd/svNEK4Y+VdJfQlaDoR7PCbDB4URx+JWi/eXQkunkAd
X-Received: by 2002:a05:600c:3b2a:b0:499:4ada:981d with SMTP id 5b1f17b1804b1-4994ada9885mr37136825e9.7.1785827458992;
        Tue, 04 Aug 2026 00:10:58 -0700 (PDT)
X-Received: by 2002:a05:600c:3b2a:b0:499:4ada:981d with SMTP id 5b1f17b1804b1-4994ada9885mr37136405e9.7.1785827458624;
        Tue, 04 Aug 2026 00:10:58 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b23f6fsm256254955e9.0.2026.08.04.00.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 00:10:57 -0700 (PDT)
Message-ID: <8e0dc8db-bfb7-40f4-b6f8-fc773e8b74f1@redhat.com>
Date: Tue, 4 Aug 2026 09:10:56 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: eip93 - use struct_size() and flexible array for
 ring allocation
To: Rosen Penev <rosenp@gmail.com>, linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
 Antoine Tenart <atenart@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 open list <linux-kernel@vger.kernel.org>
References: <20260803224028.87631-1-rosenp@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260803224028.87631-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/08/2026 00.40, Rosen Penev wrote:
> Embed the single ring as a flexible array member in eip93_device
> instead of allocating it separately. This simplifies the probe path
> and uses struct_size() for a single allocation.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>   .../crypto/inside-secure/eip93/eip93-main.c   |  6 +----
>   .../crypto/inside-secure/eip93/eip93-main.h   | 22 +++++++++----------
>   2 files changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
> index 1a8dabc4ada4..e62785952b0d 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
> @@ -415,7 +415,7 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>   	u32 ver, algo_flags;
>   	int ret;
>   
> -	eip93 = devm_kzalloc(dev, sizeof(*eip93), GFP_KERNEL);
> +	eip93 = devm_kzalloc(dev, struct_size(eip93, ring, 1), GFP_KERNEL);
>   	if (!eip93)
>   		return -ENOMEM;
>   
> @@ -436,10 +436,6 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>   	if (ret)
>   		return ret;
>   
> -	eip93->ring = devm_kcalloc(eip93->dev, 1, sizeof(*eip93->ring), GFP_KERNEL);
> -	if (!eip93->ring)
> -		return -ENOMEM;
> -
>   	ret = eip93_desc_init(eip93);
>   	if (ret)
>   		return ret;
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.h b/drivers/crypto/inside-secure/eip93/eip93-main.h
> index 990c2401b7ce..5f0f51081743 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-main.h
> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.h
> @@ -92,17 +92,6 @@
>   						    EIP93_HASH_SHA224 | \
>   						    EIP93_HASH_SHA256))
>   
> -/**
> - * struct eip93_device - crypto engine device structure
> - */
> -struct eip93_device {
> -	void __iomem		*base;
> -	struct device		*dev;
> -	struct clk		*clk;
> -	int			irq;
> -	struct eip93_ring		*ring;
> -};
> -
>   struct eip93_desc_ring {
>   	void			*base;
>   	void			*base_end;
> @@ -131,6 +120,17 @@ struct eip93_ring {
>   	struct idr			crypto_async_idr;
>   };
>   
> +/**
> + * struct eip93_device - crypto engine device structure
> + */
> +struct eip93_device {
> +	void __iomem		*base;
> +	struct device		*dev;
> +	struct clk		*clk;
> +	int			irq;
> +	struct eip93_ring	ring[];
> +};
This looks weird, too. If there is always only one "ring", why don't you 
embed it without the "[]" into the struct eip93_device directly?

  Thomas

