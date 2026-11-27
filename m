Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795754753;
	b=wosgCntQiPz6wCeVcGaj/UGr0ecdbWHSnm6ZVhmvrEy2+X/d19vFmcHDt8uuvWkws/l/
	 OsJqD0ffWeNlB9CvHJ+OLt4e4kLY2GZNlWL2MISeFyuKzEGRoJ2iTtmCXZdu6+RI8c0Jw
	 QCmCv2to39emnlZrPoTBEShOMxX6fRJEIMPYS1hwYz1jdpmIN9lTbc76FMqyJ0q8dmMjF
	 dJJs6RE/94s9NfLdUkFTsV17qVgjn/Y+ApvKfe/VbEIKFvslviRpeLAJdGerJWfo14dEx
	 m8CJ+qDigrsE0ydC5/Fg+WnQF1uK2xBGEbBCZuIEaxMZBmMcHSbDnYiJ12pePQwoiqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795754753;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=PRKPtJOLbnC27h3uioNsO+R4riFgVMiKGh1NJXpiY6E=;
	b=N1NbrCvchPLi240ZJb+h7x6eEUuEgYfgLJhJTf1PIv5heN2kEK8RLU7hqyFiMsha5Cb1
	 JBrz8l707B8Qn8/hBscRiU+d0UKP80m5T0cTLyT24aapq/pJNtnvdbEN0QW/Y7NMkcM6a
	 e77qkgCeF9lJQqw5IvLVcOr8cbkJDHKQ2glwpryH0nMzdSVgIO4Gc+EuWdkDqmUkdcWiW
	 txaK39KskC6b0a9jvTlKEnkVsiaSoz4MFzB8l2xFP89+4yfsNRAf7oFELVxeNeKafvpRc
	 SSI9RvjgwqlDkgR4T3IfrLt0gYs0OiuqqIfMP7wCCk72WjuJxOfs/6OnJqp1CNCKbRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=r7PGWkZe;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAA0606A31E;
	Fri, 27 Nov 2026 04:45:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDAA0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=r7PGWkZe
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PRKPtJOLbnC27h3uioNsO+R4riFgVMiKGh1NJXpiY6E=; 
	b=r7PGWkZewT/Qu37JuPXBGYF0XJWBmX5ofI+YY/QwkwsBVX1110EJkGB8LoiPfTm2x6I5nOdyS2x
	9xL07z/OBjnzInp+SJklnzlafs3+dbplljXr9sHOBBX7Tz0Wogh3vmSSI53uOKF/KwzvzBziHLMdg
	q95sy5GAiqr0Oqb+WLL5kjrG2kjdwZdmT8l6w9GfGKuMKQAy3s0f97+mrOOgAZ3jO18HO91/tzxOJ
	3Fqd+WvRS4eTlPoi4Xee8RNf5TmXZ9Vhi8af0fyvcyuibpCusByZK3ptKDlVOjex5ZMCsEG1+41la
	khzDq0idnHB98u9Zg2/PwX/J4alMy2ulgAsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWnqF-00000002VDC-2KO8;
	Fri, 27 Nov 2026 12:45:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 12:45:47 +0800
Date: Fri, 27 Nov 2026 12:45:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guicai Ma <maguicai@kylinos.cn>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg - wake up waiters on zero-length final
 message
Message-ID: <awkK-9grfKCPNJhY@gondor.apana.org.au>
References: <20261120083244.1156396-1-maguicai@kylinos.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120083244.1156396-1-maguicai@kylinos.cn>

On Fri, Nov 20, 2026 at 03:32:44AM -0500, Guicai Ma wrote:
>
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 7524070f26d8..9b4f8c1d2e3a 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -938,7 +938,7 @@ static void af_alg_data_wakeup(struct sock *sk)
>  	struct af_alg_ctx *ctx = ask->private;
>  	struct socket_wq *wq;
>  
> -	if (!ctx->used)
> +	if (!ctx->init || (ctx->more && !ctx->used))

Good catch.  However, this is still slightly out-of-sync with the
waiting side's condition:

> 	ctx->init && (!ctx->more || (min && ctx->used >= min))

How about putting that whole thing into a helper and have both sides
use it to ensure that this never happens again?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
