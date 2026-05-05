Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AA83B4EB0;
	Tue,  5 May 2026 05:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777960035; cv=none; b=PXbeXe04eNQmdf5OlMR+nOgU5feMuv4X0uTOWKfUnsdHfrjDu27VduACl0n1VBym4Qjg3QI6xFMy+sH+DuUFmJPw+z0SHH6JQStpjRPaBpzdIkEhS22Ty7BIrp9C+fSS/tRdu16Aan+d4+7/fsRs4a+3vduvCY+akNPyQvPeZRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777960035; c=relaxed/simple;
	bh=GFraPeWSHBeBTBKCHbqMZZ0RI743i2GrkYooIVfmUgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrDyiHhZbK0ZLaqGij91n3VKoYbXoR/NLKtyMyIj/CqeT0XLN+gvZ0AY4RIEB22SbM9P4xUI9jiI96/0MGX2j6icGzfZsg2dgxB8m2icNunJcFZlRayhNzGRW4Sn6fKZ+fcFuJVpqYEqIAaWB6wTOmddlXUbcqM2XxVk4ux5Xbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=THdNyWbQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="THdNyWbQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=b3O989lIV/7AhzyUAfm0eiu3LCgeXU7IX5L5ttzSu/Y=; 
	b=THdNyWbQAKbe5cfM/fzIO0A9naeL2J+WRJZZ/NNwDciTqcvUGjpZuK0vvXOcMGhdURkS397sUcj
	62JoXmWLzDi2vaYAECbgJUEnkSfamHa7EixXQYTaD95Ni6ZqDHjR41HTRrzwsBnPsz5Vx4PwHIfas
	sRjvhbIcn9fXYPqunhReiCglPIQXR64f7xd2hRFfBZcrkkUEALrIv260/ZmSd4bffQQsnSJxV6gaf
	KZrYtCfA3NDGb53h+DHYvgFy2CW0SLplLJ9+vNyesVYvYnX0knj3sboieAVAps8iQJ7BDQbbFREPm
	qCH0aH90LKKmcqQmfYvfMjriufP9ouD7BJTw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wK8cF-00BKaw-1z;
	Tue, 05 May 2026 13:46:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 13:46:43 +0800
Date: Tue, 5 May 2026 13:46:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weiming Shi <bestswngs@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Vivek Goyal <vgoyal@redhat.com>, Kees Cook <kees@kernel.org>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>, Jarkko Sakkinen <jarkko@kernel.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH] crypto: fix OOB read in pefile_digest_pe_contents
Message-ID: <afmEQ5ove_8fqEhH@gondor.apana.org.au>
References: <20260430173632.277436-3-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430173632.277436-3-bestswngs@gmail.com>

> 
> diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
> index 1f3b227ba7f2..cec99db14129 100644
> --- a/crypto/asymmetric_keys/verify_pefile.c
> +++ b/crypto/asymmetric_keys/verify_pefile.c
> @@ -305,6 +305,8 @@ static int pefile_digest_pe_contents(const void *pebuf, unsigned int pelen,
>  
>  	if (pelen > hashed_bytes) {
>  		tmp = hashed_bytes + ctx->certs_size;
> +		if (tmp <= hashed_bytes || pelen < tmp)
> +			return -ELIBBAD;

I know nothing about this but why should pelen == tmp fail?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
