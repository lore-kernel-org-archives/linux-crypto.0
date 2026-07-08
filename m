Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C0F3BA246
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 05:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783488597; cv=none; b=sazKvJsc/j382rHcpTXTvNID3bEoPZZtY3fdXh9JnELO3/tBp4jzJyIsfKfPP2rNzE7vOwC08sl+Mqe+G7pHNPuvN48UjXCMxkkNkQaxCTPHaz5+kfjCcSi89mEj51/y+Ow0nEExzGbvyTYfCN4vgngSSdatFhxKggYwocBzIN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783488597; c=relaxed/simple;
	bh=ibDA7NQ5D/GQDVMIt1Z0G+p75ku9lTBTMN7IFAnci04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YOpz9mzGqRWU/978Ph73fSp1eVOxCUnVDEvJxxHd2nApb1uJ+dQzcYNBvyI/TAhFR+h7TeHjuLfzcPLUY7vr9Gz0rO+TXU2UDS7jQuunZGH6LBfVRWiBHGamm426AijvKextumwyqax8UhGdUX6nImgwZb5VWwsqkstSfBm0szE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QNj7AoqB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KIX3C9qI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QNj7AoqB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KIX3C9qI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783488594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tWtkaMz7VS2BCJOcQRnOKtrrPL/RJARaWXcps4LohLA=;
	b=QNj7AoqBs0ZGgHieCVpdSnesHcbn6pPErO42tCzk6yw0rEyaACv5uH8+wsqcRVdMX9q6xT
	sEAVQNNNWk4YMNgDhpeXs+NJssLICCqY0IhfQDjelUpMEtfrlPHgNDJnPzmoqEPbGhLmY7
	LHy+tSIF321dkLYiMwOl+cNZlpQZaeE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-pjfTEiOJMXWk2wlWJAl8uw-1; Wed, 08 Jul 2026 01:29:53 -0400
X-MC-Unique: pjfTEiOJMXWk2wlWJAl8uw-1
X-Mimecast-MFC-AGG-ID: pjfTEiOJMXWk2wlWJAl8uw_1783488592
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4926fa2cb17so2117065e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 22:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783488592; x=1784093392; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tWtkaMz7VS2BCJOcQRnOKtrrPL/RJARaWXcps4LohLA=;
        b=KIX3C9qILYMzQmupzK3ORk4oEumOHUBflB7PPq59E49zwCLXoHFheD/idiopeH7dT3
         uymDJmqwqlm0ewVbqkqM82KerNUQf/MqpcDq5r98yW5Zkaue4ZDZXY6jGRiUiWMv1BwX
         78BTiVm0cTK4Z/x1ZjMYNewUY0CBAK7wbNj1fa8eYWO+Ev+60t3w+p0xfUCBAyDvDBQY
         xsjD8JUaREAwrMlaSyBg5orc3zljnWAN9YtDsAMBlfL7zb0GdkM6aL611g/iaaoFy3s4
         +yn6BgKtGU0UQnyb3pYn4G1pHd6zQMu6/RZAqqRQCaQBzLynE0mO0uuEOvbtuvnuEQfy
         krfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488592; x=1784093392;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWtkaMz7VS2BCJOcQRnOKtrrPL/RJARaWXcps4LohLA=;
        b=I88yI94ornh9N4WnKZ1M8XmUBgmf5oQzjklkcfE+FcyyOpvyJEnWAWZzhV1/FyIdej
         NPQnBS0VmY4mTV7c9thm/unKpB/MTPVxxrlIapyp5pPCeFNYpy4k2imP9zWkz0uX5FcF
         WKMEcqLHh6V6horI/AStx11Fh3MIqsHTtiPhdsxo0RX+bZtQ88n6kqurJ+EmkqJMW+tf
         9lyKlpTRVtwx9/RypNe67jclrtUbeiynH+/W/9fG//zLLINviyD5BvCtckreL09VYjqk
         FBTtLFDIbWrbjQI1qpcdToMRdnXReng/9ANuRx9O4dOTBiBHO1G2JFxxqYgM/uVU6szQ
         iPwg==
X-Gm-Message-State: AOJu0Yw+hNtad5CjzmyGP3Suh9bMtS5ryL+KjEQroEp20QiXbDl5AYwG
	pClLiK2cls28LfppXJBOxwcsMu9LrRrHpwEDFh88uSfy5wXBYSBooiZKSKkLpXFBXWkf+QBxeSw
	51Xew5WQnsu+G/GaI64lLpJ4Gk1S0byqTpWWGy1aj4zEB5C0RcO03plf4t76FbeIYXzi+1/Ch+w
	==
X-Gm-Gg: AfdE7ckLn2MVcl1XlT0k1HY9zAv74D4uOpC/5EPX0cgwZ8u80CaTmjqpoTEUHy4evN4
	GC1ZT6l28QXauXSwn4xarta5i5ogf7UBLivYHPLlzJa7+Qz/qDQdfPv1quB+3ad8TMQPa3GawTd
	xboakiFz3q7ElECxaBKc+ae73OVy6fXAcvVXPg6EPcrhNWA/amzXLoFD2D3lWMpjaBqSXb1s+D9
	KhW9Q5NX/hTPXv+wR/CK8fgOMjxPDXg2H+O3D5iDTXa3qYt6ZzntkZlrrkB6yZG+XCxENKlaelm
	kNx3PfONjMTESWC6PVkknmqCS5NPkIJLV4F72XQ7Bn6uVO+xiU5lltLOqZME7BYNl/w9Dv8Egb6
	gaxTP5WVy
X-Received: by 2002:a05:600c:4fc9:b0:493:cbdc:7cd2 with SMTP id 5b1f17b1804b1-493e6368e4bmr8398715e9.3.1783488592472;
        Tue, 07 Jul 2026 22:29:52 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc9:b0:493:cbdc:7cd2 with SMTP id 5b1f17b1804b1-493e6368e4bmr8398505e9.3.1783488592113;
        Tue, 07 Jul 2026 22:29:52 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0fccf2dsm115720475e9.15.2026.07.07.22.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 22:29:51 -0700 (PDT)
Message-ID: <97c50b12-8f05-46cc-8941-e7af5a1c1ec9@redhat.com>
Date: Wed, 8 Jul 2026 07:29:50 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/33] lib/crypto: aes: Add ECB support
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-3-ebiggers@kernel.org>
 <f41f7217-c444-41da-84b9-1592dcd9b58d@redhat.com>
 <20260707192256.GB2238@quark>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 xsFNBFH7eUwBEACzyOXKU+5Pcs6wNpKzrlJwzRl3VGZt95VCdb+FgoU9g11m7FWcOafrVRwU
 yYkTm9+7zBUc0sW5AuPGR/dp3pSLX/yFWsA/UB4nJsHqgDvDU7BImSeiTrnpMOTXb7Arw2a2
 4CflIyFqjCpfDM4MuTmzTjXq4Uov1giGE9X6viNo1pxyEpd7PanlKNnf4PqEQp06X4IgUacW
 tSGj6Gcns1bCuHV8OPWLkf4hkRnu8hdL6i60Yxz4E6TqlrpxsfYwLXgEeswPHOA6Mn4Cso9O
 0lewVYfFfsmokfAVMKWzOl1Sr0KGI5T9CpmRfAiSHpthhHWnECcJFwl72NTi6kUcUzG4se81
 O6n9d/kTj7pzTmBdfwuOZ0YUSqcqs0W+l1NcASSYZQaDoD3/SLk+nqVeCBB4OnYOGhgmIHNW
 0CwMRO/GK+20alxzk//V9GmIM2ACElbfF8+Uug3pqiHkVnKqM7W9/S1NH2qmxB6zMiJUHlTH
 gnVeZX0dgH27mzstcF786uPcdEqS0KJuxh2kk5IvUSL3Qn3ZgmgdxBMyCPciD/1cb7/Ahazr
 3ThHQXSHXkH/aDXdfLsKVuwDzHLVSkdSnZdt5HHh75/NFHxwaTlydgfHmFFwodK8y/TjyiGZ
 zg2Kje38xnz8zKn9iesFBCcONXS7txENTzX0z80WKBhK+XSFJwARAQABzR5UaG9tYXMgSHV0
 aCA8dGh1dGhAcmVkaGF0LmNvbT7CwXgEEwECACIFAlVgX6oCGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAAoJEC7Z13T+cC21EbIP/ii9cvT2HHGbFRl8HqGT6+7Wkb+XLMqJBMAIGiQK
 QIP3xk1HPTsLfVG0ao4hy/oYkGNOP8+ubLnZen6Yq3zAFiMhQ44lvgigDYJo3Ve59gfe99KX
 EbtB+X95ODARkq0McR6OAsPNJ7gpEUzfkQUUJTXRDQXfG/FX303Gvk+YU0spm2tsIKPl6AmV
 1CegDljzjycyfJbk418MQmMu2T82kjrkEofUO2a24ed3VGC0/Uz//XCR2ZTo+vBoBUQl41BD
 eFFtoCSrzo3yPFS+w5fkH9NT8ChdpSlbNS32NhYQhJtr9zjWyFRf0Zk+T/1P7ECn6gTEkp5k
 ofFIA4MFBc/fXbaDRtBmPB0N9pqTFApIUI4vuFPPO0JDrII9dLwZ6lO9EKiwuVlvr1wwzsgq
 zJTPBU3qHaUO4d/8G+gD7AL/6T4zi8Jo/GmjBsnYaTzbm94lf0CjXjsOX3seMhaE6WAZOQQG
 tZHAO1kAPWpaxne+wtgMKthyPLNwelLf+xzGvrIKvLX6QuLoWMnWldu22z2ICVnLQChlR9d6
 WW8QFEpo/FK7omuS8KvvopFcOOdlbFMM8Y/8vBgVMSsK6fsYUhruny/PahprPbYGiNIhKqz7
 UvgyZVl4pBFjTaz/SbimTk210vIlkDyy1WuS8Zsn0htv4+jQPgo9rqFE4mipJjy/iboDzsFN
 BFH7eUwBEAC2nzfUeeI8dv0C4qrfCPze6NkryUflEut9WwHhfXCLjtvCjnoGqFelH/PE9NF4
 4VPSCdvD1SSmFVzu6T9qWdcwMSaC+e7G/z0/AhBfqTeosAF5XvKQlAb9ZPkdDr7YN0a1XDfa
 +NgA+JZB4ROyBZFFAwNHT+HCnyzy0v9Sh3BgJJwfpXHH2l3LfncvV8rgFv0bvdr70U+On2XH
 5bApOyW1WpIG5KPJlDdzcQTyptOJ1dnEHfwnABEfzI3dNf63rlxsGouX/NFRRRNqkdClQR3K
 gCwciaXfZ7ir7fF0u1N2UuLsWA8Ei1JrNypk+MRxhbvdQC4tyZCZ8mVDk+QOK6pyK2f4rMf/
 WmqxNTtAVmNuZIwnJdjRMMSs4W4w6N/bRvpqtykSqx7VXcgqtv6eqoDZrNuhGbekQA0sAnCJ
 VPArerAZGArm63o39me/bRUQeQVSxEBmg66yshF9HkcUPGVeC4B0TPwz+HFcVhheo6hoJjLq
 knFOPLRj+0h+ZL+D0GenyqD3CyuyeTT5dGcNU9qT74bdSr20k/CklvI7S9yoQje8BeQAHtdV
 cvO8XCLrpGuw9SgOS7OP5oI26a0548M4KldAY+kqX6XVphEw3/6U1KTf7WxW5zYLTtadjISB
 X9xsRWSU+Yqs3C7oN5TIPSoj9tXMoxZkCIHWvnqGwZ7JhwARAQABwsFfBBgBAgAJBQJR+3lM
 AhsMAAoJEC7Z13T+cC21hPAQAIsBL9MdGpdEpvXs9CYrBkd6tS9mbaSWj6XBDfA1AEdQkBOn
 ZH1Qt7HJesk+qNSnLv6+jP4VwqK5AFMrKJ6IjE7jqgzGxtcZnvSjeDGPF1h2CKZQPpTw890k
 fy18AvgFHkVk2Oylyexw3aOBsXg6ukN44vIFqPoc+YSU0+0QIdYJp/XFsgWxnFIMYwDpxSHS
 5fdDxUjsk3UBHZx+IhFjs2siVZi5wnHIqM7eK9abr2cK2weInTBwXwqVWjsXZ4tq5+jQrwDK
 cvxIcwXdUTLGxc4/Z/VRH1PZSvfQxdxMGmNTGaXVNfdFZjm4fz0mz+OUi6AHC4CZpwnsliGV
 ODqwX8Y1zic9viSTbKS01ZNp175POyWViUk9qisPZB7ypfSIVSEULrL347qY/hm9ahhqmn17
 Ng255syASv3ehvX7iwWDfzXbA0/TVaqwa1YIkec+/8miicV0zMP9siRcYQkyTqSzaTFBBmqD
 oiT+z+/E59qj/EKfyce3sbC9XLjXv3mHMrq1tKX4G7IJGnS989E/fg6crv6NHae9Ckm7+lSs
 IQu4bBP2GxiRQ+NV3iV/KU3ebMRzqIC//DCOxzQNFNJAKldPe/bKZMCxEqtVoRkuJtNdp/5a
 yXFZ6TfE1hGKrDBYAm4vrnZ4CXFSBDllL59cFFOJCkn4Xboj/aVxxJxF30bn
In-Reply-To: <20260707192256.GB2238@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/07/2026 21.22, Eric Biggers wrote:
> On Tue, Jul 07, 2026 at 03:59:24PM +0200, Thomas Huth wrote:
>>> +Unauthenticated encryption
>>> +==========================
>>> +
>>> +Support for unauthenticated encryption and decryption, including bare stream
>>> +ciphers and other length-preserving algorithms such as block ciphers in XTS
>>> +mode.
>>
>> This sentence no verb?
> 
> It's a noun phrase that introduces what the section contains, before
> transitioning into full sentences.
> 
> I used this in all existing Documentation/crypto/libcrypto-*.rst.  It's
> also fairly common in the help text for kconfig symbols (across the
> kernel, not just the kconfig help text I've written).

Fair point for the help texts (which should be concise), but (as a 
non-native speaker) I did not expect it in doc file. Anyway, if it's already 
like this in other files, then it's certainly fine here, too.

>>> +void aes_ecb_encrypt(u8 *dst, const u8 *src, size_t len, aes_encrypt_arg key);
>>
>> Other similar functions like aes_encrypt() use the key as first argument ...
>> so maybe do the same here, too, for consistency?
> 
> For single-block AES, there's indeed already aes_encrypt(key, dst, src)
> and aes_decrypt(key, dst, src).  But for actual AEAD encryption there's
> already:
> 
>      chacha20poly1305_encrypt(dst, src, src_len, ad, ad_len, nonce, key)
>      chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len, nonce, key)
>      xchacha20poly1305_encrypt(dst, src, src_len, ad, ad_len, nonce, key)
>      xchacha20poly1305_decrypt(dst, src, src_len, ad, ad_len, nonce, key)
>      chacha20poly1305_encrypt_sg_inplace(src, src_len, ad, ad_len, nonce, key)
>      chacha20poly1305_decrypt_sg_inplace(src, src_len, ad, ad_len, nonce, key)
> 
> Those follow the convention described by Jason here:
> https://lore.kernel.org/linux-crypto/aPT3dImhaI6Dpqs7@zx2c4.com/

Ok, makes sense now, thanks for the explanation! Feel free to add my:

Reviewed-by: Thomas Huth <thuth@redhat.com>

to this patch if you like.

> Note that if we decide we like this order, we could reorder the
> arguments of aes_encrypt() and aes_decrypt() to match.
Yes, maybe a good idea for more consistency in the code...

  Thomas

