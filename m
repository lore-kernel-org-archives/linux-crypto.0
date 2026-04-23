Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385AF179A3
	for <linux-crypto@vger.kernel.org>; Thu, 23 Apr 2026 05:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776923169; cv=none; b=EC3fEgOOTQwdlMGnTFiCnwEMRNePqbzvICjBkwfMh3N8IWuhN6/Q+ekoQQ3+SF4MWiT83uEjgXtoVHkQIjqoppGJHDsARkoOj0I2znFSHqdb+Bw1z/ElI5ZJGbdHnHi5A66t8+8n3cGLQM0H2HbObZO6a0ql6zmsy3w6L7lfgpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776923169; c=relaxed/simple;
	bh=xxtAK1RkFSR65DZWnX9grywr2laEQsOQRV8BMVdSDns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mf5y7/DUd3a3NnyolLn063WuehPKn4jq3JcMQVGwNoL+CKIeRNUlSiOY0iTcUh1rt69bZXhaW4LFmErXPilJimCax9y56ofvEiZnlEonOcUR/vnKdgjoImAD8foXid6KLM8cMXW85WJvEwVeBuF1un1gA0d+WZq/5p9ul6aMPKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=keVhvEYS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="keVhvEYS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2Rl4Paw36eodI1QF4ldVo+rNx+AMOpCijxMKgWwt8s0=; 
	b=keVhvEYSv4yTeo86Vg2CuYxo55zZfACgg0kxUkrVLdnWH2QxNb8P+3eJfrazWgUOvVr6Y1TaCKL
	NhVr41S9ypVj/9Rz1dhJfOSgM9Z8BucUQlxOYmm7Ins0bGKTDVkUsyCCyUb8/z05oXOLitEDQbDUY
	A41W/dDl3uObCY0S/xxnieLchE8Aqqq9nSRqgIulPA0OWseReiIV+Znd2Xdi1jlzCO1t/OqkPAmG/
	O1HS4npAAGF1kCERLY+CibLt4r4Rx9jhHnHTOa2EbbFfhcYfBeM5DiX7MrrBiqzKfsBlXNkMaDr73
	5FL83MA9hZUmW/+fjjfxLrk81XIA0/4CDttA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wFmt0-00895I-09;
	Thu, 23 Apr 2026 13:46:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Apr 2026 13:46:02 +0800
Date: Thu, 23 Apr 2026 13:46:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, ardb@kernel.org,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, yuantan098@gmail.com,
	bird@lzu.edu.cn, z1652074432@gmail.com, ebiggers@kernel.org,
	kanolyc@gmail.com
Subject: Re: [PATCH v2 1/1] crypto: authencesn: reject short ahash digests
 during instance creation
Message-ID: <aemyGjtOvU5tnIjK@gondor.apana.org.au>
References: <cover.1775217403.git.kanolyc@gmail.com>
 <cb1188757edab9b056961d4d2441be009ac73ce8.1775217403.git.kanolyc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb1188757edab9b056961d4d2441be009ac73ce8.1775217403.git.kanolyc@gmail.com>

On Wed, Apr 22, 2026 at 09:45:04PM +0800, Ren Wei wrote:
> From: Yucheng Lu <kanolyc@gmail.com>
> 
> authencesn requires either a zero authsize or an authsize of at least
> 4 bytes because the ESN encrypt/decrypt paths always move 4 bytes of
> high-order sequence number data at the end of the authenticated data.
> 
> While crypto_authenc_esn_setauthsize() already rejects explicit
> non-zero authsizes in the range 1..3, crypto_authenc_esn_create()
> still copied auth->digestsize into inst->alg.maxauthsize without
> validating it.  The AEAD core then initialized the tfm's default
> authsize from that value.
> 
> As a result, selecting an ahash with digest size 1..3, such as
> cbcmac(cipher_null), exposed authencesn instances whose default
> authsize was invalid even though setauthsize() would have rejected the
> same value.  AF_ALG could then trigger the ESN tail handling with a
> too-short tag and hit an out-of-bounds access.
> 
> Reject authencesn instances whose ahash digest size is in the invalid
> non-zero range 1..3 so that no tfm can inherit an unsupported default
> authsize.
> 
> Fixes: f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")
> Cc: stable@kernel.org
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Co-developed-by: Yuan Tan <yuantan098@gmail.com>
> Signed-off-by: Yuan Tan <yuantan098@gmail.com>
> Suggested-by: Xin Liu <bird@lzu.edu.cn>
> Tested-by: Yuhang Zheng <z1652074432@gmail.com>
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Yucheng Lu <kanolyc@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
> changes in v2:
>   - move the short digest size check to immediately after
>     auth_base = &auth->base;
>   - add Reviewed-by from Eric Biggers
>   - fix the stable@kernel.org address typo
>   - Link: https://lore.kernel.org/all/cb1188757edab9b056961d4d2441be009ac73ce8.1775217403.git.kanolyc@gmail.com/
> 
>  crypto/authencesn.c | 5 +++++
>  1 file changed, 5 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
