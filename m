Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D942B9A8;
	Fri, 29 Aug 2025 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756483885; cv=none; b=h6BI0YEO4V5kmre2BCxfTZ4tZJj+LzWgFzpvi8b8cNT8BkRTBEOLVEb55nUHZRxg3Wi3d0ksqmlHx1K7TSNbASX9//Ea2pplsxaYLD/Hw7AzPEILpakvzvVzoGXj/kEs4YpRb+xVEE82b4by4T7XMJ/D1LmknboUWdLC1emwPQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756483885; c=relaxed/simple;
	bh=sqJTNjc9tqL3D56vJ9a8C8Qu0i2VXToHvsttDUp6REg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMvRV1pkuhpLdvNYP2QfHbXq6QEPNgxkH4ndkguDkSeARw2zDClJOX/Z2KQccsX+wg+KivsUTzzbaebjZ/QtTzCrU20UQG7lr84Auxedbr/BBRWAQiIgttwf6Z/YZiWozzB5xXqPmr+5taX+zhJ0AeBV9nckcDJtzx+XHsaHnCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyZYBY9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyZYBY9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553CCC4CEF0;
	Fri, 29 Aug 2025 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756483883;
	bh=sqJTNjc9tqL3D56vJ9a8C8Qu0i2VXToHvsttDUp6REg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WyZYBY9dWSyaRvLdEkrWAcnQnR655At0UbTNlwKw15O8ake1aLvcMYcv7FK6w5mEQ
	 +iWVzxpMWFB8LRAwtARMeCVF5OmtzzeS4VTdwrOH8fDeZ2xw/KofblztMT2C30lV+j
	 /fNWEXPrMFH8igk6kL/8PpjQf9dC0UrYDGF60ePYgVxzDXe82Zjtry+ZuruG5UXWKR
	 /Nkizg3iDv54WJWXH0vTpmCna0scULQmI4wXtgX3TSdjK+7NWfFpmKxcWI/Ldg6c5n
	 lhMNIcIUtSSsAVzsvMk6Sl46KbX1DrlodZCuT9TurbWPzGOxppumEHu81l1WWeTeXJ
	 IHu3U552FvEsg==
Date: Fri, 29 Aug 2025 09:10:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Honza Fikar <j.fikar@gmail.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/12] lib/crypto: blake2s: Always enable arch-optimized
 BLAKE2s code
Message-ID: <20250829161018.GB91803@sol>
References: <20250827151131.27733-1-ebiggers@kernel.org>
 <20250827151131.27733-10-ebiggers@kernel.org>
 <CAEH5pPY98CaSm+EXiuOzo6EuWzGu7rEQjGa3eojk18HP29Rs7w@mail.gmail.com>
 <20250829152912.GA91803@sol>
 <CAMj1kXGf+0b=6kPAzzxgesaOYSJtzoL1oQyNqT2VrUkWFzwJzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1kXGf+0b=6kPAzzxgesaOYSJtzoL1oQyNqT2VrUkWFzwJzA@mail.gmail.com>

On Fri, Aug 29, 2025 at 06:05:42PM +0200, Ard Biesheuvel wrote:
> On Fri, 29 Aug 2025 at 17:30, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Fri, Aug 29, 2025 at 03:08:56PM +0200, Honza Fikar wrote:
> > > On Fri, Aug 29, 2025 at 2:54 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > > Currently, BLAKE2s support is always enabled ('obj-y'), since random.c
> > > > uses it.  Therefore, the arch-optimized BLAKE2s code, which exists for
> > > > ARM and x86_64, should be always enabled too.
> > >
> > > Maybe a stupid question: what about ARM64? The current NEON
> > > implementation in kernel arch/arm/crypto/blake2s-core.S seems to be just
> > > for ARM.
> > >
> 
> That code is scalar not NEON, and is carefully tuned to make use of
> the ARM barrel shifter, which does not exist on arm64.
> 
> > > While the upstream BLAKE2s with NEON is both for ARM and Aarch64 (ARM64):
> > >
> > > https://github.com/BLAKE2/BLAKE2/blob/master/neon
> >
> > There's no ARM64 optimized BLAKE2s code in the Linux kernel yet.  If
> > it's useful, someone would need to contribute it.
> >
> 
> NEON is cumbersome in the kernel so this only makes sense if it is
> substantially more performant, and I'm skeptical that this is the
> case, as you pointed out yourself in
> 
> commit 5172d322d34c30fb926b29aeb5a064e1fd8a5e13
> Author: Eric Biggers <ebiggers@google.com>
> Date:   Wed Dec 23 00:09:59 2020 -0800
> 
>     crypto: arm/blake2s - add ARM scalar optimized BLAKE2s
> 
>     Add an ARM scalar optimized implementation of BLAKE2s.
> 
>     NEON isn't very useful for BLAKE2s because the BLAKE2s block size
>     is too small for NEON to help.  Each NEON instruction would depend
>     on the previous one, resulting in poor performance.
> 
> Even if NEON code might be slightly faster on some cores, the fact
> that it is sensitive to micro-architectural details makes it less
> attractive.

Yes, agreed: there isn't much opportunity for an ARM64 optimized BLAKE2s
implementation to be faster than the generic C code.

- Eric
