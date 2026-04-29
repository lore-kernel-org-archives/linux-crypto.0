Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D613E346A1C;
	Wed, 29 Apr 2026 07:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777446938; cv=none; b=AtLVpX0HjY0W6nVC79wBI5hJ0Hk4n3D3zsBqXuXJlZ4qi2M+3H1h1mmU2NIKeNzTKSbdUrX249sR0C9oRy0Ka4pQzx0ZRU5m97iRWYkV2dRVzuI75+TCeGvOZnuksAW2iqAlFtkDsRfy+jfksPzhpoBUa1fH03woo5Uc6mpsDoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777446938; c=relaxed/simple;
	bh=vf1qihwTwqTOOUiy6EhkIQH7P8j9MM0lYcgnvfXA1tU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fsmCMaV5Jq4acIbZ0eDq700rnkbkB/NFfwx+GlwzD3j/NZfHGlJNnKA840AAJIipr+7LONzuH9cRouxv8sdHBC0sphzFwiVvW02eh9VgHSVTHKTDCFCAv+wisjBV33ZZzP4usea6wUuaWuwOIUPX3bR2zDwKFXBsjzfJYc3NlIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ciSCCJOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ciSCCJOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF70DC19425;
	Wed, 29 Apr 2026 07:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777446938;
	bh=vf1qihwTwqTOOUiy6EhkIQH7P8j9MM0lYcgnvfXA1tU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ciSCCJOGB7qihqINk/tzhLMtVzc4b5EMEHN1hA2fMZau7CTINQUMOMNanTlNNZ7pn
	 hIR2H/dW9vRcIXV7j8RsCPWkPRaCJBiPwaIN/xWB/mcGASzP5yg3HQky4UKVNRxDdq
	 078T38s/WmcsPVSUuDn2S3qEmcL/FWZjM1rgIlyNjVArCDnQWUrKyTYwvjNNud1yDK
	 j7LSzRvCSbYANzJN16+Nelc48Mbx7s1z+boTVJByWYvXZSYaRK5udHRS1xjmdMuKHr
	 tH3uP8aJWcHoZWIulH7R7zEdH18Bcn8LImSXKL55918/qw3hgEwPWrPBmpQPHsJNwE
	 QH+JCBP3KILjA==
Date: Wed, 29 Apr 2026 09:15:35 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Dmitry Baryshkov <lumag@kernel.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Nord ICE
Message-ID: <20260429-important-panther-of-drama-00f5af@quoll>
References: <20260427010527.230473-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260427010527.230473-1-shengchao.guo@oss.qualcomm.com>

On Mon, Apr 27, 2026 at 09:05:27AM +0800, Shawn Guo wrote:
> Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC which is
> compatible with 'qcom,inline-crypto-engine'.
> 
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> ---
> Changes in v2:
>  - Improve commit log to make the compatibility explicit
>  - Link to v1: https://lore.kernel.org/all/20260420073301.1250197-1-shengchao.guo@oss.qualcomm.com/
> 

Same comment as for SoC patches - do not split patches targetting same
maintainer - crypto - into separate patchsets. It's one patchset.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

