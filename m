Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849E0192D7C
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741230841; cv=none; b=LFp3D6KyrkOmaCxgc2qjYqu2r4BoNWWuymdEQU+FO4MaO6EVrrRstwbRSJ7LXnTJrHD/g7CCRDodgGv5tlLHWe2duGNSNBPFcZvBWXmcQXSxx0twbxA8m9ik8upCxmC7wIvHXMxyjALmvT905QXJa/U29+o5K9e4T7Qtdqa84Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741230841; c=relaxed/simple;
	bh=gUTGF1wyZR3naZX2NszzdR9IzH6NtJXC70ovw2azvR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VOx68KX5IF9dVQQjBq0YR9bpv+0C364XtXPIARUirxgZZAP1k985c+NeLEw9qw+Pvo6u8rNMAzuCBkB3YEmXmcHJRUJhmkBX7Yildzxk2JNxPeskSYN1cAChEuhkuT7r1JwCMXByCb1YbREAFPuTj9oukpscOaawjXkAr0R0S1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBsFsKpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBsFsKpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDCFC4CED1;
	Thu,  6 Mar 2025 03:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741230841;
	bh=gUTGF1wyZR3naZX2NszzdR9IzH6NtJXC70ovw2azvR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hBsFsKpn3bEp0QJvnwm2gIZjIUm7jZkitNoj6C2zXXXVKvK/JZK65aoqo8YCGEuZ8
	 FeU9KP60hjl6CvddmgadnWqRRgYHphyfms3cnNarw2Kg4gyn4XYU5PaJIlDY8iFgnt
	 vMzY/IMTrhgopWaZHKbRgm4ujJLoyr4xUvdjIyngLr4CTENBagPTglGUeA0hQ4tz/v
	 vXqjS9XspIY2hHbT7eMhp7N2DXsxp10+UH7PiALx3TsDh+/JKUJWhYrnevG6yTjz4Y
	 /rjaanAhRMh2WbI4K3yRvhTyXgPRXX+H4vzi4cOLfZS1kmFioPwZoiUn5/ahPNGtuL
	 nJ45oCzzfTz+w==
Date: Wed, 5 Mar 2025 19:13:59 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <20250306031359.GC1592@sol.localdomain>
References: <Z8kQejXQqMhc3X8x@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8kQejXQqMhc3X8x@gondor.apana.org.au>

On Thu, Mar 06, 2025 at 11:03:22AM +0800, Herbert Xu wrote:
> +void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
> +		   unsigned int nbytes)
> +{
> +	struct scatter_walk swalk;
> +	struct scatter_walk dwalk;
> +
> +	if (unlikely(nbytes == 0)) /* in case sg == NULL */
> +		return;
> +
> +	scatterwalk_start(&swalk, src);
> +	scatterwalk_start(&dwalk, dst);
> +
> +	do {
> +		unsigned int slen, dlen;
> +		unsigned int len;
> +
> +		slen = scatterwalk_next(&swalk, nbytes);
> +		dlen = scatterwalk_next(&dwalk, nbytes);
> +		len = min(slen, dlen);
> +		memcpy(dwalk.addr, swalk.addr, len);
> +		scatterwalk_done_src(&swalk, len);
> +		scatterwalk_done_dst(&dwalk, len);
> +		nbytes -= len;
> +	} while (nbytes);
> +}
> +EXPORT_SYMBOL_GPL(memcpy_sglist);

Local kmaps must be released in reverse order of the mapping, so
scatterwalk_done_dst() must be done before scatterwalk_done_src() above.

- Eric
