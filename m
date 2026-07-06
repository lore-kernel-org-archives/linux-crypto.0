Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FDA3B42F1
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 05:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783314680; cv=none; b=FkG8kFDP2jG4c9R8z+4kJ6g5wcmXTs3PIiJSNx4G7yIsx98Ome6oFF/UfUm0OCLMh49wDItSTpWSeFDEF/Fcjche6u0S05WWDEkzBx9JldJvysfP74kNjAV5RAcx++gDz7wM+nUSG3+B/5Cu462sUFUTFbuh7SMHLHPbgz0tKzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783314680; c=relaxed/simple;
	bh=P997Ne0ukAp9OVBdlFOQgAT6dUdsnk4v4SF9WhQSZdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kjPuXzkedFbhGvXxBsCVGw8m7sTcouWTqQcxnNGbdFOFo4utp7zkzhGvR3rFAGZyD47ZtOUWLYeD0dKENlOTF90crs3EzWpiXQy0ISTCCMoVC8LvRBMBv1CRHoRHVY2w1gNSIFhf/yG2YKyYS4uzoxgG4ow3DHffRg+9XwNQUtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GvtRTTGo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XILF7Hwa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GvtRTTGo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XILF7Hwa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783314678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XfZobLIyFSfKPQ8moG7Mp4eAnQzlNBi6mn41MBA1fRQ=;
	b=GvtRTTGoYKCJ/cX+lHnU7DtVCudCxU6lslirpVN2PuUhGOrehfStSLkuhNDhaADS5DDGMD
	wJvJo45f4BFGweOR6jfbXcInir+kat5ACNEX2yJ4gEBM3Js/hp/UYbL+7Ac7XgUWtw5c1y
	mRLAJIUA5Hr5KZRSlg8AIpdTz+e9gzE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-PgG4_lUqMGK_-xJCTILgRg-1; Mon, 06 Jul 2026 01:11:14 -0400
X-MC-Unique: PgG4_lUqMGK_-xJCTILgRg-1
X-Mimecast-MFC-AGG-ID: PgG4_lUqMGK_-xJCTILgRg_1783314673
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47780faf8cfso1624528f8f.3
        for <linux-crypto@vger.kernel.org>; Sun, 05 Jul 2026 22:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783314673; x=1783919473; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XfZobLIyFSfKPQ8moG7Mp4eAnQzlNBi6mn41MBA1fRQ=;
        b=XILF7Hwa90foCjp7GJLSpanjxjOhtMNHcfgh+OjQ19j8HUtapMusMAUnWGORTYy2Fb
         s+NxYw5b6lILbbiXBfiPYbLi7SxZGIFGswUb/jpaNUnwYYkPK6m0UGIK15s/NOPM5iS/
         5mh0iswuKeQ0PD3GlfX8N7fiBch/shW4RCvCdygIf4WFGqE/6gkswO2ij0m7/zUr6DsP
         3WsfoqzPIhAzvSYMPTMaj8Zzy1SMHcI08EfYlivmWMupnjve32tdhd6IeOT0QArusZWp
         5CBbZzByCbFzIDRpcdMvPAfTTJYafhWHXqwmSLpuTx7wjTIb+zE3P2bKShD9RyGV7AFu
         EIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783314673; x=1783919473;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XfZobLIyFSfKPQ8moG7Mp4eAnQzlNBi6mn41MBA1fRQ=;
        b=WHIwLD5d4SjPdQLzWHXh4DWgQPMKnV9HvSARtAxFvWwFhhrvKeTkzqE8EntIN2S8DB
         LmlrWCcraK2m0lQ3A4edSwPYRW0i4Z2avz206feo1n0a9lqUtJhuKdX2yzkY1LILpv3N
         l32y9+Pto0TDTdPIkVWO9hZ1gbb4XNEkFIMnO77+IfqqZMMTEIdYWrLMaZbYmvDB3dcZ
         kNg6q3Z5YRAt4plgaa4DQkHebJhsXBJ+OREtJ4ojwRV10jPPE7hKc88cLBkvdI0vWwT3
         1z2VQ61XmdlySZPMTQy8CBa7dM5e9fLI2Ymbg2l7WCzwAG2awkDyqT1F9CGjkLhBFoZH
         164A==
X-Forwarded-Encrypted: i=1; AHgh+RoK+gMiU1ALSSGNpKmFwLOXOms0LzI3NNUrypCuH/R/QVRROfzHBFP+hTg8dP8yfrNcRFLGjCW3a1CoqEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ+v0s10kMFLbjsKCvDVQlDrbXO5Jepw23WpeyYiYcdXPlsmmu
	i9L3Hs3fJlUbsoGz6RL7+3lv+nLM/Ewsb6LnEOlTh5jj1PGCncquSpItb45qvNcPsCiQQUCtZXN
	6GqkQVoER0M1PqnkaYVIhmDTaQ9xGxudfVZaAke9qLI9zEs6mbiqW9WshoKuA0gp0Uw==
X-Gm-Gg: AfdE7cmo38HxDhFnzmFgV7384w1eynyDbmRwv0DFRu6MvzV0/iHOqrPQwYiFPxn6J6C
	Z7Yhfqnct8aRNBFs080CpO/vKyRO5UKt+WtpsQoUIo7wX4pKAaafQJFoRmG27vmDdl9q+Vgvdd8
	STDF0GHlhmExRU74VvBmucMop8uRrFJw2rBsTum08Me4NGDydoXk6L31/9sBWazFu4XRTfkQCVE
	dbY14EJSZRT+55eRevhxunE+Ou9Z7IeJJtD4lvjXuw9v7K0ALYPKS+WBM9tyb0Jey+RCaB6lZkj
	ARAT75VnsYMrOCFHZuTt5D8Ar3AbBO9cIyc5IRuzHhJb7gd4W60C92xI1po9LnO64PEIO3oBQXI
	hMo3axMGB/eZnG8LaToSAnlMQaJdI4y7eZ61mucggKEKt6ujb+E3l
X-Received: by 2002:a05:600c:8b6b:b0:493:cc25:85cb with SMTP id 5b1f17b1804b1-493d11d275dmr104107855e9.8.1783314673341;
        Sun, 05 Jul 2026 22:11:13 -0700 (PDT)
X-Received: by 2002:a05:600c:8b6b:b0:493:cc25:85cb with SMTP id 5b1f17b1804b1-493d11d275dmr104107635e9.8.1783314672967;
        Sun, 05 Jul 2026 22:11:12 -0700 (PDT)
Received: from ?IPV6:2a01:599:b25:5a4f:dc68:5203:b109:1efb? ([2a01:599:b25:5a4f:dc68:5203:b109:1efb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0f21543sm20570611f8f.35.2026.07.05.22.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2026 22:11:12 -0700 (PDT)
Message-ID: <6ed4c75d-c17d-40e6-9ef2-6c29ca54342e@redhat.com>
Date: Mon, 6 Jul 2026 07:11:10 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qat - use strscpy_pad to simplify
 adf_service_string_to_mask
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260705133842.241401-3-thorsten.blum@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260705133842.241401-3-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/07/2026 15.38, Thorsten Blum wrote:
> Use strscpy_pad() to copy buf and zero-pad any trailing bytes instead of
> zero-initializing the local services buffer and then using strscpy() to
> copy into it. Also use the strscpy_pad() return value to detect string
> truncation instead of checking the caller-provided length.
> 
> Remove the now-unused length parameters from
> adf_service_string_to_mask() and adf_parse_service_string(). Also remove
> the redundant strnlen() call in adf_get_service_mask(), which only
> computed the removed length argument.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>   .../intel/qat/qat_common/adf_cfg_services.c       | 15 ++++++---------
>   .../intel/qat/qat_common/adf_cfg_services.h       |  2 +-
>   drivers/crypto/intel/qat/qat_common/adf_sysfs.c   |  2 +-
>   3 files changed, 8 insertions(+), 11 deletions(-)
Reviewed-by: Thomas Huth <thuth@redhat.com>

