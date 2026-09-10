Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B9E3D7D74
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 08:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030662; cv=none; b=P3I1p/kT/2zjlyLv80Wd4GQKREL+/f8gNMd3KFwLjnSqmjlWnMD40z4kA7IEsalotzUfnWDmZTjLrZhrgOYXxvNH9GxdyBbYLSLDtFCR8YV+2myUJk22yxMG2wglR1EfdAnQCXOZZMLcDDwshROegqJm2cXSFqMqeIl3E6KcNwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030662; c=relaxed/simple;
	bh=b7K6pIWMoglwO1Ja+bQ2JtN346C4MXe5NqlN3W0b7Q4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hRyk1fs6gzdAVbF7eIiXH6ZBss3oY5BnSXjBOAUJujO8v/rGPVQpCDzJQp0hSScLgnkMAj3+mJZ3KbSsR56Mbz3cdknneh93HveyYLXLSN/1gf7at0xnS1Kp4WeFqW3/6pi4or70EoQVFPZ6DGX9RuHZs3xCdP6d9tNx6Q6Q2zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxsdv1Y0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=p6HKrO/7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxsdv1Y0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="p6HKrO/7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789030659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y08MuvRHSicjXeoYJ3CdQ0GrnmqIMwlAmbYm+7kzbhY=;
	b=bxsdv1Y0XJN/j65mR4Hu9J9Ymf4wK+x2OIY8T3vg3G4FNkM7Fl5XR76WFhMNQLHlvJJyRj
	o6EbKEK3MAak6dL+U9GI0vXTaBGpTc6Ie8dXVGFFOwQtxInnqa0NyMqCOEpqCMbBqwYQ2R
	vWaD8Px2ULrt9rZBLgI+Z2dK4wEtgRM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-EfevskJbO4-sHtlAk6GLOg-1; Thu, 10 Sep 2026 04:57:36 -0400
X-MC-Unique: EfevskJbO4-sHtlAk6GLOg-1
X-Mimecast-MFC-AGG-ID: EfevskJbO4-sHtlAk6GLOg_1789030655
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49cd55ee2f7so58505735e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 01:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789030655; x=1789635455; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y08MuvRHSicjXeoYJ3CdQ0GrnmqIMwlAmbYm+7kzbhY=;
        b=p6HKrO/7Sx0XGr5o2hbpsC0j/4IOnIjJZjF819j6Xg2v/B+xV6SDUep756ptndGJBF
         PnTNdV8hIgDsWwo0njzB7pufTg1nRIEQfIhW9ACP71kpaiK/Ep0zKVE5pSPF8xSnmuta
         K2YI0obnetn0aSwI2NXaVx3yhT8su6SKsWtkc2uMgGp9DI2bvvD724TqhesTaAnkoY0M
         rygo833uBYB3p+tr5BOOYXl63Vf74ye0rmxM2X1jqAxDfo5YMbQ9AKpEW7eckvlzxtcy
         jGFfU8TF7vKxNnJovfglsfhIaXxVFrLn8PBMOorVZp/F6wmstKXQe3NElPOatXKysq2M
         BlFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789030655; x=1789635455;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y08MuvRHSicjXeoYJ3CdQ0GrnmqIMwlAmbYm+7kzbhY=;
        b=qYNePydFHlUuqCzy6PsndxZWEEur/XCAydm3MPqfS9aifrnoBUGTIGUAHaGiP73EFr
         dW7IipHi5QYLJzI3no2J8hAifnOmisghhQlbI0tHj0qfvV1n32CQj28MTrISD6ebJ3/H
         dNLlBuSqN4wjf3xb4ZLCyKcxNM9mi1yj/HGbYYjscnl9oP8jHBZvUyAxOxKcHQLOvxx3
         oz4l5xvSzgsvUMhe8M8H3St7S7DiwPKfd/aaGSz4pC+FwF+NCXRv4pt9C2q+IIIQtkly
         AA/w3PjsLxmEcqR6VcrHlukBF8llZQ56GaoDdP8bV3kPDZlg9O4A5RhtrESAcm8cao6F
         ihhQ==
X-Forwarded-Encrypted: i=1; AKwUvByI3IuEjpyN7b2kbvuNzamSBNn//WG1c6hwN++GyWmv2IQAD3ymYBAybXX+v7GVMerMOfAkgdphtcJAmbs=@vger.kernel.org
X-Gm-Message-State: AFuF++lxfvBYFChemtWI+ayaWc6NjjrUNR0h3FdUczqAyAtRoF3ZniXu
	fjiv2nyo8naRtF3b0Qv45RXCgAec/i/dtzZW7kyQzpvt0w1nWHgVh9OEcu1tuWeGRXF3Qi9D0EQ
	au0aHizF2KquDfKOpiY82oJ1btN8HInzKMdA5fQX2iPZ75pBDlJqZd8PoedkopUvj3Q==
X-Gm-Gg: AYBFou2nUDDeVTm/WX09M9AofHqLjcLsdkjrSAtWrYJl2yKsMm2RCiQLAfAO8cSFjTa
	uvDHQ9eVtrdBhDa7Kuy4t+9THLoNWVOt6nCRxiyFwtwzuUN2UWfOvTSPlFdfihuTp3YlC1WQz4Z
	eAnGEpfrVmWG7k/8VUHSB8jiJnHvqkjtp3+mmjBGc4jVo96XnikuOh9S2MnXO164z39SM34Tmpq
	5CBEe1eF/oSX0J2W5Q9JBHOvwOqArSWCyYvTMRLlfoRvN8pm9cfTda+OH2qtb6sU6xUSSuGDPMg
	Z20Dc9on6u7pgU89mw2Hl3IIXdyJNW9kT3i0EKItrolyTi6as1Zhx1uV6zz4uAn2lN1joorBVg=
	=
X-Received: by 2002:a05:600c:3550:b0:49c:d019:70c5 with SMTP id 5b1f17b1804b1-49cf7f4a6cfmr363669285e9.0.1789030655332;
        Thu, 10 Sep 2026 01:57:35 -0700 (PDT)
X-Received: by 2002:a05:600c:3550:b0:49c:d019:70c5 with SMTP id 5b1f17b1804b1-49cf7f4a6cfmr363668975e9.0.1789030654851;
        Thu, 10 Sep 2026 01:57:34 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49db038401fsm26614995e9.13.2026.09.10.01.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 01:57:33 -0700 (PDT)
Message-ID: <48f12b65-428d-4809-9735-18876b09e759@redhat.com>
Date: Thu, 10 Sep 2026 10:57:32 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
To: Joachim Vandersmissen <joachim@jvdsn.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
References: <20260303060509.246038-1-git@jvdsn.com>
 <abTuFto8Tc3mhRRe@gondor.apana.org.au>
 <64592fee-1956-4a70-a751-9ac3335cfc27@jvdsn.com>
 <9926908a-5f08-43ba-99dd-b83c7067d52b@redhat.com>
 <83d09aa1-729a-47a2-a8e9-381c74e92f42@jvdsn.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <83d09aa1-729a-47a2-a8e9-381c74e92f42@jvdsn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/09/2026 05.24, Joachim Vandersmissen wrote:
> Hi Thomas,
> 
> On 9/9/26 9:36 AM, Thomas Huth wrote:
>> On 15/03/2026 01.43, Joachim Vandersmissen wrote:
>>> Hi Herbert,
>>>
>>> I don't think this one can be applied yet since dm-integrity still uses 
>>> xxhash64 through the crypto API. This would break fips=1 systems that use 
>>> it.
>>
>> Out of curiosity: Wouldn't such a system be FIPS-incompliant anyway? If 
>> xxhash64 isn't FIPS-compliant, nobody should use it for dm-integrity 
>> there, right? So I doubt that there are any systems out there that use 
>> fips=1 and use xxhash64 at the same time?
> 
> There is a risk that users may not know that xxhash64 is not FIPS compliant 
> and would still use it. Especially considering it was marked as 
> "fips_allowed = 1" for a while.

So isn't that a very bad situation? They think they are FIPS compliant, but 
actually they are not since they use an unapproved algorithm by accident. 
Maybe it would be better to include this patch so that they are aware of the 
mistake? If there is really somebody running into this issue, they could 
boot once with fips=0, fix their system, reboot again with fips=1 and 
finally be really compliant. Sounds like the better solution to me. WDYT?

  Thomas

