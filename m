Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7AF7867E
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 12:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708087096; cv=none; b=r9PKQmE6St06DkAD+b4nLEZzIIXvtfFarbHILBjh1dCrat4k97/P7ou40mYj4dJCvX1tE3xK+MdKeDaXhRaNOOPBYPvOH/a8lC3se9hxzCsG2T+cXDiE3RSkOL52z/veb+vnTStlPeumSzOnIjNKDQeeasU8SIaAyjnNVcav8vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708087096; c=relaxed/simple;
	bh=DXpOjr9u7RVP1XLeCElRFzY8Lby1k6lppKtH1GBPbL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GZr0L18Ufav45xHMxvYmju4NOSd50UdPn9vCV9d7+FiE5yCZwqFgSbgWy+ILfZS63LSRRUnWwLA2z9iP+w6vVRG4jrscl4KWzwTsevHgDGcZPjD7fUicx6PIexVlt7FpHXgDl4u7aUHwO7ZN8YKAA5gI5P6ORtkUyXB/AJ/KkQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=aj2UChBF; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="aj2UChBF"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d7354ba334so17696755ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 04:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1708087094; x=1708691894; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yjzwPHk2p33IGtJdMsugVw65fwcmD9njyLsVUfTHxq0=;
        b=aj2UChBFtbLdybPNZahK3zZvVmHmqB86zffV2GwL+e2M3Rca2uHNh9gZBlC3QDuTo8
         3/lv1HB1CaLGsau2VdTGMaEdMRaZ7zoLAyH6PLSGFmTRwLHMqw+BvcR1r1/V/fkLf94r
         DBER1vwT421DwVKfHK9jraef+NBznEI4TfM2sSAWDFDnPRYaS7uYcMj/hPCQ3tDA9Q9p
         KcSuroFkYwO7naA6KiX12RXcxn8qipFpfO8QVn2iQBeNGZlWKOfzCYJW4vHNviufTVyN
         vKylMIzwMg7rCfPrDj8veX5LrgPNJAle/az3dlR3ibrXi2h6+yDHJcI7wYKwdbiqnWk4
         lgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708087094; x=1708691894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yjzwPHk2p33IGtJdMsugVw65fwcmD9njyLsVUfTHxq0=;
        b=CiQ0jMqUKiiMgGzonKbm4u3H7dkTy0EOySw8Q3rH/dD0iRAsWS8u80BDkWB6DcU1+8
         ZZ6DP3qSSr7kQyeGfHVCz/X/o7zfY0lPzp/bXJdr59LWZnPXKZ/3vxniaWvxASpyYIn0
         SB4u2k4vHd3LhV94bl5RMm+2lNbmB5Y+O1yoJy7v29b0I+dSh05Tbq4No63QLqq8ODdu
         6dJE71EA7AbgjH+iiSj0RmpNZCHZIm0xKiK+JrgcOghcizjNJRDv9fOYDAcZUzJAN92d
         2+/E99dlXW9tf5yAoXMktGbcfTui25rikFt7/jW5fuW4y03/1FpsbLLe5ddMRWtBhJD5
         K+oA==
X-Forwarded-Encrypted: i=1; AJvYcCWa+17oCCvyRx5f7UPGxNLPtbogRPpt7tDrY5YuNEaimSAZXzCVbdrQWwEwjAVHbb3jy0otKXaNlpXHrpabREo/WP8gW6nRSSM7OucU
X-Gm-Message-State: AOJu0YwP6GoxKM6HeyoaILHusVQw+EZ2oxehC8kAue20AzTwzVuV6c2O
	6tn/kNpeE7Ym68wNJUX85WrTbL3PbrRnQMOcmSmsZmK1BoZ1Iij12F2UU9pU9C4=
X-Google-Smtp-Source: AGHT+IHfk1qfuACl6jLmGIKvguSAMywWfTCxizmfKcpFacjh2S7+JnloeWkJprnOskN4KHyZZ5quZQ==
X-Received: by 2002:a17:902:c947:b0:1db:4b08:fbe8 with SMTP id i7-20020a170902c94700b001db4b08fbe8mr5610125pla.44.1708087093682;
        Fri, 16 Feb 2024 04:38:13 -0800 (PST)
Received: from [10.254.109.253] ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id m8-20020a170902db0800b001db2b8b2da7sm602298plx.122.2024.02.16.04.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 04:38:13 -0800 (PST)
Message-ID: <2e35014d-1df3-4efa-8aec-d305094dcd80@bytedance.com>
Date: Fri, 16 Feb 2024 20:38:04 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/zswap: remove the memcpy if acomp is not
 sleepable
Content-Language: en-US
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 davem@davemloft.net, hannes@cmpxchg.org, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com,
 yosryahmed@google.com
Cc: chriscli@google.com, chrisl@kernel.org, ddstreet@ieee.org,
 linux-kernel@vger.kernel.org, sjenning@redhat.com, vitaly.wool@konsulko.com,
 Barry Song <v-songbaohua@oppo.com>
References: <20240216040815.114202-1-21cnbao@gmail.com>
 <20240216040815.114202-3-21cnbao@gmail.com>
From: Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <20240216040815.114202-3-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/2/16 12:08, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> Most compressors are actually CPU-based and won't sleep during
> compression and decompression. We should remove the redundant
> memcpy for them.
> 
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>

LGTM, thanks!

Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>

> ---
>  mm/zswap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 350dd2fc8159..6319d2281020 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -168,6 +168,7 @@ struct crypto_acomp_ctx {
>  	struct crypto_wait wait;
>  	u8 *buffer;
>  	struct mutex mutex;
> +	bool is_sleepable;
>  };
>  
>  /*
> @@ -716,6 +717,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  		goto acomp_fail;
>  	}
>  	acomp_ctx->acomp = acomp;
> +	acomp_ctx->is_sleepable = acomp_is_sleepable(acomp);
>  
>  	req = acomp_request_alloc(acomp_ctx->acomp);
>  	if (!req) {
> @@ -1368,7 +1370,7 @@ static void __zswap_load(struct zswap_entry *entry, struct page *page)
>  	mutex_lock(&acomp_ctx->mutex);
>  
>  	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
> -	if (!zpool_can_sleep_mapped(zpool)) {
> +	if (acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) {
>  		memcpy(acomp_ctx->buffer, src, entry->length);
>  		src = acomp_ctx->buffer;
>  		zpool_unmap_handle(zpool, entry->handle);
> @@ -1382,7 +1384,7 @@ static void __zswap_load(struct zswap_entry *entry, struct page *page)
>  	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
>  	mutex_unlock(&acomp_ctx->mutex);
>  
> -	if (zpool_can_sleep_mapped(zpool))
> +	if (!acomp_ctx->is_sleepable || zpool_can_sleep_mapped(zpool))
>  		zpool_unmap_handle(zpool, entry->handle);
>  }
>  
