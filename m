Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECF41FC7E0
	for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2025 23:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739576324; cv=none; b=Gd+udvacv2hgrBv5BDBGbLWxoTggdE2ZWW7C+Wn4nONDuijOkohlIT3pl8wN6AI1OYujvUazVEH46U03ARgql0QXQKQn156JXgnF9QOcI6OfScBS7cIwuBicf7/s+Ax1eLaA+hbwtrxEw+54YSsFX7wsoKJhalnttDF+b3wSfBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739576324; c=relaxed/simple;
	bh=3FgOVFO8GNqDS2zLxm0cMMBnAmqo1GiengKzpNDRW/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cVdpwdW1KkA+XWlnG9yguSETw9xbIu2xJRiKINhEMfvpBjwdvNCpXYY3JArtkHocxyvCbS4wwpMkQedNotJf6HINp58d0ClzSj9CFGrHWijmIY6s/5tdl8rJFEDim34rSo0jFMd38Wj7jeFPUVDyEw3uDtUoMntO/tPuvH3tN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c5nflBpR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c5nflBpR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739576322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dkl08VAARbn7X2yB9Abn8zNYw7VapeXfiEWGo0rvbzs=;
	b=c5nflBpRACT5MjrhYf/ANVsHMQ5UPN5mMJUvQZQSrCBOlH8wo95+V6CdZSGG6YlH+sv3jM
	FrRvmr2u5fuovQNMczKrCnHuhHaBYT2P94Qiw3nnUxiKWjyB4ZxPbulgxIQh8hUhoXh7N9
	tKzN4eg33d2o13wa8+RoaR8vu31/1/Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-AjvHLdKRNlW0TV5I-437eg-1; Fri, 14 Feb 2025 18:38:40 -0500
X-MC-Unique: AjvHLdKRNlW0TV5I-437eg-1
X-Mimecast-MFC-AGG-ID: AjvHLdKRNlW0TV5I-437eg_1739576319
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4395fa20a21so15219255e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2025 15:38:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739576319; x=1740181119;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dkl08VAARbn7X2yB9Abn8zNYw7VapeXfiEWGo0rvbzs=;
        b=aHFpfKqBpOmZmoJyyKKf0HHm1068gR9rUj/LQYWIu7IXorOMHuFB/1Jcywdg27YF2S
         nE3SeUrnRT3ZbOmPcmOq0LURdN0IVzUMkefX1LSdL4xdf4a6MzW2lq5U/ngxWCTVfCfX
         i0lefAoSwgdC5jmuMjac1qEXpp0aDQFKMWifZDsF+AtaFMX/zPFqVl+bezYZvDGdmDdk
         AMUUI1oB3zcwEfjD8Dd7uyr+6jmsIur0b+7GhA3sXXJ6fT51JcYDw4yw/+vxLhXFzwIU
         UA/uzWTBZGjp/qivzvbRhnW9eX/ONzX63olowiYN17g1NtuTZuMj1ZsN+ly0f8lc8xfj
         +b3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/rmv3rxo5z7aFzTMxrLfi1gdx6mqdMQwVhJlbSMTARsyS9QRNMUWTPC1iybOdLK8EVsMdPVzE2Qa8NOk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpckj6ppO1ZG36sxC78TfCieECk8Te+i0F8v6VDf9ImfPpsFwv
	JvKdGfeq965tiZoxeRLrhk2JuW4d2hDh8mG1bvgL4pRFkP0XS8DarRGx9DjyfzZVX7fHHTlnBp+
	tSbDangbh+inSPtX6AzYP5oiAX+ms9xVG41UpOmiQ0ameU327aCy95Xmht/OqLQ==
X-Gm-Gg: ASbGncukOtWnw2bwacYqXbGx3rVWjhHAjKZit1c0r0kX4+cJBhvoo2F2W0Qf2ybx/mX
	byRhaoXMWkVdd3PyTBNM8DoVH5fhbuOcJpcu8iLvPmyUhZ7h0xij2JSirXicW3iwHuNioakXvj8
	4PN8ZmFQubsAsyCkQPqn4z0symtvq8ixfX9E1FCilx4DszaAJjrz7Xsq8UoKICtD/KBrtFQRCxl
	dgMFCMk1R8qei7IA8Es7JOWkoiL2fyHX/28Wtz9r5nt9/vf9tzcQGxOQ0Fb+hnV105x1F99tKjf
	ADRQVQGfykA=
X-Received: by 2002:a05:6000:1f8d:b0:38d:b028:d906 with SMTP id ffacd0b85a97d-38f33c20f7cmr1320383f8f.21.1739576319205;
        Fri, 14 Feb 2025 15:38:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGuwJR95sgolXJa3JZbal6oWOnodlKaw9NVdzdZq6kdIBfuHesYm3UO/VFsI1pO4iTzeaJo2w==
X-Received: by 2002:a05:6000:1f8d:b0:38d:b028:d906 with SMTP id ffacd0b85a97d-38f33c20f7cmr1320351f8f.21.1739576318838;
        Fri, 14 Feb 2025 15:38:38 -0800 (PST)
Received: from [192.168.10.48] ([176.206.122.109])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38f259f7987sm5694927f8f.87.2025.02.14.15.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 15:38:38 -0800 (PST)
Message-ID: <dbb0ceba-4748-47ca-9aae-affd189e2f92@redhat.com>
Date: Sat, 15 Feb 2025 00:38:36 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] Fix broken SNP support with KVM module built-in
To: Sean Christopherson <seanjc@google.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com,
 dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org,
 kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, vasant.hegde@amd.com,
 Stable@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1739226950.git.ashish.kalra@amd.com>
 <Z6vByjY9t8X901hQ@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z6vByjY9t8X901hQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/11/25 22:31, Sean Christopherson wrote:
> On Mon, Feb 10, 2025, Ashish Kalra wrote:
>> Ashish Kalra (1):
>>    x86/sev: Fix broken SNP support with KVM module built-in
>>
>> Sean Christopherson (2):
>>    crypto: ccp: Add external API interface for PSP module initialization
>>    KVM: SVM: Ensure PSP module is initialized if KVM module is built-in
> 
> Unless I've overlooked a dependency, patch 3 (IOMMU vs. RMP) is entirely
> independent of patches 1 and 2 (PSP vs. KVM).  If no one objects, I'll take the
> first two patches through the kvm-x86 tree, and let the tip/iommu maintainers
> sort out the last patch.
I'll queue them myself (yes I still exist...) since I have a largish PR 
from Marc anyway.

Paolo

