Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B8014F112;
	Mon,  6 Apr 2026 08:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775465162; cv=none; b=RWH8XlZGROAfu9FeGyLDADGkjV2Ng03Qv2PAGg1Iu4c5wxtF+jyg9t+4lvXKbep0lxtOSu4/2h+grEpAWjGGKE6JRu+spCd5q9PGp+MOEf7o/ylqUBy12LBLpD8McB/z02o10bpkhgwfdXehHbrVRHVOtJoRDlnx/6KNg7k1EcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775465162; c=relaxed/simple;
	bh=IhMkaZ9mxzkCdkE0Zb6lttJZvYtR4vxUIre9ih4ttEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZryX/HaJUppixWYeF5XS78mUgJEJ7BdLn0/4h29I8YCfnltP9coEqk+tOrcQAqTFB2NT41x3ciyhX6E56XVGJlEc8d00435GrWsrQOGfnoWyMFDtnVIh9IuxfMHay/1Gix+fj2TDLtELoLLYSYUrwiWBgK4GSZABVHHW3GCTA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUOvmWXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUOvmWXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ED1C4CEF7;
	Mon,  6 Apr 2026 08:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775465162;
	bh=IhMkaZ9mxzkCdkE0Zb6lttJZvYtR4vxUIre9ih4ttEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cUOvmWXi7ArWYvBSRYXwMhYW6a4KN22FMusVzVem9nR9egGHcm7FKDbmbWsLWFopH
	 c6bxPGYhS6itzuGobADF+Yu7ewVY9xlkR5kab+bpKKxr5UqIE2ox3odTKrFiZ40Ut0
	 JKoUePPLSjpWVayVQulSEwox0FZlr5oXMqXFhVt6Ve0kqOigp4409SgH9VIQ3+yUQa
	 eltWhIw9TKLqIp7L+T1IHzZG/VDSWSJUttC3Ymd52bsE2+HqrAKZMmIgcgfCpMg8uk
	 /RTsQ1ttQ1HKFcBYUtrS0FK1GIWeLSoSZXvS4Bv+a67+FZ+eb1X3KC8eNWno1d4E+z
	 fB/XL7nZL9xFQ==
Date: Mon, 6 Apr 2026 10:45:59 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Alexander Koskovich <akoskovich@pm.me>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Document the Milos
 crypto engine
Message-ID: <20260406-smart-cornflower-pigeon-f7dd22@quoll>
References: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
 <20260405-milos-qce-v1-1-6996fb0b8a9c@pm.me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260405-milos-qce-v1-1-6996fb0b8a9c@pm.me>

On Mon, Apr 06, 2026 at 02:10:07AM +0000, Alexander Koskovich wrote:
> Document the crypto engine on the Milos platform.
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---
>  Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

