Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F392B340A6F;
	Mon, 13 Jul 2026 04:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783918034; cv=none; b=eXbsBAmGWeZpfF17kbmchZ1pzSU6h6FePZXCfdOi/dDyWNbwfNT9ZmdUxjzLOdxiG59/Jy8D6IEgTtcPbZKugI7pD3xvQq5vWExj/4BrFMPsEUF7R6Ol1QLScPAublCzHQDNszW8w7301PFg01HWpogqmgiEmpU/gSgg0I5CsL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783918034; c=relaxed/simple;
	bh=JIypKOIXxa8D99JWB1t2xz0jlYRBSgOjoMtuoBHEY6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/e1E475hP3mEcyS9nB6kH0idPs2a5cEwYAid/bFz7TfQ+wIstx9g9UaXerHOZHw+zI2rRtFWV4J75GJ/0Pjf8XR5KWRDHVAQo7iuxk8eqzKJNNgkeFnJwePg80GXZExuuNxWt5edY13MG2tR30BMaAgxyIAkmWSdRb8QWZsJpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mMAEGUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mMAEGUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1190F1F000E9;
	Mon, 13 Jul 2026 04:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783918032;
	bh=9PAJlGm06FdpPNE7UoP/ZDlHwM5ZAN6RmcnqlknM3U8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=0mMAEGUuZ+pvom+KPpTGZ/jy2dn31zcecZPV462JSSnQOYNsGMieQl7Qs8RG99wDe
	 ysif8cOHHXdhAKuohY0T/tomxmuYxDjz+GBytCjV/RTSQ7BK+b/JpJBv7nDy1J95gr
	 oHnQWFGN9XqHHtwZPrtQKnV8hkfpAhuF0LA/vzJg=
Date: Mon, 13 Jul 2026 06:47:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: demiobenour@gmail.com
Cc: Russell King <linux@armlinux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Message-ID: <2026071312-uncover-refining-8cac@gregkh>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>

On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4 Relay wrote:
> From: Demi Marie Obenour <demiobenour@gmail.com>
> 
> This driver is harmful:
> 
> - It is much slower than the CPU [1] [2].
> - It Has a history of bugs [2] [3].
> - It does not have exclusive access to the hardware [4], causing races
>   with the secure world.
> - It register its implementations with too low a cra_priority for them
>   to be actually used [5].
> 
> Therefore, disable it to ensure that nobody builds it into kernels they
> intend to ship.
> 
> In the future, the driver will be used for processing restricted media
> content.  However, the kernel does not currently support this.  Since
> the driver will have future uses, allow building it if COMPILE_TEST is
> enabled.

Why not just delete it now, and then bring it back when it is needed in
the future?  Otherwise this will just trip up the static code checkers
who will attempt to "fix" things in it.

thanks,

greg k-h
