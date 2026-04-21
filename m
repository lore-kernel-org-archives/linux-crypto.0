Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A9E1FB1;
	Tue, 21 Apr 2026 07:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776755800; cv=none; b=UfW47NYrMcvmqxMVzUGKl5NZ95mBmjYSpxf1x7tMsIZIajyZJaXbVgyDwl9YAN06wn5sYeEopNRyCJU8hMXMQJE9jcTF+tb5tdQQ/X9MR5aRCC2v2R8z78KLuYcEO1ii+3LEkLznffa+46DjSGERAiwPNPXF238eMW4kDn36eco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776755800; c=relaxed/simple;
	bh=PlcRVfR/vAZ3jRFPOEYEFhF3xy4lVkpygdA+qLPzc+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZKQ9GzUhTSZhUjAZqKC9LeJYN+lUqW3YALjbF4taZ9NDCcjViQeDmqzFVQ9CApAJZL3Z149a2BxMmpE48dzqHzLFDForaJMw86TKy2ynkUuqoVN3rP+0lpbuRIipxblbDB+EE2ioMdkQOHJxzt6EHNGIzlJcfBOj+kRjAnivk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjELeC2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjELeC2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC988C2BCB0;
	Tue, 21 Apr 2026 07:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776755800;
	bh=PlcRVfR/vAZ3jRFPOEYEFhF3xy4lVkpygdA+qLPzc+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OjELeC2AjXDIcOyYBIPSrWENjRtzqgCQ28UrHMMo6qQTwvHt+lCL+2aF8iNKaE1PZ
	 9yUORyrXv4P++xNbABelxAyxf9fG6fSun1s54xVvqCsBXTPCxIZD2eK0+DWjpzF8Qg
	 ryNLV20WDpaD01BVSz2CIAZXduB8JP9PrPWzGAnsWXgUMyLnmcS1Pm1yWGlINKM+ba
	 xaTUMyCY8WS00np4/+bkSf0QLhVFqiGQtKQFTy9O9L8SLhyPZWBnFydbCZh/oELYyD
	 cQF+bT3FqyIWluatCaGQNEfF2NkrB6VryPgqZfT1lZDKQ8RX2sBaR9bFCSYfvGLDDF
	 +XOLr01mqQsFQ==
Date: Tue, 21 Apr 2026 09:16:37 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Sean Wang <sean.wang@mediatek.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v4 1/3] dt-bindings: rng: mtk-rng: fix style problems in
 example
Message-ID: <20260421-congenial-grumpy-teal-56615b@quoll>
References: <912fe579eccf577f3064b69d6c945e2c9087cab8.1776702734.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <912fe579eccf577f3064b69d6c945e2c9087cab8.1776702734.git.daniel@makrotopia.org>

On Mon, Apr 20, 2026 at 05:34:45PM +0100, Daniel Golle wrote:
> Use 4 spaces for each level indentation, remove unused label, and add
> missing empty line between header include and body.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
> v4: new patch

When doing such trivial cleanups, fix all bindings in subsystem (rng),
not only one. Doing it one-by-one is simply churn and I DID NOT ASK to
fix existing example to match the expected style.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

