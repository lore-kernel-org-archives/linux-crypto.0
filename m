Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208703115BE;
	Wed, 24 Sep 2025 17:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758736703; cv=none; b=fW3F0srKC29Paf6X9B6f6JCYIaC2HdpbCt4+/5K/TvCWjEHFPbb90msUxlWGfIlft846gpt7L4kb08b8uH47KPDLt/7DTeJPMVuI7jR5h5gLMZn9cga5loUaTBmCfahRfhBQUp8I+2ZrTk26gba48Ien5ATUq8v47YH5iFvE6OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758736703; c=relaxed/simple;
	bh=ze5dp8F8Yg/MczIfVsfrnieGIk/e6W8KaJLnoFbhkU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGkFua6YFtxjwNK4ytXM7w1V+/FERr/YPhcgxXNz6URxEExPb67oBjU2WRI1XO78Xv2XSUJnPyznEkNI8bkyS28d5J9onaQfawQKYzozzPtXn5pMGjT+7Sku1D32HD+Ud5ArwH1aGlPyD+7rujPbhaGk3lATxMbJ5DGnmmSgJkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ixi601Ep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ixi601Ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE41C4CEE7;
	Wed, 24 Sep 2025 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758736701;
	bh=ze5dp8F8Yg/MczIfVsfrnieGIk/e6W8KaJLnoFbhkU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ixi601EpbcZC2kA0AgRBOxgqkY+I3wYL6iFthigN9WWQet16kMLtti3VpmpvL9h0R
	 f0y12Y4slOZRsu7CldGCWDZUIcO3UCjCV3ErJCwngVD1BfoVIlR8zA2uWw1g9V6eo6
	 r1775D3EtF+D2kRja4tELWi1iZBWgagSqRqtV++JqeChnam9ZV/aXcvJAzHZ1GfkCy
	 tx1vPsprJ/7YFShv/OdORCrQdJiIavEQ+QeMvVY8kAE3L0mLjsh5GHhVFvVpqFywZm
	 luC7poaINIfRvmA3JmCVq6lI9dT2YK5UV2+NKiQQaDIHbCUhJdfLIZJtjdjGUTxZe/
	 Fgv9SjN4HerdA==
Date: Wed, 24 Sep 2025 12:58:15 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Kael D'Alcamo <dev@kael-k.io>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: microchip,pic32-rng: convert to DT
 schema
Message-ID: <175873669193.2360811.8690503029973801383.robh@kernel.org>
References: <20250923093330.31649-1-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923093330.31649-1-dev@kael-k.io>


On Tue, 23 Sep 2025 11:32:34 +0200, Kael D'Alcamo wrote:
> Convert the Devicetree binding documentation for microchip,pic32mzda-rng
> from plain text to YAML.
> 
> Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
> ---
>  .../bindings/rng/microchip,pic32-rng.txt      | 17 --------
>  .../bindings/rng/microchip,pic32-rng.yaml     | 40 +++++++++++++++++++
>  2 files changed, 40 insertions(+), 17 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/microchip,pic32-rng.yaml
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

