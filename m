Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395489;
	b=0fJNgoHoqnF8yUR1r8nfSEkdeGeDceFx3HO4V87ZMik5Z0Lpo+shbjBHagRn37JGSoJd
	 3/v8S25Zm5mYiEk++JSRxsJJjFSZsEr5S3FY3loMZx46iVwZaHAFFGfiFXHjbuYHgugzU
	 25Xajmdiepg6XjtCTSysIsLrYq1QJCUqPMpqFyATnCnubetBVfBpnXmdWakHJ1b8fILnc
	 IovPQXLHJRy1I/1lV3B5s1omYnKERzTvBzQp2WbF24cXA6+tXlu2kymW8tSem/PZIhmiU
	 RECsOOVuHFgP3baS5jz7pvq213ldMuStq5K0xOnI3OgQK5jR8LDJaGxPB9A2CSaIL5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395489;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=lr27f7oJOgQb2Rbu6eqCK5yXG1BOvy4SNYG5xsOyD3U=;
	b=mId28QHMHI+bfVPZQPLOfLUsaKuaXZLCO6FQdUk9om7FYiydduUDXVX9Pjg2D4ZOSmZP
	 4zQPgIPqbr3JKDAUD3UywOuQ8yGRbfTEyRg48N+kEaaR5KdKnM0+VwZdYK6s9ssq1Bl4u
	 9srWmQmYPutb8Li5H2JVvvjZ5je0/e2HdSPWi5KJP8GObHRUTqSaEYw1GP3JUgps/7YTA
	 iCp+uunj7AgyARNWDM9NWh+804jsGsTq1MmrfrhMtG+KCI3ec5sWb+5XAc/DAFmLlLcno
	 KA4KpJbh3hVVNzSeqHAH9uD3Ei6MJqEHG4JhlP8VX37F5SEpEmeMqk1W0LrF5wFVLdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=DHTk5BqP;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7907606A8B9;
	Wed, 11 Nov 2026 11:11:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7907606A8B9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=DHTk5BqP
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lr27f7oJOgQb2Rbu6eqCK5yXG1BOvy4SNYG5xsOyD3U=; 
	b=DHTk5BqPIS82AKb1pcL16kDUbK2KBPoeXMbdrMy2z67kgxaWGeMhO43EAKF6tHis+aocHRkLDqN
	wZ4M2UwhBSSpyDT30V2eHdc8DO+QKUA/IAOGUNd3HEpbPf1nUKNrbq8zhvYC+wiFtsiUqQImsCzqt
	6c9uOBVshZWFoEtZgVBLPbT6WZHZpvdyZOBE714tgju7blsp5bdHEoDa20NU+nRuiGNg4khlL7+8l
	InUzDcnBnnH35PJjSWUQ2TERuDCpBIk2hniZqlgMRbKcAphk+nVxzpXJGOk4dLGW9aRVmW3bPz1qw
	2OdlaZrzAGvkloTviGFPulBTnLvTWAHH01zQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR6Ef-0000000DmQb-1R1U;
	Wed, 11 Nov 2026 19:11:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 19:11:25 +0800
Date: Wed, 11 Nov 2026 19:11:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
Cc: Abel Vesa <abelvesa@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 IPQ5210, IPQ5424 and IPQ9650
Message-ID: <avRNXY5Hxbjw5Szi@gondor.apana.org.au>
References: <20261021-ice-v2-1-3dfa8f343ceb@oss.qualcomm.com>
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
In-Reply-To: <20261021-ice-v2-1-3dfa8f343ceb@oss.qualcomm.com>

On Wed, Oct 21, 2026 at 11:19:44AM +0530, Varadarajan Narayanan wrote:
> Document the Inline Crypto Engine compatibles for the Qualcomm IPQ5210,
> IPQ5424 and IPQ9650 SoCs.
> 
> Separate the power-domains requirement from the two-clock requirement.
> IPQ5210/IPQ5424/IPQ9650 require two clocks but intentionally do not require
> power-domains because they have no RPM.
> 
> Preserve the existing requirements for other platforms.
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
> ---
> Changes in v2:
> - Fix sort order in the !power-domains block
> - Pick R-b Krzysztof
> - Link to v1: https://lore.kernel.org/r/20261016-ice-v1-1-4098b1972f31@oss.qualcomm.com
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 27 +++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
