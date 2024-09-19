Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EE61990C1;
	Thu, 19 Sep 2024 08:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726734689; cv=none; b=OOguqqF4oiAIQttW6q52GUxKd+Gpvtp9ZbYAwUbAd7FyIr9hxXoeyjpsJPe5A3tTmIjBTQp2XQz7XLTfeRN6omsowXBKzWjkV4DibLZdH/UeLCTysahslKjRSYw7RcEIzEbPt2YU74TaLo7YZCbsUnuPag6K7b5pz5f7StUlPyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726734689; c=relaxed/simple;
	bh=gS7x3o5w5OafhVV4ZhTd/Qj/VByyhrG4JHQ+AYR5fEM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z/RUsNqwgyyoTvUUsiGuG/jqsNvdCS1wtT6nEbDm3E4SFrGSdQ1F9FiVNtB4+LizK8B/conlA7Lsge/WOGAhDJ7l1H+D9CpRcmb3BftlU/dAjMvLsN/x15VJxDnPxxBqF838mbnfkcQhUhW5FeiDHDghOnnhf9dVhE9M3djqdK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=AHskkJZE; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="AHskkJZE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1726734685;
	bh=6STFTel6EALPNAHMkB7/bCDTQaEJVym4v691AgY/9Q4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=AHskkJZESgdHBK9HGs9wo3xCUjLoUjYsaHiZ2b7KxFWI24V3Z77N5DjB/MNwNxjM0
	 HCxddCKrbRQ9OTuqWDa4tZdlbdXAuaxKBI0lkeddnrli1EM8hDUBsNMeBhp5dZ5E5B
	 UHZNsUa5JZ2NUa8lDn1BCzOdmxUNxdEi8NQyyIKg=
Received: from [192.168.124.11] (unknown [113.200.174.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 44E8166909;
	Thu, 19 Sep 2024 04:31:23 -0400 (EDT)
Message-ID: <8ba2bb15917480db5cb644570bc7f79cbd6883fd.camel@xry111.site>
Subject: Re: [PATCH v6 2/3] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: Christophe Leroy <christophe.leroy@csgroup.eu>, "Jason A . Donenfeld"
	 <Jason@zx2c4.com>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
	 <kernel@xen0n.name>
Cc: linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>, Tiezhu
 Yang	 <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Date: Thu, 19 Sep 2024 16:31:19 +0800
In-Reply-To: <77655d9e-fc05-4300-8f0d-7b2ad840d091@csgroup.eu>
References: <20240901061315.15693-1-xry111@xry111.site>
	 <20240901061315.15693-3-xry111@xry111.site>
	 <77655d9e-fc05-4300-8f0d-7b2ad840d091@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-09-19 at 09:08 +0200, Christophe Leroy wrote:
> I know nothing about Loongarch assembly and execution performance, but I=
=20
> see that GCC groups operations by 4 when building=20
> reference_chacha20_blocks() from vdso_test_chacha, see below.
>=20
> Shouldn't you do the same and group ROUNDs by 4 just like I did on=20
> powerpc ?=20
> (https://github.com/torvalds/linux/blob/master/arch/powerpc/kernel/vdso/v=
getrandom-chacha.S)

Maybe.  In theory the scheduling would improve the performance.  I'll
measure if the scheduling will make an observable performance
improvement.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
