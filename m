Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0B9171CD;
	Mon, 25 Nov 2024 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732547956; cv=none; b=qkMNlupixideU9AI+lbB+2bStr2nWkahizh1lrXuanuB9RtR9TScPV2/y3etFKrueEEDx8cOr9gkvYdhX1dLmjCj92ngdz6RGLBPjTgqXUKe2/EKfLDN7oX6Uox5mq+xXYVzvVL6aUlEKtOotlpZkbCWILSFlwM9hOgBPhSsreo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732547956; c=relaxed/simple;
	bh=xEpte8eBmmW0xPcX9oq49i5AgBNK902Y26wJxaJvDoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kOgUR2fUZHp2QDKLzftsdRq7cXG5StxQDW7Hw5jdbB64J70V4if0xrok7+C2mpillWIzW9Jwx/lbnGquqLHO0s56y9NheYVk/NE/ztCJX3WUfjuuZMkTRGzl6Ht3MdvMZ+j1MBWHbmjv3Okv9SFK0TJpnNB+RCk2bnrw0od1ftc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF6511692;
	Mon, 25 Nov 2024 07:19:43 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9A1B3F66E;
	Mon, 25 Nov 2024 07:19:11 -0800 (PST)
Date: Mon, 25 Nov 2024 15:18:57 +0000
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
Message-ID: <Z0SVYSew0gIgSdAe@J2N7QTR9R3>
References: <90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de>
 <CAMj1kXFvJGHr_iv6bFQfb89XqPFrNWH7-rV7SFy4QBSWXYC4RA@mail.gmail.com>
 <CAMj1kXER7AbNyUDjtij6Ni0jVRMg11xvyhkCMKAxaKbx=dsgcQ@mail.gmail.com>
 <Z0RJaU4wjU5WeQb4@wunner.de>
 <Z0RWcgrQASMIleRn@J2N7QTR9R3>
 <Z0SOZhtJohCNxX6_@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0SOZhtJohCNxX6_@wunner.de>

On Mon, Nov 25, 2024 at 03:49:10PM +0100, Lukas Wunner wrote:
> On Mon, Nov 25, 2024 at 10:50:48AM +0000, Mark Rutland wrote:
> > On Mon, Nov 25, 2024 at 10:54:49AM +0100, Lukas Wunner wrote:
> > > Other arches do not seem to be concerned about this and
> > > let virt_addr_valid() return true for the kernel image.
> > > It's not clear why arm64 is special and needs to return false.
> > > 
> > > However, I agree there's hardly ever a reason to DMA from/to the
> > > .text section.  From a security perspective, constraining this to
> > > .rodata seems reasonable to me and I'll be happy to amend the patch
> > > to that effect if that's the consensus.
> > 
> > Instead, can we update the test to use lm_alias() on the symbols in
> > question? That'll convert a kernel image address to its linear map
> > alias, and then that'll work with virt_addr_valid(), virt_to_phys(),
> > etc.
> 
> Do you mean that sg_set_buf() should pass the address to lm_alias()
> if it points into the kernel image?

No; I meant that the test could use lm_alias() on the test vectors
before passing those to sg_set_buf(), when the test code knows by
construction that those vectors happen to be part of the kernel image.
That'll work on all architectures.

That said, looking at the code it appears that testmgr.c can be built as
a module, so the test vectors could be module/vmalloc addresses rather
than virt/linear or image addresses. Given that, I don't think the
changes suggested here are sufficient, as module addresses should still
be rejected.

Can we kmemdup() the test vector data first? That'd give us a legitimate
virt/linear address that we can use.

> That would require a helper to determine whether it's a kernel image
> address or not.  It seems we do not have such a cross-architecture
> helper (but maybe I'm missing something).  (I am adding an arm64-specific
> one in the proposed patch.)
> 
> So this doesn't look like a viable approach.
> 
> Also, I'd expect pushback against an sg_set_buf() change which is
> only necessary to accommodate arm64.  I'd expect the obvious question
> to be asked, which is why arm64's virt_addr_valid() can't behave like
> any other architecture's.  And honestly I wouldn't know what to answer.

I don't think arm64 is doing anything wrong here; an image address is
*not* a virt/linear address, and we only fix that up in virt_to_*() as a
best-effort thing. I think other architectures which accept that are
signing themselves up for subtle bugs that we're trying to prevent
early.

Mark.
