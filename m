Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AD736492F;
	Mon,  9 Mar 2026 07:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773042713; cv=none; b=keGj3sPcnjZ9c+/6KDA9gBnzNLzz8n/M88u42oL7q/Ym8J0YsIY5cmIRT5Ofh+z00K790idfif1iKKcU6NPU/bDFheqtpB/fIS+cAUvykIhFarCOV7ys3305PjnT0czAThK4aNpOXwqmmzHKRfG2bsbLJIgoKRG0A17kfA2H658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773042713; c=relaxed/simple;
	bh=VY8UI4kwRStHjLQuzei8w8SgS6+okNyaVN4M4QYvoSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sOKOv+dSdg6Yha5D4DGY08+V7AaadlZiZLlrFyRYgE3JG/cZN2m5pOV9Bm3YbDKxPrwvdgKDCXkIQm+6neqhITWExrXB4wuCiWxn5KRmKQcwOUwB9Jnq1kv3ss7ocaG1LcNnMBFEMBsXxq/ttKGuUGiOXuWwashD3O0sp+RuUfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q04OZdF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q04OZdF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65D3C19423;
	Mon,  9 Mar 2026 07:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773042713;
	bh=VY8UI4kwRStHjLQuzei8w8SgS6+okNyaVN4M4QYvoSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q04OZdF7gxzSBkpqNgOJRT7USDOxJ/gZ+hMI2lCCevuV1KdPAnrhqjwLWSTbQANag
	 q8tY136SzEGrlRNTmEVPVggF/Prb9LKruq5UZW70beh3tRghTjmAoAJ85r9J8lby28
	 w69EP+AbV5iYCNze6LirTF44ixzIkTodxpP60f47bV1SKi5hKeQ4VMCP24buoEVBPi
	 fvy6aRb9q4fCZZ0xfranzee0D4ttcKYTmM2QJcXa0VKH/nZwm+JmSPNFPfpT9w+J5j
	 TXwKjmpBiVkYMHWfSvs/SsAklF1Kk3Y4ts0Reotpdde0QNT2n7x2y5PIuEWnYjp/Ek
	 MFs8DTJes4lQw==
Date: Mon, 9 Mar 2026 08:51:50 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Alexander Koskovich <AKoskovich@pm.me>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: ice: Document sm8250 inline
 crypto engine
Message-ID: <20260309-smooth-angelfish-of-popularity-05efd6@quoll>
References: <20260307-sm8250-ice-v1-0-a0c987371c62@pm.me>
 <20260307-sm8250-ice-v1-1-a0c987371c62@pm.me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260307-sm8250-ice-v1-1-a0c987371c62@pm.me>

On Sun, Mar 08, 2026 at 04:49:00AM +0000, Alexander Koskovich wrote:
> Document the compatible used for the inline crypto engine found on
> SM8250.
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Please fix the case mismatch in From/SoB (rather to lowercase).

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

