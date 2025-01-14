Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A432361D3;
	Tue, 14 Jan 2025 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736858026; cv=none; b=Y1IozNqdxF3hm34Ho3QFcMehE+zDoTQSE2dj7umf+Bf3yox7Vx1g2vRtKCvt72lTldbqwAOdmiUhT/Ak1OZEKUlBBH0MlmPfMduO6k7LMSRJM759p+nHLuI7tJpTjPNXdl3L6SHAUK2QnOY2H2r7Q4aicMC0sibM0w+lSkdY7bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736858026; c=relaxed/simple;
	bh=/YJr8UpKRDc+0utfD6HmlO4vHLwuJEf1t/xcHKocVQ4=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAwm0gfS6y8pbsMyS3ms/KWDHZUO0s/5lISVYXtiBcIeyz2ueKyUnS9NHdzS7IIXexMGy/u39OXzm1zBZwOHjz22OBDbj9YO3eYmT0MCCrOfUugCDV6Uf/B3x8+GRmDnNi+3h2WuZBbSzOBpeMpvI4wrxo1JoiJ2bcdqIxRYwT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BDxQtl3x; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDxQtl3x"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-436202dd730so38654915e9.2;
        Tue, 14 Jan 2025 04:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736858022; x=1737462822; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=e0G14l1knOdaruc+I1unnIDR29LSZs4T072x9bMUSOk=;
        b=BDxQtl3xiFP8m+JyNDVgrOR+kLZplSvvYo4+NW+XeEzBAstzbDeJBU1eqGy/Q3uQvk
         v5tpzht4Mouwz4R1fEngqZDd1kXGZOlcKS/ZOU4SDZQjCs/OVuZ8FCnXJ7ESlVcLNcAX
         UPUL/r40nETECU4TGkGwa4C+J26DIyMsR298dgYB+p678d2zTnGt8AvuGtvtnZqS7joT
         m0x1N/GS6V9z5FcbdEo2cl3xl8deb1d+z9VMBfqRsrqYRWvmyNmYM9xml4eVpjAHVNWY
         xmn1MYRMt664VXMLfmZ6P7c6fJnqEVKSDmuBWzJTkXsRn3UYSy5FSetG7p5Nx6Fi9PhJ
         y46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736858022; x=1737462822;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0G14l1knOdaruc+I1unnIDR29LSZs4T072x9bMUSOk=;
        b=a2PxB6OZfdmp1+xiHTJkh5XYg1BumjDhSwnOQlyw3omrljikpsdXn5M9A6nJQtUtjR
         1S8nNX3EOa+xe6t129tobFjTWTXpyfbsFVpBi70t4oywcoO9Y16X9Y5EUo7TFzzjHPVF
         eDOkH1H3w7DVNqr0URFE3eaKgluy1rg0gCGVARgCevnFQqeX3Tgde0IslnQ0NVz9RRHl
         irYKJV8mmXWOrtkC22JyMKduze57UJn18hcA0M374Nk/YvxxaojooOoCkk2b/o6Vq5BT
         lCgFp3uZzpXfJekPbAm6oi+BxeKSseUwMzsMzQ/ErGCoLLDNlftUV3Sst9ySV/bNxBhH
         sv1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUFgYdZmy8RVS/T/XoiyYJ2/rAr4N5JDXHrtczInThKAxmnmJFP2xFin5+84afi5H/WLUdBDvOg0OyBfkP/@vger.kernel.org, AJvYcCUjDIo3wK7N6HGNHDMaSdiz670ndDy34c/zIHupdsR4KcxcRD7Dz+hv9+Yqh956TUZa1xUHKQkIh0Lb@vger.kernel.org, AJvYcCXB45PUa51Wbg9EskZuIXNz0X7cndxYPGZCNOtafP3sxUQ+FIgrsvGY6A9+124Kj5sLx5Tar5jDT62LyPry@vger.kernel.org
X-Gm-Message-State: AOJu0YwQFx/R6ROraMyH+kMlQP6hm6WWwcSVHVUSSetAkHwGdTjkg6hQ
	4l54vX0fwlAp3M4tdWkhXGZbREgrOKGQ3nkmKyT8YiDdtUkv/oaz
X-Gm-Gg: ASbGncsm8lDkjlDwgmFAoGRGpxo3U9xU69j4RpttmOUrFNS8i9KHjHQ6URN/hY/4Dra
	qae/xnNBkNG3FdVOV5JdurRtBKPdfsTFztsPhNWOhx1cAfcPqd7PRiCkBVBIVPM/yU7nlaAChSx
	cbIvEZsD3BaUXUEv0RlKfo2/xQaOu8vrOHkzz2kRPu0NMjMOil1AiLqabmnVYwzXAwumz8lIifl
	LlHsiaCgMrVU6tLdDJEN1FqsIYocTczKs4uGOrahkSZS2jldw6APVRPMN8ruxTxfKTIDdx7CLgx
	4+6mVcwKFRDj
X-Google-Smtp-Source: AGHT+IHCsdPFaJF6vWjg+pdCa0iGNxZHxd+p3cTgxOveEGdFXhRJJcBQjoZk8a5ZgIUGLsHlqteHJQ==
X-Received: by 2002:a05:600c:1552:b0:434:fb65:ebbb with SMTP id 5b1f17b1804b1-436e26be5a3mr241842435e9.17.1736858022273;
        Tue, 14 Jan 2025 04:33:42 -0800 (PST)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9e37d7fsm172267105e9.32.2025.01.14.04.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 04:33:41 -0800 (PST)
Message-ID: <678659a5.050a0220.17d5d0.749c@mx.google.com>
X-Google-Original-Message-ID: <Z4ZZof-GeNjDEUOB@Ansuel-XPS.>
Date: Tue, 14 Jan 2025 13:33:37 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v10 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
References: <20250105143106.20989-1-ansuelsmth@gmail.com>
 <20250105143106.20989-4-ansuelsmth@gmail.com>
 <Z4XbwyrBXXcQvqiO@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4XbwyrBXXcQvqiO@gondor.apana.org.au>

On Tue, Jan 14, 2025 at 11:36:35AM +0800, Herbert Xu wrote:
> On Sun, Jan 05, 2025 at 03:30:48PM +0100, Christian Marangi wrote:
> > Add support for the Inside Secure SafeXcel EIP-93 Crypto Engine used on
> > Mediatek MT7621 SoC and new Airoha SoC.
> > 
> > EIP-93 IP supports AES/DES/3DES ciphers in ECB/CBC and CTR modes as well as
> > authenc(HMAC(x), cipher(y)) using HMAC MD5, SHA1, SHA224 and SHA256.
> > 
> > EIP-93 provide regs to signal support for specific chipers and the
> > driver dynamically register only the supported one by the chip.
> > 
> > Signed-off-by: Richard van Schagen <vschagen@icloud.com>
> > Co-developed-by: Christian Marangi <ansuelsmth@gmail.com>
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> I get a compile-time warning with this patch (C=1 W=1):
> 
>   CHECK   ../drivers/crypto/inside-secure/eip93/eip93-common.c
>   ../drivers/crypto/inside-secure/eip93/eip93-common.c:101:5: warning: context imbalance in 'eip93_put_descriptor' - wrong count at exit
>   ../drivers/crypto/inside-secure/eip93/eip93-common.c:126:6: warning: context imbalance in 'eip93_get_descriptor' - wrong count at exit
> 
> Could you please take a look?
>

Hi, this is just a false-positive with the usage of the cleanup API.
Sending new revision muting this by using scoped_guard instead.

Will also make cleanup guy aware of this bug.

-- 
	Ansuel
