Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311567;
	b=myTG0hiGolm69TbPnGNTapebi7jT0Eo2J2l9uqdaVPhoZrsOOEZg8Nhtsup6K59JKZU+
	 19XTFvmIIvKYhIgSIYRjf9zOWdgmjiq3I+/TVMu7WNqFbN7Lv9PmDnOHGbgpWLYLMJCKq
	 U5UoC3lkBj8JbANzyaTUtOXegepCCdla+/9LOLAch1ghmTD3ew78n96SHvBk6n4AxTDfo
	 YwuaH0WECpoXFwg3VraAnGwu43kml+OV65t1d8QJ1hvgABc4uAE4aiSZLcHRJDDvK1SIv
	 8Yzr8ihQiVrUFq+/i76tv8OAoZu4PgvjNHV5dzwAaLmbIVbtJzso6w6NU1AZLuuA7Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311567;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Q+IkvQtL5ObOy+q62Xc96m74OgGtoWgoqKq4zQpvAZ0=;
	b=lLz1uVuABKy0R/oE4ibXJrpYP3D4bHt/WMhu78sRimtVU14ifoJlKB8d7YV1ArVHbXQa
	 RM2fcCEK8YK92UhdL1O05xg7XLCaVsaUBz1AqsW+L9vBPPmeWtirnN+iH+Xr3PblpzeHR
	 PuHkU6g5Eu0O/2Bur5MOVDjblvuWZtHm6hc4leN8KJabJqoNPQRWBfBkXeNUuzfwY0S02
	 QL4U7bs3HpEEJyU192XRtyq8Q9BH0QGXV0Ql7nxtdjIO9AJEtYt1zB7z4DuMJDR/bpQUZ
	 akxJ1qfIi9KQeIcIr5bnhRXV2MYVX2ZiBBd+ekXSjS1qFREH4X+hCZZaRtqykjNczIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DP8HkjU5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96235606B5AB;
	Tue, 10 Nov 2026 11:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DP8HkjU5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EE91F0089F;
	Tue, 10 Nov 2026 11:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311567;
	bh=Q+IkvQtL5ObOy+q62Xc96m74OgGtoWgoqKq4zQpvAZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DP8HkjU5T83IWyPjBkGBGk4rtnDD7AROqjLS347ksks61BqCyegrtofOXDOd2MLWj
	 y5v5LekEWgJIwdi8jcSVZSOfNh6DNLeRf0oEPf/qx0r2rhECckbAgQ26HUC+9Op824
	 TYWCdeeANpr3OrBAjhz4yPYln7Mawc17X/WCBA1PMuBGt0NlmdHwGEqMuCi+dix0x5
	 qja565LmnhO5EGUi7MgurfmPOlTht4sa9a0fKJzxR+zIOMF4yf3pZFrolv35TtX201
	 yu0bevNg1SHN2X4DU0xoVtcm7Zwier+QtgstMCRDMzA67VOyk+THdhPCTaOPcJMAJP
	 vRjnlElsnjGNg==
Date: Tue, 10 Nov 2026 12:52:43 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Demeter Barna <me@fromdisposition.org>
Cc: Abel Vesa <abelvesa@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add SM8350
Message-ID: <20261110-colossal-dancing-clam-1db0cd@quoll>
References: <20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org>
 <20261109-b4-sm8350-ice-v2-1-fd5e84985e90@fromdisposition.org>
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
In-Reply-To: <20261109-b4-sm8350-ice-v2-1-fd5e84985e90@fromdisposition.org>

On Mon, Nov 09, 2026 at 01:55:29PM +0000, Demeter Barna wrote:
> SM8350's UFS host has an inline crypto engine, version 3.2.0, with a
> hardware key manager behind it, clocked by the UFS ICE core and AHB
> clocks and powered by the UFS PHY GDSC. Document the compatible. Being a
> new SoC, it stays off the legacy single-clock list, so both clocks and
> the power domain are required.
> 
> Signed-off-by: Demeter Barna <me@fromdisposition.org>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

