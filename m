Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224E13E763E;
	Fri, 18 Sep 2026 08:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721408; cv=none; b=gEN5V858b7xel//FDy61HwSMiT2ZIX9BX/JZVu7xBotVioK7KZzvZbjJAwBd0sytMDvfi4UMcqnWeAW613l7dyMpn+EtbXVD/P9mLFbtMDBjaIvhhYLC9cKJtskU1bMhttWyyPEkFSOIoFE7IYydcAuqBZzCOzTmYkytsDvbk0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721408; c=relaxed/simple;
	bh=Qy4aD/RPF/BzhIVdze7t/aiu8d++NWsgUROxDMxTLTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQO/jG4/NjhbwizQXBNusqx2xMSZ+ChIlk6hnxBldebOh4bJ2f8Sc5YLQNlHRa45OfvT6NsvxFh5fGv2W73MuFiKzj0RoyzFh/eYvXVUSqvsNj9vl9JVDEObxJKrWDPrw3YGx4xvsM207nWUnjeM9T+ZmpRdSfpB8UJY19Bd5No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3z8qkcR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3z8qkcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787A91F000FF;
	Fri, 18 Sep 2026 08:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789721406;
	bh=LDJjd9/1o+z+c7/Cl4w+R1oLsSZ0eu0e0EhDDi66568=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F3z8qkcRNxLQxrwBDPWQL87UhPj1p8yE4Ewn4XYw65yXCs55Dw0LBAz7hh+4Oxhl0
	 x0agoJZikT56rAjhEvjegJ6P5dyY8gjwGf34ebxwfsbeybhYFYSwcNKtQb8LceUS9E
	 t1MwePoKMt0McN6ZR4gcHdh21JJslFkw7IObIcKr3uDsvE7rjV+q2NUCD16dwIMswa
	 4iG2efS5VZ7lkEz5S18CW9mPWyyXHKcLULDcStU1UHlVJAdnSHLqIeEE14Qd+v2thj
	 62fo8uCAQHEJD5dgP8QotuWIpBuqqSGA3R/i0PIwlaRwtz3sOuuKdZN77M6x5vJDWI
	 5T2KKwg6ni6/w==
Date: Fri, 18 Sep 2026 10:50:02 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Bhargav Joshi <j.bhargav.u@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, 
	Andreas Kemnade <andreas@kemnade.info>, Kevin Hilman <khilman@baylibre.com>, 
	Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Animesh Agarwal <animeshagarwal28@gmail.com>, linux-omap@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 4/4] dt-bindings: crypto: ti,omap: Fix missing
 subdirectory in $id path
Message-ID: <20260918-vociferous-pegasus-of-contentment-aa4bbd@quoll>
References: <20260916-ti-dra7-omap-sham-fix-v2-0-4eadb60081e5@gmail.com>
 <20260916-ti-dra7-omap-sham-fix-v2-4-4eadb60081e5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916-ti-dra7-omap-sham-fix-v2-4-4eadb60081e5@gmail.com>

On Wed, Sep 16, 2026 at 02:29:41AM +0530, Bhargav Joshi wrote:
> The $id fields in the omap2-aes and omap4-des schemas are missing the
> crypto/ subdirectory in their paths.
> 
> Add the missing crypto/ to $id.
> 
> Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
> ---
>  Documentation/devicetree/bindings/crypto/ti,omap2-aes.yaml | 2 +-
>  Documentation/devicetree/bindings/crypto/ti,omap4-des.yaml | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

