Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A622BD0B;
	Tue, 31 Mar 2026 05:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774933425; cv=none; b=ltm5CTi4u2v/h/N7hGoRKwCboC1VuHALKscftff+Q7YDBkSGukTPGajzQFVTvktseU1CpkeUmvSyHnFEdDxqfRx4yRljbgXb9NUSPljF6z0ZfU0UUtjtj3CSr6/92wohqpXO61XlVNGso/Lei58fb4hZVMY5d1f0omEQdDvIG2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774933425; c=relaxed/simple;
	bh=qMstW/7xUOmb2Y4hr/76ZaJ7NkFZViYfphCvV8YfhMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxLYmAxqTnSumkL2r+02ot3CJ6iX3yTDVGjTA05HAbzjdtEhPiaLR+oPhmQedYX4wmEA7WFEdX9unrQWg0wtgoGoKbBr+plx3BXJVwbmOzrEXcBvPacFx/TRtR0Q2DxbKVoMjk8gVp3QIseZPzk9ogDrfa9gYHXz/8XKK9Th1xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNkY+6yh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNkY+6yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C028AC19423;
	Tue, 31 Mar 2026 05:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774933425;
	bh=qMstW/7xUOmb2Y4hr/76ZaJ7NkFZViYfphCvV8YfhMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UNkY+6yhCQkQedl6Fy8nLDDjX/j7uPg+zLB3iAKVoqwy/ubrqQamcdVg2sBEf9sbG
	 EPQY7h+pqqPfwExPXZDbhNGTtO+IGoIaGJE3MZ413nN2wSMvslSQPv5enZvlN6MGDj
	 xb3TMRK/QDcH/TBdZdG5+OPdAElMEOYFmoXr1i81BOWDHtO6HCA3NytyMjtA9iYmSL
	 yxC+wOvqPX+3p/EBStFKlGhmoOCh/Y4RtsGsGLCQOIKE26a8bMsf8bdw9Fd6YLfRLm
	 FP+lonNunaNmH908fl+uLdeThHjN9VSAPeU1EUkDBWl+BqIm1E1d+oW7HcVAEGomr9
	 MpI3aQsDx1TLA==
Date: Mon, 30 Mar 2026 22:02:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH] lib/crypto: aesgcm: Don't disable IRQs during AES block
 encryption
Message-ID: <20260331050234.GA4451@sol>
References: <20260331024430.51755-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331024430.51755-1-ebiggers@kernel.org>

[Added x86@kernel.org and nikunj@amd.com]

On Mon, Mar 30, 2026 at 07:44:30PM -0700, Eric Biggers wrote:
> aes_encrypt() now uses AES instructions when available instead of always
> using table-based code.  AES instructions are constant-time and don't
> benefit from disabling IRQs as a constant-time hardening measure.
> 
> In fact, on two architectures (arm and riscv) disabling IRQs is
> counterproductive because it prevents the AES instructions from being
> used.  (See the may_use_simd() implementation on those architectures.)
> 
> Therefore, let's remove the IRQ disabling/enabling and leave the choice
> of constant-time hardening measures to the AES library code.
> 
> Note that currently the arm table-based AES code (which runs on arm
> kernels that don't have ARMv8 CE) disables IRQs, while the generic
> table-based AES code does not.  So this does technically regress in
> constant-time hardening when that generic code is used.  But as
> discussed in commit a22fd0e3c495 ("lib/crypto: aes: Introduce improved
> AES library") I think just leaving IRQs enabled is the right choice.
> Disabling them is slow and can cause problems, and AES instructions
> (which modern CPUs have) solve the problem in a much better way anyway.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

I just noticed the rationale in the patch series that originally added
lib/crypto/aesgcm.c in 2022
(https://lore.kernel.org/all/20221103192259.2229-1-ardb@kernel.org/):

    Provide a generic library implementation of AES-GCM which can be
    used really early during boot, e.g., to communicate with the
    security coprocessor on SEV-SNP virtual machines to bring up
    secondary cores.  This is needed because the crypto API is not
    available yet this early.

    We cannot rely on special instructions for AES or polynomial
    multiplication, which are arch specific and rely on in-kernel SIMD
    infrastructure. Instead, add a generic C implementation that
    combines the existing C implementations of AES and multiplication in
    GF(2^128).

    To reduce the risk of forgery attacks, replace data dependent table
    lookups and conditional branches in the used gf128mul routine with
    constant-time equivalents. The AES library has already been
    robustified to some extent to prevent known-plaintext timing attacks
    on the key, but we call it with interrupts disabled to make it a bit
    more robust. (Note that in SEV-SNP context, the VMM is untrusted,
    and is able to inject interrupts arbitrarily, and potentially
    maliciously.)

So, the user of AES-GCM in arch/x86/coco/sev/ is a bit special.  It runs
super early, before the crypto library initcalls have run and enabled
the use of AES-NI and PCLMULQDQ optimized routines.  And apparently it
really needs protection from timing attacks, as well.

I think this patch is still the way to go, but it does slightly weaken
the protection from timing attacks for super early users like this.  So
I think we'll likely want to do something else as well.  Either:

- Disable IRQs in the callers in arch/x86/coco/sev/.

- Or, enable the AES-NI and PCLMULQDQ optimized crypto library routines
  earlier on x86, so that they will be used in this case.  Specifically,
  enable them in arch_cpu_finalize_init() between fpu__init_cpu() and
  mem_encrypt_init().

I'd prefer the latter.  The dedicated instructions are the proper way to
get data and key-independent timing for AES-GCM.  It's much less clear
that the generic C code has data and key-independent timing, even if
it's run with IRQs disabled.

Any thoughts?

- Eric
