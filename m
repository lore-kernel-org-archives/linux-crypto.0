Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32C163B9;
	Sat, 21 Mar 2026 08:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774082513; cv=none; b=oRS9BrrwXXvTvWkCrM6tO56To0Qw8JNKz5Urn6l0j3Cu4ZcXpTxggKdiLMTfuFllIUkLzk3VfVJN7FJqPsBxy8gFI78TDsCMHGJ1qvt2bzl3INAzUjW0XBhXHtTzJ1R5nbBJDIv76Ka1Pr0bHywNr3VcZJJUrAOYKHceK/Dq/js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774082513; c=relaxed/simple;
	bh=fU5me3WO6+BMyAxxD4WyTHVELPrrFu5Tt93tZOkZ9kU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ep551Vx5Cw9WiGWqY8qA8W4wfTio9gT0hvXXzf6QuRaDaEbKHJ8a/is7JQGbqR5kv96XHVMsGbiXnrM3zSudf+i5mwLUt6jedX52dTUlqgDBY1NBJHrdkChuTRMdNXuEHWmPRGmZ604ynqZyDbr4NKHm91j7T4j7wmlev4wzpPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dJSbOYBX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dJSbOYBX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7gPYPrtnNq9jbYdSoCC3tDIfvk1BPW6eGZlyuwa7SJ0=; 
	b=dJSbOYBXUlexhmmCYLfXpWh/2enmgG1oC0pyl7H0ExH1jfhSApRO40xyohu5sXFY3npmMZo/aN3
	XXpV0xxuu46i9QAoTP2sNHxWY6jgjsoBO9CG2vsROoURJiezOcejZJPNb20l6eAb6qPsfG4bl3QPP
	LWLArCfgJ08iwBL95bz/tCs5clXbD8AH650Tu7//jBLsSWRTVEW+YVBpYWfz85DEbYecwQLl1mVCJ
	6yJg3oc//vBeNvBGFHpOlzPRXSJm+5KgtUhxYcG1C7IIWTftF27njJ2FICAvmhiv4+oEwL2t7VV5Q
	kENiAvbVAbPiEJpZ6Ens1Dx7oTsvdeRO2qLA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3rts-00GJ46-2R;
	Sat, 21 Mar 2026 16:41:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:41:40 +0900
Date: Sat, 21 Mar 2026 17:41:40 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wesley Atwell <atwellwea@gmail.com>
Cc: davem@davemloft.net, ebiggers@google.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: simd - reject compat registrations without __
 prefixes
Message-ID: <ab5ZxDIk-foO4NKW@gondor.apana.org.au>
References: <20260309043143.3525376-1-atwellwea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309043143.3525376-1-atwellwea@gmail.com>

On Sun, Mar 08, 2026 at 10:31:43PM -0600, Wesley Atwell wrote:
> simd_register_skciphers_compat() and simd_register_aeads_compat()
> derive the wrapper algorithm names by stripping the __ prefix from the
> internal algorithm names.
> 
> Currently they only WARN if cra_name or cra_driver_name lacks that prefix,
> but they still continue and unconditionally add 2 to both strings. That
> registers wrapper algorithms with incorrectly truncated names after a
> violated precondition.
> 
> Reject such inputs with -EINVAL before registering anything, while keeping
> the warning so invalid internal API usage is still visible.
> 
> Fixes: d14f0a1fc488 ("crypto: simd - allow registering multiple algorithms at once")
> Fixes: 1661131a0479 ("crypto: simd - support wrapping AEAD algorithms")
> Assisted-by: Codex:GPT-5
> Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
> ---
>  crypto/simd.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
