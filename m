Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1314B0CBF
	for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275228; cv=none; b=NObCvKIn8C9oBIYWG9z8bOs/I3BtNjmeybIavmlG0MdFPBhFo8u9EJW9HI612aX9NC2nmKOP08ZH1/XXPfiR0h2TTJdY9i1zshi7X1V9GdQtjkhShbVC2HB3HUq6XQkpoPcjNmSDS8MWPUinF2YcaRpegNnCUlOpAn6ib97EntU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275228; c=relaxed/simple;
	bh=Nk+ZmHul13vItNzxp9WNGq55sqZd0D/SppcIDO2waas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hjhhFEAIaTPUY9al0ywucJVNNpgtkC/0hXiSxr2wJG7hH9Mdk9gdznCQh+sxw69XCHlAjScvC0TkKUBX1gSNC6t66K5kuwVP3nxxNvtMsqi8aT6VKRvOZSzgQjUnT1/a7Jfu1b2qABg5CfF7bJo0ZOPATBq36FqVRyEnKofEhC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SD+yeEOJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ku5/hg8J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SD+yeEOJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ku5/hg8J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790275222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ax1mvo5VRJQL+OKwaeWHNjbCauQE7swJ+BSz8cvxms8=;
	b=SD+yeEOJQayHZZU6166zOKzllspTS6Jdjqxxk+4GHavQ9agoEvcEeobZjhd1bnzYoiXggJ
	JUH1zWBdt16aTtHYwv/xnNqnlfcRnFMtw8XKCtU3iiOftfs98McWD2Pq5NVNYTLmzf/keW
	VI0Q5dIjrSyheMfliO3SCQ9JPlYFYfE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-Mo5nMAYbOfKhMUQeWhL-vA-1; Thu, 24 Sep 2026 14:40:21 -0400
X-MC-Unique: Mo5nMAYbOfKhMUQeWhL-vA-1
X-Mimecast-MFC-AGG-ID: Mo5nMAYbOfKhMUQeWhL-vA_1790275220
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49ccfad90f1so1289605e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 11:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790275219; x=1790880019; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ax1mvo5VRJQL+OKwaeWHNjbCauQE7swJ+BSz8cvxms8=;
        b=Ku5/hg8JOBjbd16z+JyV1FbvI6Qc56Md8ASXoALyh0J7GP7lAL8n/NOIkRoi3qYmaM
         U30viZQCid42aUw+ju7UWY32nHNrLbjfEFC8ACwnwgG2N9XPcEPwI5Jdl09oJMQkAn74
         Yx+60i+jGCEs5R0//ChigNQx8U7UfDSc2pLD682POGLY7T/ZHb3BJpKxZOdk3w8cSHGw
         CTahRSewHbxcDT4PARRdpAfgwUltLjbrEzICVO9i7/RlgJbvdAy6SpcmC+b22ZMlKTna
         DRlLoKujg8jntwlBGCA17pdr9Yd/8e3nP31Ep/e/Ha7jqMLEMDWn5fIs6JJzaA2kE/XD
         kzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790275219; x=1790880019;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ax1mvo5VRJQL+OKwaeWHNjbCauQE7swJ+BSz8cvxms8=;
        b=vkHkk3oDsD2e3d9kIB3hScRh2w4DMGm871dJMpIgW949lNLh0i03UooyF7RlEvXM0T
         JxRAUfqFhvCFdoOtUjT/g9J9MYgz1kY7CY4bElQELhD19Q+JgVfGrFI+5hWFomqYaRjU
         rUuECXzWGRQCSUuZmdE8M7nePWmy2wt2dSvGNhNquydXp1rY5ahFQyrcTtMpwWdD1HiM
         AIG/K4p3QLbZ9a+tLUcDYj2v56nhu848t0wMGEGwNLEowscsjp9TDtv6qvKCo8yBSDLr
         B8g/HjBhaWxUHzDf6lPyfgdCXqvLyWfi8Mhad5ni5v4rkcIBdoACrpU4IneW7VlV3Tyl
         lbng==
X-Forwarded-Encrypted: i=1; AKwUvBzWMFSUsqO5TY2lG4TRU6TIFwUbOqrmWfLdVQZa3OL584/oRNxg/qzn8GC/bJoNuN5uy//lLrjelB15uSM=@vger.kernel.org
X-Gm-Message-State: AFuF++lkoy5Kvuovs0Q9ECqJRA9BBE3jPLsPzWtH9WGVh/C4UL2obBOa
	hICJjIQ51R3DrW2LV0pAJePDKKNt/ufUMLejBHX5VgifgG1Kqr0LH4KAzAfuHvwvrM91RqCqz4u
	w7jV7nwV+KnzK1Z54dISQEbVMv1JimR6DEJsMYpNbTlkv8l2+Lc+LGBu6djnZozVuM05i9xHbkw
	==
X-Gm-Gg: AYBFou0EKj+k5SROsJjwWi8PT4fal6djyp0Vjm/Kky4IY0zu7fqgiLOPF29Td9G60iC
	BG8g92fnj2ejBLKeKr1DlERkKZhErbhMOcNvWzp5K/rYedJo2iLO0y4zXbrz8FoujTrgsEqHtEf
	Io0y0Fm47g7e0VPxr4vGl6lzgJqwkSwcUvD6oYN1NXIpXY6zyLvqP/lxLI4UXpb52n05jFOyRtG
	Xng5vDyuPJur2S18fW8Dz/AgOMk64JsyudIgJ3+5R1FpMabQ7WrdDT0BwUIpPPQR0bORA34zBGG
	6anrSlrY7fkmKvBiUdVolwu/nQBX89LOFZ6sekTu2WTJHsUPsDicf+uMqPLEBwhs8M20GDLK
X-Received: by 2002:a05:600c:4e86:b0:49c:ffe3:2b3f with SMTP id 5b1f17b1804b1-49fe66c8e13mr56080275e9.3.1790275219663;
        Thu, 24 Sep 2026 11:40:19 -0700 (PDT)
X-Received: by 2002:a05:600c:4e86:b0:49c:ffe3:2b3f with SMTP id 5b1f17b1804b1-49fe66c8e13mr56079965e9.3.1790275219269;
        Thu, 24 Sep 2026 11:40:19 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.113.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fef60da94sm139075e9.4.2026.09.24.11.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 11:40:17 -0700 (PDT)
Message-ID: <ea1a64b5-5c0b-4ef4-8aeb-7fe248e369ff@redhat.com>
Date: Thu, 24 Sep 2026 20:40:15 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/13] lib/crypto: sha2: Provide functions for
 zeroizing SHA2 hmac_sha* structures
To: Eric Biggers <ebiggers@kernel.org>, Nathan Chancellor <nathan@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 Borislav Petkov <bp@alien8.de>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Namjae Jeon <linkinjeon@kernel.org>
References: <20260916095022.604354-1-thuth@redhat.com>
 <20260916095022.604354-12-thuth@redhat.com> <20260924145806.GA1949494@ax162>
 <20260924174911.GA1978@sol>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260924174911.GA1978@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/09/2026 19.49, Eric Biggers wrote:
> On Thu, Sep 24, 2026 at 10:58:06AM -0400, Nathan Chancellor wrote:
>> Hi Thomas,
>>
>> On Wed, Sep 16, 2026 at 11:50:13AM +0200, Thomas Huth wrote:
>>> In certain cases crypto code functions need to zeroize their local SHA2
>>> hmac_sha*_key or hmac_sha*_ctx structures after use to avoid leaking
>>> sensitive material on the stack.
>>> Provide hmac_sha*_zeroize_key() and hmac_sha*_zeroize_ctx() helper
>>> functions that can be used with __cleanup() to automatically zeroize
>>> the structure when it goes out of scope.
>>>
>>> Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>   include/crypto/sha2.h | 73 +++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 73 insertions(+)
>>>
>>> diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
>>> index 7bb8fe169daf2..22fbc37ae8407 100644
>>> --- a/include/crypto/sha2.h
>>> +++ b/include/crypto/sha2.h
>>> @@ -7,6 +7,7 @@
>>>   #define _CRYPTO_SHA2_H
>>>   
>>>   #include <linux/types.h>
>>> +#include <linux/string.h>
>>
>> I am seeing a build failure with CONFIG_CFI=y after this patch landed in
>> -next as commit 09eb210b7deb ("lib/crypto: sha2: Provide functions for
>> zeroizing SHA2 hmac_sha* structures").
>>
>>    $ printf 'CONFIG_%s=y\n' CFI KEXEC_FILE >kernel/configs/repro.config
>>
>>    $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper defconfig repro.config arch/x86/purgatory/
>>    ld.lld: error: undefined symbol: __memset
>>    >>> referenced by string.c
>>    >>>               arch/x86/purgatory/purgatory.ro:(__UNIQUE_ID_addressable___memset_5)
>>
>>    ld.lld: error: undefined symbol: __memmove
>>    >>> referenced by string.c
>>    >>>               arch/x86/purgatory/purgatory.ro:(__UNIQUE_ID_addressable___memmove_6)
>>    make[6]: *** [arch/x86/purgatory/Makefile:80: arch/x86/purgatory/purgatory.chk] Error 1
>>    ...
>>
>> This comes from the instances of KCFI_REFERENCE in
>> arch/x86/include/asm/string_64.h. Maybe __DISABLE_EXPORTS should be set
>> for the full purgatory to avoid this? I am juggling a lot of stuff at
>> the moment so just this report instead of a full patch.
> 
> To fix linux-next, I dropped patches 10-12 of this series.  Thomas,
> please resend just those once there is a solution.
Yes, thanks, dropping those three patches is the right thing to do right 
now. I will try to reproduce the problem in the next days and come up with a 
proper solution (like setting __DISABLE_EXPORTS if that helps...).

  Thomas

