Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A642813CAB7;
	Fri, 26 Apr 2024 08:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714121810; cv=none; b=GYgUFcOO2MrE+UryoDzAu17RjIe1Zm9gFCogZaM3nNNcA0EviZWsiJ5oARFQXSQrALB89whvjVZ7mkssDTwAuJvo1fLVUqH8b4d1PclT7sDsIo448bCVoh3qIgdyQMUtPP05sYNMbSObXv14gEIasGdxmCwk8ZyYfGN+fg+1lQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714121810; c=relaxed/simple;
	bh=B5McHmG2hxWqiezo9OOvdzUTt0Xn8lTGfuOoc5RjqBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWzONAuXC+eioWD27atAQ5VADhEVPevvDskEVaFecaql1YfoQyn2Dal8YoFMsMtKmbIRLs7fdhbEMVIBhXZ1stLnhuUzh2BzfrZRfSXQ3bTy7ROD48Vr+MazQDPpSnDY7mYd2Qk0pjs5FFCRizCeNDF9idxBXMro0sHvbpI6aIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0HNg-006dVw-Ea; Fri, 26 Apr 2024 16:56:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 16:56:50 +0800
Date: Fri, 26 Apr 2024 16:56:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [RFC PATCH 1/8] crypto: shash - add support for finup2x
Message-ID: <ZitsUtjm7/tuWwqM@gondor.apana.org.au>
References: <20240415213719.120673-2-ebiggers@kernel.org>
 <ZiJI1RhdHUsCDELY@gondor.apana.org.au>
 <20240419163007.GA1131@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419163007.GA1131@sol.localdomain>

On Fri, Apr 19, 2024 at 09:30:07AM -0700, Eric Biggers wrote:
>
> If you mean the fallback to scalar instructions when !crypto_simd_usable(), by
> default dm-verity and fs-verity do all hashing in process context, in which case
> the scalar fallback will never be used.  dm-verity does support the
> 'try_verify_in_tasklet' option which makes hashing sometimes happen in softirq
> context, and x86 Linux has an edge case where if a softirq comes in while the
> kernel is in the middle of using SIMD instructions, SIMD instructions can't be
> used during that softirq.  So in theory the !crypto_simd_usable() case could be
> reached then.  Either way, I have the fallback implemented in the x86 and arm64
> SHA-256 glue code for consistency with the rest of the crypto_shash API anyway.

OK that's good to hear.  So if they enable try_verify_in_tasklet
then they will only have themselves to blame :)

> If you mean falling back to two crypto_shash_finup() when the algorithm doesn't
> support crypto_shash_finup2x(), my patches to dm-verity and fs-verity do that.
> Modern x86_64 and arm64 systems will use crypto_shash_finup2x(), but dm-verity
> and fs-verity need to work on all architectures and on older CPUs too.  The
> alternative would be to put the fallback to two crypto_shash_finup() directly in
> crypto_shash_finup2x() and have the users call crypto_shash_finup2x()
> unconditionally (similar to how crypto_shash_digest() can be called even if the
> underlying shash_alg doesn't implement ->digest()).  That would make for
> slightly simpler code, though it feels a bit awkward to queue up multiple blocks
> for multibuffer hashing when multibuffer hashing won't actually be used.  Let me
> know if you have a preference about this.

No I don't think it's necessary for the time being.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
