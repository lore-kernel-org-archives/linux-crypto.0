Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC0C1E515;
	Thu, 30 Jul 2026 06:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785393370; cv=none; b=X+5eL8RuBh9VFemQ2Gax3BL7Uyp1/a9aLToRtdLax9TqVvegdkg6KtU6xx/SEQvkUvdcAH14OAruEDb44ffDKGMoxBSQdMrfGR2mE1MW9yFt89O/aEuKVjPwoeEF7rKkS6MpbnCuxpWEg9g/OqkQ9pYiwVH1FEbWuGjUUZfumY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785393370; c=relaxed/simple;
	bh=0BHfa9/esMOPARJ9h+TGO4/fIH9I0oB6kjngm2ERuW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g3zo4qNkZBhaVTHkXhQy3pYgkCdKGVFgtVMU+C2LNZyNghkW5d9forcGlxblRvkZNqhH+HETXVihlCVOEw6Vt6hNhLLOAwBn4Wae5EUrZnoJXuVUTc8vuB2JBGgvxeYF7/Q9nmFe7h2DtCRXtjef+SzOsC/8QRsZ5fSwvtTIsCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/jdMbXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/jdMbXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACEC1F000E9;
	Thu, 30 Jul 2026 06:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785393369;
	bh=uqfoNFBJ9FFItfmhvuet1AGsE8BMVfg5ig2Ih1eTV+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R/jdMbXJCWy/phffXtJHlICuOIIg7ky/c/jkC96VWiu7FVghB/4pny1Xt+pmFQZJX
	 PLV7Z/ZSy7Nr1/HnVIR2zt+QE6H+362ftcLx6ekmHrYN8dSYXhERXQ9apgBpA8lRaZ
	 5VfMYGIJ9mIRgimkwsOUjmv4mc2kJaXoW2REIVmggbBfObUPorx/3ceAhsJofwbW9X
	 VryNjHWmWIrE8zh7td87aHsVdpzjtp5xUJWH8RZ4mEDTYPUwfhDMhg5lLebrqNOBYc
	 yzWcClzW6JEXuj5qH7PSDdeGPeLOvH411jgYWarAolhMS4ndAVztNL4I0Tybn8ZWeI
	 wEkLuY9zKKqoA==
Date: Thu, 30 Jul 2026 08:36:05 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add x1e80100 support
Message-ID: <20260730-eminent-innocent-quoll-cb2d26@quoll>
References: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
 <20260728-hamoa_ufs_ice_change-v3-1-293c7c6c2ae5@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260728-hamoa_ufs_ice_change-v3-1-293c7c6c2ae5@oss.qualcomm.com>

On Tue, Jul 28, 2026 at 05:53:55PM +0800, Wenjia Zhang wrote:
> Document the compatible string for inline crypto engine found
> on the Qualcomm X1E80100 SoC, used by the Hamoa IoT EVK board.
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

