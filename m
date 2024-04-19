Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393103A8CE;
	Fri, 19 Apr 2024 16:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713544210; cv=none; b=CfieoxcXl6xdCAXDvzlqPT85eln4C0U1kBlkixAkioncschKpsh5he0bGWCCY4VmL1e9kXs/mvK+3m1WrOsG+nRw1hpmCSxE6pVG1OtNlilj/j106DkRGibob/au8qZmcl5Y3rw5ICJknWzX8ywx8ojkAMffkrhZ62OVtQYTY80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713544210; c=relaxed/simple;
	bh=v5MMF4sIsyKZ3N8RRXo2tf2gqlanICtP5fvLTXeqLFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2yxpKQwTHPmgF9PYeE+IU1LseQsZIlJ0EAVhC5EsDAi3XG2vdPf7uJkvaRKj4t1puKEGDchJ6b5gmdyZ7AG4KOOgjeM+5sYzH1SsOBGf/qHiZbnmKtJV7GfYsGZcOmbPz1FQx+UMvRxDlor69Y4BztkPfqgIA7vccTLdwUex0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+i8an4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+i8an4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3DCC072AA;
	Fri, 19 Apr 2024 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713544209;
	bh=v5MMF4sIsyKZ3N8RRXo2tf2gqlanICtP5fvLTXeqLFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+i8an4+RHBaHIfqfGD8ealLtIAsz6St26O1nZM3C8ms4MqGT5QMufqZdXCVNumX9
	 TjJBPmZH2LgZU+ZDfkzMqqHNQ35hh/tfesz8qOSRVuMSPxG/TkHCwIbxJCHASIAvfe
	 GqNpT8lFABWEIYat9LLuNF5jzLh5qtX+Rqs/zzLR4uBY/wBn0eO64l66wPcjknD5Tv
	 fEOv96Uhh3vwI934AiyI1H2I2Rz3pMcSOrv3AQwH7O/f+x6rFSWEVJYXzs1BbfCm3T
	 QB5Scu0tT2RCexliBsMnvcpxpyGI3IgYT64jZJkHwGdFIrg8sesOHDfy22tRYBwRsy
	 EZnodEk1p9FlA==
Date: Fri, 19 Apr 2024 09:30:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [RFC PATCH 1/8] crypto: shash - add support for finup2x
Message-ID: <20240419163007.GA1131@sol.localdomain>
References: <20240415213719.120673-2-ebiggers@kernel.org>
 <ZiJI1RhdHUsCDELY@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiJI1RhdHUsCDELY@gondor.apana.org.au>

On Fri, Apr 19, 2024 at 06:35:01PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > The new API is part of the "shash" algorithm type, as it does not make
> > sense in "ahash".  It does a "finup" operation rather than a "digest"
> > operation in order to support the salt that is used by dm-verity and
> > fs-verity.  There is no fallback implementation that does two regular
> > finups if the underlying algorithm doesn't support finup2x, since users
> > probably will want to avoid the overhead of queueing up multiple hashes
> > when multibuffer hashing won't actually be used anyway.
> 
> For your intended users, will the SIMD fallback ever be invoked?
> 

If you mean the fallback to scalar instructions when !crypto_simd_usable(), by
default dm-verity and fs-verity do all hashing in process context, in which case
the scalar fallback will never be used.  dm-verity does support the
'try_verify_in_tasklet' option which makes hashing sometimes happen in softirq
context, and x86 Linux has an edge case where if a softirq comes in while the
kernel is in the middle of using SIMD instructions, SIMD instructions can't be
used during that softirq.  So in theory the !crypto_simd_usable() case could be
reached then.  Either way, I have the fallback implemented in the x86 and arm64
SHA-256 glue code for consistency with the rest of the crypto_shash API anyway.

If you mean falling back to two crypto_shash_finup() when the algorithm doesn't
support crypto_shash_finup2x(), my patches to dm-verity and fs-verity do that.
Modern x86_64 and arm64 systems will use crypto_shash_finup2x(), but dm-verity
and fs-verity need to work on all architectures and on older CPUs too.  The
alternative would be to put the fallback to two crypto_shash_finup() directly in
crypto_shash_finup2x() and have the users call crypto_shash_finup2x()
unconditionally (similar to how crypto_shash_digest() can be called even if the
underlying shash_alg doesn't implement ->digest()).  That would make for
slightly simpler code, though it feels a bit awkward to queue up multiple blocks
for multibuffer hashing when multibuffer hashing won't actually be used.  Let me
know if you have a preference about this.

- Eric
