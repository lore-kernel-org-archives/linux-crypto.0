Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72AD3C555B;
	Fri, 26 Jun 2026 05:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782452398; cv=none; b=UZI35z5adcgVU7dEhtSpR2VwB443coPtSRaD0YUwe6fLXg2c8pxjQQPI0kw3ztHbLqNNbMyk+1+lQ2cUdezhJB0EEjLdMMTX9P4Tn829Yk91CeY3G2X1bdd0aKMh1Nm4JSMm95ipgqp1Va80IaCmB/D9CR+xJt9+x8Sqm2amrmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782452398; c=relaxed/simple;
	bh=TQSzTw9EAFYugue+JZNGZyvxo8PM1nt9mOtOsEaMWQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SoKKTQkqovneFes02pXIWOKe0t28dTYi0CuayQ6zf1uoVWnv5xpuaGgAG8sSHzTiSMiVoAdPXcjHLYL4pE47Ohzgc1nrjfe99Ip7iH/+Hu8ELNHAM7h/aCqkWC1AXskthdFIuunUC6nz3q/zmR2oS2/zUW88K30CX/J8+XCU1DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 53D4268B05; Fri, 26 Jun 2026 07:39:55 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:39:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260626053955.GA9629@lst.de>
References: <20260626043731.319287-1-ebiggers@kernel.org> <20260626043731.319287-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626043731.319287-2-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 09:37:24PM -0700, Eric Biggers wrote:
> If the CPU declares AVX or AVX-512 support, verify that the
> corresponding xstate bits are also set.  If not, warn and clear them.
> 
> This eliminates the perceived need for AVX and AVX-512 optimized code in
> the kernel to call cpu_has_xfeatures().  That has never been universally
> done, which strongly suggests that it has never really been needed in
> practice, but this should remove any remaining doubt.

I'll leave it to the x86-experts if the low-level details are right,
but the model behind this makes life so much easier, thanks a lot!

