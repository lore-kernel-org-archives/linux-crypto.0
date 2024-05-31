Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4AC155732;
	Fri, 31 May 2024 08:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145374; cv=none; b=ApzaN5FBcCXxZe35nh6YVqFyQmelvV954tPgaC37ujI4eKfLNlvsEzU71Th4M4YR523cFGopptd5wuEDfTOhdZaDZnVw/9wgHNzA/sexS63ciWagFBMkHGmew8p8vSCtR6VOZ4Fp0xZxsHImOb6ZBCoMpri76SkFCAOri3ge5lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145374; c=relaxed/simple;
	bh=gM9jxLLgGUzdesi8OXYnPBuszSEmITh9JwsuowapVbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fziYrnRh80U05nxqMTozsX0fF3hbapx5CaYd6Q5zHw2o/i5nlB5gJmYTfGKbbzPxPmdjXZWOes7MttlaDeN3exR32m5n/25WmVkdEtpBoF+nRxrYoS/chZmYKtalKsGpnn3zgR1FWqK3oIi2nRGIeHLkzvuP3rlXzHo3i3TCf+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCxx0-0048hU-0A;
	Fri, 31 May 2024 16:49:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 16:49:28 +0800
Date: Fri, 31 May 2024 16:49:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [PATCH v3 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZlmPGEt68OyAfuWo@gondor.apana.org.au>
References: <20240507002343.239552-7-ebiggers@kernel.org>
 <ZllXDOJKW2pHWBTz@gondor.apana.org.au>
 <20240531061348.GG6505@sol.localdomain>
 <20240531065258.GH6505@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531065258.GH6505@sol.localdomain>

On Thu, May 30, 2024 at 11:52:58PM -0700, Eric Biggers wrote:
>
> Looking at it again a bit more closely, both fsverity and dm-verity have
> per-block information that they need to keep track of in the queue in addition
> to the data buffers and hashes: the block number, and in dm-verity's case also a
> bvec_iter pointing to that block.

Again I'm not asking you to make this API asynchronous at all.

I was just commenting on the added complexity in fsverify due to
the use of the linear shash API instead of the page-based ahash API.

This complexity was then compounded by the multi-buffer support.

I think this would look a lot simpler if it moved back to ahash.

The original commit mentioned that ahash was bad for fsverify
because of vmalloc.  But the only use of linear pointers in fsverify
seems to be from kmalloc.  Where is the vmalloc coming from?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
