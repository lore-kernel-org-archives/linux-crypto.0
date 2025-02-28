Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B0E1C5485;
	Fri, 28 Feb 2025 21:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740779200; cv=none; b=KjoExDfOoUhsD43HyVoKZ9AhhWVRVOp0nUgaLwz/6S7DMzi6EMeuXppxDA4xaVBPeAUqCc3P1p7tjqiE1ZRHWXtWS92MLAFFX2g5O1FhZaw6jRvQX+4KqVQ01UY0dffMrdGA5SEBpZfKVMZJeRXeMb7RvB7/1FWJv0BMdT9pZFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740779200; c=relaxed/simple;
	bh=b+Pt+AbLzMd0xbimf2RiCDW1M8COrQ6cRLlcBWSh2xo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKqBVdK8SeDu0xcTAPvQfZSmNcywy/8AGvm4+0a49ElU0IHcP8f7l+FvQ/Z8ooTiqQfvDYfdCUfSmyinNLnUMFbrlUnfjF11gB9Cv08Z02xup87tZGR3l6o8jnandb8Nke9Z2FFNnc8HBfSK85VbppJUDTywvaN2CZnf382YCek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gC42YTxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gC42YTxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB27DC4CED6;
	Fri, 28 Feb 2025 21:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740779200;
	bh=b+Pt+AbLzMd0xbimf2RiCDW1M8COrQ6cRLlcBWSh2xo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gC42YTxmw1CyImh8EdtvwuCwUiNVqoYYFFAaF5+/dTGL2079zCTbJ2wY7nSM5rzTT
	 BsM6Y9QNgO/pOpqFc8a72F6t9CmVbOJNrjfyeWVd0Ray3Os4Zi4LVH9Swpfq5hnjXH
	 lWts/FqCK/fZOe6AE8TcWAawNnDJ8oiP6s+Y8kZz9+qPuxeLuDGcI9F28AvChteQyd
	 jAJYhpRbFKXCBKllHWfL93pQC2bdBkcJaXp3QBIp5VmwGXjgEtbgGwhwhGZjGsVLxG
	 spFu/PDAe2znxi6U/FFA63E85yWnDfN7sFUXcLVL7SYX4CgxI3O+yan2ImadEfc86T
	 644URTiQxTq8g==
Date: Fri, 28 Feb 2025 15:46:37 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Abhinaba Rakshit <quic_arakshit@quicinc.com>
Cc: Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org,
	Konrad Dybcio <konradybcio@kernel.org>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: qcom,prng: document QCS615
Message-ID: <174077919741.3752280.13005036673756111786.robh@kernel.org>
References: <20250228-enable-trng-for-qcs615-v2-0-017aa858576e@quicinc.com>
 <20250228-enable-trng-for-qcs615-v2-1-017aa858576e@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228-enable-trng-for-qcs615-v2-1-017aa858576e@quicinc.com>


On Fri, 28 Feb 2025 01:45:54 +0530, Abhinaba Rakshit wrote:
> Document QCS615 compatible for True Random Number Generator.
> 
> Signed-off-by: Abhinaba Rakshit <quic_arakshit@quicinc.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

