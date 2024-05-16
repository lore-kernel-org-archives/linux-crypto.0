Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397C81474B4
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715866940; cv=none; b=SqJ5uMbfUwgbq8I4ABJxz+kD7JhoUtHhAZSsm8r8hkytlTy9YffSSGfFvm9H6CWo/GUZqrCOUYbSHHoMmr/r4+DjN5V//7cYRI8hPlq1hI38wphhFLjPIVyVNf3ge3anO0aEjado62bkiKXtGOsGoHBbcutn/pzMZNBVJE+FWHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715866940; c=relaxed/simple;
	bh=151v6rdvho1G17EjfT9Y0O8i7FboV1qw+Oer60H+nIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l8ERzkPAgYS4YNm7JzZdwycf7WWcpDYGTeYbuIPltV77DAe1qp5GlCS3fBMSaQLqUKKzkWcshMkcVJK7p2zzfzjXHL+LsY372HNC0nrjsv94xlbZot1wHpKtMytvqEBaeKEHSGV2+5GjgxZ7O0t9WXXCGUXkhvoR0i2UdTkJJQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=l24/JPA3; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="l24/JPA3"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2e428242a38so10227801fa.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 06:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1715866936; x=1716471736; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iiFTd9vLC+WBmXaWz0Ro0gtEC5QRTIQUDbpfIDLM78A=;
        b=l24/JPA36AGbCxTwroMK+zy079h2G60NtDl6QwrmwU/TrOapfKcvECCuEWDmRAjsyX
         0VLngo78cN+iC3+atwtWfJJzg0TihKgLBEdbk+IcJnDpCT24G5gcmRgZl+4HiGGGAvzV
         dZlbk5nEK6nyEM55gn8YvpwFN/UQMC1AqSNrMD8u4VuS4JX26OUXbhhd74YjQw1gsJ4T
         97f6GJpT4GWX7522ggexMfhILpXXCRec0AxhLJ1sQL607Fh0Z/teEU2CmLUfI6wGnd0j
         Qe4YAPsw19qQZiLtXnYbFZC1pXjBM2ko4htKdz5pITYNCsFfr4ry35Z3ZqIkCKmqw0/T
         KAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715866936; x=1716471736;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iiFTd9vLC+WBmXaWz0Ro0gtEC5QRTIQUDbpfIDLM78A=;
        b=RxkyGr5rD5cgM7XMQasAdcwDZ/N4mJfTnGRfzMYu+HlN1KYOOKqrOYcWuz2X6zeJLd
         oO4LpNPFOdUiot4zzdSRFynAAmPvywP3sT8UgZwgUsvnscLuapEc/mnoFDv0dHbzyQAQ
         rPRbrEAPqd6cf7Fn0YFk5UG1S8/tgFfdCsN8NI4U30XDihkH4qMLOSpNEimHNBDzQQ0c
         jeZwS2356sHIMM/q7nHPLI7RVo5z2iG5qa95R1uVOfAZ4ztCrbEBYwXH1WcQW0TpJNL2
         aMHnmNWdU1sdZ1VU3Er/xd3gCGHTIAmE4AQJbUQZ+PTGfl6Fh9ipoI81Aq7lkZWh208x
         /4gA==
X-Forwarded-Encrypted: i=1; AJvYcCUE3ACXklA1Hg/zj2kiq8ygAVCKDkCG1gGnBGgQfjkdHHpSzKTU9woa6Vj/IFlEZokGP5mDL7WWkdnCe8n4P3GBIT7RfDu4mfUf+P37
X-Gm-Message-State: AOJu0YyxJZAGuMS0AXyx0B/plLgljocIu+PaHCkOWkRS7LDhZCjnuL1L
	BcfSi4zTpW1gL+1MQrOLvmMmD2zhpzQfBhK/u2TeyR/7+xyChgE7BumgF31QMI615D0cfTopalR
	G
X-Google-Smtp-Source: AGHT+IHMVWL5FCeucAox6jSM5BC3F6ELEMd53V+fH6IyH7uugBQxemkHfOIOLVukBEROZInnopv+QA==
X-Received: by 2002:a05:6512:234f:b0:51f:2f5a:54ae with SMTP id 2adb3069b0e04-5220fc7c5e0mr22121911e87.7.1715866936263;
        Thu, 16 May 2024 06:42:16 -0700 (PDT)
Received: from [10.0.1.129] (c-922370d5.012-252-67626723.bbcust.telenor.se. [213.112.35.146])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52399de9832sm658502e87.7.2024.05.16.06.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 06:42:16 -0700 (PDT)
Message-ID: <bea0a088-f9f0-4fc8-8235-ebc0ee42ad16@cryptogams.org>
Date: Thu, 16 May 2024 15:42:15 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] crypto: X25519 low-level primitives for ppc64le.
To: Michael Ellerman <mpe@ellerman.id.au>, Danny Tsen <dtsen@linux.ibm.com>,
 linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
 <20240514173835.4814-2-dtsen@linux.ibm.com> <87a5kqwe59.fsf@mail.lhotse>
 <89e7b4b0-9804-41be-b9b1-aeba57cd3cc6@cryptogams.org>
 <875xvevu3h.fsf@mail.lhotse>
Content-Language: en-US
From: Andy Polyakov <appro@cryptogams.org>
In-Reply-To: <875xvevu3h.fsf@mail.lhotse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

>>>> +.abiversion	2
>>>
>>> I'd prefer that was left to the compiler flags.
>>
>> Problem is that it's the compiler that is responsible for providing this
>> directive in the intermediate .s prior invoking the assembler. And there
>> is no assembler flag to pass through -Wa.
> 
> Hmm, right. But none of our existing .S files include .abiversion
> directives.
> 
> We build .S files with gcc, passing -mabi=elfv2, but it seems to have no
> effect.
> 
> So all the intermediate .o's generated from .S files are not ELFv2:
> 
>    $ find .build/ -name '*.o' | xargs file | grep Unspecified
>    .build/arch/powerpc/kernel/vdso/note-64.o:                        ELF 64-bit LSB relocatable, 64-bit PowerPC or cisco 7500, Unspecified or Power ELF V1 ABI, version 1 (SYSV), not stripped

I would guess that contemporary linker is more forgiving than it was 
back then when the .abiversion directive was added. If it works now, 
then it of course can be omitted. I suppose my original remark should be 
viewed rather as "you can't replace it with a command line option" than 
"you can't make it work without it." :-)

> But the actual code follows ELFv2, because we wrote it that way, and I
> guess the linker doesn't look at the actual ABI version of the .o ?
> 
> So it currently works. But it's kind of gross that those .o files are
> not ELFv2 for an ELFv2 build.

Well, as far as passing base types and pointers to/from assembly goes, 
there are no differences between the versions. Then it's a question of 
meaning assigned to r2 and r13, but as long as you don't touch them, you 
can freely reuse the code with either ABI. With this in mind the 
.abiversion directive is effectively reduced to just a marker in the .o 
file. In other words the instruction sequences by themselves are 
customarily ABI-neutral, at least in "general calculation" modules such 
as the suggested one, so that if it works 100% without the .abiversion 
directive, then it can be safely omitted.

Cheers.

