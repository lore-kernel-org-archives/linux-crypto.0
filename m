Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67A6191484;
	Thu,  6 Mar 2025 02:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741229806; cv=none; b=MVhQDIDW/TJV40s+7QVNqnIvd0W0Ao/fr2UMCEpAEBzZTO1FCMzgtRvOgIEQ3k6HMsuEAfcM+AXERNpligaEZ/ZwiHnrzmtZE3CoB2+ctQXioo1Q3MwM2+G79lqqz4uFX8r4nhcHKee+aMXX6NaCN95abVbyhMMIDYWAOvQ7gCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741229806; c=relaxed/simple;
	bh=8DeWfzCxrqel0/a7+qeFa55jA1XHeM+A8wMYrayk/U8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s8VX/5utz1FQQrXm2Y3ZVjcl2VQLdBBigHDqeHOd2O8Bpq3MgLFu+xW4P1/mcwXNpDKbB/iFBlf99KP1aN0NufNlPiIsfn1Lrk1rlJmtvv1pGOmCfUqzbxSK6X5bq7d8i6VWtM7ydVo4Ov86K6IhueqH2I9E8ve4Ev/xnxlUznw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CW9jEJvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CW9jEJvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F43C4CED1;
	Thu,  6 Mar 2025 02:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741229805;
	bh=8DeWfzCxrqel0/a7+qeFa55jA1XHeM+A8wMYrayk/U8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CW9jEJvfczPFw6j9/0McknStDTMBFz1KTucb6dKvDCc0zaL1eTb2kHQNJCIR+DlzV
	 Bv7gzJXXnQHzlLbylnKsV+sEYTbcREaDrv9m+X6fbXil6ccqgkenc9gRgo19OshVDO
	 GgEyIfXjOxM1mV1Jn/3xlYF1m1+e4kxJ8DcTSPtxGOSP1t6u7fDOYdRTEPBSmRwoJx
	 hOF5PueZbmDztYOFSZ85wV1dKtDqtDhRmLb5SZsHDCPHRPh67ltmvThYPACTuCh9B3
	 mMZ9h0ECnkTac85q2TaO3uXCRol+iyUHjhJ4O83CiKnVJ9wnFogXH/sEhDo2EqMdn3
	 2EoupNof6gtcw==
Date: Wed, 5 Mar 2025 18:56:43 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Bill Wendling <morbo@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] x86/crc32: optimize tail handling for crc32c short inputs
Message-ID: <20250306025643.GA1592@sol.localdomain>
References: <20250304213216.108925-1-ebiggers@kernel.org>
 <20250305142653.751d9840@pumpkin>
 <20250305191608.GA19889@sol.localdomain>
 <20250305220739.1cb4b61e@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305220739.1cb4b61e@pumpkin>

On Wed, Mar 05, 2025 at 10:07:39PM +0000, David Laight wrote:
> On Wed, 5 Mar 2025 11:16:08 -0800
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > On Wed, Mar 05, 2025 at 02:26:53PM +0000, David Laight wrote:
> > > On Tue,  4 Mar 2025 13:32:16 -0800
> > > Eric Biggers <ebiggers@kernel.org> wrote:
> > >   
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > For handling the 0 <= len < sizeof(unsigned long) bytes left at the end,
> > > > do a 4-2-1 step-down instead of a byte-at-a-time loop.  This allows
> > > > taking advantage of wider CRC instructions.  Note that crc32c-3way.S
> > > > already uses this same optimization too.  
> > > 
> > > An alternative is to add extra zero bytes at the start of the buffer.
> > > They don't affect the crc and just need the first 8 bytes shifted left.
> > > 
> > > I think any non-zero 'crc-in' just needs to be xor'ed over the first
> > > 4 actual data bytes.
> > > (It's over 40 years since I did the maths of CRC.)
> ...
> > > 	David  
> > 
> > Sure, but that only works when len >= sizeof(unsigned long).  Also, the initial
> > CRC sometimes has to be divided between two unsigned longs.
> 
> Yes, I was thinking that might make it a bit more tricky.
> I need to find some spare time :-)
> 
> I wasn't taught anything about using non-carry multiplies either.
> And I can't remember the relevant 'number field' stuff either.
> But (with no-carry maths) I think you have:
> 	crc(n + 1) = (crc(n) + data(n)) * poly
> If data(n+1) and data(n+2) are zero (handled elsewhere) you have:
> 	crc(n + 3) = (((crc(n) + data(n)) * poly) * poly) * poly
> I think that because it is a field this is the same as
> 	crc(n + 3) = (crc(n) + data(n)) * (poly * poly * poly)
> which is just a different crc polynomial.
> If true your '3-way' cpu doesn't have to use big blocks.

Well, to extend by some constant number of bits 'n', you can carryless-multiply
by the polynomial x^n, pre-reduced by the CRC's generator polynomial.  That's
basically how all the CRC implementations using carryless multiplication work.
Take a look at the x86 and riscv optimized code, for example -- especially my
new versions in the crc-next tree at
https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next.

But x86 does not have a scalar carryless multiplication instruction, only vector
(PCLMULQDQ).  It does have a scalar CRC instruction, for crc32c *specifically*,
and that is what the code we're discussing is taking advantage of.  Given that
there is overhead associated with using kernel-mode FPU (i.e. vector), it makes
sense to do that, at least on short messages.

On longer messages a PCLMULQDQ-only implementation would work well, but so does
interleaving the crc32c scalar instruction on multiple chunks, which is what is
currently wired up in the kernel via crc32c-3way.S.  And yes, the chunks for
that do not *have* to be long, but you still need to use pclmulqdq instructions
to combine them (unless you do a really slow bit-at-a-time carryless
multiplication), and you have to enter a kernel-mode FPU section to do that.

- Eric
