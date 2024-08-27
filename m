Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0D1C6888
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769952; cv=none; b=Lxz/QdV1nWU2CdEgj+kKm7gQ2vt+ehydhPibHI72uVdEjVhzz3p3bSSRnuzFrf2AJz/6ZyINa6sRUU61gLlez2txoKZJq0+5fDrlFRX/6qRgtGoTEy/B7KQYE5KkBqQuo7AoLCSujjksgGS1eftUH+FjL6KKQJm36wtD4ibkpnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769952; c=relaxed/simple;
	bh=OR3xsWF9vTLygsU97FOOwW5LF8V9eAkqaXXY91We4Bg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZpXBMBqgM+FQC+PFcP3gb0m14aVaFtW9OJP3z/1cJ2qEoKIwnnO1FpISbTb+POTBAmQU8OzISZjciJJ54dqyhRe+TGSRDAlGG90IwkSyc1Qn47AgfFRK9i7EkaojdfYUcSQxkYn3nnuoSOBITSbEIrvGDu0z1XHTnjgJd+Lq1Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=W9yiJujt; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="W9yiJujt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724769948;
	bh=OR3xsWF9vTLygsU97FOOwW5LF8V9eAkqaXXY91We4Bg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=W9yiJujtE9n0rWGNz5s4EuEFE+hQCSdua+pnHQT9I7Xy0B/hG9RiwkIBpLgaszXIH
	 rmpgp5V5KC/wdPR4OMPx8T+AdaoRGhNRinKajU937TA6exz/9gh2NK+wuuoL7Ro8mg
	 BlI8X8A+z4S/o55+BlNVQ9ofpQ7eUhjptO3CzoG4=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id E89AD66F26;
	Tue, 27 Aug 2024 10:45:45 -0400 (EDT)
Message-ID: <3af07eb37d65d0f10f14f95ff234c5664fd35937.camel@xry111.site>
Subject: Re: [PATCH v4 4/4] selftests/vDSO: Enable vdso getrandom tests for
 LoongArch
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, Jinyang He
 <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>
Date: Tue, 27 Aug 2024 22:45:42 +0800
In-Reply-To: <Zs3cFJ9qvPrFt_FK@zx2c4.com>
References: <20240827132018.88854-1-xry111@xry111.site>
	 <20240827132018.88854-5-xry111@xry111.site> <Zs3cFJ9qvPrFt_FK@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-08-27 at 16:00 +0200, Jason A. Donenfeld wrote:
> On Tue, Aug 27, 2024 at 09:20:17PM +0800, Xi Ruoyao wrote:
> > Create the symlink to the LoongArch vdso directory, and correct set ARC=
H
> > for LoongArch.
>=20
> FYI, I think you can squash this into your 1/4 commit. Ideally this
> whole series reduces down to 1 commit, once I take the two general bug
> fixups you're finding.

Ok I'll squash them.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
