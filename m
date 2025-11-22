Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63ED1B4244;
	Sat, 22 Nov 2025 03:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763781252; cv=none; b=Cu1zekP3zmfY7SoQUzb5LA5ENGg1lOvc7C9TC4cyKSKbtEP2DO/3NdvXmA0fgV+cJM2XQWG7KT9bPHj0Q01u3nPnhjiwGAKYBudl4eFIkZQWjlo/OEDbZvfJtZtj2/48SQu5lZBSHJzFwdy3JrJL7xFdoi3v+2MBAqUqP9FJlVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763781252; c=relaxed/simple;
	bh=N47m66q/P2FV3V9Z/fhfDE7RkBGdm6paWWSyyewxiDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZeEWTknOJr0+4RYF5zT3jkoW02qIL7vk8V2WL6n6nCa5egEqxIoT2tmA0hdVyKVMkvTPDFhJsJCuuOoHAa99p1thOeLpXTxHheZeDqXQkx9oGWXu4BPxa4PMtdYS2eOaZEzWVK0Z0BR0QzgmV56Z6b9kofVk7gvlyVmuHcBnEvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=I8cHjX7U; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="I8cHjX7U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fS1Sf8IsLGHQVpfYJBWgaUSfsZEry7ICG5rYAQf9QDc=; 
	b=I8cHjX7UTBphScCPzOOKZqvVQlqldMa0PJBeV7kHdwZhYYaA3V+JWVy22+2YIzrmVTSSAt+92It
	9ThzxabYKLya5EZhpCcs5eD7xPxXPPhllRbf7C9xHWXv70hrsWbD/o/vmiD/OE9pniee+KYTIppwb
	Yn4GhV5P1pXu5YcPVSU2uzFRXvyTgG53y8K3bk110t7c4gTh9wGbctL7TpAxvVrNMX1xKtDKW8HNi
	5j0wsEGcb+EzCtB92zy5YQHRc4XlLuAYNpLu5QxZ9jjy2kLclWZcLLN3NGtpY1y9CxtGjm4SNtB87
	4xVE6dYV1N90C2lBYZ4UNUexxx7G7lHn9pag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMe4O-0056RZ-3B;
	Sat, 22 Nov 2025 11:13:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 11:13:52 +0800
Date: Sat, 22 Nov 2025 11:13:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: gilad@benyossef.com, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree: Correctly handle return of
 sg_nents_for_len
Message-ID: <aSEqcJ5k4JsErB2l@gondor.apana.org.au>
References: <20251110072041.941-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110072041.941-1-vulab@iscas.ac.cn>

On Mon, Nov 10, 2025 at 03:20:41PM +0800, Haotian Zhang wrote:
> Fix error handling in cc_map_hash_request_update where sg_nents_for_len
> return value was assigned to u32, converting negative errors to large
> positive values before passing to sg_copy_to_buffer.
> 
> Check sg_nents_for_len return value and propagate errors before
> assigning to areq_ctx->in_nents.
> 
> Fixes: b7ec8530687a ("crypto: ccree - use std api when possible")
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/ccree/cc_buffer_mgr.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
