Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3EA342538;
	Sat, 26 Sep 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790443542; cv=none; b=M6rzcrsQ6pTnLxm/MZCqGxTZTV4okrGdUIfBtDZoeeeL6eDPhJYbs4PHHWTeEKijoZZ5V4ARnH3X4tRLvxziDsqBc2eB+GEOWOxoXzRZuSeZkbDBetDaN2xGPGqgaT9OZKZLfVRrDNJmDpJVRZNfAY7WxkxLFTLkS/eZFR+p3Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790443542; c=relaxed/simple;
	bh=y2I90xoCV3PRj5J53q/2o1GlfM7BQr+3Mkt5l5LjiB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEB0nFXMLPEAvhJBFyDReyRtKkXGxDL4D1bwIhMgDLPPOWLeVn0VpX3TD1ZwukTdr/zBYP/Ij6vH4omddYiNf+96gmKT2qWByj9RLXRmPlT8buBHhlATRoMbbUFBTqC0bza1eC26T2tpkwHWRXdPI8vDLDhoXuarK/TJ3KtagsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMmSBcJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMmSBcJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147301F000FF;
	Sat, 26 Sep 2026 17:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790443541;
	bh=CVfEizPoUtkOeR75ExhS6Q/xBOnwOFbVpHS4hH8XutQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aMmSBcJHKDv1Rl7vaODxvUx45eWFGorvbm4HEdAkYkkjMjwAChhv8RmUrPWSoR3r1
	 vGOPVQURZ9GCEpwGsxPZxAeDcmvjkSecdcsxmz8CkSp+woXcSX2RO1b+BlWs/XjEVJ
	 ry3EMdDjir7fbvNzzuoJ+db2tvPipAFaPiioVjRICNvK9p2vNKcZW6a0sD7vmMBHCJ
	 qaNolJggh7+3biheHPqrzw+EmtbpUUyNi7l5tO5cNmhc0mc/IRYKzhUA+SW3Kd7/2J
	 +mKVdstCbmP3ECWwoL6EWmuwRtv++djvgvNV4aqnGxfL7VihKiPf1JZjZ1QERdmjse
	 GkDq57P3DCFQQ==
Date: Sat, 26 Sep 2026 10:25:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: aes - Fix undesired override of some
 optimized AES modes
Message-ID: <20260926172539.GA2460@quark>
References: <20260925202353.10763-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925202353.10763-1-ebiggers@kernel.org>

On Fri, Sep 25, 2026 at 01:23:53PM -0700, Eric Biggers wrote:
> The new library APIs for AES encryption modes were wired up to the
> traditional crypto API via crypto/aes.c.  However, for now the kernel is
> still in a transitional state where various architectures still have
> architecture-optimized implementations of AES modes in arch/*/crypto/,
> wired up to the traditional crypto API only.  Because of that, the
> crypto/aes.c algorithms were given a cra_priority of only 110 to prevent
> them from overriding arch/*/crypto/ in the traditional crypto API.
> 
> However, because of how the traditional crypto API works, the
> cra_priority trick doesn't work in cases where the relevant algorithm
> isn't directly implemented by arch/*/crypto/ but rather is provided by a
> template instance using other code in arch/*/crypto/.
> 
> For example, x86 doesn't have its own "ccm(aes)" but rather relies on
> the "ccm" template constructing it from the x86-optimized "ctr(aes)".
> The existence of the library-based "ccm(aes)" prevents that, even though
> its priority is lower than what the template would produce.
> 
> Thus, "ccm(aes)" ends up using the slower single-block AES code.
> 
> Therefore, skip wiring up the relevant library-based code to the
> traditional crypto API on architectures where this problem can occur, as
> determined by what exists in arch/*/crypto/ for each architecture.
> 
> This is ugly, but it's also temporary: these conditions will go away as
> architecture-optimized implementations of AES modes are migrated into
> the library.  But until then, we need to prevent performance regressions
> by ensuring that the optimized code continues to be used.
> 
> Note: "xts(aes)" is left alone.  Though the "xts" template can use
> "ecb(aes)" as an inner algorithm, in practice this isn't very efficient
> and a dedicated "xts(aes)" is already provided in all the important
> cases anyway.  (This omission is also consistent with the fact that the
> library isn't planned to provide a similar ECB-to-XTS "adapter".)
> 
> Fixes: 20df21a482aa ("crypto: aes - Add CBC and CBC-CTS support using library")
> Fixes: 8ca62072faa1 ("crypto: aes - Add GCM support using library")
> Fixes: f70ad727d1d6 ("crypto: aes - Add CCM support using library")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is intended to be taken through libcrypto-fixes
> 
> v2: Fixed PowerPC config option, and resent as standalone patch

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
