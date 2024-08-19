Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1164E5339E
	for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 15:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724081813; cv=none; b=Cvt/g8CW+KsR4jiITSmbeYY1sxlU59TZS0+ldVX14PAl4cTnw5YyKzui3kDnl/kcJ4YteO/V7Ca/3G7r1xyxj5TC3oQuFDQJV+++6yy9zQh6gD7LBYKWMUOq+tIKTQkP9in59ra+tsRfwdxT3JA6H0hZN/PDbFykXvShrvIIeC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724081813; c=relaxed/simple;
	bh=DrLCCgk5Pv+NRzVbmw63X/YE4Xq3igbrfTU6q8wpwDg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BjJPuuPXP5BdnBIO//gt3sf7FtI4REjiKVQG3nRzwACuUalekbCjm66dg15WaY7+1pSiSZROwmhRrYnJw5fsjzNLt6zGlnw1PFp3/EUac3kJRvVOl2HlluJLPWdhmAcFekH0A2qtdz0BB/5go5AGXoOkK8O9Q1LezwyTgUUTnEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=MX45U6eM; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="MX45U6eM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724081810;
	bh=DrLCCgk5Pv+NRzVbmw63X/YE4Xq3igbrfTU6q8wpwDg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=MX45U6eMpJUfzBf+2BpSv9bxRoA4065icZjnOSw8f+21AXSY7HX0wo8NJ7wYJMwdu
	 mm1vnNMTdFIlDqiCTNWDFkd8s3cmBK8n/+b+RO6jrKZ+m4fF0Dpi0Zt4dgeEFRW3Ja
	 0iL+Ug4drpb37PDsYjuHyx7K0vnPibgRSki72H2Y=
Received: from [192.168.124.6] (unknown [113.200.174.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 092D066F26;
	Mon, 19 Aug 2024 11:36:48 -0400 (EDT)
Message-ID: <9d6850dd52989ad72238903187377cbaa59f7e62.camel@xry111.site>
Subject: Re: [PATCH v3 1/3] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, Huacai Chen
 <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, Jinyang He <hejinyang@loongson.cn>, Tiezhu Yang
	 <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 19 Aug 2024 23:36:46 +0800
In-Reply-To: <ZsNClVFzfi3djXDz@zx2c4.com>
References: <20240816110717.10249-1-xry111@xry111.site>
	 <20240816110717.10249-2-xry111@xry111.site>
	 <CAAhV-H7TKg98QXtrv9UmzZd9O=pxERvzCsz83Y+m+kf0zbeCkA@mail.gmail.com>
	 <ZsNClVFzfi3djXDz@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-08-19 at 13:03 +0000, Jason A. Donenfeld wrote:
> > > The compiler (GCC 14.2) calls memset() for initializing a "large" str=
uct
> > > in a cold path of the generic vDSO getrandom() code.=C2=A0 There seem=
s no way
> > > to prevent it from calling memset(), and it's a cold path so the
> > > performance does not matter, so just provide a naive memset()
> > > implementation for vDSO.
> > Why x86 doesn't need to provide a naive memset()?

I'm not sure.  Maybe it's because x86_64 has SSE2 enabled so by default
the maximum buffer length to inline memset is larger.

> It looks like others are running into this when porting to ppc and
> arm64, so I'll probably refactor the code to avoid needing it in the
> first place. I'll chime in here when that's done.

Yes, I've seen the PPC guys hacking the code to avoid memset.

BTW I've also seen "vDSO getrandom isn't supported on 32-bit platforms"
in the PPC discussion.  Is there any plan to support it in the future?=20
If not I'll only select VDSO_GETRANDOM if CONFIG_64BIT, and then the
assembly code can be slightly simplified.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
