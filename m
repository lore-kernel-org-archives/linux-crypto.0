Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A628189902;
	Mon, 25 Nov 2024 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732546159; cv=none; b=Y3Eg3YSy9vjjFVvxXCygp3TiLGKpEdjzmFd9SUhadGAf8XnEaSRqH3bDRngNh4kOcjR7lq7ZtQcTkDbMQFkSU2mpDCBQZlFuFJccvX1QmTz4rpn3oK6UgyBjTKJKtlaqsAmY6zpYg4okU6hiz7deW4KkRrHjSgqp48UizbTEuEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732546159; c=relaxed/simple;
	bh=qHRw4mJYZ51r7U3KQtuYVZftXv8lMYjCUNP70Rurk4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAg7msve0fatkxVpVhr1Myl0HqOv5Ab2dBWBKLLLXTqMqQNxdcMk4o8SpvlaE+sLnFKWK1IZoN5acwT3i8tWXAgvpWv5TfmMN2cSX98K39NVJhGIQBHr4fIuPFo1/If2qkfdfiH5i3R0lYrNzjq+QZkeYhsPw5xsxgtH4OmfcZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 0631B30008CA3;
	Mon, 25 Nov 2024 15:49:11 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id E2FC24E9249; Mon, 25 Nov 2024 15:49:10 +0100 (CET)
Date: Mon, 25 Nov 2024 15:49:10 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <Z0SOZhtJohCNxX6_@wunner.de>
References: <90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de>
 <CAMj1kXFvJGHr_iv6bFQfb89XqPFrNWH7-rV7SFy4QBSWXYC4RA@mail.gmail.com>
 <CAMj1kXER7AbNyUDjtij6Ni0jVRMg11xvyhkCMKAxaKbx=dsgcQ@mail.gmail.com>
 <Z0RJaU4wjU5WeQb4@wunner.de>
 <Z0RWcgrQASMIleRn@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0RWcgrQASMIleRn@J2N7QTR9R3>

On Mon, Nov 25, 2024 at 10:50:48AM +0000, Mark Rutland wrote:
> On Mon, Nov 25, 2024 at 10:54:49AM +0100, Lukas Wunner wrote:
> > Other arches do not seem to be concerned about this and
> > let virt_addr_valid() return true for the kernel image.
> > It's not clear why arm64 is special and needs to return false.
> > 
> > However, I agree there's hardly ever a reason to DMA from/to the
> > .text section.  From a security perspective, constraining this to
> > .rodata seems reasonable to me and I'll be happy to amend the patch
> > to that effect if that's the consensus.
> 
> Instead, can we update the test to use lm_alias() on the symbols in
> question? That'll convert a kernel image address to its linear map
> alias, and then that'll work with virt_addr_valid(), virt_to_phys(),
> etc.

Do you mean that sg_set_buf() should pass the address to lm_alias()
if it points into the kernel image?

That would require a helper to determine whether it's a kernel image
address or not.  It seems we do not have such a cross-architecture
helper (but maybe I'm missing something).  (I am adding an arm64-specific
one in the proposed patch.)

So this doesn't look like a viable approach.

Also, I'd expect pushback against an sg_set_buf() change which is
only necessary to accommodate arm64.  I'd expect the obvious question
to be asked, which is why arm64's virt_addr_valid() can't behave like
any other architecture's.  And honestly I wouldn't know what to answer.

Thanks,

Lukas
