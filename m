Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741DB2AD25;
	Sat, 27 Sep 2025 11:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758973731; cv=none; b=VIVeBy8guqLqHHiFEwGhlMRGAfUs28sgd9c9KkcJInZ4/3d69Xuwb5ZNk+gF/DoM/yspYtyarlre+Ns47YFmmz9rrl5xMKYVagEZp/E6X1Ra6PZ7qG167SKYkPvTO3j6bW4ZziUyhSSpPWahhY+9wOLtV/GpEPItCwUToEr+dyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758973731; c=relaxed/simple;
	bh=cjJHS/zkt0CU7rTn0fUKN9KkeAaEWmLa0/FIB9UVcVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gln31vQljQQBXA3MWKDf7q6tmWzavK7d33ZVX1dD16B9Rronr4f/aqpNj7/WzKvCYLAdq8PyBBV2kZCLldqrXqCcgzX/CdVdePGSSUxyj9LfXEI6itkV208wpeK7ZuMFDrVm/I6enpx3Cv1NrKJ8N5OLLHRe5+SxjpPzI3ZrZGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=a5Co6tQp; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="a5Co6tQp"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cYm1n3Ykrz9shx;
	Sat, 27 Sep 2025 13:48:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758973725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZpHKe82XIjZTyoR1Mn5EXgvHGihkX0jvH66zAs3RPI=;
	b=a5Co6tQpKCTN2d3PQnUL5T5CLBw2H2MSZqJUFtSpFiM59eMyb0mGQVApnMGjljzpca0CDq
	MSm+oH37FXU+X0KwOH52EMwROyky5IBZEaUNftw52muTqHgegVEjv6hlc8wgS4fcK1n2Yy
	cCfLAX51nYdIUPK+EaPpCGDTF2ra11XwChDU2OpH1otrjfrX7EV5K3P+TT4NeKJpcnAH4F
	DBKeFv5HOs12grUpEp6GehtBtYlR+8CLZ7yvBzt8MsZ8aUj1xSoksZD7/fNPojdqdKFazv
	Vmn9+Y1yvoYOOZenj05BEoFPu8tRP/x18qcS5znEF3PSSAsib646QlW7nwEZhA==
Date: Sat, 27 Sep 2025 13:48:22 +0200
From: Kael D'Alcamo <dev@kael-k.io>
To: Rob Herring <robh@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v2 0/2] dt-bindings: rng: sparc_sun_oracle_rng:
 convert to DT
Message-ID: <f6jhixs6xfwg4mk2bm4pvexfxgtu52ic5yubzyxxo57wvhyg2n@fjbzpum4zoum>
References: <uprke6fujhmckymlpy6oskecol4awhqyroqlg25tprmhnkeyy6@ztozdrlmeotp>
 <20250924141247.69323-2-dev@kael-k.io>
 <20250926205301.GA1448549-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926205301.GA1448549-robh@kernel.org>

On 2025-09-26 15:53:01, Rob Herring wrote:
> On Wed, Sep 24, 2025 at 04:09:18PM +0200, Kael D'Alcamo wrote:
> > Changelog v1 -> v2:
> > * updated vendor-list by loosening the regex for names without prefixs
> > * removed extra example in DT binding
> > * updated DT binding filename
> > * updated DT binding title
> > 
> > Kael D'Alcamo (2):
> >   dt-bindings: rng: sparc_sun_oracle_rng: convert to DT schema
> >   dt-bindings: vendor-prefixes: updated regex for properties without a
> >     prefix
> 
> The reported failure is because you need to reverse the order of the 
> patches. Normally Herbert would take it, but I went ahead and applied it 
> reversing the order.
>
I'm glad to read that, thanks you for the feedbacks.
> 
> Thanks,
> Rob

Kael
