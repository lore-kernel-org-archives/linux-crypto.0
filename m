Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018586;
	b=A/avOkOnXjUMigZDpvJGFxXFlC/3ePbmcXsemC8UPbOuXmSgQvvN79a+rOCCu1L0yxHj
	 qpws6I65dmk9VvqA/QXFh2IOQSigUr5EsNAp4G+nQ7aYEcVDntexc9+6H6cv03ACVyjeE
	 j+5dJKPUdrjmHVoBt82n8diTn2FFNhgkcvfZcZ/i0VJxgacfH1GbZbE58vxPxbbmIKjKO
	 RFsFTVsg2oZncwMSqt7SsRHPYvFygN8WkHRgXPdQeVYqJniiTvUq9PUzsHWIPULOmI3iJ
	 mKCqju6Dp3arF88slNe1imj4okomEhwpXx/EPlNoY2XOauZn1+axsdF5bZJMfuOV1lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018586;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BggR3LMQ5B2H+14O+KbzWRM+OZcQ6ED+Q1RPs+JGDuY=;
	b=5L1ol2Wz83DIWPRMPUcvlVUDCe8mGughv6f3TlaYupSo3oRo1NYFzAX28L6JFuGOCmIo
	 IkqIykVp/mxFdaj0hllTZkPhe/A3qYeH6rw+VrHJUpwkeI/L84Ar9dU5y0k3lkI5uwbYZ
	 LChcBSGUINptkU1AGo8wkJGvTkGlp48hls4JqI24N+hHDSQ69o1DIC8iuon64jGKiyMrx
	 bFUnA7dhIANDjIYHhhtcmCphHDdML3EO9cjeox6t/mzDztjpU3aO00lP4bqzPMA/Xb5+O
	 EIyV2fM/6qB9jPVEEQuDwN5PxN+ORKTSzHR+EC9VfDD5BVNe9Xy6odtGAxd2Vgb498w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n7HIePDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6267606A31A;
	Mon, 26 Oct 2026 12:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n7HIePDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2C81F01825;
	Mon, 26 Oct 2026 12:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793018585;
	bh=BggR3LMQ5B2H+14O+KbzWRM+OZcQ6ED+Q1RPs+JGDuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n7HIePDCNGLATxlHDR1D9kUVrxyjfPbo/kID5m5uw8cgHUVfiMhV1h4JNWf+9h66L
	 zVztPXZFqx4sYrLWoJpmgOWiVzYWUERxW2R4qK8BKCHoiKdStuuTfqmj0IGum51zm1
	 zjsF+34ZND5llQyoiRQnxTeghGRhi4Rc0Wnqzpplod6ZBYqwnmqHXRXa8nHYG1GJCQ
	 u/5ta9WGGFySjI63tHc0V8Xgl7NYJngZwPm2v4QW3c5Whq7erEajlyS4jmVkJv/aW9
	 /nRrW3O0/vjgDmST+QgAEycPin230DJEDsyDawQbLigGG+DXLMvqQrWQjINtE3wHz7
	 gcPRCVlbqwsjg==
Date: Mon, 26 Oct 2026 13:43:01 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Patrick Tudor <ptudor@ptudor.net>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/3] dt-bindings: trivial-devices: add Microchip RNG90
Message-ID: <20261026-determined-elephant-of-brotherhood-0a3c86@quoll>
References: <20261024-rng90-submit-v1-v1-0-e265cfabc9af@ptudor.net>
 <20261024-rng90-submit-v1-v1-1-e265cfabc9af@ptudor.net>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261024-rng90-submit-v1-v1-1-e265cfabc9af@ptudor.net>

On Sat, Oct 24, 2026 at 08:18:22PM +0000, Patrick Tudor wrote:
> Document the Microchip RNG90 I2C cryptographic random number generator.
> The device needs only a compatible string and reg property, so the
> trivial-devices schema is sufficient.
> 
> Signed-off-by: Patrick Tudor <ptudor@ptudor.net>
> ---
>  Documentation/devicetree/bindings/trivial-devices.yaml | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

