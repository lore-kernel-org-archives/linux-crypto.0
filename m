Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDBE85C4E
	for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 13:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779991; cv=none; b=Yh92kYXAyAWfV1UyihCfIkw8R2UjJZli79h2RH1/TikabdbvRs9xsgyDcVJcVdtxqbDCyPaw1mBymhqaIwEzcJnGu3rRec0ljuge036qMWaxV2361CoRZt3YBY8JvfbOdSG1sGi+42pITk8akkBegc1epdyY2y9GK8tDv0sUeUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779991; c=relaxed/simple;
	bh=9S7DSw9sHbiB+sYt8oWVLOv/m7dBhEgy7oKSHCb0BPo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=t1nsYdQlYz7onUZUF6CiUSftfkitC0/H//n8LfmYN+ZpX7hzexEsKA11wCwQAxTMj1MUpc9VoMmKB5Ij0/Aj31OaFtGjUrwu8iJs+uBXf9IXEpkTx/V0HuwSkHVs7n3BeNleulI/VvoScH46ZJaEUvLLPl+4GFqAPV0cbMyhOkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org; spf=pass smtp.mailfrom=cryptogams.org; dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b=fwmCmxIO; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryptogams.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="fwmCmxIO"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-51ff65b1e14so7599029e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2024 06:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail; t=1715779988; x=1716384788; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IZnKfmHcaXKfk4mANRDz90u7oAjx4Am3VbR95ZF3WgM=;
        b=fwmCmxIOXMpSoN224HbUI9m5AikYcgUMSH0yBtwoVUsbdQTWt8lV9PIOXBP1oA6SWC
         ZVjNfCvgdrfVnk4L040Ht/o3THevHP4OkuEQ75zWDdj5c1BKsVdX0u7RdDuMUnDvqKVH
         6zadIi/8YEaVghG74JGhQpMLBBo1TpmL8RPtFNwJr1SH5K+e0SRNAE/rG3dEyjgJU9rd
         XWdT9fheoyLdAh5zjBR5BjfKGHO5CcXvOsjpCaokxBEluMVdyfVCZrWURcPFYy6J08Ug
         bYU0/6ntjl7QCZhq7q9Bwt4V1k9eHH4whGXOmkUTmCDOVqyBKYwuxHuFdLYGbC40yvDR
         GIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715779988; x=1716384788;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IZnKfmHcaXKfk4mANRDz90u7oAjx4Am3VbR95ZF3WgM=;
        b=s2iNOlFlbvRGFbLcdBLHucRRHqtrywMoMEdDTZk8Mpgw3ARX5Ogi4mZQ1ZBT9dOgvl
         ZH4icgctWHar1ZUSFBPnbsZUSyieQ//4ebFrqD1a+fzNo9CTWLsMGtsbRYT8McynFdA1
         6+SCExAmb4kDfZ+37V2O4lhxoDtf2oXz/GGpHWEGc0A9asqrhbH1/0UC49Ns/Ovttgwd
         gxrrWHY/j7jo5xFZpJldvxE0XvlQA+SryBowAmNxXoyt0YNCaruQZwj9wcK28EO5+FPP
         Lf2MIhCbP+/T2Lgn+V+VWxAXZAmprmkfrbrIqc9fA1ihXx0cC92bpBaFjKs2/hp7UuhD
         6m8w==
X-Forwarded-Encrypted: i=1; AJvYcCWtKxIMkzbh7GYqLy/UEJXiMVaCNkzuxkO49Jw8a5OGiL9qeZ0hOeikNLbAypQOh/73HKpypnJz3NHcT3sRVHzb//QhAN/GfJt3eX4S
X-Gm-Message-State: AOJu0YyWmOHp9KyV+pfEmbEgczvai5elsSZ1RFAcjYt4uoI+PB+VRmb9
	aX/2jmN/z8c6b8ROSEn6Nos671PaThvTznDGy+wuTT9Y56DTcyiL87aQbj5mD9hP63XCahWGB51
	f
X-Google-Smtp-Source: AGHT+IHARK6h98zaZeHwpQW3CC/oAdRtrkGoOz4whPQzV2TK8WECwB1HF5F/+Wjw4JdTyvdc6/Eqyw==
X-Received: by 2002:a05:6512:3e10:b0:51a:f16d:52a8 with SMTP id 2adb3069b0e04-52210070178mr14110770e87.50.1715779987823;
        Wed, 15 May 2024 06:33:07 -0700 (PDT)
Received: from [10.0.1.129] (c-922370d5.012-252-67626723.bbcust.telenor.se. [213.112.35.146])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-521f38d86b3sm2613126e87.210.2024.05.15.06.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 06:33:07 -0700 (PDT)
Message-ID: <7eb6bf4b-5510-48fe-aa6c-ac5207d5a2c1@cryptogams.org>
Date: Wed, 15 May 2024 15:33:06 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] crypto: X25519 core functions for ppc64le
From: Andy Polyakov <appro@cryptogams.org>
To: Danny Tsen <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
References: <20240514173835.4814-1-dtsen@linux.ibm.com>
 <20240514173835.4814-3-dtsen@linux.ibm.com>
 <847f2e4f-ace1-415d-b129-ed2751429eec@cryptogams.org>
Content-Language: en-US
In-Reply-To: <847f2e4f-ace1-415d-b129-ed2751429eec@cryptogams.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

>> +static void cswap(fe51 p, fe51 q, unsigned int bit)
>> +{
>> +    u64 t, i;
>> +    u64 c = 0 - (u64) bit;
>> +
>> +    for (i = 0; i < 5; ++i) {
>> +        t = c & (p[i] ^ q[i]);
>> +        p[i] ^= t;
>> +        q[i] ^= t;
>> +    }
>> +}
> 
> The "c" in cswap stands for "constant-time," and the problem is that 
> contemporary compilers have exhibited the ability to produce 
> non-constant-time machine code as result of compilation of the above 
> kind of technique. The outcome is platform-specific and ironically some 
> of PPC code generators were observed to generate "most" 
> non-constant-time code. "Most" in sense that execution time variations 
> would be most easy to catch.

Just to substantiate the point, consider 
https://godbolt.org/z/faYnEcPT7, and note the conditional branch in the 
middle of the loop, which flies in the face of constant-time-ness. In 
case you object 'bit &= 1' on line 7 in the C code. Indeed, if you 
comment it out, the generated code will be fine. But the point is that 
the compiler is capable of and was in fact observed to figure out that 
the caller passes either one or zero and generate the machine code in 
the assembly window. In other words 'bit &= 1' is just a reflection of 
what the caller does.

> ... the permanent solution is to do it 
> in assembly. I can put together something...

Though you should be able to do this just as well :-) So should I or 
would you?

Cheers.

