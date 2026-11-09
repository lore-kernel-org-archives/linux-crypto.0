Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794230373;
	b=SABEB23UgC4cZ6DSveEjiKRap6hxgcdKYUtpHpjummopMQZeLuSWsSZ7wHKCUdGDR4UM
	 cRwhF/cehqIwK44e/GGVViW6s2d4OdQog4sa8kIUlkMvCmE/NWkytjTaVpd+6Eom7lvbC
	 8OQim42bacx62t0d/4T8KBAAdWkCMGwA9B2uB8yo2brE8a4/Ph4M6Ij4sObDWy0/HSSVX
	 KB/+ZIIxExaSBRYd8Y2nt9sxetVmxtyteIXZHWBGhzeiHID9VBXKpO2P0hzOZHlErzfC1
	 eOGNF5s4kRcMI6RblVb4uDXqE7gbV8L4inGqU+OboIub12OApWKVFjYZ6V1e+5EHq1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794230373;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Uv5bO6AUKJsHIPdwpCyD14HCM2d7u5JJeW1iJ7y05Go=;
	b=IrOZANetdq1LnhmOGlBAc5HhBkQkVTaeVohUS4qeRgbdcbHfDHZFn2Uqz8FJUqsLvDYV
	 IMXaIOvhT0eOjabWqjcrB3EGx0VaowlQLaUN1f7mJqd8HA/zcrvIZFXSWiZFIwMLhwUes
	 4MSTd543F3RrWDmQc8yKZF6KRgDdQV5z39VbzlEpCkfiZxm/6J/O9pAwQ/GvOosRSmMw/
	 mES8CwOw39QqhJbWsmYhsRKY7cflABy5ICdLLiXisVLQZOt9jMFZjNrZY4StKRX4aAoA2
	 6sC7AFYG2UZlzLNGIAWNWlbIjoHoPSr5AFcj/SxUkXTVkQrBig14sOXaNIJ3idGuEFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HXFEuxO1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B73606A31C;
	Mon,  9 Nov 2026 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HXFEuxO1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832431F0089F;
	Mon,  9 Nov 2026 13:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794230372;
	bh=Uv5bO6AUKJsHIPdwpCyD14HCM2d7u5JJeW1iJ7y05Go=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HXFEuxO1iviPKj4y+W2QeyM8UemUDAKPU+dMccpBYqxAqYS+EMfrxDzmzUetlwl7F
	 NrXh+o9u2nGMVC9OqH+LY49kVLO7hMHHpBMNbXUdXlBchaBGSGgVLwEcCjypgSpG2f
	 rE+1aaRH5ckRAPETBAiu/sVr4H+1xH0V+HZQLnWftgcS+Vl5A9kHCfOCktbuZ30JNC
	 T823VhkEKYUtsV9ssJwRlQCsDcvw5iRJ/yNHsLqeBGT+b2PpkZLjWu0uKNZ5GZv8L2
	 7BYmemoFNhxUsIT4OhSoFVvxSo4zAL1HBhCHTXGhDEqwemBNHX/JhKM+A8L8OgoPKN
	 c6h1/QbcGYukQ==
Date: Mon, 9 Nov 2026 14:19:28 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Demeter Barna <me@fromdisposition.org>
Cc: Abel Vesa <abelvesa@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 SM8350
Message-ID: <20261109-tested-finch-of-trust-48febb@quoll>
References: <20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org>
 <20261105-b4-sm8350-ice-v1-1-f55e6ea8e1ca@fromdisposition.org>
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
In-Reply-To: <20261105-b4-sm8350-ice-v1-1-f55e6ea8e1ca@fromdisposition.org>

On Thu, Nov 05, 2026 at 03:29:30PM +0000, Demeter Barna wrote:
> SM8350's UFS host has an inline crypto engine, version 3.2.0, with a
> hardware key manager behind it, clocked by the UFS ICE core and AHB
> clocks and powered by the UFS PHY GDSC. Document the compatible and
> require the power domain and clock names for it, as for SM8450.
> 
> Signed-off-by: Demeter Barna <me@fromdisposition.org>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 2 ++

And a comment "do not extend that list" did not ring a bell? If you do
something against clear guideline, at least document why.

Best regards,
Krzysztof

