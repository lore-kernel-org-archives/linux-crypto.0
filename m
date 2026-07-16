Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6D2302146
	for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2026 07:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784187650; cv=none; b=M/VKrnTK89eU3Z5KPhUoyG8vxv08CLV6oWRK1v/g95ZLDEErsQLdBkCi3C/SNe8vfV+/d/alCgkVV1U8O/CDAJUASD6gweUWUS4Zqr2EHBW0h92KWumlw5mEPsIhBPejB0vywAvVYso1ADasPVcsVMA8W//QSRsXoxUkiXGS9gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784187650; c=relaxed/simple;
	bh=kwrVD48n9TshVSwxoc+KfASCVH2HWD3A3pfA+rLKRzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F6ubW4jNGJ5zZByQQi5P8p5rJ9g65QcxkVj+4WDJDS2bWWScY55U5dA5dfC9+tjMt05Zl+jIc251qyYrsAREafZsNvJ3IN8V3yhnYk2jupqLtAQ1Kma/8ZaXxN50Pii+qepEqn4BVSLIBj/oE1fDb0NgdKv7WXYQthneuIkVpLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T61ut12h; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WFO8sg5+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T61ut12h";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WFO8sg5+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784187647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vEXmMhTqAU/XjTLvsw2TT09jUbuHJagzwjVIq1CQ8fw=;
	b=T61ut12hs74Uoep2JniXIyJiImqTnJF07rn3axsD9eqkPiZGhONR5mMUcY9+uMqmJibuz/
	4UbbsxK+yGm4lpgo6XOBod47YPVoY0RRQ7IgJz3VsQp2juC3PBnIXRDTcviuyzpqU0zBd2
	lCf4gnBAEpYUjM7FCoLxwYpUjsAxHnE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-5InMgVI4MkOBp5FO9zKK6w-1; Thu, 16 Jul 2026 03:40:45 -0400
X-MC-Unique: 5InMgVI4MkOBp5FO9zKK6w-1
X-Mimecast-MFC-AGG-ID: 5InMgVI4MkOBp5FO9zKK6w_1784187644
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-475eba52438so2563611f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Jul 2026 00:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784187644; x=1784792444; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vEXmMhTqAU/XjTLvsw2TT09jUbuHJagzwjVIq1CQ8fw=;
        b=WFO8sg5+gzGhNGtraqG5XOPfMcSlAfzIPV7bN59sPsleZyVV7bG507To0RvPCyGD//
         ADOzpJ/n9RTBUjMDYz5qFJS8sYK39q+81lWh4UO3hOo0ujDp+GQB7KnxoBPs4IOioJeI
         4YUykyTjkU3Szv6DG5eSlANaSV38EAUXZeeoAb4qQf9YGwp0UjhGK/ZeRnujAFRSurYz
         PULYnvQvEJlssjSqrRlBQddawtDsnEDHpc0bJfP1geZwhq8kdjPEeVIjHCRse+g0d2oJ
         01INcAxyAO0s4icrAf6xVEVAgZ4Ejite++COTGC4lZE+a1rnN2qZ5V4qfTP8rqaeLI2a
         vu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784187644; x=1784792444;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vEXmMhTqAU/XjTLvsw2TT09jUbuHJagzwjVIq1CQ8fw=;
        b=PcEseMyuc68JmiiAPftppARWLWB+7LQUMi9wUNxYQUNELe6zsfn1F5yRNc+wm14I1W
         76IZpTowsYaLASEyK8ft/+d447ft+9zCX+Jcy3VXWWB5FmYMSLFKt2ba1XB3ByloC3CY
         Q5sGRd1JR+Fdi1Cj/X1PfweJY1PB8nFLuNx6BUV5nDJe0ee9BDHAk6YUOcII+pLB1cci
         jlMDwiI8zormFiy/SNCIKr5myAJb2L9RKXGhIxC0AHSd1jBYx1Z61Db+6OUsXzIcTi4j
         sD3Rcr6Zyriub9aUj/34ecCZ3UhyGfhjc+Jo2cZhiQIFvC5Gn0NmN9D9Po32F9YBDYju
         1J3w==
X-Forwarded-Encrypted: i=1; AHgh+RrRyxRk9fnc1w36wb5raeLOf20wXD7iZRuhfCnlhM7K3F+NSsiKtujAYTnC3DucReFV9yr+duDDEijyDuM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWaMmXI2qAZHauRDOvFv4UF+ELKU1wS9FFxJaSLyUzim6uF2UB
	PC1smiJbn6j6JafQ1tN3nk0RL84yreRSMwXj/FcxioymZgoaJgkwk/kPX5v8N9i1fTPhpohM5R8
	g9CeYFSerJY06njz4ZsaTtocAfrWuVkjWtHKxr3FeddMR6OjQmwOUhxsAFCvPKFur6w==
X-Gm-Gg: AfdE7cn2OuYKOfwIG/J/xkPoaC4wzdzlsuGtZgibMn0zr10zLMKjzrw4s1WMdSstb54
	3+nVWPxvmbITkmFTKy8SnCUjgde8ZXdW1y2DrxBGOfbSehbIt+Sdj3aCr5LBFMxVKo/SM+RgSXP
	yn0mBIzzYcADSSUsL7IcwIC+gYOOjQ8UUzgxFp6W/UwoS0PxfTkNDtbPgIHlEc4/NxzNq4YcQzi
	QBLka3OXMBFWwtAwEB+5CzeoJXY0KwuBm+4N4+NgoGy4cgYWx4s2aLQNLB13OiRyRL9NMmtpW/a
	ACbF/iVLQra+gjVmO1SrhmNhEwsTDLiU1Ax2RWl1XmfGwb3qpFSk36QVE92GHCDK2omqIJZSMg=
	=
X-Received: by 2002:a05:6000:2512:b0:470:390c:1e73 with SMTP id ffacd0b85a97d-47f2dce45f5mr26552736f8f.18.1784187644471;
        Thu, 16 Jul 2026 00:40:44 -0700 (PDT)
X-Received: by 2002:a05:6000:2512:b0:470:390c:1e73 with SMTP id ffacd0b85a97d-47f2dce45f5mr26552709f8f.18.1784187644092;
        Thu, 16 Jul 2026 00:40:44 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.112.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4634e0d9sm21595433f8f.2.2026.07.16.00.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 00:40:43 -0700 (PDT)
Message-ID: <1ffd7a63-4e83-4ce8-8a75-df9ec4289c3d@redhat.com>
Date: Thu, 16 Jul 2026 09:40:42 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] lib/crypto: aes: Add CTR and XCTR support
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260715221153.246410-1-ebiggers@kernel.org>
 <20260715221153.246410-5-ebiggers@kernel.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260715221153.246410-5-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/07/2026 00.11, Eric Biggers wrote:
> Add support for AES-CTR and AES-XCTR to the crypto library.
> 
> These will be used to provide streamlined implementations of the
> "ctr(aes)" and "xctr(aes)" crypto_skcipher algorithms.  Most users of
> "ctr(aes)" will also be able to switch to the library, which as usual
> will be simpler and faster, e.g.:
> 
>    - net/mac80211/fils_aead.c
>    - net/mac802154/llsec.c
> 
> As usual, the architecture-optimized AES-CTR and AES-XCTR code will be
> migrated into the library as well (using the hooks provided in this
> commit), eliminating lots of repetitive boilerplate code.
> 
> This is also a prerequisite for supporting AES-GCM, AES-CCM, and
> AES-HCTR2 in the crypto library.
> 
> Initial test coverage is provided by the crypto_skcipher support added
> in a later commit.  I'm planning a KUnit test suite as well.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   .../crypto/libcrypto-unauth-encryption.rst    |  7 ++
>   include/crypto/aes-ctr.h                      | 65 +++++++++++++
>   lib/crypto/Kconfig                            |  6 ++
>   lib/crypto/aes.c                              | 96 +++++++++++++++++++
>   lib/crypto/tests/Kconfig                      |  1 +
>   5 files changed, 175 insertions(+)
>   create mode 100644 include/crypto/aes-ctr.h
Reviewed-by: Thomas Huth <thuth@redhat.com>

