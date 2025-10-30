Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD6E21D3C9;
	Thu, 30 Oct 2025 08:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761811662; cv=none; b=klLEPAccRCDoF1SWz2slDtngRhBJxK7NjfhrdelXdrXDIejUwPCgdgDzw+4HsUdrshFrpwrbTnY+4BdGkpe+etxNy3WD3ZogtmduWQnpMlKFASBXyeh5qXfruTjS2M5Ow13qMBrZYbrqT48qXMjJ60Bh5kmSOfpMxP8JQQW/4e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761811662; c=relaxed/simple;
	bh=tx+9ONWz0erQeG73gAESo7zYQdNz6syhMPWKMFLR3HY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KepZhKC6XYm6oXR/RWRCWechd9mOkA895aqZy2BdIySFUF3m2dIzG366sYLumJZ4D7eYlYWHT9Fywy/53wiP2MPFBag3GUbtPf+EQj81u3oaMMIqx35FfkE6ax6WGBLEb7yjSWiJHzsKtBEvTGxgpHCXITHQPS5GrVqyLcn9r98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdZ6/68b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdZ6/68b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B13C4CEF1;
	Thu, 30 Oct 2025 08:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761811662;
	bh=tx+9ONWz0erQeG73gAESo7zYQdNz6syhMPWKMFLR3HY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EdZ6/68boe1hfp3PniogA58QBsx6NZ7FXz+dP33luyMmfrP4T6JGDylpGUUV+TmZH
	 Qu7NVCmcyvO+PY1OywmXbAiJlbvTeKcSQfHQEeEuOmCmEFcytKIzJqQoVUKyq/FDti
	 wvnTk1rYQoRZSc/A15VbSDgsyqb+o+C0GAVVm4i8aQulRZTDKDGUzW8+0d9ExLfTmD
	 9aqod/VD83bD3cQIyU6p0nsXdiAhCWrG+K9P9yckjC8m5OYJQBRNgHyRL0vFmEipzN
	 0lzwZQ/ENzM1z+agqQRWhybduybGxtOx/Sn15vkQiqoNpmjsGJYlkPO4cUaAYkEc/+
	 sQim1O1B5V4yw==
Date: Thu, 30 Oct 2025 09:07:39 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Harsh Jain <h.jain@amd.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org, 
	conor+dt@kernel.org, mounika.botcha@amd.com, sarat.chand.savitala@amd.com, 
	michal.simek@amd.com, linux-arm-kernel@lists.infradead.org, jay.buddhabhatti@amd.com
Subject: Re: [PATCH 04/15] dt-bindings: crypto: Mark zynqmp-aes as Deprecated
Message-ID: <20251030-wandering-happy-dalmatian-9cce2b@kuoka>
References: <20251029102158.3190743-1-h.jain@amd.com>
 <20251029102158.3190743-5-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251029102158.3190743-5-h.jain@amd.com>

On Wed, Oct 29, 2025 at 03:51:47PM +0530, Harsh Jain wrote:
> zynqmp-aes-gcm updated to self discover, corresponding dt binding
> can be mark deprecated.
> 
> Signed-off-by: Harsh Jain <h.jain@amd.com>
> ---
>  Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml   | 2 ++
>  .../bindings/firmware/xilinx/xlnx,zynqmp-firmware.yaml          | 1 +

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

