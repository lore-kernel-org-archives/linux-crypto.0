Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D0D1531EA;
	Thu, 17 Oct 2024 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729202651; cv=none; b=AOJ4G48/Hb+PqKtNfznyPO5+UaG0Aiq7QxXp+i9BCSsGRVOswpuEhojuoRps15YU9fPHmA2EcOLAyDJp+FNGA7Lx1lEdSzDcGUwFEiQ1wjrh1iN7glFPUUflkWCpvvwTpeSnRpw3kyjveGheIK4XXZPQgcoZ8E2KNzF0rYcksLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729202651; c=relaxed/simple;
	bh=WJiXraYnLFsn2UwSe85rbF1/b6U4gvtBHtFJkJLo8M8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3e4KSqRFEgi6zFQgmdKUeIxXoF6xmaoX/1mlnafSzFsSFovjgsuqufoUwid1bjzDzGb2pyBrdZ0k17KIo37A3LLPHMN8gI+zV/XEWIY7pAdBseRYnhgQ5Dglydz0FYjk8WItBiCA0OXMytuid5KOzDm8vrko5XpeX+BFDcqOac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHOYOIAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHOYOIAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DADC4CEC3;
	Thu, 17 Oct 2024 22:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729202651;
	bh=WJiXraYnLFsn2UwSe85rbF1/b6U4gvtBHtFJkJLo8M8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DHOYOIAvZZ1gWxOepJPe/c72xDeAS/W3jVejl8b93mRbFAWpqpwrTNpEUJtlHCBNW
	 yMFGcbUSxLWwvbZsFIlEfRjpNHgM6jyx3PE4XHScdFtLgoQo8xm6P9aFYa7I06HfxT
	 oAaMYgZrdHGMrEfb3QXQcqJYfK/rRSsC56fX2LK7Fstd2fYKjufrSFNvRI0lVSoLxo
	 sdMBwToKtfomEIqPus0RiGGTwv2tR0ySYxSGyGmztQwF9K9Os7OxEl+wCq6HgEP8Da
	 qhYIrYkSCdH1NiCoSvYt5syp0fEAa3TblXqjcu/9qCMNNqPhKma2kQIwlKO1hoQC8f
	 Fp63vCuEcRitg==
Date: Thu, 17 Oct 2024 15:04:09 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	will@kernel.org, catalin.marinas@arm.com,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v3 0/2] arm64: Speed up CRC-32 using PMULL instructions
Message-ID: <20241017220409.GC11717@sol.localdomain>
References: <20241017094132.2482168-4-ardb+git@google.com>
 <CAMj1kXFROGbn_49njp_rivEidqfgnLymOCRnfSkV_dTX_hAz9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFROGbn_49njp_rivEidqfgnLymOCRnfSkV_dTX_hAz9w@mail.gmail.com>

On Thu, Oct 17, 2024 at 06:30:19PM +0200, Ard Biesheuvel wrote:
> > Ard Biesheuvel (2):
> >   arm64/lib: Handle CRC-32 alternative in C code
> >   arm64/crc32: Implement 4-way interleave using PMULL
> >
> 
> I'll need to respin this - the crc32_be code doesn't actually work correctly.

Right, good catch.  It looks like it needs an rbit of the crc value at the
beginning and end.  lib/crc32test.c doesn't actually test crc32_be_arm64_4way()
because it runs the tests with IRQs disabled; it probably shouldn't do that.

On a slightly related topic, since any crc32_le() and __crc32c_le() functions in
arch/*/lib/ are automatically exposed as shash algorithms via the crypto API
(this was already the case, but your other patch makes this more explicit by
properly separating them from the generic implementation), I wonder if all the
remaining arch/*/crypto/crc32*.c should be migrated to arch/*/lib/, and then
users of crc32 and crc32c like ext4 and f2fs should just use the library
functions instead of shash.  That would simply things greatly.  See e.g. the
horrible hacks used in ext4_chksum() and __f2fs_crc32()...

The only crc32 and crc32c implementations that *aren't* software based are those
in drivers/crypto/stm32/stm32-crc32.c and
drivers/crypto/inside-secure/safexcel_hash.c.  Access to those would be lost by
going through lib.  But I strongly suspect they exist just because the hardware
supported it and not because they are actually useful.

- Eric
