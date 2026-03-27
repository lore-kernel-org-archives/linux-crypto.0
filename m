Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA68A3DEAC0;
	Fri, 27 Mar 2026 17:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632265; cv=none; b=Fr+OChdDw9Xh+8/RivE4ylOADHaB5zEZfIrzMtvHZPDTHgBcV3KJ1nDDabObHkZX2B9uSkCi/YAeCI99UIELxWmwXpsOnApD8m5W0sbXQCTBL7xBZrXEOqTbyX5mWXeKia2EOHHQJMoujpRut+EMXJiw4J2iSSo6Av5PbNgLX1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632265; c=relaxed/simple;
	bh=gTtjGwzSChsLL9Od7n/9UFgIXBsiTV+PnVqaWgbAtH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2mqijCz9sHTX3NZtI0WD1Y/TdtRDtCZoWjBy6aopd0+b9p6lKP7cZLTZSUswL6BJ0K7caflb2wYIZ1GDyh4QwJCrZ5oUoNeXs6HV/GYmEgy54bFvX1Wt5FoXS91Xqf8DtlGDKfwQwT/lTLyoAaPudiHqr8xDaGdV7hw2ATCkJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mttds8zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mttds8zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EDEC2BC9E;
	Fri, 27 Mar 2026 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774632265;
	bh=gTtjGwzSChsLL9Od7n/9UFgIXBsiTV+PnVqaWgbAtH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mttds8zrEN0sWll98lr8NoQsL/6553+pOoxQlRvhTRUVNJDAzECvyiaszsTrvSmLj
	 amNBs9+0x9Fam4wTkNBEmkkCnrnuMxhdaa+A0AaiOrrEPkKAAB1LRtxzpV6plCGt2g
	 rZU6fZxDcOruZxgvFPu86KDN+eE5Kh2E6ZK1N/D4uAbagzT2FvgJsurNcEiaKQBjOF
	 BBpPJoOlyHWHdXNuejF5z7LNhGrmrLVBY+RLBpwbRtLMzk7q3Vn7cRcTzB3Jx0cR73
	 Vtho9zWkDDuAub75p07nwAO3phn7ZwOqEt89TMGx3BhZSgJe/rWb4+j0CKNUO96WeE
	 Eu7YetdJZPQHA==
Date: Fri, 27 Mar 2026 17:24:23 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: [PATCH 0/3] crypto: Remove arch-optimized des and des3_ede code
Message-ID: <20260327172423.GA3407398@google.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
 <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>
 <20260326202733.GA2657@quark>
 <35e00d0f-85f6-457a-99b4-703caf3e1e6e@hogyros.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35e00d0f-85f6-457a-99b4-703caf3e1e6e@hogyros.de>

On Fri, Mar 27, 2026 at 06:59:21PM +0900, Simon Richter wrote:
> On 3/27/26 5:27 AM, Eric Biggers wrote:
> 
> > In general that's good of course, but DES and 3DES?  Really?  Why is
> > effort going into these obsolete algorithms at all?
> 
> If there's dedicated instructions, we need to emulate them, even if the
> kernel stops using them, because userspace might still use them. The
> alternative is implementing them as a trap in the kernel that delegates to
> the crypto subsystem, and nobody wants that. O_O

While I appreciate the sudden eagerness to implement these instructions
in QEMU after them not being supported for 15 years, I'd suggest that
the instructions for the more modern algorithms should be prioritized.

> I wonder if it would make sense to split between "crypto" and "offload"
> subsystems, so the "crypto" side can focus on a small number of contemporary
> algorithms and give them simple, easily auditable interfaces, and move all
> the complexity of asynchronous request processing in offload hardware over
> to the "offloading" side. The userspace API would also move to the
> "offloading" subsystem.

lib/crypto/ and crypto/ already largely provides that distinction, no?

> This would give the offloading subsystem a bit more flexibility in API
> design as well, so we could maybe represent offload capabilities in network
> or storage hardware as well

The kernel already has perfectly good support for inline storage
encryption in the block layer.  See
Documentation/block/inline-encryption.rst.  It's a completely different
model from non-inline crypto engines.  Trying to create some common
abstraction is not going to succeed.

> However, even from the "crypto" perspective I believe that we can't get
> around support for asynchronous offload devices, because of mobile devices.
> I suspect no one would be building dedicated silicon for asynchronous AES
> into mobile CPUs if that wasn't worth it somehow

They do it anyway.  It's a checkbox feature.  I.e. the purpose is for it
to be advertised on a list of features.

> so if such a device is
> present, we want to use it as much as possible, because the expectation is
> that while the difference in performance compared to the CPU is hardly
> noticeable, the difference in battery lifetime is (that's why dropping async
> request support from fscrypt makes it largely useless on mobile).

I'm quite familiar with how fscrypt is being used on mobile, thanks.
Most people do use hardware offload with fscrypt, but it is *inline*
hardware offload.  That remains fully supported via blk-crypto and is
unrelated to the crypto API.  The rest just use the CPU.

I've only ever heard of one case almost a decade ago where someone
intentionally used a non-inline offload engine with fscrypt.  And I even
recently showed that on the same line of SoCs that was being used in
that case, it is no longer worth it, if it ever was.

Every other case has just been someone using one by mistake and getting
their performance tanked or encountering driver bugs as a result.

Anyway, this seems very off-topic for this thread, which is about
whether the architecture-optimized DES and 3DES code should be removed.

- Eric
