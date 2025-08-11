Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1151624DD;
	Mon, 11 Aug 2025 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754923733; cv=none; b=KgYSuvhjxtcgnIoShTsVGak2tvhZpkR1MLgQ0Mp/xh6Oslopv862PuI9/lOMsW+r4AUg+lL5c02H//87KOEYHZJWijNXVHiJQdLx83LjulMxmZj9sK6N3U4b6ZKGf65WfyszqkMGb70s28rAq7m2wbFnIjJdXGjpC9qU4Tuspg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754923733; c=relaxed/simple;
	bh=mQt2w0ZG//S0B9hwWMBwKv6N4PiPTQi9ryZgGoj07es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFSl8bNhZhEoYWc4JMviXX0sFGqaKPBmO4OqNDYhXJS/rmA6OqAqBaQxo5gnC5w8p/nihTdgpj5r7yw/YyWfORLL+yBodKohMLgf0zCvjkTBjjeXmVGg6XDXpEzQDGRzH6DPfxC1bYi4/F+wIMJpf3XCK3LP44/bt4A/tlSI1Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oX4elPmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oX4elPmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45D0C4CEF4;
	Mon, 11 Aug 2025 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754923732;
	bh=mQt2w0ZG//S0B9hwWMBwKv6N4PiPTQi9ryZgGoj07es=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oX4elPmPIOpeD2XHzeEW/jupl0j9mCSkrh987KVB6Ut30cFt59YanHU8ZKErzKcnm
	 0en0nPALWJt6UyraIHambC3cfku8+9AKMnBP9h/b5iRnaeVNuecWViz07qW4MNYmj4
	 ktRYMMWGIMLQoGTw/RVPKx/RXiPa7PJ4sl19nQE52N2qLNhqN4BDtceir16gR9QMqz
	 i7SfwFsHY1ypJzkB+Gh3i2dCcjf2kBSztnYE6ROSPk5dtyi8HPE7LGlNtRRjgallQD
	 ozmQMHzMqojk4U9iDwFHwT4kW/1OxcF7OhIr//oS3zxVI0w6is95bZWz7LoSOIuJv3
	 Sgn/pGPp8JIMQ==
Date: Mon, 11 Aug 2025 09:48:51 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, krzk+dt@kernel.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, conor+dt@kernel.org,
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>,
	adityak@vayavyalabs.com, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com
Subject: Re: [PATCH v4 1/6] dt-bindings: crypto: Document support for SPAcc
Message-ID: <175492373105.3051979.16817613723067435625.robh@kernel.org>
References: <20250808122631.697421-1-pavitrakumarm@vayavyalabs.com>
 <20250808122631.697421-2-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808122631.697421-2-pavitrakumarm@vayavyalabs.com>


On Fri, 08 Aug 2025 17:56:26 +0530, Pavitrakumar Managutte wrote:
> Add DT bindings related to the SPAcc driver for Documentation.
> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> Engine is a crypto IP designed by Synopsys.
> 
> Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> ---
>  .../bindings/crypto/snps,dwc-spacc.yaml       | 50 +++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

