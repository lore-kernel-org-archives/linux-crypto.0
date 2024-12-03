Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B841E0E11;
	Tue,  3 Dec 2024 07:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733212693; cv=none; b=PxWq8oDbqYmlIATtqk8lsetheJ+fn7+Ib1WBkLdk7cL8CCTRAzV1DD0r3HVwTlARgL2eloz6q4yNwwameQDUnlBhMSSPTPNDChSPSQhH3+yIAyz+ldTKtvBTj0R317FL/Ve+6a4XzJnD11ox1fkvQtQvqTMCBzkT4laDgg8oohI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733212693; c=relaxed/simple;
	bh=h4HcZnyipoIhXRRvbKerBOWLgD0F6tgbQj7OpZYlnAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meMbpBPHEFaRDuQJx7tb9+dNKTajGWzCXAnjGIcybSF7xM8UGIRsf0Rw0+nuB/HzcXEb/tDCXmHXU5l+uhQWhZkATIYH5Lekb8fobUJdXU660SLq5bwV2l5NhoZ1wXYYdRe8a9spf6bp9JwOloxn2wxUZbF14SUnXUJ0Vgv6jgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AtfNY+IE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AtfNY+IE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GHXWrVfiD4gfitt7A6+cck4e1YWEVGJKkcPfpxGTlm4=; b=AtfNY+IEK9koEsP1f9tSP1PTEb
	EDO8eY0wIZAX0hyBvNZeI4owe0Z3JhjSJ88mNhttEpfQheEoZyjzy3Q6FOV7UelQWaDEIRbQjnO+H
	ppU4FB4FcTkO8uUMGjfpn3LSUai6+NpBBp2d9Kpa3zMUh+hFTbhPUEoFOf9qKmTjYD77IkpT0uiDL
	e35VhFjC1zbPw/CrNFRZmHSBMzlGfGI5U84qtF9iYnuIp8XHyhaVtkHaWuf+8SjvlK78A9jkFFaI7
	7ngaAhx8pcS3NaHObJ4szIlZO4Z1hI6JgYkm0KMJFSDXmk8ll9Wl96FaRoHWoxytoPZEvy9xJUajn
	LXoKuXHg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tINn8-0037dM-3C;
	Tue, 03 Dec 2024 15:57:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Dec 2024 15:57:54 +0800
Date: Tue, 3 Dec 2024 15:57:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Zorro Lang <zlang@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] crypto: rsassa-pkcs1 - Copy source data for SG list
Message-ID: <Z066Aqy3kipGicnw@gondor.apana.org.au>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <Z0mPDA31r_LEYzNq@gondor.apana.org.au>
 <Z0rPxCGdD7r8HFKb@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0rPxCGdD7r8HFKb@wunner.de>

On Sat, Nov 30, 2024 at 09:41:40AM +0100, Lukas Wunner wrote:
>
> Just a heads-up, this won't work for use cases when the src buffer
> isn't accessible by the kernel.  E.g. if the virtual address pointed to
> by src is in TEE restricted memory which was mapped into virtual address
> space by dma_buf_vmap():
> 
> https://lore.kernel.org/all/20241128150927.1377981-1-jens.wiklander@linaro.org/

If it's not accessible by the kernel, why would you map into the
kernel page table? That just makes no sense.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
