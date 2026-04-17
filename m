Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A555537C920;
	Fri, 17 Apr 2026 09:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776419241; cv=none; b=hdnXwKWcQDmfwn7GQdw6dD55xG7vmoErvINWk74apPHuyCGBkmQJXzeryyzDAVd1Phh/VL+wNVFrmH6XzZkOmkeSPmxXFMagn0VueGUx3n3ULukibGourwnJLHVaXBJMnBMRtsfrCBOX9eXGdbok3taxKUvXcUQH4IMuFVrb3NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776419241; c=relaxed/simple;
	bh=ipvPurGlzUqzc+LQJsObT0jUXXsIFgJdtIEg+46cJVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzFfhetUnwotGCrRKN9gTIvNK9AGURpFye7NriXK4Vkq74tJ+cwu4G5+O9qdxgDkmSWMm6gHWRsjfNUpROpaU15UmoyfXwo/Dh/OcMnapj+jL94N305ieAuSWt9TSKNt/wByqPFrxIdEYl6mcExqt3H5PE4vZtJsy3oNkUAw/gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=trb7fFh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="trb7fFh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97D7C19425;
	Fri, 17 Apr 2026 09:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776419241;
	bh=ipvPurGlzUqzc+LQJsObT0jUXXsIFgJdtIEg+46cJVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=trb7fFh46GPTuzixb7sdsN5O03ribcLsjIQf4E4hzGbreLXvVOxW/XgzwQWBlXc7f
	 K4DQ90SOel8mcu070Q8U+IgQpPnHh/Hua5n/K4xHUkZKn5BXyyKiGtV0WSO9CqXQ8+
	 FDCw5C4kw9I3cMBIofx2ESXH73XtiNUl8l5icnck3j647VaBw1Yasl+SeTTogljShy
	 42VZPerg/rYFl4kOFEnRa+iM8qmQ2PoDifqbo6M7ntbGEZuLc+dA8U76B5G4NC7od4
	 U4/Hc5YbEWHDJoU3WCRKNqVZYH1IN0uSnH6FpgBWgwGsH6i0HYtzH2swxMShSTmt11
	 ouhkj6TpWVZig==
Date: Fri, 17 Apr 2026 11:47:18 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Document the Glymur
 crypto engine
Message-ID: <20260417-portable-proud-dragonfly-6bdd9a@quoll>
References: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
 <20260416-glymur_crypto_enablement-v1-1-75e768c1417c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260416-glymur_crypto_enablement-v1-1-75e768c1417c@oss.qualcomm.com>

On Thu, Apr 16, 2026 at 06:37:20PM +0530, Harshal Dev wrote:
> Document the crypto engine on Glymur platform.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)
>

Poor commit msg, but none of previous patches were doing it better, so:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

