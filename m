Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA3442254B
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783432773; cv=none; b=LRBi9rE4AZskOD+BduLDzNq/KzqVbDfLXYBQk7R0S6iQYPQOQnysWLhEVf/493P+d8aBqDK34fpohDw4DtgFVzavHI9t3JBMQ0685W+0Hz4iGVKoIcswGKGAUg/IFam/TbNA6lNQayLpEWrSKFEuKcUaVH5/MfdFnSUlBVzfkwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783432773; c=relaxed/simple;
	bh=SNwNEvR3B4X+HSQ0xfwY01jo5aUtKjVKytIhYPj8+O4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F/jvADsIoMYG/Jr4a8+PSs58VCPzhTugMak+UhAviDkenBJhWFA7tnjSXp821oscB3ZeCZ9Z36sn85lzaWa6qHIxLyreG7QeujqyBSSAVRYAAtLHRBCyXi7VXI2Nbu644uLKwea/R6WUqqyW5E9zBiQkjhTh2/sYhDmx9yq82gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fr30qjZv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hl9tbIop; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fr30qjZv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hl9tbIop"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783432770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LOhI92gO2abWc6onwVewcjchzMElVC19g3LkYaM5jTo=;
	b=fr30qjZvc8Df/aavquYUPkXOgWJvrJXazXcg4/xT3GJJLz105wMuTg7dMgaD9OOW1bbakY
	+njpo06DKrfZXACLxRYbFJirbU7AmhL75Nmg1yA76lr5UZ6SGiht3yhaJO/ikJPON30vN2
	CnQSBfpiRr/E4U+L7SV90069PoZLPRE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-J9fAA5rwNEmXEx1_Nizsew-1; Tue, 07 Jul 2026 09:59:29 -0400
X-MC-Unique: J9fAA5rwNEmXEx1_Nizsew-1
X-Mimecast-MFC-AGG-ID: J9fAA5rwNEmXEx1_Nizsew_1783432768
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-493c20d0468so57411735e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 06:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783432768; x=1784037568; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LOhI92gO2abWc6onwVewcjchzMElVC19g3LkYaM5jTo=;
        b=hl9tbIopTSSjSKX6TgXhPO/WWYSEtytC4OKr0/MlbfJpeh+ZSNuYocyz0q9VwpLRWj
         q+ZzJLo2wN6fFj/GoZdjseGSqLZmq4LHPnLq7qFKeocchCUzQUMjIjBJy4ZGxMFso03B
         idNetr20nHP6+nOMuSs35lj6n6FCfcFB0JYBTiR6eWc8y5Z8lLgBfNz+t/QBKGzg5z/H
         VFG4A4bftjrAIAa6ic8uhvw8m9WaqHb4Pt8ZTBmUnWfAKtutKyIioTy6l6CquVEVWcwx
         +IgvGanLY7WSA7YEIFQkFcFxsx6kSO3CX/fYx9TY8Y75CzfVU8K8AuB07li1ys35wXbc
         55eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783432768; x=1784037568;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LOhI92gO2abWc6onwVewcjchzMElVC19g3LkYaM5jTo=;
        b=SqWqrJENwCIAidDLPc+X9fseYMgcFNY0H/4B3xYJOYndD+FWV3kZqghH9/SxUMezpR
         gYi4slH32g2HFx8STonNGL2LiJz8O5wLJ0TQ55F4Ww1RJb8O16DkDg5GTzl/i4p5mvvU
         vS/m3f52GZkS4ht9Sb+BsqurDQ01EXirXf9u7eEPa523n8qfnmfBKwW89Xuax0/qdp+2
         PjvasRQ5RUPbsxtgp4oxsyMu/pgmXqUvAwkWTPQo5XPSyhP/5EPvF1EgEWCuV7Vt20dN
         EPYnpYIFNn4FBdJA7o1CzCGjpnPqsz0EgJpiN6kdRTapSke1gxnUWyYwXAn1jpAtvqHS
         GL0Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr7OTVK3GH8sd3H6Fnc7JKppn4mHnwUVLL4EwT5Old8+VetkrMFlMNr++2kGffMzvo2BPV4BisfF1jqOnY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLbrPEoqa20UyimgTfLEijSCtmFuxQGVJ5VftglIsZKbOVdsds
	OjopBrH2FjMkROBYCSVtQgzw2iPUsYa7bEQz2N2w0wZCaHLUeIEJpYl0XRzvzWthuE09T48kLdZ
	IYn7F8F/ur7B3mkzAbb0LhjDfyVPzINlUX7xDRUcdCrRTH7nnJuP46kigI6r4ArJoIsa+dxfzxA
	==
X-Gm-Gg: AfdE7cn8RlfAlZdtq2WHqU0lnctrI7KLEd0ONACfF2rhnfuFoAYfj4daBchZrsOYaH2
	IvpjCGFItGM8XWD0DzYbKqSlBgI3u0vtAeqOQ4r3hsFNVVCQ/v4nF1JBgCxXH25fiM++/3mDO4Y
	7PoK9Qa1ly3O61TO5Mt5F93IZWDpNiQQ8qwXYxmWAQ4bLYyA+GX/rrCM7HvaLqSedHjWmvpD2Nb
	GTdzvotTLSr5OTalNp41dRvccENHMIvt10u8Mr8GcR0jhaAbiX4fF7yySTiqbwYQeE713mR2bI1
	ayjX5Y72XqeK2J8NY2Lkhpf39c9x1UJXVblw6CTnJ7qieoWpgUK30iO/oqWDF/UMigykonyiNbL
	e4XUdlQ==
X-Received: by 2002:a05:600c:474a:b0:493:c062:a533 with SMTP id 5b1f17b1804b1-493df0673f8mr64717535e9.17.1783432767990;
        Tue, 07 Jul 2026 06:59:27 -0700 (PDT)
X-Received: by 2002:a05:600c:474a:b0:493:c062:a533 with SMTP id 5b1f17b1804b1-493df0673f8mr64717195e9.17.1783432767384;
        Tue, 07 Jul 2026 06:59:27 -0700 (PDT)
Received: from [10.22.2.34] ([91.26.127.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0fccf2dsm60380145e9.15.2026.07.07.06.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 06:59:26 -0700 (PDT)
Message-ID: <f41f7217-c444-41da-84b9-1592dcd9b58d@redhat.com>
Date: Tue, 7 Jul 2026 15:59:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/33] lib/crypto: aes: Add ECB support
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-3-ebiggers@kernel.org>
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
In-Reply-To: <20260707053503.209874-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/07/2026 07.34, Eric Biggers wrote:
> Add support for AES-ECB to the crypto library.
> 
> This will be used to provide a streamlined implementation of the
> "ecb(aes)" crypto_skcipher algorithm.  fs/crypto/keysetup_v1.c will also
> use aes_ecb_encrypt() directly.
> 
> As usual, the architecture-optimized AES-ECB code will be migrated into
> the library as well (using the hooks provided in this commit),
> eliminating lots of repetitive boilerplate code.
> 
> ECB is obsolete of course, but we need this for parity with the
> traditional API and to support some odd users of ECB in the kernel.
> 
> Initial test coverage is provided by the crypto_skcipher support added
> in a later commit.  I'm planning a KUnit test suite as well.
> 
> Create a documentation file libcrypto-unauth-encryption.rst to hold the
> documentation for this and other unauthenticated encryption modes.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   .../crypto/libcrypto-unauth-encryption.rst    | 28 ++++++++++
>   Documentation/crypto/libcrypto.rst            |  1 +
>   include/crypto/aes-ecb.h                      | 49 ++++++++++++++++
>   lib/crypto/Kconfig                            |  9 ++-
>   lib/crypto/aes.c                              | 56 +++++++++++++++++++
>   lib/crypto/tests/Kconfig                      |  1 +
>   6 files changed, 142 insertions(+), 2 deletions(-)
>   create mode 100644 Documentation/crypto/libcrypto-unauth-encryption.rst
>   create mode 100644 include/crypto/aes-ecb.h
> 
> diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
> new file mode 100644
> index 000000000000..891c15279749
> --- /dev/null
> +++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
> @@ -0,0 +1,28 @@
> +.. SPDX-License-Identifier: GPL-2.0-or-later
> +
> +Unauthenticated encryption
> +==========================
> +
> +Support for unauthenticated encryption and decryption, including bare stream
> +ciphers and other length-preserving algorithms such as block ciphers in XTS
> +mode.

This sentence no verb?

> +
> +- Support for legacy protocols that really should have chosen an authenticated
> +  mode (or even another primitive entirely) but didn't.
> +
> +- Internal components of authenticated modes.  For example, AES-CTR is used by
> +  AES-GCM and AES-CCM internally.
> +
> +- Storage encryption that cannot accommodate ciphertext expansion.  Usually
> +  AES-XTS is used for this.
> +
> +- Stream ciphers for key derivation and random number generation.
> +
> +Besides the above, these shouldn't be used.
> +
> +AES-ECB
> +-------
> +
> +Support for AES in the ECB mode of operation.
> +
> +.. kernel-doc:: include/crypto/aes-ecb.h
> diff --git a/Documentation/crypto/libcrypto.rst b/Documentation/crypto/libcrypto.rst
> index a1557d45b0e5..bbf5ca137910 100644
> --- a/Documentation/crypto/libcrypto.rst
> +++ b/Documentation/crypto/libcrypto.rst
> @@ -161,5 +161,6 @@ API documentation
>      libcrypto-blockcipher
>      libcrypto-hash
>      libcrypto-signature
> +   libcrypto-unauth-encryption
>      libcrypto-utils
>      sha3
> diff --git a/include/crypto/aes-ecb.h b/include/crypto/aes-ecb.h
> new file mode 100644
> index 000000000000..bfc56bdb082c
> --- /dev/null
> +++ b/include/crypto/aes-ecb.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * AES-ECB unauthenticated encryption and decryption
> + *
> + * Copyright 2026 Google LLC
> + */
> +#ifndef _CRYPTO_AES_ECB_H
> +#define _CRYPTO_AES_ECB_H
> +
> +#include <crypto/aes.h>
> +
> +/**
> + * aes_ecb_encrypt() - Encrypt data using AES-ECB
> + * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
> + *	 overlaps the behavior is unspecified.
> + * @src: The source data
> + * @len: Number of bytes to encrypt.  Must be a multiple of AES_BLOCK_SIZE.
> + * @key: The key
> + *
> + * ECB mode is insecure by itself.  This function exists only for compatibility
> + * with legacy protocols and for internal use by other modes.
> + *
> + * This supports incremental encryption, but the length of each chunk must be a
> + * multiple of AES_BLOCK_SIZE.
> + *
> + * Context: Any context.
> + */
> +void aes_ecb_encrypt(u8 *dst, const u8 *src, size_t len, aes_encrypt_arg key);

Other similar functions like aes_encrypt() use the key as first argument ... 
so maybe do the same here, too, for consistency?

> +/**
> + * aes_ecb_decrypt() - Decrypt data using AES-ECB
> + * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
> + *	 overlaps the behavior is unspecified.
> + * @src: The source data
> + * @len: Number of bytes to decrypt.  Must be a multiple of AES_BLOCK_SIZE.
> + * @key: The key
> + *
> + * ECB mode is insecure by itself.  This function exists only for compatibility
> + * with legacy protocols and for internal use by other modes.
> + *
> + * This supports incremental decryption, but the length of each chunk must be a
> + * multiple of AES_BLOCK_SIZE.
> + *
> + * Context: Any context.
> + */
> +void aes_ecb_decrypt(u8 *dst, const u8 *src, size_t len,
> +		     const struct aes_key *key);

dito

Apart from that, patch looks fine to me.

  Thomas

