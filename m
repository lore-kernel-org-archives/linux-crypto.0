Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BD6383C85;
	Mon,  4 May 2026 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777917724; cv=none; b=Fvd8OarshJRVAMzsdMze/GDzICBELy+YQnYVJ3DH2LpGhfFpinIr8er/H4880vC4opnIbn/gXCCWLMHTHB67CumeCCJCUEg+mJGSM15cWzsCIPosLJnXHjgXGJokjj8OI7qq1cOlGjGPzxEWDes1qWy4sBd1B9bKO9xkpjLuHtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777917724; c=relaxed/simple;
	bh=szpkNhMXI62ZGJn42+LaItfXpXq/gaSIIeijRGwBhNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqPnEMYQckQPovj6wB5TIG9c7LtE5HndyEvIswoYqXs1v4gvu7JBnx+jTalqfU+gkVBYDuxU9QsxU+wyn3mYDNebfZW/U9YuUraFfSxT8ZTHy3nVO/TmCLXvMIg9wyDo4yboGmjiKU1y8iB0wLM+li/Uah1xCaQdQm/j8VLVDsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ml1/qumi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ml1/qumi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6F1C2BCB8;
	Mon,  4 May 2026 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777917723;
	bh=szpkNhMXI62ZGJn42+LaItfXpXq/gaSIIeijRGwBhNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ml1/qumiMS+QpbPL+4qP9mrMlLyrmiU97zBcGe+r3Fx8DB9frOllVIwaxRKuEQd7C
	 nCNQL67pWujcN2BskEgyOmaPI2uCI8VMR/nWFR2LeYcZrbcsCIQr4Rs4lYSpY22rU2
	 uMFr4M4tBqqVjKsDkqpEMdDJK/6UDXC6pJ5SsumUze6z88qpDyt9XppA707CvJ8r26
	 IZl79/rvbGSH20RceZGzdldGVU5bN3GgrRdT/jJBmuDXp/ko3+DgVUmJbMx4OUghpP
	 zKqW6Us2fz+pacR6exjt7BUuzXW567t9ByMJq/mf4MBZ2BhMicFK4Ck9uEyawKIN15
	 zoUxh2z1o51IQ==
Date: Mon, 4 May 2026 11:00:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: Re: [PATCH] lib/crypto: powerpc/md5: Drop powerpc optimized MD5 code
Message-ID: <20260504180044.GC2291@sol>
References: <20260504041448.15820-1-ebiggers@kernel.org>
 <111ea924-fef5-441e-9849-83f938c913a7@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <111ea924-fef5-441e-9849-83f938c913a7@kernel.org>

On Mon, May 04, 2026 at 03:28:24PM +0200, Christophe Leroy (CS GROUP) wrote:
> Hi Eric,
> 
> Le 04/05/2026 à 06:14, Eric Biggers a écrit :
> > Earlier the decision was made to keep this code for a while, despite no
> > other architectures having optimized MD5 code anymore, because of
> > someone using it via AF_ALG via libkcapi-hasher
> > (https://lore.kernel.org/r/f0d771d5-ed70-444c-957a-ad4c16f6c115@csgroup.eu/)
> > 
> > However, with AF_ALG itself now being on its way out due to its
> > continuous stream of security vulnerabilities
> > (https://lore.kernel.org/r/20260430011544.31823-1-ebiggers@kernel.org/),
> > it's time to be a bit more forceful with nudging people towards
> > userspace crypto code.  It's always been the better solution anyway, and
> > it's much more efficient if properly optimized code is used.
> 
> Ok, why not, but what do you propose as an alternative ? Let me explain the
> situation.
> 
> We have two versions of boards:
> - One with powerpc MPC885E, which embeds a SECURITY Engine called TALITOS
> for offloading crypto operations
> - One with powerpc MPC866, which doesn't have the security engine.
> 
> To use the security engine, our software use the AF_ALG interface (via
> libkcapi).
> 
> Our software has to run on both boards, we can't afford two different
> versions of the software and the software shall have no dead code. Therefore
> we rely on the capability of the kernel to do the hash by itself when the
> TALITOS in not available.
> 
> The kernel has always been the place where we do board specific stuff, not
> the application. I can't see why the application would have to ask the
> kernel when the Talitos is there and have to do the hashing by itself when
> the Talitos is not there.
> 
> I'm really concerned with the optimised MD5 going away now, and I'm also
> wondering what will be the way to splice a file into the kernel and get it's
> MD-5 hash from the TALITOS if AF_ALG goes away in medium-term.
> 
> What is the way forward ? I'm open to any suggestion as I really can't see
> where to go for now.
> 
> But please don't remove powerpc MD5 before we find an alternative solution.
> 
> Thanks
> Christophe

I think I gave the solution in the commit message already, no?  Take the
same MD5 code and run it in userspace.  It will be even faster than
invoking that code via AF_ALG.

Yes, the selection of software vs "security" engine (if you actually
still need the latter, which in reality you probably don't) would then
occur in userspace.  But selecting an implementation in userspace isn't
unusual.  It's no different from how different CPU features are handled
in userspace.

Anyway, please don't confuse this patch (which only affects performance)
with full removal of AF_ALG (which would be a hard break, and won't
occur until quite far in the future).  This patch is just a nudge in the
right direction, and a cleanup of the kernel's powerpc support to be
aligned with all the other architectures.  So I do believe we should
proceed with this patch.

- Eric
