Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605559;
	b=KSYbILylChDmP6ic61tXRqWQBucnSUXNd8zhi5CC4xdBMVvK5SzQT+GwffmQRv8ange9
	 B4Rb3hepf0KKVJKME96HYZ/RVfaJbM4X0kERN4V1zoKBCt382nFkWJSHYbZciX9QymMV1
	 ggcQxrMoCw9ZruJgPixP6jEE8uJaLQvcRCs/odRcDN3tr2jSWMhEsrdduzBkIbw5SUjRD
	 PHn87BNF3yen1CmRYNAqvEUeB+KMBkFsoxUL8LvnQAZiLHHvzOp8eO7jFzwJx8xxIptkc
	 BC4AszxhGSBsoJKDcyVU7ottUcYjkzHN39jJPlPVzBDkEGZJSK73dO5/htXUZtK5BXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605559;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=zXAnmuPb+UJxfaWEwGiyc7AIwSrsHLI5fi4lsQ4yc4A=;
	b=mlgTQB7vYcN6xgc/fqYxlBpJwSU0vtCZv31wtu3vw/1fj3pONzx5xQ3hEPQDPWy8i37A
	 4AsIyXaS3ujJOg4ewAPmU6ngUrXt56sviX7cQZCukKkZKMH94JSM9eqEwQN+NbHht5EHl
	 uhM+kPA2milms531+rV9boCsOiJ2lPLJs2unEC6Qc3AYjOsAhvTI4Bdcp/rdg1fEas6zk
	 07t5KyfAlktQP0F5tQtI9EexsTTDFcUUd3Zs//LqAXDmPHxaVsLdClJgOy2iAPKVivxsO
	 X71xd/V/lhL/+jCdm7/VA7KC4QXXlJB+C7zX6v/DZV81P4etPAF1Jng3xXt9279LbYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Jv0+1uWb;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Soyl8vn1;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23A5606A327
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 07:45:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C23A5606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Jv0+1uWb;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Soyl8vn1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793605557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXAnmuPb+UJxfaWEwGiyc7AIwSrsHLI5fi4lsQ4yc4A=;
	b=Jv0+1uWblTE5esqJ4gFj+v9GGoS8bpoS2ea7jwE0UJGt8Cc4k++p3cL6zWrhcbRCgu4XZ2
	qIQPCbogOoCtXOWzMAhlYwgJUU86CLEcBL76R4Zvo3x/ou4fV6PWKJwoz3eIOTZ3433vFO
	OUUV4pynwOwE31Ag3bO2A/vUtGbvt/4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-CXOlVUr-PH-8nrNC69iTjw-1; Mon, 02 Nov 2026 02:45:56 -0500
X-MC-Unique: CXOlVUr-PH-8nrNC69iTjw-1
X-Mimecast-MFC-AGG-ID: CXOlVUr-PH-8nrNC69iTjw_1793605555
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48af4a0bd0fso1464873f8f.2
        for <linux-crypto@vger.kernel.org>; Sun, 01 Nov 2026 23:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793605555; x=1794210355; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zXAnmuPb+UJxfaWEwGiyc7AIwSrsHLI5fi4lsQ4yc4A=;
        b=Soyl8vn141gSBq5Haa9UsLSYHSWP5oYCk9shIBGyMT5FvfeoUc3njHGNEFzW9fYMKs
         AViZKnkWxqChHcimPiOMPtfJpL2zXaW7LZWX4cx/I2w09egTRTkjVm43R/1wY+UbRZzE
         z+AezeCsn3rUpJJ05nZTUlCO1GsoCjpdXlm1/AFcdn00mw1gcvczwEolsCUnboGcTtth
         aRAlhEVn3fSbwTVfbH4CMFX398dS2hV3OAUSZ1gFtYUIFmWIdrVSWLzEX4AcOZmmJTAp
         EWq7tk5uzk+QB05qGYJEGpyNTGzxCYKOQR1HTrg5E8885suk+tpAuXRNi7Y39OoY6g+D
         Un6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605555; x=1794210355;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zXAnmuPb+UJxfaWEwGiyc7AIwSrsHLI5fi4lsQ4yc4A=;
        b=a2vVxu7Rfkewm6d21zvyFWwjoj/6aCgz5zyiuoDbfgbxgiXetK0nrNrwqqf4gSd4vJ
         d9F3ct3qQvwI14/lYt7cZLEiP+Q7WVT59jyQOh0/txAkIf7Xh+JHGEqrUuzpDhvNXmZs
         LFSj/sPJ366hMX7MObVXC68FArrggtEh8xqcf8bBldfaNusByJbvUAeLdc2sic6c0o4r
         8Nsd6rmwi5vDc/pTYZYVbWZMf9N+vcz2Ebi2soVTUIoqEWOqFd8a9HEhe0e0Mfuhhadw
         4CtP++QVPsuy0PTkgqj8WxrptMx8UApLvENT3NydsKvhp1vWGEi18rz5Aj26Y5I5YcGg
         qJhw==
X-Forwarded-Encrypted: i=1; AKwUvBys73ZAkCJQtVS2JBlKgoZI7GFuSnM0vWXYBA9JZT9jMnOacO6XzVisbWQ9Ve3nqD9w4uLqVEXSsE6Fvlc=@vger.kernel.org
X-Gm-Message-State: APuU4Z84k2IcRqOyRNdY+Uqswe8tvmZ9UhntjBFg37796obubPFJ85Hc
	oHsVTYc2NDtnkgoYajYTZW5mDP8Tk/gawp7gagw9pUfxQeBq2EiqHsTjcOKRj32H6qSjVfkB69Y
	1+uefq9+otJLEHuySifUOoYRb5Cb5GF4rutBDeAooY7pbo9FnP09IbopauEGv+BiD+w==
X-Gm-Gg: AYBFou1ijOhWGzsLSi0VRt7+a97KhU4u5gsoBRcFOZTRq2j6mGucsf21eztCbbysUUV
	hJbZZhPYYn7TyNYjDhwM5ULUFltyFpaHYVGz+2yFwZZFyrxgVZIM71/1sd0VRyBugu8827Md94j
	g3jgeUpPEDnftOQmZNBZMFmK89BE0WRv2nJWjlPQ6mDPof8gvjI7d5keOlPl0n+8buk0M0YcjTT
	kXNjzQz1Bk3kW3sPNXYX/3YOdBg/4Lhca/Rp2jwI9OJU4pOkaKGPAne5/M5GfAKIuo1EsXs1cyY
	Wqvx0y2B8BZFoz8IfGxs18aTfutA2fh07loUb3URztJdXQZs9LcaQPCdp02yQrFaWJfrORA4DNl
	zWqBAaXsfuIMx0ghT4LwnsceZJ1pIUIWZOGTOg/lhtuhk
X-Received: by 2002:a5d:6f0b:0:b0:48e:f14:61bd with SMTP id ffacd0b85a97d-48e6e2f6772mr21787830f8f.14.1793605554841;
        Sun, 01 Nov 2026 23:45:54 -0800 (PST)
X-Received: by 2002:a5d:6f0b:0:b0:48e:f14:61bd with SMTP id ffacd0b85a97d-48e6e2f6772mr21787797f8f.14.1793605554469;
        Sun, 01 Nov 2026 23:45:54 -0800 (PST)
Received: from [192.168.0.9] ([47.64.112.102])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b727c6sm20260675f8f.16.2026.11.01.23.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 23:45:53 -0800 (PST)
Message-ID: <a125b22e-4096-451e-a9d1-71113f7cce35@redhat.com>
Date: Mon, 2 Nov 2026 08:45:52 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: arc4 - Remove obsolete crypto API support for
 ARC4
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>
References: <20261031211535.8793-1-ebiggers@kernel.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20261031211535.8793-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/10/2026 22.15, Eric Biggers wrote:
> All in-kernel users of ARC4 use the ARC4 library (lib/crypto/arc4.c)
> directly, not the crypto API wrapper (crypto/arc4.c).
> 
> Removal of the crypto API wrapper was attempted in 2020
> (https://lore.kernel.org/linux-crypto/20200702101947.682-5-ardb@kernel.org/)
> but was delayed due to its use by iwd via AF_ALG.  This was, however,
> soon afterwards resolved by making iwd simply use userspace ARC4 code
> (https://git.kernel.org/pub/scm/network/wireless/iwd.git/commit/?id=1db8a85a60c645232eb5bba1ec0cd0a2927ccd16),
> which was released in iwd 1.9 in September 2020.
> 
> Also at the time, CONFIG_CRYPTO_ARC4 was placed under
> CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE, and the kernel started printing
> a warning whenever "ecb(arc4)" is used.  See commit 9ace67718310
> ("crypto: arc4 - mark ecb(arc4) skcipher as obsolete").  So, any other
> hypothetical user would have had 6 years of deprecation warnings, even
> if somehow they were overlooking that ARC4 is insecure.
> 
> Finally, "ecb(arc4)" isn't on the skcipher_allowlist introduced in v7.3,
> so it's no longer available in AF_ALG by default even if
> CONFIG_CRYPTO_ARC4 is enabled.
> 
> Given all this, it's clear that the crypto_skcipher / crypto_lskcipher
> API support for ARC4 is no longer used or needed.  Remove it.
> 
> The ARC4 library remains in place, as it's still used in the kernel to
> support certain legacy protocols.  (Note: since this removes the only
> ARC4 test, I'll also add a KUnit test to replace it in a later commit.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   arch/arm/configs/am200epdkit_defconfig     |  1 -
>   arch/arm/configs/spitz_defconfig           |  1 -
>   arch/m68k/configs/amiga_defconfig          |  1 -
>   arch/m68k/configs/apollo_defconfig         |  1 -
>   arch/m68k/configs/atari_defconfig          |  1 -
>   arch/m68k/configs/bvme6000_defconfig       |  1 -
>   arch/m68k/configs/hp300_defconfig          |  1 -
>   arch/m68k/configs/mac_defconfig            |  1 -
>   arch/m68k/configs/multi_defconfig          |  1 -
>   arch/m68k/configs/mvme147_defconfig        |  1 -
>   arch/m68k/configs/mvme16x_defconfig        |  1 -
>   arch/m68k/configs/q40_defconfig            |  1 -
>   arch/m68k/configs/sun3_defconfig           |  1 -
>   arch/m68k/configs/sun3x_defconfig          |  1 -
>   arch/mips/configs/decstation_defconfig     |  1 -
>   arch/mips/configs/decstation_r4k_defconfig |  1 -
>   arch/mips/configs/ip32_defconfig           |  1 -
>   arch/mips/configs/rt305x_defconfig         |  1 -
>   arch/mips/configs/xway_defconfig           |  1 -
>   arch/powerpc/configs/44x/eiger_defconfig   |  1 -
>   arch/powerpc/configs/44x/redwood_defconfig |  1 -
>   arch/s390/configs/debug_defconfig          |  1 -
>   arch/s390/configs/defconfig                |  1 -
>   arch/sh/configs/sh2007_defconfig           |  1 -
>   arch/sh/configs/titan_defconfig            |  1 -
>   arch/sparc/configs/sparc32_defconfig       |  1 -
>   crypto/Kconfig                             | 13 ----
>   crypto/Makefile                            |  1 -
>   crypto/arc4.c                              | 82 ----------------------
>   crypto/tcrypt.c                            | 19 -----
>   crypto/testmgr.c                           |  7 --
>   crypto/testmgr.h                           | 62 ----------------
>   include/crypto/arc4.h                      |  3 +-
>   33 files changed, 1 insertion(+), 212 deletions(-)
>   delete mode 100644 crypto/arc4.c

Reviewed-by: Thomas Huth <thuth@redhat.com>

