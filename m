Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE6615E86
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 16:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715360386; cv=none; b=HVf643d0QD6Ye1mfftxf70qkOUOAo+Gtyry2FJO3qHCYM+lNiWmePV5MqDNHzGPFvUx3/CgMibWX0mwVrBEOMBHbJgSJs80EBcPFBsxKWQb6gj4XJMxMEy6GFoFfcCvk72E6oTEJ/ecBjK5UWQE9t/pzLz9vXgQ1umAK/2XipY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715360386; c=relaxed/simple;
	bh=mrAxYLN7YaKXLmK0pnZRcR4iGVsgpjNfTJqetsyp/K4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pqR4xBAEUQROzuzvxdpS/gd/dBZKdqcLIk1r/kMM7HPq29ozDdD9EYSd4JTy6xJSD4QPbMqTZLQbOVEMYd1EEpolfJYn57XruL4MMNi9j0xumT/fR/L/CzUUl25aIAUZ4DTuk84HrclxKaL70kBEdwyyml1ZfIoI0G59KBf+2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IvCsnucj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IvCsnucj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715360384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=f7sEcl6o9eRoGhOwSAHXKaKKxu23m+YNGmYQyYZJgpk=;
	b=IvCsnucjqAjUgKz4MPAoLQasbLiz3zftf7a5C/zolYGJQi3IvX0HTzaS0ms4pqwOl3PEXn
	vhb1+/EGEMQEpd224QQiaF1Iu599oVDeeHAmxG43v80CiJlbWhwHUjWWomgISenNRJrB4e
	f8eO7PntCNUUom31vt2Wpeb9B1p7iFA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-v8_oFU5iMUe0LLsdPdxbGQ-1; Fri, 10 May 2024 12:59:42 -0400
X-MC-Unique: v8_oFU5iMUe0LLsdPdxbGQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a59cfaba975so76563766b.2
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 09:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715360381; x=1715965181;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f7sEcl6o9eRoGhOwSAHXKaKKxu23m+YNGmYQyYZJgpk=;
        b=OHgG6RjtoiQBLZFurROE2cPh7b/mDDpjXalSw2tOhCtmpnR4ZN2Tt9RM4CZ9c22KSH
         ZbdVt0NUgymN4KZ4CSjRzff89BVVQAhzOOTd9dmjnL5OUDBjo4ZHwPE6wPNn6uGwtXK0
         6d69YpUNYUeGnunKZELgf2ytsw5mew9cIZPOrXNzsjVyrOVgaWUf77rVEuikuZfJXboR
         re/RuVCXeKGnn6bzTMw9e0Z2y86o3KlGx9QrvH7GJTIARynOZAMcFcwpZb7rX3kLcMQm
         dN9eXl/uYn65UTnMqE7wnzw4Jyr4um1eDIf2yVaDuR+M5akqbvXd+L4DvcwnifWKWdgg
         Msew==
X-Forwarded-Encrypted: i=1; AJvYcCWT/Qq2oZVIGT8FXLzwtTs4Ppv+IAQ1eDMuzZH0SilBZ0y6Tk/TBvycf2w39JVKPTQmp5/+XP1rwcMAKa19jfCsuw8LLB5u/1attHer
X-Gm-Message-State: AOJu0YwJ5htRb9jo7VXPNve7Tdp7ep0LqySNf9ulXR0GK4r/J+EkhFu8
	sNAu77Uc53mPmMvQiq4Q0RaS+XP897HMBeAYcdTYs67sjh2PeCb18YW5BnKXsQedqWPRJR8OPWe
	hFuKNDX3BCwmSYWOaute7T38JNZvNm5FHJVJT6yUkbPu25ciXZO9OkbFosp6x8Q==
X-Received: by 2002:a50:c012:0:b0:56d:f3f3:f61f with SMTP id 4fb4d7f45d1cf-5734d597da8mr3087126a12.9.1715360381382;
        Fri, 10 May 2024 09:59:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1NRP6cZSOa1XYwX9+D1CVHmUjYsL2urgesJf7rD62GMtL4OAvAaffXB16L2Ce76IP/7uSvw==
X-Received: by 2002:a50:c012:0:b0:56d:f3f3:f61f with SMTP id 4fb4d7f45d1cf-5734d597da8mr3087084a12.9.1715360380864;
        Fri, 10 May 2024 09:59:40 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5735a2490casm559601a12.32.2024.05.10.09.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 May 2024 09:59:39 -0700 (PDT)
Message-ID: <a47e7b49-96d2-4e7b-ae39-a3bfe6b0ed83@redhat.com>
Date: Fri, 10 May 2024 18:59:37 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 22/23] KVM: SEV: Fix return code interpretation for
 RMP nested page faults
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 papaluri@amd.com
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
 <20240510015822.503071-2-michael.roth@amd.com> <Zj4oFffc7OQivyV-@google.com>
 <566b57c0-27cd-4591-bded-9a397a1d44d5@redhat.com>
 <20240510163719.pnwdwarsbgmcop3h@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240510163719.pnwdwarsbgmcop3h@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/10/24 18:37, Michael Roth wrote:
>> So, we're... a bit tight for 6.10 to include SNP and that is an
>> understatement.  My plan is to merge it for 6.11, but do so
>> immediately after the merge window ends.  In other words, it
>> is a delay in terms of release but not in terms of time.  I
>> don't want QEMU and kvm-unit-tests work to be delayed any
>> further, in particular.
>
> That's unfortunate, I'd thought from the PUCK call that we still had
> some time to stabilize things before merge window. But whatever you
> think is best.

Well, the merge window starts next sunday, doesn't it?  If there's an 
-rc8 I agree there's some leeway, but that is not too likely.

>> Once we sort out the loose ends of patches 21-23, you could send
>> it as a pull request.
> Ok, as a pull request against kvm/next, or kvm/queue?

Against kvm/next.

Paolo

