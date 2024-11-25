Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA2C190662;
	Mon, 25 Nov 2024 09:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732528495; cv=none; b=PUm+aZVEgMy/kK3NUUDUWzIXmIhxpyl6GF4g0fzUPoIyCYnyHxs0xwvPlwnGIG5K4xfQhZB2qh/RLT+2oN99REJzlY7BdA0yPbKU0brFBRgoTyltOLJHidlE1Vd7ImEaTlwI84eopGu9QbXSCDwgTZHCRXPXMXXs/mjBIAT2jw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732528495; c=relaxed/simple;
	bh=/CLrHMVNx/mePjLWbFiXP/cRihUPLTLPw2Tf94Tmr0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gu63QYlwP79ZmPKbrsseX9FNcJMSae1qElwOyqaW/Rsn/oxiGI8N1sON0RgO8kGJ0QgVAsOcZesk2XG66IhO7KGqAS0LFQ+yc6qk/tiObwP60FzrMS0zgdLV2U4AvmcLzUgMwS9CUBGxbjKL9sfUP7R+2G/xrEaRLY1qRxamAqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=176.9.242.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id C845B100D5868;
	Mon, 25 Nov 2024 10:54:49 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 84C5020B94A; Mon, 25 Nov 2024 10:54:49 +0100 (CET)
Date: Mon, 25 Nov 2024 10:54:49 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Zorro Lang <zlang@redhat.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next/fixes] arm64/mm: Fix false-positive
 !virt_addr_valid() for kernel image
Message-ID: <Z0RJaU4wjU5WeQb4@wunner.de>
References: <90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de>
 <CAMj1kXFvJGHr_iv6bFQfb89XqPFrNWH7-rV7SFy4QBSWXYC4RA@mail.gmail.com>
 <CAMj1kXER7AbNyUDjtij6Ni0jVRMg11xvyhkCMKAxaKbx=dsgcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXER7AbNyUDjtij6Ni0jVRMg11xvyhkCMKAxaKbx=dsgcQ@mail.gmail.com>

On Sun, Nov 24, 2024 at 06:13:26PM +0100, Ard Biesheuvel wrote:
> > On Sun, 24 Nov 2024 at 17:16, Lukas Wunner <lukas@wunner.de> wrote:
> > > Zorro reports a false-positive BUG_ON() when running crypto selftests on
> > > boot:  Since commit 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to
> > > sig_alg backend"), test_sig_one() invokes an RSA verify operation with a
> > > test vector in the kernel's .rodata section.  The test vector is passed
> > > to sg_set_buf(), which performs a virt_addr_valid() check.
> > >
> > > On arm64, virt_addr_valid() returns false for kernel image addresses
> > > such as this one, even though they're valid virtual addresses.
> > > x86 returns true for kernel image addresses, so the BUG_ON() does not
> > > occur there.  In fact, x86 has been doing so for 16 years, i.e. since
> > > commit af5c2bd16ac2 ("x86: fix virt_addr_valid() with
> > > CONFIG_DEBUG_VIRTUAL=y, v2").
> > >
> > > Do the same on arm64 to avoid the false-positive BUG_ON() and to achieve
> > > consistent virt_addr_valid() behavior across arches.
[...]
> that doesn't mean doing DMA from the kernel image is a great
> idea. Allocations in the linear map are rounded up to cacheline size
> to ensure that they are safe for non-coherent DMA, but this does not
> apply to the kernel image. .rodata should still be safe in this
> regard, but the general idea of allowing kernel image addresses in
> places where DMA'able virtual addresses are expected is something we
> should consider with care.

Other arches do not seem to be concerned about this and
let virt_addr_valid() return true for the kernel image.
It's not clear why arm64 is special and needs to return false.

However, I agree there's hardly ever a reason to DMA from/to the
.text section.  From a security perspective, constraining this to
.rodata seems reasonable to me and I'll be happy to amend the patch
to that effect if that's the consensus.

I'll wait for guidance from arm64 maintainers what the preferred
approach is.

Thanks,

Lukas
