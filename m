Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637B24ABBD6;
	Fri, 18 Sep 2026 08:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721345; cv=none; b=ApqY3w3JQ9yF/CS3mYtSxklDnbpbEm+9+NjGaizrFWX5vYdZ7p2bRhXsbdSUZ4QFsbS1osxDQnD+rE8hq1IVzObe0K+ealfIIVHpBRoXjGxV9znUkcRztFJbHyN21hpiQeIkosU+yQjhwD5pmlrX3liWkL5ScvHdQ9si/5/C1/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721345; c=relaxed/simple;
	bh=bYr9xN80RQl1A+GT1JhWGTOf+sYgvL21c7reH2AN680=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aC+HaY8eNiA8vOyL+efZFq1HK+449GwJZ1nfpPOJjvTf/NW0YHz40hPb4UgoEL6vIcpFBW1hcB92rZhwCTVJGqD9CssZSXcAY5zlxLkgO5FlJlb1128hdh8kEOgH0vDjJfistKBtO7nhjKLr5OOC23k8FnCmCv1LjGsa7H0IVSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lbg82g/b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lbg82g/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF2B1F00893;
	Fri, 18 Sep 2026 08:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789721342;
	bh=bYr9xN80RQl1A+GT1JhWGTOf+sYgvL21c7reH2AN680=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lbg82g/bGLOT1L0xQ80yZhrn4SPIRJDi8c8cRtDHbzP8Ng9/DxZX1yQVjw8jlux/N
	 abzoJWRt+mUHpynm+7XReyeB58Iq9UOchenxuQgPxW+tDajae4MghTP1FN443YZRJ1
	 BhfNOkuelZCbY5M27WzJ7IjmYWGuM6ErLjC2bWlinU1OnFgrF72tyH8rAvocu95eKq
	 SoDMlsniTP/pTq/EPS+fyDRrogTcRtBMLy6gSibUDFJ9Ndx9rOIlxLm00WnvSAzZMR
	 nQDVhWZzltMdqxbX6yo9GhOZtLHo1cyjC6TtZpxqZ5etBeDBqg1ah6X6bwZYknjZ/7
	 Ze7OENI51/FOQ==
Date: Fri, 18 Sep 2026 10:48:57 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Bhargav Joshi <j.bhargav.u@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, 
	Andreas Kemnade <andreas@kemnade.info>, Kevin Hilman <khilman@baylibre.com>, 
	Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Animesh Agarwal <animeshagarwal28@gmail.com>, linux-omap@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ARM: dts: ti: omap: dra7: Remove clocks from
 crypto nodes
Message-ID: <20260918-ingenious-dinosaur-of-persistence-9b7e9a@quoll>
References: <20260916-ti-dra7-omap-sham-fix-v2-0-4eadb60081e5@gmail.com>
 <20260916-ti-dra7-omap-sham-fix-v2-2-4eadb60081e5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916-ti-dra7-omap-sham-fix-v2-2-4eadb60081e5@gmail.com>

On Wed, Sep 16, 2026 at 02:29:39AM +0530, Bhargav Joshi wrote:
> The omap-sham, omap4-des and omap2-aes crypto drivers do not use
> "clocks" and "clock-names" properties. Clock management is handled by
> the ti-sysc interconnect parent wrapper. The dt-bindings for
> ti,omap-sham and ti,omap-aes don't define these clock properties. Having
> them in the child nodes causes dtbs_check warnings.

This is not true. First you removed it from the DES binding and then you
claim it causes dtbs_check warnings.

Order your commits properly and then see if there are warnings.

Best regards,
Krzysztof

