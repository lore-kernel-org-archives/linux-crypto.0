Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1943793B3;
	Tue,  5 May 2026 08:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777970950; cv=none; b=uFkZyGFHr08SH97J73oJN7v8cFYpzZKV7GlbzEN+If/D8C6O4yVFQZzBe1EhOET9cOYw0CYFOrnD/cPPP5FrxM0Fr/9TMxODtqU93hxwiq08d2S4gS+JMYg8FzwUfV2QDAizfxOEP6D0X3bzcLIwZzkUF/rT86G8h3/wFNY6Jvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777970950; c=relaxed/simple;
	bh=wKT+37U3rbsxJbtJb6Mfp4K6YUpB+1XO060jkjAaup8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PoR13f4Q0GCVL6vcf44m+BwXcnMsJJKAUe5tDnz26GA2MZqTcwGlqiBdq9LDeeVThYIL0+p8S7V3mzvTBXkPIkDPOhm93cUt8RksWcTZA0NwWx/1TFRIlrQzYjQN7Ide4/OLV4uJfDImMgI8m9HSpi8L0heArDUBBU1axVxJEOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YLX0/Vp3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YLX0/Vp3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=uT3P4h9GhZoc2lPhylLaDJaPfgEn98NuABV4LIab5Lk=; 
	b=YLX0/Vp3aSw1A1EAsNC/3A3JC8ikp3HliZ/LqGFUdJi+1QeHKOpJ0elKw93eaGlG6UGt2OGcS0o
	4o++iLGomWIipOh+cfOLulNDo7rmlkdWqrv3Mu6L2qVao0UK49PG7kvRsjTZIzVrz4/yF9kprcjSA
	y2eZdaM0xQf9QN7drLseWqyphBahHLsF1IS9qq7jAfFAkUt+OtnwfJFTlSYDp5gLmJjvp5uicgcof
	30ERyE8tWwtp8wX8WG1HjH7vjlW9VfwNp59+AN/uF7gvXZ7az7YtkJJLGkG/5S+/qLj2gsA1jaNv0
	P61K0Fj00ZmEzgFCgzxLaY9CpB9VVJWdbl8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBSf-00BN6J-3D;
	Tue, 05 May 2026 16:49:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 16:49:01 +0800
Date: Tue, 5 May 2026 16:49:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Document the Glymur
 crypto engine
Message-ID: <afmu_YZtOA2QCyb2@gondor.apana.org.au>
References: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
 <20260416-glymur_crypto_enablement-v1-1-75e768c1417c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416-glymur_crypto_enablement-v1-1-75e768c1417c@oss.qualcomm.com>

On Thu, Apr 16, 2026 at 06:37:20PM +0530, Harshal Dev wrote:
> Document the crypto engine on Glymur platform.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
