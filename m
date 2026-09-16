Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0B24E3EED
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 11:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789556811; cv=none; b=gq+/MeHhKU2G7Joz0opPiKsp3N8naBCP5EYgVzJ8s5DFOTgf74FMY5MrglbCFCcBMUT8J/ovK+WqLlAzxFZsjjV+wwhjvHiFBCLyv0Z6pomqWZnX2tV1OPgXotoZ0Kw1gI7vCvtv1pNoqRXy5O6vs+zemBSHDlT0ehUPr8Ynchg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789556811; c=relaxed/simple;
	bh=gwIUkktuidCGPHldmjcD3ZAPK4UHd/SoWIdHNcjBeL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J0qn+4g7V39c1zfOXsGQBS0Xu8+s5SlpviE/4Oa2DRBHjmf/l/627eNtPBssY4LQMYpcJH76Vh9Gpug0p2Liz1AfJfjjh/0shA1qSIZGgBB30yrFhV1FFToGN/aH6f8A284MUT7M3t0pw7gcXTodu3hVPbyD8Ka8VUX2d6Tdsqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPCfSzTH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=h6VQXH+k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPCfSzTH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="h6VQXH+k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789556803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wa6WV+kYrjlESTUxvQTqQFxS+ZtQm6NsZYg9SHCkmJo=;
	b=jPCfSzTH+6qFwOvcnBBrT6XkaxPkTPREnlURF/Z9Rx9CaAO5WXt86C63m3bS+lnYbS7OS4
	0y4t/+dNu/BEXIWOJ+oi+5zpuSWYGwLPpDtwOO4DoCIkhqWAQjQAt4C3sY6Kk52T89QwLh
	WItEeceWfSkLzWurWhgMEIlvzox33OM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-iJRMCaWWMCe1ZWLnjTW__A-1; Wed, 16 Sep 2026 07:06:41 -0400
X-MC-Unique: iJRMCaWWMCe1ZWLnjTW__A-1
X-Mimecast-MFC-AGG-ID: iJRMCaWWMCe1ZWLnjTW__A_1789556801
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4870487e33aso685622f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 04:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789556800; x=1790161600; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wa6WV+kYrjlESTUxvQTqQFxS+ZtQm6NsZYg9SHCkmJo=;
        b=h6VQXH+kE3Q1IM9nCd8s+jZ1Ma5X6ElOcR+tiOx1cyBfDccwn6JcdsiaQzqZrSjmpG
         XaZwg1309hegeT/TMcSP2fn+/2Me7S5yt6YvcUr2DDsf2f00dbXPXo2kC9Px7D1T1A7i
         dNknp7zqWUGJdAkQViWEPW3rjVap3HzKNEf1w41/mOl3QtYP5X/OJzBxHoo+AK2GAyie
         4Ecsh9cxX90uovUn8bujPthkDXCufVcR6/i3VP/LC/qc8LH2LDq0nVOc/y2gz861FfUk
         CPuGufuX9gajfwzol9+0/Z2jp9rLiLXgpweT6uUy4fZbM78SHzofmXAxI7c9eR5lyliY
         bUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789556800; x=1790161600;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wa6WV+kYrjlESTUxvQTqQFxS+ZtQm6NsZYg9SHCkmJo=;
        b=UtaUQ1frHud3pz0O+N93zsSidMYMc+D61CXoDzSvFELRZmGLeRqTdmac60HZ2yFZCd
         LFIkS4/5j6nceVKQ+s70zhoySrEDTFTYZQH1IgcWTD7T49y3sXJRinh7IY2rE9DePx3S
         uXmCs9e9sqhy5a6t+Bx77ZzO+uppEigxuxHA7l1fxFCWNSpmwNs/XLOKRlPo4wX2rdoZ
         F/oRPCFsgOAizDySeQhq0xRa02lWvJuomxwXP1/VxawAGdh4NBYv3YoqgL4cpWinNA2x
         lnhhV4UKrb+D8jM2sK98QQGWl9mivDnSBL84Cb6UZsW04LmMvF6Y/6Jlz9fGHMW91uCy
         Dbng==
X-Forwarded-Encrypted: i=1; AKwUvBwr/nKo1dUnQlB8DJRJvP7v5KEfqH/53d2j38atV1/A5xDJ08U/D+9kUaQJvlyPAHi4gAhltu3Qh4JmWQM=@vger.kernel.org
X-Gm-Message-State: AFuF++nLVE2ORwab5tzTOe3rqTNw9rkvJpXrHWAIbF8C1i0rgb0UfYv0
	rRR1DhPI/BwkPBFW/3PFUStp2qzEovrAK4h1aY+AT/SSZ9a2TJ0gMh1JP8U02VC/sTijIaMsqdY
	HJ3EMlBPWLSek0+hQ81zwpyKxy6VawNSTOSkdHhogNNQM/6HRUh7MKBAQMxfNTf/P+w==
X-Gm-Gg: AYBFou3Po09rCi7PfZFAaxVb486pzyoTlrhBr3TajP7UPHc+33ScYzDqZaIX+Pu+CIN
	5qKuA6JoGqozR6n5aLn8W/Q3xTKEKHFSzS4Js1jDWXTRua6nYfMN1eehYc539FCK2t5uJZzHdz/
	LO271gLrtqxK1lC8VzW9PH+UK0VnVdPZ45lIBFEoDrFngZ+CUe23Gm1AQ2LCHfFlYDSOlJDwPar
	sW09I/S44rXF4lIGpqwppLJqZ+QqsdACcSPmVEaxYKfqdmZkAk15nWiP2emUHm1SiRL5X6eAnbb
	gMzcv78L6fpxEbtH8BwVY93EKJsHnXiDmaKT0cTP6Byu3wL+HhIKWtnWAsdJKU/2CKSTwRUF0Qv
	1U+bOeYKn2Rv3nVMMBPukumSJUz1C
X-Received: by 2002:a05:6000:60e:b0:486:e901:e59 with SMTP id ffacd0b85a97d-4870d05a86emr2951058f8f.31.1789556800622;
        Wed, 16 Sep 2026 04:06:40 -0700 (PDT)
X-Received: by 2002:a05:6000:60e:b0:486:e901:e59 with SMTP id ffacd0b85a97d-4870d05a86emr2951010f8f.31.1789556800204;
        Wed, 16 Sep 2026 04:06:40 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-41-176-3.web.vodafone.de. [109.41.176.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bef7659sm6964448f8f.3.2026.09.16.04.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 04:06:39 -0700 (PDT)
Message-ID: <4fb988c5-3dc7-49b2-aca8-45f23e71bad3@redhat.com>
Date: Wed, 16 Sep 2026 13:06:37 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] gpu: host1x: Allow entries in BO caches to be freed
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Thierry Reding <thierry.reding@gmail.com>, David Airlie <airlied@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Aaron Kling <webgeek1234@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Simona Vetter <simona@ffwll.ch>,
 Herbert Xu <herbert@gondor.apana.org.au>, Akhil R <akhilrajeev@nvidia.com>
References: <20260515-host1x-bocache-leak-v1-0-a0375f68aeab@nvidia.com>
 <20260515-host1x-bocache-leak-v1-1-a0375f68aeab@nvidia.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260515-host1x-bocache-leak-v1-1-a0375f68aeab@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/05/2026 04.34, Mikko Perttunen wrote:
> When a buffer object is pinned via host1x_bo_pin() with a cache, the
> resulting mapping is kept in the cache so it can be reused on subsequent
> pins. Each mapping held a reference to the underlying host1x_bo (taken
> in tegra_bo_pin / gather_bo_pin), so as long as a mapping was cached,
> the bo itself could not be freed.
> 
> However, the only way to remove the cached mapping was through the free
> path of the buffer object. This meant that if a bo got cached, it could
> never get freed again.
> 
> Resolve the circularity by holding a weak reference to the bo from the
> cache side. This is done by having the .pin callbacks not bump the bo's
> refcount -- instead the common Host1x bo code does so, except for the
> cache reference.
> 
> Also move the remove-cache-mapping-on-free code into a common function
> inside Host1x code. This is only called from the TegraDRM GEM buffers
> since those are the only ones that can be cached at the moment.
> 
> Reported-by: Aaron Kling <webgeek1234@gmail.com>
> Fixes: 1f39b1dfa53c ("drm/tegra: Implement buffer object cache")
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
...
> diff --git a/include/linux/host1x.h b/include/linux/host1x.h
> index 5e7a63143a4a..d8f052a85b75 100644
> --- a/include/linux/host1x.h
> +++ b/include/linux/host1x.h
> @@ -143,6 +143,12 @@ static inline struct host1x_bo_mapping *to_host1x_bo_mapping(struct kref *ref)
>   	return container_of(ref, struct host1x_bo_mapping, ref);
>   }
>   
> +/**
> + * struct host1x_bo_ops - operations implemented by a host1x_bo provider
> + *
> + * @pin: create a DMA mapping. Implementation must not touch the bo's refcount.
> + * @unpin: destroy a DMA mapping. Implementation must not touch the bo's refcount.
> + */
>   struct host1x_bo_ops {
>   	struct host1x_bo *(*get)(struct host1x_bo *bo);
>   	void (*put)(struct host1x_bo *bo);

  Hi Mikko!

FYI, this now causes some warnings during "make htmldocs":

WARNING: .../linux/include/linux/host1x.h:159 struct member 'get' not 
described in 'host1x_bo_ops'
WARNING: .../linux/include/linux/host1x.h:159 struct member 'put' not 
described in 'host1x_bo_ops'
WARNING: .../linux/include/linux/host1x.h:159 struct member 'mmap' not 
described in 'host1x_bo_ops'
WARNING: .../linux/include/linux/host1x.h:159 struct member 'munmap' not 
described in 'host1x_bo_ops'

If you've got some spare time, could you maybe send a patch to fix it?

  Thanks,
   Thomas

