Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A396E3D331A;
	Mon, 30 Mar 2026 13:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774875743; cv=none; b=ATqN2gLa7e24XMXSZ5bxx2fEc1cVFqHPfW6Dc8gnT5EaPewA850dXgf02LXuYoIa2LeB1H3gISkC/gT/E5GIwyuBBxaq0ZMV8kmNWFIEc6GISsRWwWBLo2neFTEO+5FSNP2b6RG6338jEUlEkBMrEOcyx9ax5VX89GabIiEE1t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774875743; c=relaxed/simple;
	bh=FMaehLTE9Fva2SorzDWrzR3gczfkcsqVYTXQ/u0ueLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OT31+LIXXQjFy1lnQbM7ETsbnE0GG3XXc43RphFDoEp4jimrKhi3zV6oz82hVrT01z9y/4Y4TMtmJ6B80mCktMYOnLoV/9G8IIoXWjQ8egDgCyPPHOAc4bvpcA0cWMpG9Q/H2ee9KrBU3jTdX5gJxGfV4hEqxrnz0jfwyIU7l9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CDABA68AFE; Mon, 30 Mar 2026 15:02:17 +0200 (CEST)
Date: Mon, 30 Mar 2026 15:02:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ardb+git@google.com>,
	linux-raid@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 4/5] xor/arm64: Use shared NEON intrinsics
 implementation from 32-bit ARM
Message-ID: <20260330130217.GA32392@lst.de>
References: <20260327113047.4043492-7-ardb+git@google.com> <20260327113047.4043492-11-ardb+git@google.com> <20260327135051.GA739@lst.de> <cca6facc-6c37-48d0-81e6-f8568f36b91d@app.fastmail.com> <20260330053233.GB4736@lst.de> <6bedf98e-a424-4baa-890c-806345c067c1@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bedf98e-a424-4baa-890c-806345c067c1@app.fastmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 30, 2026 at 11:38:15AM +0200, Ard Biesheuvel wrote:
> > This avoid the including of .c files which is always a bit ugly.
> > But if there is a strong argument to prefer including of the .c file I
> > can live with that as well.
> >
> 
> I've respun it without the include. Instead, I've added this to arm/xor-neon.c
> 
> +#ifdef CONFIG_ARM64
> +extern typeof(__xor_neon_2) __xor_eor3_2 __alias(__xor_neon_2);
> +#endif
> 
> so that __xor_eor3_2() exists in the arm64 build as an alias. That way, the arm64-only EOR3 implementation can just remain a separate compilation unit.

Ok.

