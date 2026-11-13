Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575155;
	b=G6WOsjoneCPZjF1DPBZi+Cl85dWLZqTuPIcdaFYou2M8yvFfDZN87EWFGaia/opdMOIM
	 40ltafBaDIZCXAtqIpcSekr4DDZ0XyAyBdCfUaQ6MkY9Uw6y+Z6AzgBvC6BLnQKj5ZnkS
	 2wXfR+tJRoRwsYlOuygDjnN/FWy4EwmatIqpRameTYl4mYTahZShL6myo+4vd/sthg6m6
	 xsvBjACmYQ9mdiWa08F8ITlFgDVgQ1UZlRano4vLa4K5O3BN+bUGBA4nHRSBaOt6SjgTR
	 H6OO1MgJiRhLga55RA9JF8DlnM8tyYEqCTEQpepT5b8y5k8DswiAIuLlNukNodNFg2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575155;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=FVDzsxmUEnHwRtuOV8L5IoxD2cqSvihc/QbmdFS5JZs=;
	b=aP0m4jOdqUHbmHw0jFOSfT9xjOsve96U4M8DAmdmeyF24fxsm2WH965Vl4CX6X67iRoo
	 05z6AcSyQ1844cP2Ax0aPuyxl9qGxy86WEmiADdno4uLUlT8/PhtIwUHNypb2Iol1ZsCn
	 oC1sYuaM8chcH6ZHjQd3gQf2ctleGMzTKHijA2Sy8SzcBszeGwUmYzZBYZCrtNEb2Recy
	 ikzHCU0RQ1zTOB+ayy+xzHVRRRCvpI83U83Rx09JHG1351c+zsxJJodeDwbeL6avwsnoI
	 lhKotz40hPhnuZIMxcoNCTDwEsqw+taQhGzVERrkMnEYHTqYPYR/z0KLcdn/Q0QGHZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="einhoH/k";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F44760A2622;
	Fri, 13 Nov 2026 13:05:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F44760A2622
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=einhoH/k
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FVDzsxmUEnHwRtuOV8L5IoxD2cqSvihc/QbmdFS5JZs=; 
	b=einhoH/kd7Jp9JcO7J7FwQwyrJ5TYLcAv+wL51Z0TquFy5XBvpenh5iGm2Y6cxFFRAq0AKjhAMs
	cQ4QDY9Id7wC7MW8cHCkNsAOQPhTHW0oYDdRG2fw9GAsQPAPd7p9S1nLt05AuWelZJ2NcM9VoeWoi
	sfJa7PpdSmwadPQG7QVts6XuHVPbLHcZ3u3BSDsmXmTm3WWNeOPw0rLfJCIoGFPLMRc6irdTIcg3x
	s9Gz2/Gu3EriH9/YTLuUcXi3CB1jFghxikFXL0kqgO/GjmQuW146ll1q5unWzlLLEjs4FNzL2CnmO
	j2tzg2QYSWXUoW5+N42C29Hb8RbITsC8BBCQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqyV-0000000EfHr-0UcH;
	Fri, 13 Nov 2026 21:05:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:05:51 +0800
Date: Fri, 13 Nov 2026 21:05:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: schalla@marvell.com, bbhushan2@marvell.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2 - Unwind allocations when AEAD
 initialization fails
Message-ID: <avcLL-4XYsMcrziE@gondor.apana.org.au>
References: <20261103064248.1054181-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261103064248.1054181-1-vulab@iscas.ac.cn>

On Tue, Nov 03, 2026 at 06:42:48AM +0000, Wentao Liang wrote:
> cpt_aead_init() allocates a hash transform, descriptor and pads before
> looking up a CPT device and initializing the hardware context. Failures
> in those later steps return without freeing the earlier allocations.
> If fallback allocation fails, the hardware context is also left mapped
> and allocated. The algorithm exit callback does not run after a failed
> initialization.
> 
> Release the hardware context when fallback initialization fails and free
> the hash resources on all three failure paths.
> 
> Fixes: 6f03f0e8b6c8 ("crypto: octeontx2 - register with linux crypto framework")
> Fixes: e92971117c2c ("crypto: octeontx2 - add ctx_val workaround")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  .../crypto/marvell/octeontx2/otx2_cptvf_algs.c   | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
