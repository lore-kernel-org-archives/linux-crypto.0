Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105E915AF6
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 01:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724116171; cv=none; b=VFSn9U7x2N6rK+zEBUMJSGwHQdG8Ex0BX07Nt1Z3tGKQ0ssSQnJRez19Um9Bn4HNGx7Rr8bIgPpILgQ6inGU/OxDvcaYC3m3ZFTV0xGZE66odDC4EHssnev9b+B9+yKlypFGUBPHh+0EBGfPYcSNXlnIEPLhCWSxm42ES+ZmXlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724116171; c=relaxed/simple;
	bh=dpqZyGl7V+Nc2nBwj2Q/8ctrNo3DkOF77jatFfefq6M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XP2YQYpySg8IWpG/ePpkR5zYnlPmISwjr9sDEcbYWjYXJpZa54BxQLOn4sladtVaK64wzNvhwjwBTSOFU9cRxLlUOUdsf+yCIFjA1N6oRrm53ZZf5ZjGffCpwqC4TMNnyh0lshcO21+He1iWb5y3S3x7WfqsYRgUUVKwYzT2cWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=l3UwoKQe; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="l3UwoKQe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724116168;
	bh=dpqZyGl7V+Nc2nBwj2Q/8ctrNo3DkOF77jatFfefq6M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=l3UwoKQeFMQlDV46dXrWNS3xtkolNErbarHBr2VqhUKBhpEb2KgJdOZlwkAgGQqJD
	 O3zVM3vuiBfs27Y315XDuzxvo+wDfh6sfklJ2DjYy5rKGUbpjIR+DLMII5Pt0BUOhS
	 scbsCDFDDYDQJBcDkSCtfb26ZB+gwh8+T+Prqdx0=
Received: from [IPv6:240e:358:119c:8600:dc73:854d:832e:3] (unknown [IPv6:240e:358:119c:8600:dc73:854d:832e:3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 6E44C6656F;
	Mon, 19 Aug 2024 21:09:25 -0400 (EDT)
Message-ID: <391b12b694855412985081df86c9dd48e2b020e0.camel@xry111.site>
Subject: Re: [PATCH v3 1/3] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: Jinyang He <hejinyang@loongson.cn>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>,  Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org, 
 loongarch@lists.linux.dev, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>
Date: Tue, 20 Aug 2024 09:09:20 +0800
In-Reply-To: <a29807b5-d0ce-f04e-a7d1-024d29f398be@loongson.cn>
References: <20240816110717.10249-1-xry111@xry111.site>
	 <20240816110717.10249-2-xry111@xry111.site>
	 <CAAhV-H7TKg98QXtrv9UmzZd9O=pxERvzCsz83Y+m+kf0zbeCkA@mail.gmail.com>
	 <ZsNClVFzfi3djXDz@zx2c4.com>
	 <9d6850dd52989ad72238903187377cbaa59f7e62.camel@xry111.site>
	 <a29807b5-d0ce-f04e-a7d1-024d29f398be@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-08-20 at 08:50 +0800, Jinyang He wrote:
> On 2024-08-19 23:36, Xi Ruoyao wrote:
>=20
> > On Mon, 2024-08-19 at 13:03 +0000, Jason A. Donenfeld wrote:
> > > > > The compiler (GCC 14.2) calls memset() for initializing a "large"=
 struct
> > > > > in a cold path of the generic vDSO getrandom() code.=C2=A0 There =
seems no way
> > > > > to prevent it from calling memset(), and it's a cold path so the
> > > > > performance does not matter, so just provide a naive memset()
> > > > > implementation for vDSO.
> > > > Why x86 doesn't need to provide a naive memset()?
> > I'm not sure.=C2=A0 Maybe it's because x86_64 has SSE2 enabled so by de=
fault
> > the maximum buffer length to inline memset is larger.
> >=20
> I suspect the loongarch gcc has issue with -fno-builtin(-memset).

No, -fno-builtin-memset just means don't convert memset to
__builtin_memset, it does not mean "don't emit memset call," nor
anything more than that.

Even -ffreestanding is not guaranteed to turn off memset call generation
because per the standard memset should be available even in a
freestanding implementation.

x86 has a -mmemset-strategy=3D option but it's really x86 specific.  As
Jason pointed out, PowerPC and ARM64 have also hit the same issue.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
