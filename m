Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F96343888;
	Wed, 17 Jun 2026 05:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675537; cv=none; b=RNzUiPAv+0k1z5dN+BMgT4501lH5QSGLKzQCZ4wB4ERKGSOZ+lJ+XKJCmIq9Oiyk8rWsDmn20lCVdxcLlFlEFNisiz9xKREbjvLIMdrwhliwj9LEFxOPdYrpZQd1xM1TJ4zd27M1vHTtKynqUjOfIf0b3IXpbt5w13uwXkrjgrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675537; c=relaxed/simple;
	bh=bSw8EEC4oXhSTyWWkmOFVTQjBUoLOZpz+oLheOCEhug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOfMnSDWAgJvUesVETTKoEtPBDRjOjhZwBNBOhoI6DI+rJjyDA0YhiISWpROHFNW/aptdjMUiY7y6hN9YZ32GhsYaI4NXH/lyWlNhariEufDG3Bi8/oz677V0uey4z7ri+MRWa6a2RLeeaD6RPSmKzc+GvtZEFWm3QrLgSx0Kl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7AB2768AFE; Wed, 17 Jun 2026 07:52:12 +0200 (CEST)
Date: Wed, 17 Jun 2026 07:52:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v2] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260617055211.GA19218@lst.de>
References: <20260614010357.69416-1-ebiggers@kernel.org> <20260614111628.00af46b9@pumpkin> <20260615184435.GA17731@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615184435.GA17731@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 15, 2026 at 11:44:35AM -0700, Eric Biggers wrote:
> > Doesn't zen4 only have a 256bit bus between the cpu and cache?
> > So avx512 reads take two clocks.
> > Since this is memory limited it is unlikely to run faster than the
> > avx256 version.
> 
> On AMD Genoa (Zen 4 server processor), the AVX-512 code added by this
> patch is indeed about the same speed as the existing AVX-2 code.

The same is true for Zen 5 mobile which has the same AVX-512 limitations.
I don't think it's the bus width, but I'll leave the details to the
experts.

> 
> > OTOH if it doesn't cause down-clocking as well then it won't be slower.
> 
> Yes, as far as I know that's not an issue on AMD processors, even Zen 4.
> The "avoid AVX-512 due to downclocking" rule is historical guidance for
> Intel processors that had a bad implementation of AVX-512.  There's no
> reason to exclude Zen 4 from executing AVX-512 optimized code.  At worst
> it will just be the same, as we're seeing here.

It does not cause down clocking.  But for some of the more complicated
code I've seen AVX512 being significantly slower than AVX2 on these.
So we need to watch out and not automatically assume AVX512 is faster.

