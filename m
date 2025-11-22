Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC87018FC86;
	Sat, 22 Nov 2025 03:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763781250; cv=none; b=pn1hJ0TPHTLCoazKQK87J63VQhMPvurImatEmbTF82tz7N7LiBzhoHTMUEmWdoVW7vRVSnQhuSL7AUVGvd0pzdnI7ahhIVOQ3/ucHlr0GZ3k3WL1isukso72wb7kZfFafWj+W0hLXGcMed2QgAb78l+aGSQW64gaRLPvmub6X1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763781250; c=relaxed/simple;
	bh=xdQB9PdoUwbS8t+hlYddwX/EsBhUDL+GmA2KbkB7NqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7TEaCdarRmtBh5biPzf1Csfkq7Ln6NEyXFLwsj2gMfTQ4TBFlWtPWv0o1UG5mUvzIcxakb7urMsOdPNivNOQHul9W7+YkjOxUIHGHyNdZ8KaVHsmEZlqnpFj5XE+mvPG/x5tRUSz4wLyYAPsz4G96wHKKvY0OzSo1FoHKFO/xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=j+6cNb/6; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="j+6cNb/6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=YlKVwvw76AzWlf5cuuwrd7RFix8KbItA+lmDtN4DNMc=; 
	b=j+6cNb/6W1jVQkb9hujfDbnwqgfBOD6cewU4utEKxmOy048zfF+U9iCytTbnJ6N/tR9y+G8JaQt
	yKlr60GPAL2+cKV0dbnoEgGM9sPhX1ug7c2sDZzmAT4dOiO/9ZixeeIic7B++Cp/pFdfwGhxikPaI
	nZboc79kXnYIPEDlWmJ+rjuQB7R1iR6LrqGSv6sBR9s4vB3R+9AIGJlZEIpotm2nWfzFcWukuR8et
	0ogIYEnYtu1R7ZKnKRBkODZ2AGfyqegZ2FCvrb7049kl4K9AR+w81Lmh3vU6+8fifBEEeURHgYe8h
	dFlPPpRdpT/rajv09wkk8/TR/oQ37ESYAjTw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMe4H-0056RV-2q;
	Sat, 22 Nov 2025 11:13:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 11:13:45 +0800
Date: Sat, 22 Nov 2025 11:13:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: jiajie.ho@starfivetech.com, william.qiu@starfivetech.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: starfive: Correctly handle return of
 sg_nents_for_len
Message-ID: <aSEqaVkSZUgZ3iZD@gondor.apana.org.au>
References: <20251110065438.898-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110065438.898-1-vulab@iscas.ac.cn>

On Mon, Nov 10, 2025 at 02:54:38PM +0800, Haotian Zhang wrote:
> The return value of sg_nents_for_len was assigned to an unsigned long
> in starfive_hash_digest, causing negative error codes to be converted
> to large positive integers.
> 
> Add error checking for sg_nents_for_len and return immediately on
> failure to prevent potential buffer overflows.
> 
> Fixes: 7883d1b28a2b ("crypto: starfive - Add hash and HMAC support")
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/starfive/jh7110-hash.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
