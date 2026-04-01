Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618DF2F1FD0
	for <linux-crypto@vger.kernel.org>; Wed,  1 Apr 2026 19:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775073585; cv=none; b=Y6Pv39jHtivgpGszYzquQGSHWtEDgEIi2D9D0Q9E0F/jmCJfTr9qsTUMV9ar5SuMfPswaju26M4kLSDXHAhw/bzbY6c4qFuD6EQ+z3NhQw2hTmVVmGdy/H0+ME7ZuVRzkE0RurICmhJGfwdOYTVeBe3QKBpkD2z88ZMaXh5AynU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775073585; c=relaxed/simple;
	bh=1E8S6zwaRhyrQHTY9xCDgGhQPsQKm8RgNaujalA9hRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsCsjWxXgmCFHc2RukeSNjnGVqpAP0zNMa02iW4HJ+jJf/uoPTH55ZHIXN3KWzlbEv/SngICowGD7DLuvHZonpkURttv5b2z3COXJGIp3BJslGUoB0ahFkfgwxsiZzqf9LM8/glNS41NDeygU+vVMjR/AHk+DD0Jof5gpc9vZP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ki3d4th3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ki3d4th3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C4AC4CEF7;
	Wed,  1 Apr 2026 19:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775073585;
	bh=1E8S6zwaRhyrQHTY9xCDgGhQPsQKm8RgNaujalA9hRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ki3d4th3VNz5G1xa/d0ahz6QHzFVoF/mhM44pFM6iK83NRb/m8dYExRRC6fiEAX+V
	 sb/t5rSk05ApDpyS97AX+q1ysvgv1zZ06ErmpxiFtGTSlspYL8qf32yXqKxAzQQ6pC
	 nS6gZTE7Bsb9GdjLNOWmgiZRh6nm4qodl99MaVcZJ0mXRyS8Ja4Ouv8E9dnk6NL1U0
	 TbTeuc4yG575e69ea1subPgc8UJhTzeLnnhuVoJejIv+7jIrrbKmK33opVZeRRq4gT
	 rz5fUDta5oqXeZ7c0eDMH/52b3bq+GtttuucqRFzUckddPyoEjXBqMld761GFQwEbs
	 YxaeohEV/adRA==
Date: Wed, 1 Apr 2026 12:59:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Demian Shulhan <demyansh@gmail.com>
Subject: Re: [PATCH 0/5] crc64: Tweak intrinsics code and enable it for ARM
Message-ID: <20260401195943.GA2466@quark>
References: <20260330144630.33026-7-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330144630.33026-7-ardb@kernel.org>

On Mon, Mar 30, 2026 at 04:46:31PM +0200, Ard Biesheuvel wrote:
> Apply some tweaks to the new arm64 crc64 NEON intrinsics code, and wire
> it up for the 32-bit ARM build. Note that true 32-bit ARM CPUs usually
> don't implement the prerequisite 64x64 PMULL instructions, but 32-bit
> kernels are commonly used on 64-bit capable hardware too, which do
> implement the 32-bit versions of the crypto instructions if they are
> implemented for the 64-bit ISA (as per the architecture).
> 
> Cc: Demian Shulhan <demyansh@gmail.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> 
> Ard Biesheuvel (5):
>   lib/crc: arm64: Drop unnecessary chunking logic from crc64
>   lib/crc: arm64: Use existing macros for kernel-mode FPU cflags
>   ARM: Add a neon-intrinsics.h header like on arm64
>   lib/crc: arm64: Simplify intrinsics implementation
>   lib/crc: arm: Enable arm64's NEON intrinsics implementation of crc64

I think patches 3 and 4 should be swapped, so it's cleanups first (which
make sense regardless of the 32-bit ARM support) and then the 32-bit ARM
support.

I do think we should be aware that even with the code mostly shared
using the NEON intrinsics, the 32-bit ARM support (which works only on
CPUs that support PMULL, i.e. are also 64-bit capable) doesn't come for
free.  We should expect to deal with occasional issues related to the
intrinsics with certain compiler versions, compiler flags, etc.

I assume that "32-bit kernels on ARMv8 CPUs" is currently still a big
enough niche to bother with this, despite that niche getting smaller
over time.  But as I mentioned I do think we should try to simplify it
as much as possible, e.g. by supporting little-endian only and avoiding
#ifdefs based on things like the compiler whenever possible.

- Eric
