Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80C07E782;
	Tue, 11 Jun 2024 03:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718075651; cv=none; b=H1nj6ApWCFSS6+zejrtfCqxvATq3eA1pwCdiQRLJpL8CJLff9nk44NsNrRqCWp9LGJ0NF9xvDqN+bEaPKVonw+LTTkrTqPMJHK4OEBx33RDC98PH9Wcf4RjSqiMfUh8ERSi0zzfuaF0BEDUwLyDOc3DeS5APmF89m2w/b9QQbZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718075651; c=relaxed/simple;
	bh=mbLv1uH2SZYJsLfBUYXgs87kE41hXHw1r1WdE9F1N8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8bYz5neY6AouKLaA51eG4ECbpxKUxXfbk0FL+5IbXl8SUu41uDrnwU77d2c8J+CkVk9rNNzgpaTPgvgUrSYjSbuxQXbu8u/tk3s/EzHkN8WthAci0B4iq5DhZxv5TNsuAN8dsmyJYZTIHIoDicZmto7hEZG08DOcEXMQQbAztk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NLzAwj3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLzAwj3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE838C2BBFC;
	Tue, 11 Jun 2024 03:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718075650;
	bh=mbLv1uH2SZYJsLfBUYXgs87kE41hXHw1r1WdE9F1N8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NLzAwj3Q7cuqOrIBmQCoD309Oia4DvkXjzRhFz6WEvf2FFKM2GNjA/mb1UBMH02B1
	 xH+lTl2C2R6KuTB0CidmE/RB0/eDRIfsZqwPmyQ4GDiWW4AD2CcZYPcqE+qmIghEns
	 7wP1bTRbGiDy/rzyBpadzaF6EioxRsRNruXdMWgoFF0DfWWsvFIyoTkBUwK9zAI8gt
	 1PH2Q7xMGt/Q5MziAJHxjxLEzy8ElPCi/FvSCK3bp/MH7qxX+sWnciFZlWSwEnPQ3w
	 3Q32bWqqNqcIEWwVJN9pcteBwpJ3SWrpXhnMOnobkgjIrKt9SAXUtfLDgzTGr5pOwr
	 //9KmDYX2vrDA==
Date: Mon, 10 Jun 2024 20:14:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: kamlesh@ti.com
Cc: herbert@gondor.apana.org.au, kristo@kernel.org, will@kernel.org,
	akpm@linux-foundation.org, davem@davemloft.net,
	mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
	robh@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org, vigneshr@ti.com, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/6] lib: add ISO 3309 model crc64
Message-ID: <20240611031408.GB2557@sol.localdomain>
References: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
 <20240524-mcrc64-upstream-v3-1-24b94d8e8578@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524-mcrc64-upstream-v3-1-24b94d8e8578@ti.com>

On Thu, May 30, 2024 at 05:54:23PM +0530, kamlesh@ti.com wrote:
> diff --git a/lib/crc64.c b/lib/crc64.c
> index 61ae8dfb6a1c..40369dd26812 100644
> --- a/lib/crc64.c
> +++ b/lib/crc64.c
> @@ -22,6 +22,11 @@
>   * x^24 + x^23 + x^22 + x^21 + x^19 + x^17 + x^13 + x^12 + x^10 + x^9 +
>   * x^7 + x^4 + x + 1
>   *
> + * crc64iso3309table[256] table is from the ISO-3309:1991 specification
> + * polynomial defined as,
> + *
> + * x^64 + x^4 + x^3 + x + 1
> + *
>   * crc64rocksoft[256] table is from the Rocksoft specification polynomial
>   * defined as,
>   *
> @@ -63,6 +68,28 @@ u64 __pure crc64_be(u64 crc, const void *p, size_t len)
>  }
>  EXPORT_SYMBOL_GPL(crc64_be);
>  
> +/**
> + * crc64_iso3309_generic - Calculate bitwise ISO3309 CRC64
> + * @crc: seed value for computation. 0 for a new CRC calculation, or the
> + *	 previous crc64 value if computing incrementally.
> + * @p: pointer to buffer over which CRC64 is run
> + * @len: length of buffer @p
> + */
> +u64 __pure crc64_iso3309_generic(u64 crc, const void *p, size_t len)
> +{
> +	size_t i, t;
> +
> +	const unsigned char *_p = p;
> +
> +	for (i = 0; i < len; i++) {
> +		t = ((crc >> 56) ^ (*_p++)) & 0xFF;
> +		crc = crc64iso3309table[t] ^ (crc << 8);
> +	}
> +
> +	return crc;
> +}
> +EXPORT_SYMBOL_GPL(crc64_iso3309_generic);

Putting this in lib/ seems premature, given that this is only used by
crypto/crc64_iso3309_generic.c.

- Eric
