Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BA63B2FD1
	for <linux-crypto@vger.kernel.org>; Wed,  9 Sep 2026 08:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788944024; cv=none; b=lkEQT8oRGhM+jMUcR4q4wsVbSd+gwYiceVpn3QZ5CztCObJx9aBQyJb4hKPszYe8d3vQHIcKH52HGI3OKe/XP92bgidSHu1nUgnquQA7lls+eRcPH5B4WUJGTuYLeX7ofodqkLSW5tDMIQshgYjxYU8NZbMGsGoc/9CMzqTyXLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788944024; c=relaxed/simple;
	bh=oeNgveW9Tt4/2RrRQetsoMagtELhTgBtkFerJiMJAaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TYESJXReGSsdFF7vVcQVc4tlDJtRboudpgj2fgtbqAKCC0HW6oH2xbuAsz3UBq+2JDztJW5h8z4tGmNZPedmwWc0h/wit8Zw3vqrsqaOMxpNEBI3kRNKtO1SX6WhTEua7QCkk5+OPoqyZ3OAmXWeEu9ZoWLBHyfJmSjC+1ownhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JC7MX5kg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=m/aRkbMb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JC7MX5kg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="m/aRkbMb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788944021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XfqIN4Kwtqfnd1bFRCrRwzjmsoY7buI31s7mTLJJCXA=;
	b=JC7MX5kgCacgVnA8pJn/9etn1uIwqM9R//Z+iPdFxmA843zoScvEjIXSHuYrKPHPtskdaE
	vsYx1MNGjdnVeadlW0//ZG79yB/L0t6brq5g05Sd7A9J77RLJa4JdqEeUfOXf3rRAQHhgm
	tv79qYkB7RBN7dwZyX2BF3tP/JyO5IU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-t21D8yZWPs-WZj22vtpzbQ-1; Wed, 09 Sep 2026 04:53:39 -0400
X-MC-Unique: t21D8yZWPs-WZj22vtpzbQ-1
X-Mimecast-MFC-AGG-ID: t21D8yZWPs-WZj22vtpzbQ_1788944018
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-482e05af072so4487993f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 09 Sep 2026 01:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788944018; x=1789548818; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XfqIN4Kwtqfnd1bFRCrRwzjmsoY7buI31s7mTLJJCXA=;
        b=m/aRkbMbmMy7nCb94YDSbCghzTgBo8hTd3pPbKGHFW81EQjnbjp+jq1SKaspNvg/2s
         K9HRedbLiEorTUxVn7y0Q52iFZV6TTXg9CStsrWiqc6152MZ1+Q3/63TQby3KVllYmW8
         i77fSFSIEIhGikPPrzJFtJr7YE28fWB2YbHerWy51k3oENOz6xenjSkmcf78OJEt1Q5L
         JPMrEyB9iMBQdmWJXFGMDGO0k1xrEa7w5QXl9TS5ryIncYKv7JmL3vWLjxJw2bzdi3Df
         ZfNC8ro+zNmkb4QHuO1nydfULeFh76Xp4GBnWp6d4vO4gKH25ymz0O0IlHG8iJLn45XJ
         Uwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788944018; x=1789548818;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XfqIN4Kwtqfnd1bFRCrRwzjmsoY7buI31s7mTLJJCXA=;
        b=gyVFC5wpmeGTwXQDNlGk7x6iCJDnSF+UFdR3VkilGZPcNrQ2JbyVq8o0mwGa4o0Kgy
         x1oUHRNYQMvv6QneLTOujo6qwSwUPmgyV/hEJGXDN9U+9WwyRcYTvrI/CBw1D8be/wjv
         DSRzcNCkKsk23velPh/Wtcd9PNdfkooBNoOWR0Jai7N32s0kLJRl260mZCktq78KhsOY
         shfokkJFCmSVYX1PsZcimQlEKBVPvWhAmmWGeVdZdatxKX6J5r6woTxuRG1WoDHu5ror
         YsbnE9Z0iMd8xE6kwFDo13YsvCAL86fwkr7xSzP89BKeb9oXaticBjFt4riEHCej6CCv
         7eGA==
X-Forwarded-Encrypted: i=1; AKwUvBw5mwmY8gONEaxv3ukXYcLQyds+RygChKIcl16QlRt5CXGkcUT6rS0ohhfRBMbjvvBRC5ki3/Io5zAz7gE=@vger.kernel.org
X-Gm-Message-State: AFuF++mytZx/vmbpA0RINlLcnpfqWvu2XNxXCCbW0QL0vJJAySqwpmky
	Qso3M6m58IgeIUwVfLfmYWYdhVK+IaTi1PF/J3MaFfadQETtaTy/peuMXyIKNtL2qhrBcSffBZD
	bv8wWoU+lx1qfcKJnxEzIGJrBPCaLAPx8IOu9UkrVbvUvKdTWRmGVX4yka/vW0/GGYw==
X-Gm-Gg: AYBFou1VEeuD0QPIlDVfsYo72OehXwAQtFW0+ckwujEPICRDfPrureRxAMr7Mw6c1n/
	lAhb4EU7L1u4kr3HNTohSerbwDpuvGANldsJPHKo6LUeY/zlmeLKuZpLBAHZM4NlHABXTjH530F
	Bi+vXrPG8o75QxcTowUku8Y2eARka9gkEW1Deou1fyxnGqdZ3mSA3kL+qUZMKhFC+PkcHSO0NE3
	4uIQwqp9G2m6gTVFxOMsL0sBtVEDH2oNh6+H0AYPG6ER+nSZFzxeFj1aKMuZf7FBBeOAwJbFk6t
	HNiHBUlTdlYjkNZDxAV3JKGmnQsHFBuJOFpznHfJqA+ChAFvYufTEKhGZky19f65+IhN4QIKGA=
	=
X-Received: by 2002:a5d:5f52:0:b0:485:9233:a5ae with SMTP id ffacd0b85a97d-4859233aaf2mr25267367f8f.3.1788944018465;
        Wed, 09 Sep 2026 01:53:38 -0700 (PDT)
X-Received: by 2002:a5d:5f52:0:b0:485:9233:a5ae with SMTP id ffacd0b85a97d-4859233aaf2mr25267336f8f.3.1788944018095;
        Wed, 09 Sep 2026 01:53:38 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485958f1493sm31003763f8f.37.2026.09.09.01.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:53:37 -0700 (PDT)
Message-ID: <5a1c75b6-8d68-4bfe-bda8-b2ca25cdffab@redhat.com>
Date: Wed, 9 Sep 2026 10:53:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: xilinx - clear AES key buffer before freeing it
To: Thorsten Blum <blum@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Michal Simek <michal.simek@amd.com>, Harsh Jain <h.jain@amd.com>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Takashi Sakamoto <o-takashi@sakamocchi.jp>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>
Cc: Danilo Krummrich <dakr@kernel.org>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260908191607.405177-2-blum@kernel.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260908191607.405177-2-blum@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/09/2026 21.16, Thorsten Blum wrote:
> In xilinx_aes_aead_exit(), the AES key buffer is freed without being
> cleared, which allows key material to remain in memory. Use
> kfree_sensitive() to clear the buffer before freeing it.
> 
> Fixes: c315cb0005be ("crypto: xilinx - Change coherent DMA to streaming DMA API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>   drivers/crypto/xilinx/zynqmp-aes-gcm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> index d54c268dfe34..ebee37dddb1f 100644
> --- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> +++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
> @@ -766,7 +766,7 @@ static void xilinx_aes_aead_exit(struct crypto_aead *aead)
>   	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
>   
>   	dma_unmap_single(tfm_ctx->dev, tfm_ctx->key_dma_addr, AES_KEYSIZE_256, DMA_TO_DEVICE);
> -	kfree(tfm_ctx->key);
> +	kfree_sensitive(tfm_ctx->key);
>   	if (tfm_ctx->fbk_cipher) {
>   		crypto_free_aead(tfm_ctx->fbk_cipher);
>   		tfm_ctx->fbk_cipher = NULL;
Reviewed-by: Thomas Huth <thuth@redhat.com>

