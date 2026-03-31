Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC1237C92D;
	Tue, 31 Mar 2026 20:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774990514; cv=none; b=iKrVlwmFVnM2YKP6YWZu+M2eBYg9boXYanN6VSEeMxGchivBnO5ilQyEsKhbPW5iJsmkYGkg0HXiajJsL+7Yq/rgNqpUSEb6KM0H3drmuQUEzQV1UtV92rald0710spOyvBLJOjlyqNe7FmlVfHBJSApAtefeWn+SGQWTcDH9vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774990514; c=relaxed/simple;
	bh=uigovT+SYNrJEtYmjsd/TPbZfZYMGMjyRrUtaYyhGLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgbN604JTh9fB40ENVF6so912PzVOuYTKhWKEyjnEiRIjtvu8v6gokUyG8MqzHk9DDiPxb7+358Cp3YYI+oDXW9gdhxBxUdUbWoV21CAK0Zube+m9ystnFSPwMp+dnqqnE9efsMWL/j3vQsXiqlW0xA7rQIl9XvXf7oZcwoECII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kEXXpzCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kEXXpzCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6179C19423;
	Tue, 31 Mar 2026 20:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774990514;
	bh=uigovT+SYNrJEtYmjsd/TPbZfZYMGMjyRrUtaYyhGLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kEXXpzCk2NKcTBc/W3HqFUGzTpm0Yxl9dARrdT86UceIq8D6wYhWITQ34+PAB0ULt
	 gE5HSBkD+Uv07Tyiij62w0PfNXCaJPHYssJCEUDZK6Z1qcBPjC4eAS9/9VC1519bj2
	 rz0nh7L/nl7+9k6JKZx4yvuqAacLcV+YFqRcI2KGTILMXZcOrtVzJ/l3m6K3bnYsSv
	 hFdkC4RUB5Xx9x14pmxCHaX4kerhFqFbkp2r5QM+ASktnGj0m1ludvCfoca6Zs/DLI
	 ynwKIUSbBZWw5GKf3yc9xtg1Y5huXSPnWZL5dOuVMcl//0BZSR4tqjpT2KVwtwKwHs
	 WpUl8CaN1jYtw==
Date: Tue, 31 Mar 2026 13:55:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] lib/crypto: aesgcm: Don't disable IRQs during AES block
 encryption
Message-ID: <20260331205511.GA2452@quark>
References: <20260331024430.51755-1-ebiggers@kernel.org>
 <20260331050234.GA4451@sol>
 <1e04994d-4d82-48f4-8022-ea488d203653@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e04994d-4d82-48f4-8022-ea488d203653@app.fastmail.com>

On Tue, Mar 31, 2026 at 09:05:23AM +0200, Ard Biesheuvel wrote:
> (cc Tom)
> 
> On Tue, 31 Mar 2026, at 07:02, Eric Biggers wrote:
> > [Added x86@kernel.org and nikunj@amd.com]
> >
> > On Mon, Mar 30, 2026 at 07:44:30PM -0700, Eric Biggers wrote:
> >> aes_encrypt() now uses AES instructions when available instead of always
> >> using table-based code.  AES instructions are constant-time and don't
> >> benefit from disabling IRQs as a constant-time hardening measure.
> >> 
> >> In fact, on two architectures (arm and riscv) disabling IRQs is
> >> counterproductive because it prevents the AES instructions from being
> >> used.  (See the may_use_simd() implementation on those architectures.)
> >> 
> >> Therefore, let's remove the IRQ disabling/enabling and leave the choice
> >> of constant-time hardening measures to the AES library code.
> >> 
> ...
> > I just noticed the rationale in the patch series that originally added
> > lib/crypto/aesgcm.c in 2022
> > (https://lore.kernel.org/all/20221103192259.2229-1-ardb@kernel.org/):
> >
> >     Provide a generic library implementation of AES-GCM which can be
> >     used really early during boot, e.g., to communicate with the
> >     security coprocessor on SEV-SNP virtual machines to bring up
> >     secondary cores.  This is needed because the crypto API is not
> >     available yet this early.
> >
> >     We cannot rely on special instructions for AES or polynomial
> >     multiplication, which are arch specific and rely on in-kernel SIMD
> >     infrastructure. Instead, add a generic C implementation that
> >     combines the existing C implementations of AES and multiplication in
> >     GF(2^128).
> >
> >     To reduce the risk of forgery attacks, replace data dependent table
> >     lookups and conditional branches in the used gf128mul routine with
> >     constant-time equivalents. The AES library has already been
> >     robustified to some extent to prevent known-plaintext timing attacks
> >     on the key, but we call it with interrupts disabled to make it a bit
> >     more robust. (Note that in SEV-SNP context, the VMM is untrusted,
> >     and is able to inject interrupts arbitrarily, and potentially
> >     maliciously.)
> >
> > So, the user of AES-GCM in arch/x86/coco/sev/ is a bit special.  It runs
> > super early, before the crypto library initcalls have run and enabled
> > the use of AES-NI and PCLMULQDQ optimized routines.  And apparently it
> > really needs protection from timing attacks, as well.
> >
> > I think this patch is still the way to go, but it does slightly weaken
> > the protection from timing attacks for super early users like this.  So
> > I think we'll likely want to do something else as well.  Either:
> >
> > - Disable IRQs in the callers in arch/x86/coco/sev/.
> >
> > - Or, enable the AES-NI and PCLMULQDQ optimized crypto library routines
> >   earlier on x86, so that they will be used in this case.  Specifically,
> >   enable them in arch_cpu_finalize_init() between fpu__init_cpu() and
> >   mem_encrypt_init().
> >
> > I'd prefer the latter.  The dedicated instructions are the proper way to
> > get data and key-independent timing for AES-GCM.  It's much less clear
> > that the generic C code has data and key-independent timing, even if
> > it's run with IRQs disabled.
> >
> 
> AIUI, if we drop the IRQ dis/enable from this code, the generic path
> will be taken during early boot, but later invocations will use the
> accelerated implementations once they become available, right?

Yes, that's correct.  The optimized code gets enabled by a
subsys_initcall.

> Mounting a timing attack requires accurate timing observations and a
> large number of samples, and it seems unlikely to me that a hostile
> VMM would be able to obtain those during the time window in question.

Seems plausible, since it looks like during early boot there is just one
call to each of aesgcm_expandkey(), aesgcm_encrypt(), and
aesgcm_decrypt().  Specifically during snp_secure_tsc_prepare().  Any
other AES-GCM operations happen later as calls from
drivers/virt/coco/sev-guest/sev-guest.c, which does not run that early.

A malicious VMM being able to inject interrupts arbitrarily is a bit
scary, though.

- Eric
