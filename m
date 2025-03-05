Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5905324CEE3;
	Wed,  5 Mar 2025 19:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741202171; cv=none; b=c5HtRBr7rC8Dn6owXdNybh+ikp4w/xOXKbFDgN9hqHJgCzs59IrTJVM3623ozsnGyKaRk/7jfzPdy3xYdvb4eZsYZ5ue4zxpN9Ijs/UCIghULLabkXEXHwShT5JQdR+0VYnipxiPiiaEyv1nDAEq8VV67Em+K38Vy7Eyiq/IqCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741202171; c=relaxed/simple;
	bh=fubuqMlM2Oo+8Icg3TWKdYQa/lCj0hx58ocM+KyVbgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAILJq7RyW0w1OniMfdNwdAWRki3yDzrCdf8aBhBUXp+gNva3Qj8WWx7WSP131HAvRoAUplEBR+JmYUQeQ6X+P2lZeEnLVdV1vpOE96CIywOoXF4RYyM0rNKuDKkW1sFBxWExeUKeFvks3w/Q3S/gEelIOiIt9fh77a/a/gKu4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQ9Q1udn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQ9Q1udn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E83C4CED1;
	Wed,  5 Mar 2025 19:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741202170;
	bh=fubuqMlM2Oo+8Icg3TWKdYQa/lCj0hx58ocM+KyVbgk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kQ9Q1udnJ68GCD1jFiiTzPgeSSS5VMfZveMn/1zpJQBDvv5yc70hyqvAsnij9q52k
	 KOxrgKUB3LNd7KdtwOtwvRJ+EhMWg5K+9h1zKPnkUlQ3siibjMWiiMPuESXNt4CimP
	 s+14lE1XgnOq06UG1O7u4a80DMc5NQFGLrW68tV+HAnA1erm7Pbh56IeslO7sUiaPU
	 Btsjp5hQ9N4nBR2LcqHZk3jQ5KoTaeQJdDoejoRJVjWQW8o8r1mqTZ9OU0jJCZAD1v
	 ZkW1F8mlax5weiwXLKout3xc0phW0pziQEYKzlXaZwJS4zOq758M9tWm/tprfN6MWO
	 bvcPzpYqGSECA==
Date: Wed, 5 Mar 2025 11:16:08 -0800
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
Message-ID: <20250305191608.GA19889@sol.localdomain>
References: <20250304213216.108925-1-ebiggers@kernel.org>
 <20250305142653.751d9840@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305142653.751d9840@pumpkin>

On Wed, Mar 05, 2025 at 02:26:53PM +0000, David Laight wrote:
> On Tue,  4 Mar 2025 13:32:16 -0800
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > For handling the 0 <= len < sizeof(unsigned long) bytes left at the end,
> > do a 4-2-1 step-down instead of a byte-at-a-time loop.  This allows
> > taking advantage of wider CRC instructions.  Note that crc32c-3way.S
> > already uses this same optimization too.
> 
> An alternative is to add extra zero bytes at the start of the buffer.
> They don't affect the crc and just need the first 8 bytes shifted left.
> 
> I think any non-zero 'crc-in' just needs to be xor'ed over the first
> 4 actual data bytes.
> (It's over 40 years since I did the maths of CRC.)
> 
> You won't notice the misaligned accesses all down the buffer.
> When I was testing different ipcsum code misaligned buffers
> cost less than 1 clock per cache line.
> I think that was even true for the versions that managed 12 bytes
> per clock (including the one Linus committed).
> 
> 	David

Sure, but that only works when len >= sizeof(unsigned long).  Also, the initial
CRC sometimes has to be divided between two unsigned longs.

The following implements this, and you can play around with it a bit if you
want.  There may be a way to optimize it a bit more.

But I think you'll find it's a bit more complex than you thought.

I think I'd like to stay with the shorter and simpler 4-2-1 step-down.

u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
{
	if (!static_branch_likely(&have_crc32))
		return crc32c_base(crc, p, len);

	if (IS_ENABLED(CONFIG_X86_64) && len >= CRC32C_PCLMUL_BREAKEVEN &&
	    static_branch_likely(&have_pclmulqdq) && crypto_simd_usable()) {
		kernel_fpu_begin();
		crc = crc32c_x86_3way(crc, p, len);
		kernel_fpu_end();
		return crc;
	}

	if (len % sizeof(unsigned long) != 0) {
		unsigned long msgpoly;
		u32 orig_crc = crc;

		if (len < sizeof(unsigned long)) {
			if (sizeof(unsigned long) > 4 && (len & 4)) {
				asm("crc32l %1, %0"
				    : "+r" (crc) : ASM_INPUT_RM (*(u32 *)p));
				p += 4;
			}
			if (len & 2) {
				asm("crc32w %1, %0"
				    : "+r" (crc) : ASM_INPUT_RM (*(u16 *)p));
				p += 2;
			}
			if (len & 1)
				asm("crc32b %1, %0"
				    : "+r" (crc) : ASM_INPUT_RM (*p));
			return crc;
		}
		msgpoly = (get_unaligned((unsigned long *)p) ^ orig_crc) <<
			  (8 * (-len % sizeof(unsigned long)));
		p += len % sizeof(unsigned long);
		crc = 0;
		asm(CRC32_INST : "+r" (crc) : "r" (msgpoly));

		msgpoly = get_unaligned((unsigned long *)p) ^
			  (orig_crc >> (8 * (len % sizeof(unsigned long))));
		p += sizeof(unsigned long);
		len -= (len % sizeof(unsigned long)) + sizeof(unsigned long);
		asm(CRC32_INST : "+r" (crc) : "r" (msgpoly));
	}

	for (len /= sizeof(unsigned long); len != 0;
	     len--, p += sizeof(unsigned long))
		asm(CRC32_INST : "+r" (crc) : ASM_INPUT_RM (*(unsigned long *)p));

	return crc;
}
