Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5528C36E489;
	Mon, 22 Jun 2026 07:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782113802; cv=none; b=rfC4o6DFePR44obTuXHDrT9jYixksHGYna51CqJuJDBIqaZvtN7OlDoasqrG1WCv0xSLm/0NdrkTq7htF9aqXXX3LHZyDyOFWFXxkCdmJYBOmkOd7llxixviIjPsoN9QVjVfTDBHb4x4XEu9mN7mF5EwlRtwOXRZq+9rl0hs1wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782113802; c=relaxed/simple;
	bh=NGcfW53OD7hUMG7jk+IL7DLAol0wfrB4eVEwWeRgxlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kh0iekPLPg1Fp/hn8VQMmU0kb+ACgKRfC65XVJet/GUAm6WKjcjc76zjR4raADWoJI38kTRDuEHqYnMtE8IOIKW5I8d7hEo99eqCnM1mxZMkPfvo7OwooWiM8QgpoAmP0eq8yMPSr7MQ20k/gTMLWGcTym9TiNfY6c1U0e3nxJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7Qip6xv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7Qip6xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A181F00A3A;
	Mon, 22 Jun 2026 07:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782113801;
	bh=Do3/3VdIxMtgHjklQ9oNzFDNcBXRA87Y/Bdni4pf3Yk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G7Qip6xvIt1iRuNN7fUwoflCEWhC6bPFFfaISollUjWTFH641KTj0JOlYyXjkDba4
	 VhXZHKR7jF+UzwA3JOupMgb+C8ToR9ao9d294tN+PP98DzvJnlBFNed4+0opaXIlaB
	 oO7yj4sowW9YbSfawND3fRso3tjjIrUM4b5+aGztbD9q9YSone56FwCuYsvcvktWMU
	 RnST0cld8RlGMOlVCaDrJggMJ70E3+Z0gWWS/bsxUXwqZcMmfx/xTXHuZj2o8F79jo
	 CULMq8elD6lMytEg5fN9FnWwLB0V6V69lWgcDqCE40b8mjQuzprwaJgTwygaNWHfPQ
	 5xxfUZpNvv4Tg==
Date: Mon, 22 Jun 2026 09:36:37 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Jad Keskes <inasj268@gmail.com>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Alexander Clouter <alex@digriz.org.uk>, devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] dt-bindings: rng: timeriomem_rng: add
 reg-io-width and mask properties
Message-ID: <20260622-inescapable-primitive-horse-48cf65@quoll>
References: <20260618120110.36439-1-inasj268@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260618120110.36439-1-inasj268@gmail.com>

On Thu, Jun 18, 2026 at 01:01:09PM +0100, Jad Keskes wrote:
> Add optional reg-io-width (1, 2, or 4 bytes) and mask properties.
> reg-io-width selects the bus access size.  mask is ANDed with the raw
> register value to allow only the entropy-bearing bits through.

You should explain here why. Why are you doing this? Why do we want
this?

> 
> Update the example to show a 1-byte configuration.
> 
> Signed-off-by: Jad Keskes <inasj268@gmail.com>
> ---

Best regards,
Krzysztof

