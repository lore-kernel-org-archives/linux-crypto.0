Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D571917C2;
	Sat, 15 Mar 2025 09:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742030241; cv=none; b=C5CFZSErMKFDboDb+o4lVIstPxRJTOGKos/gutQxAkJhlcQLxqsyDZLc1jO35zxG/l7ry2R10Qp8Zsb6fuVuGicRH80ncgveOROTThcwsZEZMGH3zKMajpQbnXQkrUHPOKWj2tqhgD+szl9egAZBq0dZ4yZNAijGr2Xt9YfZ5hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742030241; c=relaxed/simple;
	bh=xpxrAJm8/9b9TjpTPLkJIVfi2YBXRGoe5njVOof2qY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rvTsJ1Ko3tNaqvEYZTsXvmhO1KY+a9z87e2JaWDNCtOLXeYYNA+nLJmtoxMafY56JIKWtIntUCVoM6Q4ocdGsLfOboHOmf813GVCPWfaD4kFC1qbc4tgDvRXEp/2d8XKMOO7u69kyhH2dwix7qaUKPFZuoMeMeg/pTZfZJUwtOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UTvDL7Wk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UTvDL7Wk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mWS2HM3iT66S6iZKQryif4NS3GIsSrxKH5Pfjk6WkR0=; b=UTvDL7Wk0X/nkaOGoAgI5Eg3AG
	fWjdixU73vMSlXTE+FvzIDePaJRm5/12K0hgMfoCQC/R1CmPdR8QCqMGlhJ1MuP0hhm3hOj1XCR5J
	cu4aAIC7267vX1dCrtfEM4IKgnXS9JgbmBsJA86Nyc+B/kl9aZxJtV58KR2E8DgF/ASoOGaEnPM2a
	EOTrpkWpvMAPHAK9byZBnxusvbXJJmG2ryPNZmmU1KL0OYi+TLUFHPf+8cH2+Dfk0qY3qL7GOOkqr
	Lk7Ol8/BKU6ICLNoRhed3GG4VoRvfXFcNTAiVUS/8mrgcDRmQaYEo03NZ2qd2celX7zOsCVDK3zfO
	pEQcLlOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttNdY-006o8i-0N;
	Sat, 15 Mar 2025 17:16:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 17:16:56 +0800
Date: Sat, 15 Mar 2025 17:16:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: rng: rockchip,rk3588-rng: Drop
 unnecessary status from example
Message-ID: <Z9VFiLMFtzBMIAtQ@gondor.apana.org.au>
References: <20250307093309.44950-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307093309.44950-1-krzysztof.kozlowski@linaro.org>

On Fri, Mar 07, 2025 at 10:33:09AM +0100, Krzysztof Kozlowski wrote:
> Device nodes are enabled by default, so no need for 'status = "okay"' in
> the DTS example.
> 
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Changes in v2:
> 1. Drop unnecessary full stop in subject prefix after ':'.
> 2. Add Rb tag.
> ---
>  Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.

Please disregard the previous reply incorrectly sent for v1.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
