Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DA6468C16
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 08:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152941; cv=none; b=pbel7CHP5LX43yeTQdL2YE3eirZhkP06ozxWIWR9wee/xtWpbBs7fz9w700kX9FI1ySVtzsogJ9qnP2JlRPeGv9lq0SPK4zEr/apeguX0zK+1uKAL2apFd6kb/VjBNc1NmydKG1J/dMEtwg1SQxtH9HoVd+2u6oDMn0Y2T7ovZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152941; c=relaxed/simple;
	bh=Pnji5Ec+MdFeaXsLGw95FIpsLR79UprIAbPo01yXRFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=quVhIv3GyjWNQ0ahDQLPF6uoOl8Ck6lbec2KBeJD0DuXLZIJvwW3oMFMKiGk+pp+DM/8DhD1DcJEW+c2slIT0Erw2R2N0ALQJkQnXcEOH3j23TF6ah8OdDfnnPBEilDA7cSDbBcY6sX9aIhGHwy9YR7wvqBGLKuIEIVGZtin1yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cq6xZj3D; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EkvCvj0o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cq6xZj3D";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EkvCvj0o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790152932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZbHzmNubZNWBdHmlif9GpwgQyT9l6KjjTU8mkVoSiUI=;
	b=cq6xZj3D7MBBhGkCpF7lIr4IzjgGKtsIpVyIEGZebYhbpj+CbnKM1WNeln3X5neCxyhKNr
	3mvmWdCl3Wb1FwAMOBsLv1wUrOooVKGyveLghB2yq0qdPD5F9ZTh5KYH1ST7wdaSrW0R6y
	LqwBdXleeb+w4JT326Us74knxkeOHYg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-FMA0qXgiPmW23laULvgzDQ-1; Wed, 23 Sep 2026 04:42:10 -0400
X-MC-Unique: FMA0qXgiPmW23laULvgzDQ-1
X-Mimecast-MFC-AGG-ID: FMA0qXgiPmW23laULvgzDQ_1790152929
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4870eda3782so563778f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 01:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790152929; x=1790757729; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZbHzmNubZNWBdHmlif9GpwgQyT9l6KjjTU8mkVoSiUI=;
        b=EkvCvj0onbjc8Lxx4bsx2KtvkNyeOKYPPggPv4O06IaL1rxQrNmi5gotKWFwAREq70
         k/vlrOEXzJl+XgqVUcmBqidV+DM8+WS/UExuTBfT9cNSCdUGhEKP6UaodgjygpM8xDb8
         d9Lvp/01gOCzhSKFI7rtDhys9Y/kysLnb+efXFUwSerIiW7rsf2BoP44+P7Oz8UUNZC0
         AU8hHyFzq5s+0UhMD1jppCrUw/kIircclXSLiEkYmszqojLz/UFG/muNND5k2fmUYlFy
         tlsCMvaI1hfR2RCz3t8hOdJNVsRWa29UvG3JK47pxLV+qiQZ1CaGbylj8laZ5JR/A6C1
         YNig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790152929; x=1790757729;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZbHzmNubZNWBdHmlif9GpwgQyT9l6KjjTU8mkVoSiUI=;
        b=L2I6UKzz26cnNLZgTPbG/RdxXDfcrUL8lxru8t8r5Y0/Pfclb3G17yuu9zF1xf/3Vz
         MZSw1MtU0qo4K4R3YN9ydv99YibacgOollDFoGmGf8+SxvRwOq5tDpq+bvtPulmr4myy
         uzIj/PB5KlP4ve+qwp5T7aoE0YzZjcQEFgbkrEjViliXVHXkDXaYIlDhuf2h46Dl7Lhy
         +cnNgXM8HS96K6gpwWqRc7u5jJQ8OZlvIwFDQKj0mo9nR98HUruFTcGjv+NX3bmFhL2U
         O0UMcEHr+li/3xck06/zlV08ESnmf2rGeVxjsRLi1SDb5tbJf8xbBq51P2WbmWIVP4MB
         Lsqg==
X-Forwarded-Encrypted: i=1; AKwUvBxW6PV7olT7VW8/0mXKZpinTT7sgpogreO1O7W+E/CFxvzykcT6U59L0MQw58CE2jIOuTSm2oTTF/QrfME=@vger.kernel.org
X-Gm-Message-State: AFuF++mMQjYERQmpJoFrcdDY0V8AKKTh7S39yUXZUtrlcXFoqdKeIh+P
	QPYMTRODUbAJDq+Ag16hE7d0KCPhuBQDL/jOsZ2BfTH3LWBy/JnpATZeFn3+DOaAxR1xNDb/26M
	rv73Dc+x+gbYIk9McK/HR0erHk48/gWf5tlLaF+SCLXKb6IDgElVWmpe67SGUY8VEeQ==
X-Gm-Gg: AYBFou2cAcc+0DG23pTntJTzEge2vkYy5CVX+cyCXak2LmX/AH8IHgSLxt7E1FfOkF6
	PzCOWu2IxAuNNY72cN+upnIE1IW3eMhxjDqD57hdkQDIrtbs5pUs0F9wvwbCNNyk/K29katf1Yz
	X2vzk5W+y72LQqOzjLEgmE08MgoU3Z03+OstW7/PoQlrUVQxDTPU8gpc0ry4tLKHgOcCfKsIdNt
	49hAPixfavmQtmJDBRevDFrIYQpXVgQ77Z5dFCwvwlAScb/YI+jY7bxBJVgR/SxtYcfwc5N5WnV
	XtMSOn1yeBaN0blLhTR2sWMB1q4Jxk6yr7biaDwnneqHGxGESu9auCAQ4XLpF1JWD6C03Tko
X-Received: by 2002:a05:6000:703:b0:486:e901:e59 with SMTP id ffacd0b85a97d-48867093c7bmr3020850f8f.31.1790152929615;
        Wed, 23 Sep 2026 01:42:09 -0700 (PDT)
X-Received: by 2002:a05:6000:703:b0:486:e901:e59 with SMTP id ffacd0b85a97d-48867093c7bmr3020801f8f.31.1790152929229;
        Wed, 23 Sep 2026 01:42:09 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.113.141])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886876c027sm5987256f8f.17.2026.09.23.01.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 01:42:08 -0700 (PDT)
Message-ID: <fbf7e74c-07b7-42e4-a236-e13d57b3a380@redhat.com>
Date: Wed, 23 Sep 2026 10:42:07 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/20] lib/crypto: aes-xctr: Pass counter by value to
 aes_xctr_arch()
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
 linux-riscv@lists.infradead.org
References: <20260921050910.296144-1-ebiggers@kernel.org>
 <20260921050910.296144-3-ebiggers@kernel.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260921050910.296144-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/09/2026 07.08, Eric Biggers wrote:
> Update the calling convention for aes_xctr_arch() to pass the counter by
> value, then do the increment in generic code.  This aligns better with
> the x86_64 and arm64 assembly code for XCTR, which takes the counter by
> value and thus has to be paired with an increment in C code anyway.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   lib/crypto/aes.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> index f1549839b3de..22f096c50242 100644
> --- a/lib/crypto/aes.c
> +++ b/lib/crypto/aes.c
> @@ -1094,7 +1094,7 @@ static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
>   }
>   #endif
>   #ifndef aes_xctr_arch
> -static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 *ctr,
> +static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 ctr,
>   			  const u8 iv[AES_BLOCK_SIZE],
>   			  const struct aes_enckey *key)
>   {
> @@ -1150,8 +1150,10 @@ void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
>   	__le64 aes_input[2];
>   	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
>   
> -	if (likely(aes_xctr_arch(dst, src, len, ctr, iv, key.enc_key)))
> +	if (likely(aes_xctr_arch(dst, src, len, *ctr, iv, key.enc_key))) {
> +		*ctr += DIV_ROUND_UP(len, AES_BLOCK_SIZE);
>   		return;
> +	}
>   
>   	aes_input[1] = get_unaligned((const __le64 *)&iv[8]);
>   	/* Handle the full blocks. */

Reviewed-by: Thomas Huth <thuth@redhat.com>

