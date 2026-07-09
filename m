Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24191397AEF
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 17:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783616860; cv=none; b=rA8SiYKd69V4khEKTK7U/VRLVvTJ+z13/YLmht5FySbJppDKPKOX7Z/vUhxVocWFMt+P3yFyxwOwu+zFG4TWTPiG2p+QbuR6MOgqUgnu6kM5aRjnLxGAa985vv4TiXXoqE4nBvQfUGftavrqXI0XUA07RBehwZx0otLJc4zvs60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783616860; c=relaxed/simple;
	bh=K9AAKYK0xxz1GMGRtHAdVMohj3KPRaD87RUmpAlYNiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kofdlaGN4wh2H+ZhcPFA/fYtlm9Ra0Kv/lrhzbUeL+4x0RuCY0It/H4Ni/GsbYnW97f1XdK8QT1ci92czjg38KQ1jKGBbDOr8SyuLQb98bUz/zJCd4gWRlF1FvYfvoTl3PI3yuMpHSoJSMzJExR6WwygN7PwO+op4v7rA3+ZuAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aLB9Gdg+; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aLB9Gdg+"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-476a130c138so179039f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 10:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783616857; x=1784221657; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/tA5XaLN8sLPIWMHf3eGKCgy4towy6ImhdoRTl/KulE=;
        b=aLB9Gdg+8iFlCKq8le4uVYfBrT6BOsveel5n9AQAvC4z7b9gaQV9KlzsgB0el2MfX+
         TmanWdPklYIgvVFlSYKTocNrHjhcu73cKopngU3Ra+6jqMCnb3CjgzOTiXXBHmsiBZpi
         1YvSzt7Gq9XizK0QAHGViyng7MArWWariMQxXjiVjRg/dh1A3p8x5b6yzV5BaAjg38pZ
         jyhhe4LfO0HAJL0PZd61tREPUerE+EMlpgPhX9UpfKN1m6uLTg2Zg7uy/cx9ipaL4/EX
         Lp7kVSPoPDN5gTph1LLirPQy8w+slHY10E56aj1n8UEM24OpDB4c79WdHUL3k6U+kfqb
         7VUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783616857; x=1784221657;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/tA5XaLN8sLPIWMHf3eGKCgy4towy6ImhdoRTl/KulE=;
        b=G5PH4EExjJ2Svm93bKNGrVnv9vlAQrVOnhGAoVkeKeJM3BMnm3vfCOOvXzN4/vAvh+
         JqexM/Vxp8H8MYLirNjh4DaXrJ8p2T0mkfxJ3yvp/F4REPEaSc0gqxYmiUVEC1ukaU1d
         uitH/0QB9T+1t5pgJkwH7WnqJCU79ggWk+QXFxrbKzV01hEeCyGr/BnXfLbZfAoYGdTV
         iqdIJBT6BnE7rVKt7HcANPwtl3Mo+vUo9Bz4BveMHqSsEk/n5/wwa9GoUugsDtUvGq+r
         igVuiau3ha2Dg8koTN9+RsJ9dI4tIrlOcrl95DspVGdgI8tfzskZsMN39/QEAXyRFR0+
         HFOw==
X-Forwarded-Encrypted: i=1; AHgh+Rp153v4A9xRYjUsjnyYV6fmH7klAcboxw4AWqg/p2FYG7n18bLtWMq1ReFCekO94QrNLq/lRII9S+f5Gpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLau8PzvigSzNGmcZXEMv8fqd+X8an+gIH/e+UCZ+gxI4sDM0h
	5h/WTrjmwbIJt2augS1fPLoCnDKpwONttJshokXsw6BEo9fEI9AK5UxpNqGdZQ==
X-Gm-Gg: AfdE7cnVUxRAStHOnnBZ8yV9Utod46Owwec3Rw7nphz2VHbV89xWxdDfV665OqP16Tq
	D/66qBdHyKPV8hUfVtEJlX6mZKw4eXhDX6CCHvLvi6b4jAUAPbxTSOlHDy8dlKmKXfBF6fGi9Om
	qq2QvoEkeJB3fdRKNLxKa/SaXTM0fXhrgLm6mmXLDNbHWhmALOywdEKZmVkas/qvXNATfA8YSeD
	hJQ1nGOZExbK8Fx+hrmxryHRuh6Yuz7TREI2d/o1J3r1BeOigEKmL+ctcGKbEuLZcPcisBpU3iJ
	2f9yZWiBHyE+lc3skL0Y2XnZKtT6joFVxF+NMTLq6ms4Jl1irhk1iPTrpFWuB4/JtkEYETiKyuH
	b6JSJxo5DZGHykOmYu3iDfSTmzdIuGcU735Tc8Ij1/h31yeBeEQFpJ1RUv6EBPEDw56amglvqgu
	Iioice4bqdJKfoa2GK1lLoCmdL9UGUiQtooTcfeg==
X-Received: by 2002:a05:6000:1861:b0:47d:edb2:a4ab with SMTP id ffacd0b85a97d-47df07670c6mr8671036f8f.43.1783616857265;
        Thu, 09 Jul 2026 10:07:37 -0700 (PDT)
Received: from [192.168.2.14] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d780csm53244262f8f.11.2026.07.09.10.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 10:07:36 -0700 (PDT)
Message-ID: <4e3f9d98-b64c-4628-892a-8a71ef9c8ae4@gmail.com>
Date: Thu, 9 Jul 2026 19:07:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: AF_ALG deprecation fallout
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Anton Mitterer <calestyo@scientia.org>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
References: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
 <20260708011112.GA3890@sol>
 <04fbbc8611699e469f44edbccdf3cf1ac65075d3.camel@scientia.org>
 <20260708030153.GA14700@sol> <aac82bdd-6a28-4e65-97f4-3d5942d2a6af@gmail.com>
 <20260709153525.GA6853@quark>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260709153525.GA6853@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/26 5:35 PM, Eric Biggers wrote:
> On Thu, Jul 09, 2026 at 12:47:06PM +0200, Milan Broz wrote:
>> On 7/8/26 5:01 AM, Eric Biggers wrote:
>>> On Wed, Jul 08, 2026 at 04:14:04AM +0200, Christoph Anton Mitterer wrote:
>>>> [X]Chacha, IIRC, would anyway be used without XTS...
>>>
>>> It's possible that some of the "aead" ciphers will need to continue to
>>> be supported in AF_ALG too (in addition to privileged use of "ccm(aes)",
>>> which already is on the list since bluez uses it).
>>>
>>> But we need a specific list.
>>
>> Cryptsetup can use AF_ALG to check if AEAD is supported, but it tries to use
>> it later anyway, just error messages are more cryptic (hidden in DM kernel log).
>>
>> So we should not depend on AEAD AF_ALG support.
> 
> What about the keyslot encryption?

AEAD cannot be used for LUKS keyslot encryption. Decrypted key is validated
against external digest.

If you use AEAD for data, keyslot encryption will fallback to aes-xts (or
whatever length-preserving mode user selects at CLI).

...
> 
>>>> Well, I personally don't use any others, but of course other might.
>>>> What about all these legacy modes that were used for years in examples,
>>>> like cast5-cbc-essiv, aes-cbc-essiv, etc.?
>>>
>>> First, the essiv component is not relevant, as far as I can tell.
>>> algif_skcipher actually does have essiv support, but it's a relatively
>>> recent addition and cryptsetup doesn't use it.
>>>
>>> So the potential AF_ALG uses there would be "cbc(cast5)" and "cbc(aes)".
>>>
>>>> Does your list have any effects on things like chained algos (which I
>>>> think cryptsetup allows to use for tcrypt).
>>>
>>> AF_ALG has never supported cipher cascades itself.
>>
>> TCRYPT (Truecrypt/Veractypt compatible) supports it, but it handles chain in own code,
>> calling always only one cipher to decryot.
>> For activation it stacks several dm-crypt devices, so no chain in crypto API is needed.
>>
>> My intention was to support all, even historic, combinations, because people
>> have old containers. (Note, we only support existing container, we cannot create it.)
>>
>> Current Veracrypt supports these individual ciphers (and some chains of them),
>> that is what we can use through AF_ALG:
>>
>> - AES, Serpent, Twofish, Camellia, Kuznyechik (not in mainline only as external
>> package, in Debian as gost-crypto-dkms package), all in XTS mode.
>>
>> Historic containers (TrueCrypt) can use:
>> - AES, Serpent, Twofish in LRW mode
>> - AES, Serpent, Twofish, Cast5, in CBC mode
> 
> So all of those need to be allowed in AF_ALG (minus Kuznyechik which
> doesn't exist in mainline)?  Can we at least make them privileged only?

Well, the whole point was that it does not need root and it was documented as such from the
beginning. So, no. But I am not saying it must to support everything, Veracrypt
removed old modes - but that makes cryptsetup even more useful for legacy containers.

And this is one place where dmcrypt fallback is not supported - but we possibly could add it.
(It is just different API - tcrypt support was written years before, actually I think
it predates most of AF_ALG users including libckapi...)

Milan

