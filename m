Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBE313D891;
	Wed, 26 Aug 2026 00:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787704495; cv=none; b=oqGAuAPxy2IQYkTF0R7tAvO6Hudy3DK3/RWxBXeJInTWnxSGkJFu2niFKVayBi0z1feXueJuVJHPxrBhKYkqG9oRGomf8RPZR2uNT1Pr85fMihkbXjNh5TsxEa1wfmnnMYJBXxa55mgDW+nuRbMLl9N6LM5cjnU5dNQwXFinehU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787704495; c=relaxed/simple;
	bh=pQAYzLvg9KpHcxU+LnXQVdH574WZO1yOPJCbVINefEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwhLLPfQBh/J5Wl1FIhK7h674wo/f2vrwRJ9+sPNbzyUJeLuJAugzxVxdY4JIRGgEPNfyM/m+WwCnpc5zrGBoR9bhBgCx9+zY3TuViQQr1Zyp4ak6xQQIQzkcKYVHl7/BHmbu1MyjVpVMoH/nDiVVf9ImTF3BGcFUioiO3T1nL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=H8rGhrXB; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="H8rGhrXB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=g6m62ULcEWLAgwV8W3EGS031S83rgrU2wcPRNuOasEk=; 
	b=H8rGhrXBXb0IAQ6GAt7khTJNyKrG+l1K5srWAbLLAdakzSuvfDgK42CPLcqrQpRvTBtwAHQmv87
	JudERSExDlTj/nbEjeP68qstNFnAVzUhEZQxV52UJgb9a2UDEbW5bP7NNvdsUPlsCfEl+SZFUfoV0
	kt55hggWWKZbTE3xJ5TFiGd0SucnsQjVT/aqpdPQibQZTjoc8hZ/7vTHXayQ/j3hlKosuGr8gKXdu
	3EANLHOxsN8VB0wJG3oXxnA1FV/zp15Glmz4zYzdgejhtawBvNVBgOFXZOHfN1AG+0KvRLG9GU7qe
	5NhSVUrKu9p4TAwKnckuW4eAMonxVOH+cTRQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wz1bJ-00000007tCB-3zU4;
	Wed, 26 Aug 2026 08:34:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Aug 2026 10:34:45 +1000
Date: Wed, 26 Aug 2026 10:34:45 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: acomp: allocate async request context when
 cloning
Message-ID: <ao40peGvkNSJ8DZV@gondor.apana.org.au>
References: <20260815100918.4064616-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260815100918.4064616-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Sat, Aug 15, 2026 at 10:09:18AM +0000, Jérémy Jean wrote:
> ACOMP_REQUEST_ON_STACK() reserves only enough storage for the
> synchronous fallback. When an async implementation is selected, callers
> clone that stack request before retrying, but acomp_request_clone()
> currently copies only the stack-sized object. The clone therefore has no
> storage for the async provider request context, and providers such as QAT
> write past the allocation through acomp_request_ctx(). KASAN does report
> a slab OOB write.
> 
> Allocate a zeroed clone large enough for the runtime acomp request size,
> copy only the bytes present in the source object, and preserve the
> existing fallback-on-allocation-failure behavior. Use the runtime reqsize
> because an implementation may adjust it during tfm initialization.
> 
> Assisted-by: Codex:gpt-5
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  crypto/acompress.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
