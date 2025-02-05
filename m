Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F9C2139C9
	for <linux-crypto@vger.kernel.org>; Wed,  5 Feb 2025 07:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738741978; cv=none; b=bq2sNjVuWTHWo1xKAM2vXq6oIay9fpg0xonPEQPTdvVoDh6+qIHOX4Vxl7NgGITmpY21bk78aJ4lHfGZRR3h5BB3bjG1f05UAMJzVGmo/wozE6r+c9BPa1If2M+Dwv27xzF16NJVdZqijPkmyzXYfZ0onahKwm+T6ce1GWf1qUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738741978; c=relaxed/simple;
	bh=0e2bbcIV07l4znqBAb8xKQvuFFeBDz3yhc/3jwI/0n8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uO8/6oJuwwhC6ykrTuY4GCMQty72JW8/+5yCWpXC8/ItlTjBEICc1cF5SQ2wljbfuMm29/iOjw8Z0NQyPUSUeSG4kMSYenTAENeD6Akfk5s/FSS+yLHYKQq2DtRd7ttu8fM2RCgNR6+cOiyIANf5ZhJvCkHlu2h5DcyHpZcegXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=DRgcMzrf; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="DRgcMzrf"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21f20666e72so1771635ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Feb 2025 23:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1738741975; x=1739346775; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L/wQcY2ueB6zeUgpe4VvN4MloDax+g7ADJ74CXff3n8=;
        b=DRgcMzrfeZPRkVnjhqgtC0ygIfowG9X6G/IeDzGkAkEdhWRj5vHIMweoDBFhAEz2p3
         KOTte5oC7fD6NcWp08liwYza3/xNEx8ZN5JX1LtLhO4W1t3gUJdqHa0xXpcknRMRRKLV
         mb/DI1T6IXl52sYfHlJj+armzY70zTSJ9YpfAI6431qmVcyqF9GiGi6FCn/Yu2kpHtj7
         WL1Y6Kgr8PJcBNxIYlD1mD3+vni0jAyhFokS4eT4nLEhGZRt4z+XnROLAeErRLeR1zOz
         eoDDdy+zLijojp2o/TPZBn6Dld0OydwdtL+4d3RobuhYHG6BQxOS86DyW+XfHylBHYNN
         2Mhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738741975; x=1739346775;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L/wQcY2ueB6zeUgpe4VvN4MloDax+g7ADJ74CXff3n8=;
        b=sXJGNYykIdfVl6nQmoHwugYrqjso191Pf7qfAEpnlzO3aQeVGB/Q9LTHsWVJ2zxBun
         rss/BgyDpAImJDSZ//Abm2ojHKZZorwN53wCJGuT9pmqjhEV/EPEN2j/YSRJ6d1N1Fn0
         jlRn3s5E2Gz45YB3EVcokjbPplXXRXD7iExV48MFIB+IkOH7bD/J6GkAmXCIRfZonLYl
         gQAq+mxp4Z6er4zFH3R4Dwi2ycV2rP2YdH/oUGgkCCCgg/uxaM5nUx0Q971ft3sfZ8in
         E/xsFqdqx37YRpYj9cQ5Vn394qvd2em7VyzSX3yCXeck/ytlhQ+k43CajhrrZ8Lk6PnB
         Ll0w==
X-Forwarded-Encrypted: i=1; AJvYcCV5TyXW4vTaoo4v7x6pUd/9xo+iRU+HVRZI1LmqPoE/DJXIuA8JL4EyYOd5CQRESvvVXkxwDda11U3b+N8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTlMuzTW5Q+ASkuG2+ujQIyeut05P+UwULKRE5UzS8y8qq+5pb
	YVCAlhlQ9MGC3FraNo2yiCtzFbAgmOr2dZi0K5i3GoBZf7UVLQRVIZCgfI5dp7Y=
X-Gm-Gg: ASbGncts2skvWtahOFhwcAF1TEPbo5+IC216P/dVGxNxlElCQe+Z41UNtlGPH3RMG80
	aaw6glQvfVk3upolZrUhmLENVUah0/wWdyvt3PpvxiCRfXOwkQ3qLfutqHHAKLnJXRIO9Fx88YJ
	bdNf5mXylWVTWsk8RdozyS8YWpaJMZbFhKfdSCIT6WTPBLu9mhWIhI5hJvcNkq25aEOtc0dH8yD
	G20ojhzFu+LPrQCQso3hIYbcH5KYXnaV9ntE/ORn6Z4V89y9CPyWG9rZcw34RFCGFPzxvA2jTQH
	u8Jg9MieTBTNC5Ximmks
X-Google-Smtp-Source: AGHT+IFjxfOyKmAjTjWKO6lMMhws+mfNPNxKXwNP4SKWYtWC/+s05Dilt2DPZDOfbAZqHgbVDjLICQ==
X-Received: by 2002:a17:902:ec8f:b0:216:7926:8d69 with SMTP id d9443c01a7336-21f17f2f955mr29410245ad.47.1738741975055;
        Tue, 04 Feb 2025 23:52:55 -0800 (PST)
Received: from [10.3.43.196] ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f09f5799esm23149735ad.55.2025.02.04.23.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 23:52:54 -0800 (PST)
Message-ID: <da5cbcee-a8db-4bd7-a09d-f262ff052a79@bytedance.com>
Date: Wed, 5 Feb 2025 15:52:49 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] crypto virtio cleanups
To: Lukas Wunner <lukas@wunner.de>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Gonglei <arei.gonglei@huawei.com>
Cc: lei he <helei.sig11@bytedance.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Eugenio Perez <eperezma@redhat.com>,
 linux-crypto@vger.kernel.org, virtualization@lists.linux.dev
References: <cover.1738562694.git.lukas@wunner.de>
Content-Language: en-US
From: zhenwei pi <pizhenwei@bytedance.com>
In-Reply-To: <cover.1738562694.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This series looks good to me, thanks!

Reviewed-by: zhenwei pi <pizhenwei@bytedance.com>

On 2/3/25 21:37, Lukas Wunner wrote:
> Here's an assortment of trivial crypto virtio cleanups
> which I accumulated while working on commit 5b553e06b321
> ("crypto: virtio - Drop sign/verify operations").
> 
> I've used qemu + libgcrypt backend to ascertain that all
> boot-time crypto selftests still pass after these changes.
> I've also verified that a KEYCTL_PKEY_ENCRYPT operation
> using virtio-pkcs1-rsa produces correct output.
> 
> Thanks!
> 
> Lukas Wunner (5):
>    crypto: virtio - Fix kernel-doc of virtcrypto_dev_stop()
>    crypto: virtio - Simplify RSA key size caching
>    crypto: virtio - Drop superfluous ctx->tfm backpointer
>    crypto: virtio - Drop superfluous [as]kcipher_ctx pointer
>    crypto: virtio - Drop superfluous [as]kcipher_req pointer
> 
>   .../virtio/virtio_crypto_akcipher_algs.c      | 41 ++++++++-----------
>   drivers/crypto/virtio/virtio_crypto_mgr.c     |  2 +-
>   .../virtio/virtio_crypto_skcipher_algs.c      | 17 ++------
>   3 files changed, 21 insertions(+), 39 deletions(-)
> 

