Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575147;
	b=roL8IZMh70IJfLMumBlf6sAA/tqOFEwhH0wky7clzLIsdZLLZ+qcMNq9cPOU+TtmVi8G
	 gBjTZZDS9t8I+1G5wtcjPsu2Tf5GhIF377HXzVDuZlGju+amnk3pPVLU6p50LyTZrVyth
	 Svsl8796uXsxelWtyq1lS8V0g9LjSZN6rPIvw0X9WIIxtlUdGdoAc7lMqgO3pSChTXgLC
	 LMW/z+cJP08BXhh45e066qNNefuzktYKhkP+KARk2/+F7AYVAEExHs3EMTFVuqGQr3XWH
	 EoFOSZxxWOwhFSmR49H8Ouxa/3sezyVhVfcTaeop5o+XcF3dSCl3/DIBdoNVJ11O8XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575147;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=gWB1qkKto9QvJ0siCHQ2H/ugVW9Vh/3THgMrvY5+aiw=;
	b=PiluNbAx6YO017GRHm43U3qO8fSXjblBleSgGtXOEjm5Y42ozLuRwwEWbktdwubVz1yt
	 9NpTjAWqrDbK7MLmACTXG7xX9JYUsBJmvMbexEicjm/ViCxJVbiocGc1mtdbz9Lb0Dtsi
	 RGdxi27N6RcX+W2Iu6WgHSNSLMHEcDRLiaZXf9UwMlFx11fKtDnRyHm9n9z9SJQCvVafI
	 q9ICU7q1j3RdfCVe8JLDIfpgf31QlhDDKipjjtVf5rUeHS9njOJCV2BQIW6gqwkrx0hll
	 h2YCGA3HLCMkphUU+VfOfiI0D87E2mthxvWR/SJhSAzRupYwX944NAYXojyhwSa+8Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="tL37/ihj";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E165160A2610;
	Fri, 13 Nov 2026 13:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E165160A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=tL37/ihj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gWB1qkKto9QvJ0siCHQ2H/ugVW9Vh/3THgMrvY5+aiw=; 
	b=tL37/ihjSN96EocDGkrTkuWBsM0zCFTWVC2Jo4/2Sn9GqjaPmTMDTOaO7+QJrHJA0tStMIPeMkX
	gVNxYXsFP8wLu+Z8lX5cSEUkq/FxhiT+6y9YksEcwuKxXN8V2H/AAVcr1tiLGxyHCUn3kZ+9A8Dvk
	e56gMoKPNcQMcpNXCWtF90L9S3IRLmjWx/EuoajzQuc3j67t3nL2A+1jWRBlLJv2U0s7xKHLdQPop
	nB0bjdr5G4YXYvQtSkR+Xzbc60FLgEYjhTobLlzb/sOfdNhJ5bCWrdiE3/q2LzUoPZ0dW5JpHpXdZ
	Nis/hpyr9NPbzcrbEheS5hfedAY3WsCLLpWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqyN-0000000EfHL-2P0i;
	Fri, 13 Nov 2026 21:05:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:05:43 +0800
Date: Fri, 13 Nov 2026 21:05:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: atenart@kernel.org, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: safexcel - Unwind SHA3 initialization if HMAC
 setup fails
Message-ID: <avcLJ_U_h9CVr6lt@gondor.apana.org.au>
References: <20261103064030.1034291-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261103064030.1034291-1-vulab@iscas.ac.cn>

On Tue, Nov 03, 2026 at 06:40:30AM +0000, Wentao Liang wrote:
> safexcel_hmac_sha3_cra_init() first initializes the SHA3 context, which
> allocates an ahash fallback. If allocating the shash transform or its
> descriptor fails afterwards, that fallback is not released. The crypto
> core does not invoke cra_exit after cra_init returns an error.
> 
> Call safexcel_sha3_cra_exit() on these failure paths to release the
> resources acquired by safexcel_sha3_cra_init().
> 
> Fixes: 6c1c09b3dd0c ("crypto: inside-secure - Add HMAC-SHA3 family of authentication algorithms")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
