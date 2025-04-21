Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id E812B1BD01F;
	Mon, 21 Apr 2025 06:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745216842; cv=none; b=Hip3GT65kZcQZbnLuyoU6aNnKiqwj861LRLvmcaO5gMW8Y2Ngf6ZTsKXiOYlwTRWHw1fVwSVnJZGZrn8lZLzuiWKl336EZvLFowICdxhD0jrOF0gQOwaMTskKbbdVL7/VBWW8WWBth8Gs8ZoRQxOfvl5icY/0GIIU59oLkmG2w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745216842; c=relaxed/simple;
	bh=+e4r3AuCco/3OGo78Ey5O3/fp5Jdixn0HRrqyS/fYl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type; b=r+zJAIjG+/zPjQ/WhiCP0ZrlxXdD7h3RCJThrJyUt8dk1KkBT3LEmThPlikdJz42qbwQ+GOjbGNJDImkgLNVN9K9eJaxap0SjsZEtP+2spSoS+I4mxkRHPuwW32C13cgvRxOjqzdDWTXoJGnxEiIO8OnXwwlx0sP885YWzouviY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from [172.30.20.101] (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id 941C46025A056;
	Mon, 21 Apr 2025 14:27:12 +0800 (CST)
Message-ID: <1c680708-eaf0-43da-9714-78b6d7f4d993@nfschina.com>
Date: Mon, 21 Apr 2025 14:27:11 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: using size_add() for kmalloc()
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Language: en-US
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
In-Reply-To: <20250421055104.663552-1-suhui@nfschina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/4/21 13:51, Su Hui wrote:
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
Sorry for this redundant <linux/overflow.h>, will remove in v2 patch.
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
