Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B846B30BBBC;
	Tue,  5 May 2026 08:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777970390; cv=none; b=EoLlO3k3dv36E5VMhy3SBaRpm46cjJebKbJKOFAft5GWWBr4qhCl4PY06LYSTNmdBdZMFhgz7ykFq1+P0ySX2X52RhBj7Dlogfhc+/TIK+9vY3Xtai66ItTXlUl5Vz5m0vsEmE162NheRhub03d9Casox0D8KxTz3inYcbZtrv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777970390; c=relaxed/simple;
	bh=dKuChwLEki/gQfe+Uh62LUtAbPgqkpsVmbSgsiey1oQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bK2OJlRbitP/DbpCRB/fpjWP2D6H6/WJqXbQGUTRfQir6Yw1lMYINn3F2/sbOpDqjXbuwcuhCbtMSmc0EjzL1RXwz69f2Nfv7Zspi/feDecLPNlThmYwb9r6GQeIRecku0LNOzHdZWpv926dZ+RwpyCmOp4FsqcjCPeek0l15TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=puUOJ7bN; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="puUOJ7bN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7McYfRH6eJ2DgYYkJALJjikpP0bgmpputunGoevKJK0=; 
	b=puUOJ7bNOE6cc2MqYoaD1jmTUlKMI+Zbxs2hAuuRFhQdDUUfIlYJt21kxPgJnyNBahnWhF+HDLY
	UCMlQHp5Az5yCrY/LguXjiYpCeNxDbPN+wYgEPD226FZam9ptdTvw0ed45+0FKonkkz3/IpKQr9ax
	nFVqdpav83qttqdkfiP9g6uxmZYIindJs27/XTtWJSbUWnuzraJzhcNLRX86ex36Z1X8SfNvGsUDl
	pL3aEChH6N6AphfF4rYLqYZ50PYpPRIpajQlTkNffC7e8znki4OSIp0bxcJ2YvJjCVGM8ALB9RHn5
	Ftd8w84G0sRyGWsvpxzItQlTJJjhb78wI1aA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBJc-00BMw8-1r;
	Tue, 05 May 2026 16:39:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 16:39:40 +0800
Date: Tue, 5 May 2026 16:39:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Add Qualcomm Eliza QCE
Message-ID: <afmszNDRi9TtxQ5f@gondor.apana.org.au>
References: <20260407-crypto-qcom-eliza-v1-0-40f61a1454a2@oss.qualcomm.com>
 <20260407-crypto-qcom-eliza-v1-1-40f61a1454a2@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407-crypto-qcom-eliza-v1-1-40f61a1454a2@oss.qualcomm.com>

On Tue, Apr 07, 2026 at 03:51:42PM +0200, Krzysztof Kozlowski wrote:
> Document the QCE crypto engine on Qualcomm Eliza SoC, fully compatible
> with earlier generations.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
