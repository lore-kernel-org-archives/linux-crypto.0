Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA42D384242;
	Tue, 13 Oct 2026 06:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791873895; cv=none; b=gQfnmnAjBs0VFaPEuLYxVF4SUVRbZHq6UwPT746NRMQEft0747HjsN3paOjC3gzdl2Tw12cFTfum/K6iel5b9CT2H21QixNubMHg0mOW6qPU/OOwA/Q+VrOzapj3IP/gPX44HncjGnfXzUfSVMp+3rfyYmVcY2iAIh0JdpLABuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791873895; c=relaxed/simple;
	bh=rKzcYvUF0MTtrWzr8w21BcuSnYY1JHXhpx5c8qIFJdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IPBzDWsr78T0ZSXIgX/sdxTZsgEL4XYQa0aFGIY/MJbzF0PLF9Nc1oOuDW912IMSqYx0oFDFY9olkpWrV7xDbqjGquqU8BRoQQ08dkVgkSH+eiOMOoZZ+R6q5BeQtdrmxrvkDkxdAwPy/k+5UksSH3NNtkxkhKsQ2B6svn2u8us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTFgFvmx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTFgFvmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B99D1F000FF;
	Tue, 13 Oct 2026 06:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791873893;
	bh=GuXm5gBL1DdcdZs9QrDVPnY+/wBXXe8hkEN4rR1MOOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JTFgFvmxgAFrwjJZARatj6cTapS+RDW7uiPc/W9FPQOJSvUJZ0zeCY/OY9L9dOhmf
	 1JQ0AaEwMIIJGEtcLgZiKuo/3MTlVpRbLAItsrHh4s0xAVtPtqNhpRiCTS61RJdRHz
	 NuckPFDzgMzUctjA7szk121Luz7vPU2a67nSFoTB/rqfY8RTCAoyBSzmJs69a9reyV
	 A49OGzvjIYapJ1sbiqLthf3wgxCRdT6gsOBXtc1U4RO4xcm6Udrvk3LoDSf98OQaJK
	 vlMVEyHnv8QRuh79AIMXKY8QT5Jbqu7ULfoa6m3KebCDLcc7o4WhUhEhLxrCpnCZBd
	 oKZXQSq4I/PCA==
Date: Tue, 13 Oct 2026 08:44:49 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH 1/2] dt-bindings: crypto: Adjust Shikra compatible
 hierarchy
Message-ID: <20261013-pastoral-magic-perch-1a2e5a@quoll>
References: <20261006-shikra_qce_fix-v1-0-8ac54d81edb4@oss.qualcomm.com>
 <20261006-shikra_qce_fix-v1-1-8ac54d81edb4@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261006-shikra_qce_fix-v1-1-8ac54d81edb4@oss.qualcomm.com>

On Tue, Oct 06, 2026 at 04:44:03PM +0530, Kuldeep Singh wrote:
> Shikra reuses the same QCE integration as Agatti and should follow the

`git grep Agatti` gives zero.

> corresponding binding requirements too.
> 
> Move the Shikra compatible to the appropriate binding hierarchy
> (matching qcom,qcm2290-qce) to reflect the underlying hardware
> description.

You do not change any binding hierarchy. You are changing fallback
compatible which is ABI break without any reason.

> 
> Fixes: 45834ff95a6f ("dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine")
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

Drop, that's v1, so this likely did not happen. Anyway, your SoB is
supposed to be last.

Best regards,
Krzysztof

