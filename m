Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905EF416CF9
	for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2026 08:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787126754; cv=none; b=Mpnx2+5MrI1r9SPENa3133Z0JWKyZdhwb+A7vxaLThqxzY7ah64xRocATVw662+m+gX47qB55cxPuizpJukFjCZNwgxXA4Sdv4kS2AsRpzvcD1VzN8M2UTtKIc6c9x/uM1zWquEK4j2woVpXg4Wl3udY7LEjwLnpfiFWqiSBVO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787126754; c=relaxed/simple;
	bh=EqY4oFvFdWZJjHrKQ/C/3JLynOx7PRk34tHkU4TsT60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CyfnX9zULRjmZMQLe6QKQfm/Bf1oaGhoUnG+2q/S8CI8C2QwtwDnI2QnKmH39IlabyPIIGKZZ4T4SXhNsMayB5hV1hlJMuc5reHXHL4lEvIJJzrqV2XMESet2FZpWBiAZpdMJV88qqcNTaOshkTG55IdeE/VYHemWOSMgl7gyvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fCPz3T4S; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCPz3T4S"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c966b9ee9cbso446097a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2026 01:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787126747; x=1787731547; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zx1XIbSXQDNjuYSMB5wywKyAweiX8bC6dFO/L0qweNU=;
        b=fCPz3T4SRuKL1wtgWIYYXpPdHVerwoqvO8Gu5kg92Ij+BQIvdCObN9p3d40RTh+DlO
         EsRx7eljv+smr3av4jnSIefo9tjJ261OxnuKxaFrlzZ0ISo7q9IwknN1P/QjAf8AWcFe
         d7zILfLDPgjGXTFxA+USS/SYx6HPiEOIebuL0R6beLm8UUp8ikuRV5bpeGvpExJH1aiN
         HU1/ctzeiojqkltJ9H1PEQ/J3mtJfCkPKTFy4fgLIxC+yqqwTLW1dLCLieT8gqdUGQO6
         KNmCb5vDyuBsg6bUeiLkQKP6kOzD/Iql3isS3Se7O2CLTUf+CmMRaoY3Ia0bt5xwhXn9
         JSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787126747; x=1787731547;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zx1XIbSXQDNjuYSMB5wywKyAweiX8bC6dFO/L0qweNU=;
        b=XRcB2uF3NzgoboFWL0YWf0gC6x6x5qjcyOjCuN5tgG5FRgqgVnZYG1PB52WvYFCNpa
         T7Cjt25t8uVRdUnQz+/r5H0mtkXcoQx7x4srSrBN7swHOWinWXILlNvpQYWYUKQaiwtk
         ORuyxqRDwAqslNAANQ5n6pjHTXv2z7Mwto0fXUxhyCniuuLmfJu+R5KxrZ1EjyWUrsYW
         g4ofzr5P2g28sg5QFPoRvjAxbjbGgJZBJw3JoYnzW7t1aS6cNFrdG+CK6RcNtBitXVDM
         1Fvl0pcQehcTIEMWCrqBfW9aUftOQQ1tVINDAUoZc9wtKVQ3piBEbeIxHnBwtg1BNFJe
         r2VA==
X-Forwarded-Encrypted: i=1; AHgh+RrOTJWvdIvikpvbCnUPgtjPJ6a9RJhKZeIhO+L+nDuouSLOgUuIiG1VduNfaeYOl3QRgLGK0i4ZdRx15sw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyCFQag5Goec6Eg/LRhIGM99ACSKzGXkry9qdDrDswXKaePdfw
	qFW5Cyv4YhDJ+3kPVTIPJNaNqicl+WkAAmddgcXEi0bRqL93hMyUYE4g
X-Gm-Gg: AR+sD136DIDdsk4jt4csL0wTKYqggBTmQ65HiKY1qHVTBGgS3xe3mCiUkNQdbwhperR
	qWwDcJGA1HEeX66Ul5B0dldMTyYj39c4xwRl/gV2JAV3LTITKVOf/PUNn0P9mVK21cbXZG9ZiZF
	h0Yih+WqXlcsLtoeaA+zdVFglQ9mZTWgN44P+/0BYHBZzkGRXEC3w2gHlbjUsEPzUS/ahzbVnib
	Pxs04EyyWg0HXkBqwQy8bArne4hzXIK6L9ra0Ee+r47nemQNgmzE3XxCayKCntCoIRStXv9telM
	mUrxLtSyLkWwdlbq/y1YyqxJpT5xbiYM+Z/sEa/2UuUCoLpgt/dE9RLFUSWJsn7uVI9mu2vlaWU
	nuiHxG6FV3mecjlsdZP0WdVljT/FPKwq/GwxlPscXTttjh7AWQLMvT5XXceVIolhJpfKxEpwL+E
	GnnXwzTlCsAyVXjebyeeTOLrSZemBLRk+cww1m1/w+6e3J35Hxl92LQUXFTkpmqsdAWMeo
X-Received: by 2002:a05:6a00:1bc8:b0:851:8bde:7873 with SMTP id d2e1a72fcca58-851d3846f63mr4732877b3a.8.1787126746627;
        Wed, 19 Aug 2026 01:05:46 -0700 (PDT)
Received: from [192.168.90.3] ([175.235.236.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851d366efa5sm330508b3a.55.2026.08.19.01.05.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 01:05:46 -0700 (PDT)
Message-ID: <f3cb693e-341d-4d4d-8eb5-45420dcca3e8@gmail.com>
Date: Wed, 19 Aug 2026 17:05:43 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] crypto: introduce generic dynamic software fallback
 and EIP93 support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Christian Marangi <ansuelsmth@gmail.com>, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Antoine Tenart
 <atenart@kernel.org>, linux-kernel@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>
References: <cover.1785226804.git.hurryman2212@gmail.com>
 <anmEDI6cQxS1wGtH@gondor.apana.org.au>
Content-Language: en-US
From: Jihong Min <hurryman2212@gmail.com>
In-Reply-To: <anmEDI6cQxS1wGtH@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 8/10/26 16:55, Herbert Xu wrote:
> On Tue, Jul 28, 2026 at 05:43:28PM +0900, Jihong Min wrote:
>>
>> The tcrypt AES-128-CBC results are median cycles from five runs. Lower
>> is better. Disabled uses cbc(aes-eip93) directly, while enabled uses
>> fallback(cbc(aes-eip93)).
>>
>>   Request   Disabled   Enabled   Cycle reduction
>>    (bytes)   (cycles)  (cycles)
>>        16        322        18             94.4%
>>        64        274        43             84.3%
>>       128        292        74             74.7%
>>       256        312       138             55.8%
>>      1024        434       439             -1.2%
>>      1424        492       488              0.8%
>>      4096        980      1023             -4.4%
> 
> Do these results vary that much at run-time that requires a run-time
> test? Surely you can predict the outcome for the platforms involved?>
> It appears to me that you're simply adding complexity for something
> that can already be easily tuned by the administrator through the
> algorithm priorities.

Many crypto IP including EIP93 can have different host CPU performance.
This idea is directly from in-kernel raid6 module to dynamically
calculate this host CPU performance to set the boundaries.

> 
> In fact, why not implement the benchmark in user-space and then based
> on that result adjust the priorities?

The same reason why there is the kernel crypto API. It is a single point
(both AF_ALG and devcrypto) of entrance to each crypto device
implementation. It is best to control within them.

> 
> Cheers,


Sincerely,
Jihong Min
