Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F675155A30;
	Sat, 20 Sep 2025 19:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758394915; cv=none; b=ln9QJT/6TpvSOGI4duy054yLHU/oUd7ml2BObRCip9i5RHcP/OeGdLAAEAWJNMA+Q51GQ4E5d5PgnLy0HkpJdupNU11dyY2PrILdNf7a0V9woKOWnQ3TG3LtLrjpEOFx5pL4ekbExti5oG2FmU763s8EyNfgRaSMqFgfyhyACxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758394915; c=relaxed/simple;
	bh=Oi9uFHOC+EyFwNjYQ2z2reLYKzdC5PW8spF29329K9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVkPcuJUg5A4QESPJzIQmb1s2EqHvjfPXzrUrRrUgqRfQ8Rof2I5He2c2vcKA/+YlgewrcLedPqtWCaw+3v8ZSd+XMJ6xxJlrpsvs+y/gBBD6zCFwvT33htq2xyrFCacGpzGHIPLofwzYv/wTtLHXZSXrbgg3eS7Gcj/sZ/kIv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pmWN3CMw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pmWN3CMw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=qRmfWcEq5xdIro+zPdjnGoFjaSaIDh/SGmjBoh3LDdw=; b=pmWN3CMwPj6bPkoop1JDSfpxdj
	iCigGptilDQ76x1lWHSeKYDySYusmGO1blKLugrUnV+IqU8EeEhYygmNpgqhtord45JWW/grqNm4f
	ca00iAH52/mjKGQ1qXKtKU0zrzlm8kLCanD4jJ98FI+SMZCEvkgcpn1BWzNb1nDrsLsPBXWJSzV0N
	i+qYOLfXx6MmutY5drg8ZN0YFN0AXq/FSf1PYeFg9wMiWpKb25iB2juknj9eeo4yRJiebEbD1B7UX
	X5zKsx/YkvuG6MYNM0TqHixOdjV4I0zkeRkgBEnxPFlJNYZ3frthZa2p3pjxLEJYdmRekM/w0Kj3Y
	98YF5Mdg==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v02qB-00000005mNq-26KP;
	Sat, 20 Sep 2025 19:01:47 +0000
Message-ID: <72f5bbdf-2054-42a9-a9bd-aec3ebefc71e@infradead.org>
Date: Sat, 20 Sep 2025 12:01:46 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: Add explicit title heading to API docs
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux Crypto <linux-crypto@vger.kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>
References: <20250920001650.10474-2-bagasdotme@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250920001650.10474-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/19/25 5:16 PM, Bagas Sanjaya wrote:
> Documentation for crypto programming interfaces lack explicit title.
> As such, all its sections become entries in the toctree index.
> 
> Add the title heading to tidy up toctree.

Yes, much neater. Thanks.

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/crypto/api-aead.rst     | 3 +++
>  Documentation/crypto/api-akcipher.rst | 3 +++
>  Documentation/crypto/api-digest.rst   | 3 +++
>  Documentation/crypto/api-kpp.rst      | 3 +++
>  Documentation/crypto/api-rng.rst      | 3 +++
>  Documentation/crypto/api-sig.rst      | 3 +++
>  Documentation/crypto/api-skcipher.rst | 3 +++
>  7 files changed, 21 insertions(+)
> 
> diff --git a/Documentation/crypto/api-aead.rst b/Documentation/crypto/api-aead.rst
> index d15256f1ae3696..78d073319f96a3 100644
> --- a/Documentation/crypto/api-aead.rst
> +++ b/Documentation/crypto/api-aead.rst
> @@ -1,3 +1,6 @@
> +Authenticated Encryption With Associated Data (AEAD)
> +====================================================
> +
>  Authenticated Encryption With Associated Data (AEAD) Algorithm Definitions
>  --------------------------------------------------------------------------
>  
> diff --git a/Documentation/crypto/api-akcipher.rst b/Documentation/crypto/api-akcipher.rst
> index ca1ecdd4a7d378..a31f5aef76678f 100644
> --- a/Documentation/crypto/api-akcipher.rst
> +++ b/Documentation/crypto/api-akcipher.rst
> @@ -1,3 +1,6 @@
> +Asymmetric Cipher
> +=================
> +
>  Asymmetric Cipher Algorithm Definitions
>  ---------------------------------------
>  
> diff --git a/Documentation/crypto/api-digest.rst b/Documentation/crypto/api-digest.rst
> index 7a1e670d6ce1a4..02a2bcc26a6470 100644
> --- a/Documentation/crypto/api-digest.rst
> +++ b/Documentation/crypto/api-digest.rst
> @@ -1,3 +1,6 @@
> +Message Digest
> +==============
> +
>  Message Digest Algorithm Definitions
>  ------------------------------------
>  
> diff --git a/Documentation/crypto/api-kpp.rst b/Documentation/crypto/api-kpp.rst
> index 7d86ab906bdf79..5794e2d10c9562 100644
> --- a/Documentation/crypto/api-kpp.rst
> +++ b/Documentation/crypto/api-kpp.rst
> @@ -1,3 +1,6 @@
> +Key-agreement Protocol Primitives (KPP)
> +=======================================
> +
>  Key-agreement Protocol Primitives (KPP) Cipher Algorithm Definitions
>  --------------------------------------------------------------------
>  
> diff --git a/Documentation/crypto/api-rng.rst b/Documentation/crypto/api-rng.rst
> index 10ba7436cee48e..23a94c0b272eef 100644
> --- a/Documentation/crypto/api-rng.rst
> +++ b/Documentation/crypto/api-rng.rst
> @@ -1,3 +1,6 @@
> +Random Number Generator (RNG)
> +=============================
> +
>  Random Number Algorithm Definitions
>  -----------------------------------
>  
> diff --git a/Documentation/crypto/api-sig.rst b/Documentation/crypto/api-sig.rst
> index aaec18e26d545f..4d8aba8aee8e04 100644
> --- a/Documentation/crypto/api-sig.rst
> +++ b/Documentation/crypto/api-sig.rst
> @@ -1,3 +1,6 @@
> +Asymmetric Signature
> +====================
> +
>  Asymmetric Signature Algorithm Definitions
>  ------------------------------------------
>  
> diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
> index 04d6cc5357c810..4b7c8160790a3c 100644
> --- a/Documentation/crypto/api-skcipher.rst
> +++ b/Documentation/crypto/api-skcipher.rst
> @@ -1,3 +1,6 @@
> +Symmetric Key Cipher
> +====================
> +
>  Block Cipher Algorithm Definitions
>  ----------------------------------
>  
> 
> base-commit: 381e8ee368234a51b3a4f231f6f24ff0b09d9f9e

-- 
~Randy
