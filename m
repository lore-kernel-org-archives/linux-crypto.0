Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A622500B5;
	Mon, 25 Nov 2024 10:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732531868; cv=none; b=fl0ZN61u0IVv64bBSaOkHZPiWJR9erK0QxZJ6Mv/WqA1y6+EExCzKdtnrzUlhKhmm2xA5bj8sFC8Ybe0QSVJ4PaDAdxsauUEJpXzINnUZZGx39XppUc/wpfOZ0bsO9EVQLzIqdDVviZtfWYrYDzZgK9fQYigj7c1xCe2iWkmDrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732531868; c=relaxed/simple;
	bh=/yWyw62R/SG0tLxmmOZ9UjT8tj2zZAL5Cpw4RfSWPvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEG4y32LbhF3MhnFgzxNtxOA/7HUp3/amxbKvHzPKoYBW3GTD/iCcNYGF8v3pRO/efXmG6KyeevUp79e/O8QXGbB7LNpTxYdn2omFOVLciruZiPLDxpNave3VerGKBQ/4BNnc6dWEXiD0tVJmMADozTKf9xLxDQMc+V/++c+AzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3355E1692;
	Mon, 25 Nov 2024 02:51:35 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36CA93F66E;
	Mon, 25 Nov 2024 02:51:03 -0800 (PST)
Date: Mon, 25 Nov 2024 10:50:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Zorro Lang <zlang@redhat.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next/fixes] arm64/mm: Fix false-positive
 !virt_addr_valid() for kernel image
Message-ID: <Z0RWcgrQASMIleRn@J2N7QTR9R3>
References: <90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de>
 <CAMj1kXFvJGHr_iv6bFQfb89XqPFrNWH7-rV7SFy4QBSWXYC4RA@mail.gmail.com>
 <CAMj1kXER7AbNyUDjtij6Ni0jVRMg11xvyhkCMKAxaKbx=dsgcQ@mail.gmail.com>
 <Z0RJaU4wjU5WeQb4@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0RJaU4wjU5WeQb4@wunner.de>

On Mon, Nov 25, 2024 at 10:54:49AM +0100, Lukas Wunner wrote:
> On Sun, Nov 24, 2024 at 06:13:26PM +0100, Ard Biesheuvel wrote:
> > > On Sun, 24 Nov 2024 at 17:16, Lukas Wunner <lukas@wunner.de> wrote:
> > > > Zorro reports a false-positive BUG_ON() when running crypto selftests on
> > > > boot:  Since commit 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to
> > > > sig_alg backend"), test_sig_one() invokes an RSA verify operation with a
> > > > test vector in the kernel's .rodata section.  The test vector is passed
> > > > to sg_set_buf(), which performs a virt_addr_valid() check.
> > > >
> > > > On arm64, virt_addr_valid() returns false for kernel image addresses
> > > > such as this one, even though they're valid virtual addresses.
> > > > x86 returns true for kernel image addresses, so the BUG_ON() does not
> > > > occur there.  In fact, x86 has been doing so for 16 years, i.e. since
> > > > commit af5c2bd16ac2 ("x86: fix virt_addr_valid() with
> > > > CONFIG_DEBUG_VIRTUAL=y, v2").
> > > >
> > > > Do the same on arm64 to avoid the false-positive BUG_ON() and to achieve
> > > > consistent virt_addr_valid() behavior across arches.
> [...]
> > that doesn't mean doing DMA from the kernel image is a great
> > idea. Allocations in the linear map are rounded up to cacheline size
> > to ensure that they are safe for non-coherent DMA, but this does not
> > apply to the kernel image. .rodata should still be safe in this
> > regard, but the general idea of allowing kernel image addresses in
> > places where DMA'able virtual addresses are expected is something we
> > should consider with care.
> 
> Other arches do not seem to be concerned about this and
> let virt_addr_valid() return true for the kernel image.
> It's not clear why arm64 is special and needs to return false.
> 
> However, I agree there's hardly ever a reason to DMA from/to the
> .text section.  From a security perspective, constraining this to
> .rodata seems reasonable to me and I'll be happy to amend the patch
> to that effect if that's the consensus.

Instead, can we update the test to use lm_alias() on the symbols in
question? That'll convert a kernel image address to its linear map
alias, and then that'll work with virt_addr_valid(), virt_to_phys(),
etc.

I don't think it's generally a good idea to relax virt_addr_valid() to
accept addresses outside of the linear map, regardless of what other
architectures do. We've had issues in the past with broken conversions,
and the fixups in virt_to_phys() is really only there as a best-effort
way to not crash and allow the warning messages to get out.

Mark.
