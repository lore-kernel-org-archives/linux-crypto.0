Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E8516DC3C;
	Fri, 30 Aug 2024 09:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725008748; cv=none; b=ZTJPTXcbvYTC+ScGNIjt56Owzlddx1TJYV6rjLsYvbekhLh7RByn9D3I5b7iUA+7iudSIJYXelsa8XxVkz4qsME8hApUO+d6pDKPtjH2u2mMY+1gN6jzDew+5OeXE2ItSZY/Br4hefja+eUMsO1okeim98Yxk2HYMK4SY/wPlLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725008748; c=relaxed/simple;
	bh=MZL+XJIDKl6SSsfW0G6HQHuhX/O1VwGvEPQqKk0XYMA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XNJUmGlcIU/HYuxZdtRGGgKv2lMTbQ1IGs2GNPcOYg5AAZO8KpfqEw4caF/WE2JYDZfH0w90MwQaGEzNx0Ud90wwUJHsYdFwrumWQSsaJ8ciuWYfoomH+rqlC0P1CzbiltUeb1qBBjFxs5M6wi9PhikigVvSq9eb8Ht3ta/Zpws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=a8yZZSFV; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="a8yZZSFV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1725008744;
	bh=MZL+XJIDKl6SSsfW0G6HQHuhX/O1VwGvEPQqKk0XYMA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=a8yZZSFV7JAtUobiaR8ZzbdBhBUtMTMBAdz52DgS9f0V01BRpgMWBYSuv9pb4rVHK
	 DsyIOWhDHDtYYyiBfxDpdj5PFTGtD1G5OcQUycc+LheHGT1c5ex213xi/LnXPagu0F
	 RgcNQlXMZYM6kEnGwx2XAdFwIW86phKFxt6w+9UY=
Received: from [192.168.124.6] (unknown [113.200.174.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 0A1BE66F26;
	Fri, 30 Aug 2024 05:05:41 -0400 (EDT)
Message-ID: <57d648ed2143df2f5951f8e972cc4c3b2d40c46a.camel@xry111.site>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>,  WANG Xuerui <kernel@xen0n.name>,
 linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Christophe
 Leroy <christophe.leroy@csgroup.eu>
Date: Fri, 30 Aug 2024 17:05:38 +0800
In-Reply-To: <CAHmME9p+-0S-a3kjsv75irmLdGpW6rUWBVm87E4-Z9hpWyA7YA@mail.gmail.com>
References: <20240829125656.19017-1-xry111@xry111.site>
	 <ZtB3RczHN00XDO52@zx2c4.com> <ZtB5pqfp0Lg6lzz6@zx2c4.com>
	 <a3373ad5f92a4120bd0c8e0c751eb7617e035cf6.camel@xry111.site>
	 <CAHmME9p+-0S-a3kjsv75irmLdGpW6rUWBVm87E4-Z9hpWyA7YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-08-29 at 16:44 +0200, Jason A. Donenfeld wrote:
> > So get_vdso_data() + VVAR_LOONGARCH_PAGES_START * PAGE_SIZE should have
> > already "jumped over" the time-ns vdso data.
>=20
> Oh good. Thanks for checking. So it sounds like there's just Huacai's
> set of comments and we're good.

Both Huacai and I (we've discussed a little off the list) think it seems
more natural to separate the implementation and the self test into two
patches.  Do you think it's acceptable?  If not we can live with one
consolidated patch though.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
