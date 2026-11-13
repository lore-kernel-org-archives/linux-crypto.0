Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559101;
	b=4JeH1CNJSlkSMihlW8uItxwmS+C+SHwD7Wj18YZECkahgYuR3PkmFS4d9MrNWl9Kl/Yp
	 14khL4Fo2AH2i7/0CM1cBmmezLHD201mIC+hxfdPh/+FO/d18aYX9Iqfm400hwSHiLXvY
	 vhrxRT7R/dv+HOJ4DiUWi+GA94sGDNJo519FxSbr6CI7UK9RIRdt8shgckMv3yiyowpGJ
	 d7q05RZYpJmCugQ+SmkVKS13mtvIJvF2OBEPWrbIh2Pf27GCiCQCalLJYJB4jC/L8bxti
	 1BBlMhChQ16Z6TIp5CinTc4ecT+riPsNeBL0csdaqQb4AUb8A6bv2ZTvCwqa30beB1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559101;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Z8H1ERebjP2RXK3he+2YJGCCuG7qOsVQGPn2ri15eSA=;
	b=5b9WomyYidvzHfBQ4mmkIlo3tnaRWElIbzdzjponjpzzFUzAF+nkk/qohYdPLHB3wZxf
	 0MsB4sGuiAPBoWZdZHgb7gIBHGuH20nkvtPar5fZMVRmR5UtxkoyM0Em9f73hTFZfOU6u
	 RsuG7EzdrNofy3Gz7nUWTW6Uc97VwQllrtnBgMkJev0agNEf9l/onfooSeVbR3phAW0Lx
	 SEOmPa/zqwKLUardsiwFtFhLPzksYpTZkSkGL73vTXfi40wi1byW/qIcHGZdc3IDAu+Ca
	 FSblbPLFHGSWlxVppzAoK+w4//m0mPiiS/1cqEG758Cv2trV7aF+VayX6s0MbzuXPmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipa39j3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FEE606A323;
	Fri, 13 Nov 2026 08:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipa39j3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37AF1F000C4;
	Fri, 13 Nov 2026 08:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794559101;
	bh=Z8H1ERebjP2RXK3he+2YJGCCuG7qOsVQGPn2ri15eSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ipa39j3Nt1b9jdJ+g9FXN8S0Vki+y1dvum9J2NcOKWKR5P946drWQjBQn0UOnpi0c
	 /ongj4ZXGlvxjbrzayI5/uDa6ioK8KdHggI9y2Pw8wHLzWA9lTQz2Bkb8sKO8CPaLI
	 yK4bgyfo2dn1RhTDmMXNq/7k7wDTvw+bT6zesnIOW9SeS+tCEdnTno8csZ06kAL/Zu
	 4yfJjJmy/3Sm0ZsfpTzRSyQOl8kUyoDYt51SoAbKEeHA6g49Pz5RKpYo903SUEa3jL
	 3tgYm1hjB4vpmBa9SEG/owZXzGBln5eCpBLWCgkScSHUQS6v+4u1VxEY/xSlcUXhEw
	 bYKCasxiNKbHQ==
Date: Fri, 13 Nov 2026 09:38:16 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: Correct Shikra QCE
 compatible hierarchy
Message-ID: <20261113-belligerent-annoying-wolf-86916e@quoll>
References: <20261112-shikra_qce_fix-v2-0-2ce112cc2ccf@oss.qualcomm.com>
 <20261112-shikra_qce_fix-v2-1-2ce112cc2ccf@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261112-shikra_qce_fix-v2-1-2ce112cc2ccf@oss.qualcomm.com>

On Thu, Nov 12, 2026 at 06:21:07PM +0530, Kuldeep Singh wrote:
> Shikra QCE requires an explicit core clock, while the existing
> "qcom,sm8150-qce" fallback allows the clock property to be omitted.
> 
> Shikra follows the same QCE clock requirements as QRB2210(agatti).
> Update the Shikra fallback to "qcom,ipq4019-qce", which requires the
> core clock to be specified.
> 
> Fixes: 45834ff95a6f ("dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine")
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

