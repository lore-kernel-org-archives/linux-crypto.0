Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794230449;
	b=PebztCUNCbmT6whJwTk1ylvWf8yCwT3ywggD8x1yJn5cCUqAsKLbl2vwoPBdTqXZLcv3
	 0H04zZ9i/xdfKYP63VMoB6gqlMMmLO0YYIzZxGzjKomQYkh29iiKlPwy2Np3v2hGpBN4G
	 ofZ/5CTYlQ/+HPrxfCT/1Ma0auMXjQ/agvk+adk0lgyvyNjamPzgBppjXa+7QF5GPY9IF
	 lYn+O/+CDocI8vgkYjoJYmhHeLlxSOluQOErRshwKwtlYiLZHwy1tKRFWRopemWc/Gm5Q
	 6I/K9hpur0gRqzVm2qD/symxOh2NDbv3ieDziE3/WUOVg180h6lclKZ1Dz9YITFTQ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794230449;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=fbrWj/P7ReOH36vraQbqKTdB5cdLMUI0mnHZkL6w8nw=;
	b=HDUkH9fwWQMWnW16H3U9cIFep41ywW0R8dVQLY+DgpMNAYEI/75+mm2Hf8hbm+H9ocBI
	 aeV9GflNzsLE6z6IcHc1OLrA80CBitxYQgIy5Dm0P7OykgbufyM/2x+/OOKiK41wYZ4YU
	 aAFTMN78k7pI02Jop+rD3yN0HoCuIRPmnIHIcNAw8FeuUJTow1aR0rpiHN7pd5LE11MfT
	 ter/3lnxZh+vD62ZtyBRaZKgvfM19+Ht2o34H2IRq4DxajfrMEWQttf1G+IPynQLpDX1A
	 jfNhQPOa1zLAsXdpMwvI4Bc5kq7ZPPQLZlZPMoFap7EY7Rcv8fqDzkKTh4Bgw1PGHNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y60etLaJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7427D606A321;
	Mon,  9 Nov 2026 13:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y60etLaJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8321F008A1;
	Mon,  9 Nov 2026 13:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794230449;
	bh=fbrWj/P7ReOH36vraQbqKTdB5cdLMUI0mnHZkL6w8nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y60etLaJSMnZOF8w/mZbUSb5AofUw7dLgMTR7pwz52+5nJwCu+0K/lQUIQm9tLCkG
	 EGgZW3P77d7028QTbHNnMXqgZyBsEYy94vUbgJljQnMIffnZEPLWQZAT5ic2TIvfoV
	 iJQF7xlLK5KWjwAOsXHqNWaSUSSrDjHpqSxinwjbYo2ZunFu+/WIg6t0TM+VKH8+UM
	 +ISOYkh+354NA09jtlWzv011qCf5IGWMdCZ4aYfGYAhldsNpBRiJSdn/q31oRPEYC3
	 tlzyRNnaRWg022z/f56RlYPJzl+301XZYbUSBBP2kaOj4Gn8FFVl7bmVv3PEBooJJh
	 FICNhYksADSpQ==
Date: Mon, 9 Nov 2026 14:20:46 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Demeter Barna <me@fromdisposition.org>
Cc: Abel Vesa <abelvesa@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sm8350: Add the inline crypto
 engine
Message-ID: <20261109-qualified-cuttlefish-of-intensity-42ffda@quoll>
References: <20261105-b4-sm8350-ice-v1-0-f55e6ea8e1ca@fromdisposition.org>
 <20261105-b4-sm8350-ice-v1-2-f55e6ea8e1ca@fromdisposition.org>
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
In-Reply-To: <20261105-b4-sm8350-ice-v1-2-f55e6ea8e1ca@fromdisposition.org>

On Thu, Nov 05, 2026 at 03:29:31PM +0000, Demeter Barna wrote:
> Describe the UFS inline crypto engine at 0x1d88000 and hand it to the
> UFS host controller with qcom,ice. The region covers the engine and its
> hardware key manager (0x8000 + 0x9000), as in Qualcomm's SM8350 device
> tree; it is clocked by the UFS ICE core and AHB clocks and powered by
> the UFS PHY GDSC, as on SM8450. Without it the UFS driver logs
> "Disabling inline encryption support" and fscrypt has no hardware path.
> 
> Signed-off-by: Demeter Barna <me@fromdisposition.org>
> ---
>  arch/arm64/boot/dts/qcom/sm8350.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
> index 55b32050c..2b258c4b4 100644
> --- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
> @@ -1782,6 +1782,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>  				<0 0>,
>  				<0 0>,
>  				<0 0>;
> +			qcom,ice = <&ice>;
> +
>  			status = "disabled";
>  		};
>  
> @@ -1807,6 +1809,17 @@ ufs_mem_phy: phy@1d87000 {
>  			status = "disabled";
>  		};
>  
> +		ice: crypto@1d88000 {
> +			compatible = "qcom,sm8350-inline-crypto-engine",
> +				     "qcom,inline-crypto-engine";
> +			reg = <0 0x01d88000 0 0x11000>;
> +			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
> +				 <&gcc GCC_UFS_PHY_AHB_CLK>;
> +			clock-names = "core",
> +				      "iface";

Odd, your binding was hinting towards incomplete/legacy DTS, but I see
complete - at least in clocks part.

Best regards,
Krzysztof

