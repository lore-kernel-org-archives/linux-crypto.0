Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD6D1E9B3D;
	Fri, 31 Oct 2025 09:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761904054; cv=none; b=NqRsIkJlpCEEoNS5ob5XMTRKRBPe3LZxsMB7jx6oUDgOTwnFFiI6duVwpVnPvywMV5SrV6zbGnvmHx8Ny1LYwMqr452NOAsaLbVJLo4vudDaKuLhyKoxb/RfNVPmfLi+hYg1ELEQtpFGc6LcTLHqF9rkVTMOGdgpkC4r1lRHTlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761904054; c=relaxed/simple;
	bh=Wz8MfVn2WwENYtwc6vDTuEODaIfIpf+/1gXSWOFt+og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlHQwDLt6+2aNBQuB8dW79YcNIqXcLGqdE+GcJZae4NMfQoCszcpTesFJai5UhZV0FXwjmOWxKeWLSxKda5dRdgW9S8nAqwRFE5BUKtC/kFyJ96O5ni6lTzCRKWK1ypt8ncLowb08ZGMMZ/GEqYTarGp1d5gk1lVHujTzChQYdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=P28u7znc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="P28u7znc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ly4SuTlAOensIek6oErVvXcX0MqcUOsqzRmSkeq3HQ8=; 
	b=P28u7zncgWYdfNrK3+LVhbutIWFCxgXQQwEb70aawBA7TSkDzluwHavbsmEs5gsAuUaqvC9IWRS
	cIDQB2oRdE3LIIHOk7Y+CQzh4dYGNvIG3CQnD7GNlOZJ+8fFrTXNN1zzn7gmQzMl7KfdcprCkXaV0
	91xHxRrwDXZzRuBJvi0UBR8d37JbtvkoZQCBbdVNlFB72T84mJM+c5+IpE0YsX28f9uS2nafUjBZJ
	Ew9B8zFiy0nUJhJWEgzPbsS3tnih0uDIX0ytfKJjM2XovpJq5F6wuAyXri0YxevgIjX+BHDfM0X73
	XB5FARxXrXxKcUJrCQoQquyk5dNG+KCzP90A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vElj6-00H1en-0w;
	Fri, 31 Oct 2025 17:47:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Oct 2025 17:47:20 +0800
Date: Fri, 31 Oct 2025 17:47:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: amd,ccp-seattle-v1a: Allow 'iommus'
 property
Message-ID: <aQSFqOte8wWUpOPv@gondor.apana.org.au>
References: <20251022230403.421699-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022230403.421699-1-robh@kernel.org>

On Wed, Oct 22, 2025 at 06:04:03PM -0500, Rob Herring (Arm) wrote:
> The AMD Seattle CCP is behind an IOMMU and has 4 entries, so add
> the 'iommus' property.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../devicetree/bindings/crypto/amd,ccp-seattle-v1a.yaml        | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
