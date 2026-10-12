Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0714B4349A6;
	Mon, 12 Oct 2026 07:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791789723; cv=none; b=CERNh4XvwbmtlIrMMW0bkjI4KGO7vl5DYdY6qZnwVJqb3NtdEdBg3Yvguh/P74xSVIQ7xidvPzK2OoLhVTcQNI3p46T+mBSqSYBTUVUhMUTHg+C83AoV1XHwcOPkDBs5L7BBInqLwm0AN/vkI9M3CSNYhoP88USc5sMPRlaKs64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791789723; c=relaxed/simple;
	bh=nr+QZ7RJ49qQP6XyJmTS4ZaFR0oQMnRmaIk2jj73Y6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVf8i3TsxAGLAA2XeheIsduAQDz2x3VImH6HByrIh5lDY1bjkG/XrKqnQg4eUwYowFb8K28Cvx3j6Wl83X7WHD+m2Num2tOvo7SA3WMbTGOcfToCIIcGq5mDCCHN7ydUdCTC3ViWIS+EX+3oyuNJicySq6BSTZMO/OTjK1NQpDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jNFlcw8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNFlcw8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371851F0089B;
	Mon, 12 Oct 2026 07:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791789722;
	bh=XBsDK6EmDHTeEYGSXN73gBpl9Hgu2Csxu6O8i4iiT08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jNFlcw8tRYe7KbvoA7Zupte10KrYjBUztxfGQ0TZADCix9W8wjzEDPSGFy9UHvAQT
	 KN5BwyzC8A7qLH+SPxrdjF78QBTriiADgkcJX5ZpoqxM6YGVWV6RWsleocH0nsGZnh
	 eif4Dq5qKb7yzlhydpO1e0soGXeWPSPV7d934s/cnLuoLW6vzqHcqJBgJsQG312n5e
	 deJT2WIbRxPoE/M2uDGYfjqgL0Wt8YKFMVmz1lfePcPXqHu3tXD5TcHSNzFLoYWWJ/
	 wNHz1TOJD4ncrmiy29u1rnDmbZTu37kcArF6GqoKrU/+ZPs9I/kSjp3sqjFxJe+Hp7
	 vrIVQ4oy8lwpA==
Date: Mon, 12 Oct 2026 07:22:00 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Wentao Guan <guanwentao@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch <loongarch@lists.linux.dev>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: Re: [PATCH 1/2] lib/crc: loongarch: Use hardware unaligned load in
 CRC32(C) loops
Message-ID: <20261012072200.GA828441@google.com>
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
 <20261011150052.GA168780@quark>
 <tencent_4750F9C704AA3CFA1E7309B7@qq.com>
 <CAAhV-H59DV-qF98M1Uu=Y4k1a8YNw0_RnP_nH-yr8fZu-jnFXQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H59DV-qF98M1Uu=Y4k1a8YNw0_RnP_nH-yr8fZu-jnFXQ@mail.gmail.com>

On Mon, Oct 12, 2026 at 02:43:47PM +0800, Huacai Chen wrote:
> Yes, we considered modifying {get,put}_unaligned_* globally. But it is
> not arch-specific code and we have no way to override it.
> 
> On the other hand, the byte-to-byte {get,put}_unaligned_* is always
> correct, we are free to only optimise the hot path (like crc32 code).

The unaligned access macros are used in lots of other
performance-critical code.  Hacks in random places don't scale.

> > > Since loongarch made the incorrect decision to not specify unaligned
> > > access unconditionally, similar to RISC-V it can be worked around only
> > > by overriding that in the kconfig.  For loongarch that appears that
> > > already be implemented; just unset CONFIG_ARCH_STRICT_ALIGN when you
> > > know the kernel will run only on CPUs that have fixed this bug.
> > I think that we have the use cases to provide the general kernel instead of the two kernel with
> > different config, so the image increase will be tolerated.
> Yes, the default configuration is to keep CONFIG_ARCH_STRICT_ALIGN set
> for single kernel binary.

So don't do that.  It does not work for divergent unaligned access
support, as the other architectures have learned long ago.

- Eric
