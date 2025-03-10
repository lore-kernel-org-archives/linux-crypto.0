Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB712227B9E;
	Mon, 10 Mar 2025 12:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741611005; cv=none; b=CmdnQLm0qQTwO74b1JMUP1E8IVgFjG/Hcfv7asON4jI3ERYaRqXcio1QaeUP45Vc1iPrGeprXliy3PdR5q1QmLFbPGo5eb2l1sc2tTjCKX+MhBqZk+lunOIiU05ztO6nvaLYBaASGsJJRaknCy7f8toVVs8/JVDILCIfi9SJRi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741611005; c=relaxed/simple;
	bh=zhBiB0dgB7O3TDhkJEPyv1ZI/bHtlP6eiqaFOv0cAL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iO3ZYFMLqlioUTJM+pnppIambbAAVC17MSS6mvbWua11zcKu6NnHJYIow4A4npFiRwTlFWfgqSoNTMNmoavFKXonjDO9njF/uVti415dp1R7FwbkrZVVgJuObBQ9xit52vWShNiBvcq9zFXpjCa3XmUQ8H9gHg/pWE//teW5eZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6R/ivm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6R/ivm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D6AC4CEE5;
	Mon, 10 Mar 2025 12:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741611005;
	bh=zhBiB0dgB7O3TDhkJEPyv1ZI/bHtlP6eiqaFOv0cAL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t6R/ivm8J+eajKPlPheXHg3NJ+nHknblHvYwOY5VD+jluqi92qYai/5AEb7hvZpVM
	 6qRIzNbhzi+elDLS/ZWoc+wQzzco3VQkWAe2a83oG5ZYTh3VL/Ou1YXu5uJzFO0P6A
	 5salt+CCaB4l+qjAw/EY2StH239j6ZVGRBkq1Hl+aC10U1aTUlyDyedtmNIKugW+qB
	 LxKKP4IdOL0I0kAlvCh6oWdSzdQWLSFmeu0Dx5qxqOC1iOeNSpFM/OzbMNoh8mK5TR
	 gCdpbABDCFmCh3ozvjVKbxmONawMXNU1jT7PnwFHdpm+r25w6XjcNKxxPNWEsuE7y5
	 gEglbx/bG1i1Q==
Date: Mon, 10 Mar 2025 07:50:03 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>, devicetree@vger.kernel.org,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	linux-arm-kernel@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Olivia Mackall <olivia@selenic.com>,
	Daniel Golle <daniel@makrotopia.org>,
	linux-rockchip@lists.infradead.org,
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
	Aurelien Jarno <aurelien@aurel32.net>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: rng: rockchip,rk3588-rng: Drop
 unnecessary status from example
Message-ID: <174161100282.3880379.16414852796970978869.robh@kernel.org>
References: <20250307093309.44950-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307093309.44950-1-krzysztof.kozlowski@linaro.org>


On Fri, 07 Mar 2025 10:33:09 +0100, Krzysztof Kozlowski wrote:
> Device nodes are enabled by default, so no need for 'status = "okay"' in
> the DTS example.
> 
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Changes in v2:
> 1. Drop unnecessary full stop in subject prefix after ':'.
> 2. Add Rb tag.
> ---
>  Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

