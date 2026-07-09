Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE914343E8;
	Thu,  9 Jul 2026 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783613324; cv=none; b=QY/3PwvD/A7xt1ERaMe5u5BwC41CTh5j7DaMRFdbbMxmyKzW+iCZk6YdLaFuU4m5rB/DNu3RMMO95bYTbPZMHtnU2+eGFPMrhJ6koRmMSSq0gVBwCjxNJcLosnB5H4bJN0eAb3slqLMdJHvO42ZNsHLZsyGoDA65nxmosV/kDLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783613324; c=relaxed/simple;
	bh=QkUqyxWcolWjRqaLftymnFLP2qJPjNeHWeySSYT0rUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pe7LkCCwSR5fSt1bjhjNkXWThqk843TyW9jZTU4u5wREID1WJ6l0hHpjieBLYXaQ/IqSxQfZNfjADHefMGjrHvbP1FiX86QZxwGi0YSoBHtbcdCvk4ONqguGfHTSzdgusLvEuNq5jetN/rexFR+SoqjesqburlTJjflYuYY88fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q5FaBwdY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q5FaBwdY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=AbexU8wuLAQE7KwfR5cfT5k1M8jwsa0MO1b35YL3hOY=; b=Q5FaBwdYU0gd211CGSryq11/s0
	wVzXfZarzpRJ2wFlsDBtKReICrVu+e/x2AV2tUyTzKi65QuMCsZcfwHhm0oYtU+b5KSc7Cte8cntE
	qjwCCxvNw7pO3Wrth9NFsUOBkCOFMAzWip5jrJi9rchWecs1lV3OITpFRomjjVt3Mvm5afflc9Tpp
	R4wVMbjaW7rUEEUGlmK9H6xgg0Hi8DMrTvDcGpUTECblGKgMAKcZ0Rqun3Nxv5nAosjRK2V+Y4UGC
	9xhtFmJ2XTLv32GQOeyVfI73ln/9ZOY6fmxIggJwso7przybCar0w9HS0BrKF5PTt2dw9VADLXv26
	s4QcYCgQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whrIj-0000000303q-09KH;
	Thu, 09 Jul 2026 16:08:37 +0000
Message-ID: <e51cd836-ea07-4901-bf16-7e1e0ac8f0a2@infradead.org>
Date: Thu, 9 Jul 2026 09:08:36 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: fix bracket
To: Manuel Ebner <manuelebner@mailbox.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Stephan Mueller <smueller@chronox.de>
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260709143837.405758-2-manuelebner@mailbox.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260709143837.405758-2-manuelebner@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/9/26 7:38 AM, Manuel Ebner wrote:
> Remove needless ')' from code block.
> 
> Fixes: 3b72c814a8e8 ("crypto: doc - convert crypto API documentation to Sphinx")
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/crypto/architecture.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/crypto/architecture.rst b/Documentation/crypto/architecture.rst
> index 249b54d0849f..ec2e99d99aff 100644
> --- a/Documentation/crypto/architecture.rst
> +++ b/Documentation/crypto/architecture.rst
> @@ -95,7 +95,7 @@ additional templates may enclose other templates, such as
>  
>  ::
>  
> -        template1(template2(single block cipher)))
> +        template1(template2(single block cipher))
>  
>  
>  The kernel crypto API may provide multiple implementations of a template

-- 
~Randy
