Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB68D385D63;
	Fri,  3 Jul 2026 06:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783061565; cv=none; b=CgU6tYUiFHq7qFWFRCdgdfd0QAY1ZdB+Ob6IXntQt25wJHP1OByyUfJSmEMd/DL6wnNX8jg8KTQZu7D5ovhppOFF5E2IO4fayNZnJQ2HLMvAVYbLyPoXGNEX35RrMH42iObY6PNAefWkZmRjfQ1MdDx4IhwHPN9GpgA3erJl8S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783061565; c=relaxed/simple;
	bh=j4zeBYEk6AdN3w3WBA5uTjKldV82rw696McSL48GiRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAbWxsycW7vUa28W/vvFNJY/t7kZZTNO6uIQK4myF1VFlbAM4BKNgyC7VPdqz36E47rVPzoDRAzQnDbnfqMwcoO05fWAnUf77rnJaKh4qG6tkSwCMozbUGK8fOVJIaoh9DdeAlaPUEvHcIis/k7cTEWXcVMUz4mkf1AS6tPVev4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JI8RFA8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JI8RFA8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735731F000E9;
	Fri,  3 Jul 2026 06:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783061564;
	bh=3xo++qHEqGIUBQYvXRJKLBHYndN7pXOoBY1fRXbYU2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JI8RFA8+SDAhtvVN2+7KEZIWIKVy3faSh9iT9ME0EXSCqyi3XSsXXsJ4RmUYwAc/z
	 bV/8dnoJgREBM65rL8idQeLzZ3Y963iDGI98nECqvRxWOgaV7uZmB6n1XgREZGO7/Y
	 bdsS2NhU10KrqblT0nwD2U3gZcoSOpdR90FsVaB0BTITT2/Q8geSCHgme/qy+1A6jd
	 ZTVjLwdgqDnrJOvPJkDR+Jbl565lcZ66vjSKIh9DWoUhAzAhebU/GOfrzTJt4ep9LA
	 lErYGAcRoS6Wqnbq1fSm3z30cnNwHzY3x4TWo6ugAHYJPwRHYxbuVAHWqXkYQDNaBB
	 Qy/03BxIduaEw==
Date: Fri, 3 Jul 2026 08:52:40 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Harshal Dev <harshal.dev@oss.qualcomm.com>, 
	Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v2 4/6] dt-bindings: crypto: qcom-qce: Document the
 Shikra crypto engine
Message-ID: <20260703-conscious-dove-of-joy-e4347b@quoll>
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
 <20260702-b4-shikra_crypto_changse-v2-4-66173f2f28b3@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-4-66173f2f28b3@qti.qualcomm.com>

On Thu, Jul 02, 2026 at 01:47:14AM +0530, Kuldeep Singh wrote:
> Document the crypto engine on the Qualcomm Shikra platform.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

