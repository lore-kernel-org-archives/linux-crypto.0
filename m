Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9D91E1E0C
	for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 08:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750407058; cv=none; b=BFBMKzwQ9Kbsal+NWzivXYRqW3gzyrPvau4i1VOYMCEQuB3dULi40BNHBcTyMy2jkSN+GpizIZ9zpahC3X+VwNhgGMsyUB/RCSCJuEazW4mY6uJOa1MJN5pW+b05u1IzHRef3LwsANBrclx6xWAzDEpxH0jVbF6zZ+rvl+N1gKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750407058; c=relaxed/simple;
	bh=es6iHuGCFi6dh05++Ucfyuu+xBaBAubXXAHCPrADR6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FZm4giVIqYpa5mP98WOaFMUPsNTwxijsZbdtkgBfaskE32CDWboqQyM2mg+HroL12fhLcaYohCDJyA+5mDTw2OnLXe7NIRGupqN+WrqsuwQEHXCAAfm2DGs096jsNgUSFRv0CR6PIBwOSJ64kwYN95nTU97CCTh5Xz8q/HuP7xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OfeRqwbx; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfeRqwbx"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a4fb9c2436so784771f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jun 2025 01:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750407055; x=1751011855; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IsMduxzxykvmdLpPy0cCHA2sqZJVkvDNGSlWWAG7xVc=;
        b=OfeRqwbx5ssmnFO1c36Fnu6nt6oxNqsdW1eQYJQIGqg9EP5gSauQpIPSbv98NvdZUx
         jyAxtvTk8AMH+Mjeguw9aObvpYnULvAGA8OtYoGpGUOqrFIlCJUUPuCmBQog/peofT19
         cpA9x3XFian/dUyTNgxO6QHpzktYqAwv2yBmJSMdtGd7Vk04VBpE1iZla2xAW3oorq7F
         cFFmr3L7GwW12YGNVCXHgyDRm1pAMZNPpsnMTXrd11ccuio7JqGKaOrXkSwRm9zyC92W
         vPemhRWTcatPPEfHnCBqSYGuiJUnhgGF411Vbt5NCkjk91J4Z9NIsNgJ20qLmFke9azd
         ySVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750407055; x=1751011855;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsMduxzxykvmdLpPy0cCHA2sqZJVkvDNGSlWWAG7xVc=;
        b=tjcefArUgfB7XD0Gdc8fPGWDcnOZfo/Upvdzlc3zefiiUluUAOVNzn0Tv+9d+YxL+F
         GFjEwRX8QbtYoYrj6SCdFvpiLV/XMBvW7/x3KHKtAuSiopnX0eL52KXNKNvkW/qeeHIw
         VjwAHWpEn4KJXEkZ+PlDp81uEkvzRR/zlB9VNdrMRBp3N1M+eFu58TWrEx+ZbnTqXtGD
         2A0djMlAS/falNgtGrwzr/QCefuYWknS5S2UqjdwOvK8nk3kgAvubljB5NzoOKHxxwLQ
         te+0Fn6adYWDeDKlTE4ZXrW+2X6CmkNcpxcu3bk2DFeZZeW9HrL1Qhyq+AMpwVoGGL0a
         bOzQ==
X-Gm-Message-State: AOJu0Yz/UbggyjiSPQNRLMYFgM6oppGZ+lrOG3IZgF2wg+hlQFvQyqid
	viHgyOxMiETyMIa8ZE7prw5LV+7BrF5Ok8t37nhBh4z9E5IFBmDBkgT/
X-Gm-Gg: ASbGncvqIHAZDSNuMPpMuuW9bDueDkIKE1zhUnvGX6+xmu2bRLIoDECrwbkHJ6aWaj6
	jnwhTc7szBAA7Y2ADMCtsjN2Bt1goCTot92Lu8gtJ6yxYToAZpKxKODKk63TFGIpyyeiFEx5XLf
	D2wwf3xniKqhEucOgYLj7Hr1OWx+sPL1wbRE/8vO1HefKFwVOhglSds2Y621Fe+FWYTRLsjMliE
	StihGdiFeAZQEDjo/m2o1oqci4tOj0cje3rW9IHI6qq5UmViOomDRbJxPKmFjw9Ph1qpBU21KhT
	72qVNzLItjrkGDfHwAcK8qAQvWuW/fJ2JmPwctkzKRey7R62uWGkk8aMR135Wk3YXx4J1xz6vvP
	tK2jebwhCZny9a/ueTb5SXVa81Nr3pGM=
X-Google-Smtp-Source: AGHT+IFGZL+y4BQli3kmDheFwRMpwqkGhBG4NZxyb1mS1T1L3ux4ZdCaSezE1yL/5ggst/FgL6Q+vA==
X-Received: by 2002:a05:6000:4a09:b0:3a5:2208:41d9 with SMTP id ffacd0b85a97d-3a6d12e074emr1466809f8f.40.1750407054585;
        Fri, 20 Jun 2025 01:10:54 -0700 (PDT)
Received: from [192.168.8.101] (78-80-16-228.customers.tmcz.cz. [78.80.16.228])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d117c40dsm1387990f8f.65.2025.06.20.01.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 01:10:54 -0700 (PDT)
Message-ID: <fea81d0e-5b80-4247-8231-1e099be5bb1c@gmail.com>
Date: Fri, 20 Jun 2025 10:10:53 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: wp512 - Use API partial block handling
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <8be28417-2733-4494-8a09-b4343a3bcf3d@gmail.com>
 <aFT2D0UeO0cQYV1C@gondor.apana.org.au>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <aFT2D0UeO0cQYV1C@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/25 7:47 AM, Herbert Xu wrote:
> On Thu, Jun 19, 2025 at 11:18:13PM +0200, Milan Broz wrote:
>>
>> The bisect points to
>>
>> Author: Herbert Xu <herbert@gondor.apana.org.au>
>> Date:   Thu May 15 13:54:42 2025 +0800
>>
>>      crypto: hmac - Add export_core and import_core
>>
>>      Add export_import and import_core so that hmac can be used as a
>>      fallback by block-only drivers.
>>
>> Please let me know if you need more info.
> 
> Please try this patch:
> 
> ---8<---
> Use the Crypto API partial block handling.
>      
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Hi,

Now I get wrong data instead of fail (both on 32bit and 64bit).
Patch just applied over today's Linus' tree

...
PBKDF vector 20 pbkdf2-whirlpool [FAILED]
  got:  58 55 1e ef 29 40 d6 a2 f0 59 e0 d9 4a 50 c5 df 01 25 be ee 27 5b 35 47 6d 37 38 13 0f e0 da 29
want:  9c 1c 74 f5 88 26 e7 6a 53 58 f4 0c 39 e7 80 89 07 c0 31 19 9a 50 a2 48 f1 d9 fe 78 64 e5 84 50
PBKDF test failed.

(Whirlpool is translated to wp512 in the crypto backend and despite it is a quite rare use, some people
used if for LUKS PBKDF2. Actually the whole vector test was reaction to wrong Whirlpool implementation
in gcrypt years ago. It apparently can find breakage even today :-)

Milan

