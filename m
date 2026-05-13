Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87943FE651;
	Wed, 13 May 2026 12:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778676018; cv=none; b=hAcNTuXzVL+i/SqEQ3KwnLmNEK+l7sj0HZzzsTxoH1n2IwkY2xeFOYc4+kiCceoSAT6fHNAv2fUg6gCPx1zZOWkL1Onp1pxxZ3gHWJ9ugWgTdE8Bd/qdQNuuLks3QCqvu1/0oOPLiAyK1fCKuXMzmWKG/40Cwo39kdO0e4NuwGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778676018; c=relaxed/simple;
	bh=Wc5Z/xk/dVpWgK4RNhNjuCwP9Kmt0LR8age3Uz+74/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xm0nMO9pBZUfHCpxuZkRulzwGLYn4Y0PePbRY8YPju6Uf6mKdGeu9JHbM1DL8Ua94FxVvtAWlV+6q1E7G138QzTHS0XwkMhvIyhF2pTOmw76y7cSqu2wktem4wnoyS3u/uElgbMRAMc1X32SwXKMCBCjFeSbD/lxUwRPA2rzlj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QQIt5zt+; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QQIt5zt+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778676012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c7DWBHMpPxzTz5YpJGtzFgvUkI+FZGl66D/PoZXVh5c=;
	b=QQIt5zt+lVNsbUxmrPZxSXFJseu//i0nGu9EYjToA/XaQ4hkHUmm0OjWdy3clVmuNSSVH1
	3p7lV15ZJGUt28LuV9R2srgRYGmC6yHCqG3qzyA5603x5Qm+dJZurRbvjnlo6CIhIi1NSS
	+16N76EgvPEOA4w/OUUDG50nrC9Kyqo=
From: Qingfang Deng <qingfang.deng@linux.dev>
To: Anastasia Tishchenko <sv3iry@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ecc - Fix carry overflow in vli multiplication
Date: Wed, 13 May 2026 20:39:48 +0800
Message-Id: <20260513123948.842-1-qingfang.deng@linux.dev>
In-Reply-To: <20260513105741.55534-1-sv3iry@gmail.com>
References: <20260513105741.55534-1-sv3iry@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 13 May 2026 at 13:57:40 +0300, Anastasia Tishchenko wrote:
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 43b0def3a225..6eb4d97a5f0d 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -393,14 +393,26 @@ static uint128_t mul_64_64(u64 left, u64 right)
>  	return result;
>  }
>  
> -static uint128_t add_128_128(uint128_t a, uint128_t b)
> +/* Calculate addition with overflow checking. Returns true on wrap-around,
> + * false otherwise.
> + */
> +static bool check_add_128_128_overflow(uint128_t *result, uint128_t a,
> +				       uint128_t b)
>  {
> -	uint128_t result;
> +	bool carry;
>  
> -	result.m_low = a.m_low + b.m_low;
> -	result.m_high = a.m_high + b.m_high + (result.m_low < a.m_low);
> +	result->m_low = a.m_low + b.m_low;
> +	carry = (result->m_low < a.m_low);
>  
> -	return result;
> +	result->m_high = a.m_high + b.m_high + carry;

If CONFIG_ARCH_SUPPORTS_INT128 is defined, you can convert them to
"unsigned __int128" as done in mul_64_64(), and use check_add_overflow()
to get the carry.

> +
> +	/* Using constant-time bitwise arithmetic to prevent timing
> +	 * side-channels.
> +	 */
> +	carry = (result->m_high < a.m_high) |
> +		((result->m_high == a.m_high) & carry);
> +
> +	return carry;
>  }
>  

Regards,
Qingfang
