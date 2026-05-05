Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9EC26C385;
	Tue,  5 May 2026 08:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777970156; cv=none; b=UUJlPz5mbn5MVXhb1hlK+Nlj5pCp7wgtzNxpmEEroKESllatpNu1e7BH1wIhQx5F74czQDPSGiEYriTIwKVxl8s/vN/OFroIaV96IXVfx9vfk+neuk+Z85mOyQ918se22rjFMpd2+j+/2ufYFCNwONXD74thVwwHbcc1hjUFmOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777970156; c=relaxed/simple;
	bh=UVFvTJ8MwWHuTCMuhV4dwK/WduDmYAHxDvPVDNyfkTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGiXZOoGgHEKzt4DWJMdfYLLK+P9q6/pJHbiTUwVYXWlTfg2TLI85gWTmouko27yYJAb3L+NmZvIMIG97wirp3hzz6+TmIXcLwEUVfKm3ikJPaJpLOppOzZFZVEpxgz7chO2uoCq1XOwcahOZ1XO9fDcOQNoRhLDPkEsZS/ngxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZE/MLmc2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZE/MLmc2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vU/la47IIa+SNd3yRLMFm/aP6rA6Cv3MN0EW4XfhWJY=; 
	b=ZE/MLmc2mbPjbIMDjqbfwwIC/ZdgsMaPtVeEyi66hApc7SP66YGjEaBccP7OMOT62PSZrYMBlFL
	djJLjaL+YW1PlxRjBArTxmuxECWs8oht5WsgI9GL9g4ZMsXUQZds96QzIDycDKh11dLW+JSG7pn+D
	wg1XVoQk1VETzjGMk25/PWR6dN/fVFqAZT+bljbi3xLMEulND3AdZDP4ZrGg/Cj8siYyHJBSxVrwM
	XYXX12zCMugLvJL+ITnb9KVEwMyeW7EVBIWuu8Hr4DmTOB89XvuyaQqiWVq7SH+w23725iGlHsu5j
	9qdP4EvN9numQGecqor/Kktmr5j79ABScXbg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBFk-00BMtQ-27;
	Tue, 05 May 2026 16:35:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 16:35:40 +0800
Date: Tue, 5 May 2026 16:35:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexander Koskovich <akoskovich@pm.me>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Document the Milos
 crypto engine
Message-ID: <afmr3GiYbM0sYfDp@gondor.apana.org.au>
References: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
 <20260405-milos-qce-v1-1-6996fb0b8a9c@pm.me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405-milos-qce-v1-1-6996fb0b8a9c@pm.me>

On Mon, Apr 06, 2026 at 02:10:07AM +0000, Alexander Koskovich wrote:
> Document the crypto engine on the Milos platform.
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
