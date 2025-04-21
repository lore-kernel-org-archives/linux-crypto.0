Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF791ADC98;
	Mon, 21 Apr 2025 07:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745220027; cv=none; b=Ge8G+//rHJYsvoe9HVOSGGk+rOT2wXHg6J18129okTpA5SZE8tO9YrHwcLHOipgW7KNJ6dGv3P1B+757PhUpq2/J2mQLIlhsfHSShfdO6ZzxTGj7+o/c7mX5UN27tlKLZ2WdCRakQUvdH1XHy3ktb5lzOG2ZRYSKUT7NEH2Hs2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745220027; c=relaxed/simple;
	bh=EwMe8Wb43GFTTbyo+/7B+EnV27Zps6JzW0QCOWV6UWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hUZj4B8d60lYctjGf6uw/+y189mZyllLne+LzeonRBifjeZfTrCu0ZkbjWEv2wz0bDWWq2TblFzqwr1QAfJ83kv1IQuC1iOZdQbjhfhxdq5vT5TSnnXEVtyt8pH+dkMHtbDktHAHgiB34wp47s/sL83rz8RTA7YHT86C5sq3gcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=ojsVQIy7; arc=none smtp.client-ip=80.12.242.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="ojsVQIy7"
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id 6lIxuVOt8RaJG6lJ0uv8UZ; Mon, 21 Apr 2025 09:11:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1745219466;
	bh=ALscRgfeA4eRVyU6WwVdv2LWYx7uE+ukJFayKniTnlI=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=ojsVQIy7uyxsbWGyE+wNuT48wRwXO0Z2R2eOZsa+xek74otwbMbwqaiyBhEoUOogm
	 JJ51o+qGB75Bohvx1+U3l/j7RBts4AplgcUOzB+f3xJXynOh7JsvE1EqDzI8UBZqG8
	 i/Q5g6hmUxKwfzS4MGOZ0bLqUoncpy2ljk1HP0TPbdTWHSYohLTwUk37qlz89jt5L2
	 TqRJXlWs+YcWGb9I2d8Ao+lxGGjh9rDyMjJAzMHw3Ix5YgqS+82GclDNw4Gcr1UBZc
	 BpZZGiWasTD/cZ/NV+rwml6XUyCxn2EeiM2B+LidlFzEfuoBXzN9f5kiDKrEYlj6kF
	 d6+N53/7cfSSg==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Mon, 21 Apr 2025 09:11:06 +0200
X-ME-IP: 90.11.132.44
Message-ID: <c86fcb5b-73d0-4d55-833f-26a16713e325@wanadoo.fr>
Date: Mon, 21 Apr 2025 09:10:59 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: using size_add() for kmalloc()
To: Su Hui <suhui@nfschina.com>, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20250421055104.663552-1-suhui@nfschina.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20250421055104.663552-1-suhui@nfschina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 21/04/2025 à 07:51, Su Hui a écrit :
> It's safer to use size_add() to replace open-coded aithmetic in allocator
> arguments, because size_add() can prevent possible overflow problem.
> 
> Signed-off-by: Su Hui <suhui@nfschina.com>
> ---
>   include/crypto/aead.h     | 3 ++-
>   include/crypto/akcipher.h | 4 +++-
>   include/crypto/kpp.h      | 3 ++-
>   3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/crypto/aead.h b/include/crypto/aead.h
> index 0e8a41638678..cf212d28fe18 100644
> --- a/include/crypto/aead.h
> +++ b/include/crypto/aead.h
> @@ -10,6 +10,7 @@
>   
>   #include <linux/atomic.h>
>   #include <linux/container_of.h>
> +#include <linux/overflow.h>

You could move this 1 line below, to keep alphabetical order.
And why do you say that it is redundant in your follow-up mail?

>   #include <linux/crypto.h>
>   #include <linux/slab.h>
>   #include <linux/types.h>
> @@ -433,7 +434,7 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
>   {
>   	struct aead_request *req;
>   
> -	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
> +	req = kmalloc(size_add(sizeof(*req), crypto_aead_reqsize(tfm)), gfp);
>   
>   	if (likely(req))
>   		aead_request_set_tfm(req, tfm);
> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
> index cdf7da74bf2f..4c37a602cce5 100644
> --- a/include/crypto/akcipher.h
> +++ b/include/crypto/akcipher.h
> @@ -10,6 +10,7 @@
>   
>   #include <linux/atomic.h>
>   #include <linux/crypto.h>
> +#include <linux/overflow.h>
>   
>   /**
>    * struct akcipher_request - public key cipher request
> @@ -184,7 +185,8 @@ static inline struct akcipher_request *akcipher_request_alloc(
>   {
>   	struct akcipher_request *req;
>   
> -	req = kmalloc(sizeof(*req) + crypto_akcipher_reqsize(tfm), gfp);
> +	req = kmalloc(size_add(sizeof(*req),
> +			       crypto_akcipher_reqsize(tfm)), gfp);
>   	if (likely(req))
>   		akcipher_request_set_tfm(req, tfm);
>   
> diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
> index 2d9c4de57b69..11ae1ad41d2a 100644
> --- a/include/crypto/kpp.h
> +++ b/include/crypto/kpp.h
> @@ -11,6 +11,7 @@
>   
>   #include <linux/atomic.h>
>   #include <linux/container_of.h>
> +#include <linux/overflow.h>

You could move this 1 line below, to keep alphabetical order.

>   #include <linux/crypto.h>
>   #include <linux/slab.h>
>   
> @@ -182,7 +183,7 @@ static inline struct kpp_request *kpp_request_alloc(struct crypto_kpp *tfm,
>   {
>   	struct kpp_request *req;
>   
> -	req = kmalloc(sizeof(*req) + crypto_kpp_reqsize(tfm), gfp);
> +	req = kmalloc(size_add(sizeof(*req), crypto_kpp_reqsize(tfm)), gfp);
>   	if (likely(req))
>   		kpp_request_set_tfm(req, tfm);
>   

