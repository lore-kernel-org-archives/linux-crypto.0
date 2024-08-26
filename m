Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BD584A36
	for <linux-crypto@vger.kernel.org>; Mon, 26 Aug 2024 06:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724653942; cv=none; b=ZV1AbTe+iuDkQL622dhB+ZX3Poy0xDfw6UWDjoELk1sMIW6PNhFfHIq8krehuWu7StmNjylbo5AGv6W42MYDGHau68maiYnrXxr2MsvwmtUOlcix28XRajNOKGENtoxsFPybf/SvoqovqPtQPoiEAeIBPcRhHB5zHKpQ2KSyOcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724653942; c=relaxed/simple;
	bh=Qqw12gOE5t5+HwsG7UDTIuSe8eJhHJpLrGlNWWhZ16E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PgzK2sy1q9/3zMxE5pGyByXRDisfQ5JBa5sPaIqMy8LM3JUT5rcLy/UXnYEemVhArQIZIcBb2SXj1Q3cwyg2CgRMCjrbTJYIm/M+hLNDvamvaG+MTYebORxbnSdTxRKsfaPO4rj9RDs/ksKE0Puou3chpzU3L8gcUs9qmmR930w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=RztfmOtQ; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="RztfmOtQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724653939;
	bh=Qqw12gOE5t5+HwsG7UDTIuSe8eJhHJpLrGlNWWhZ16E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=RztfmOtQ57ty/49FHgXo9c1/rnZSwxvkrChBrSX8+wGZrHfUaYUsOuSkdwGsPpqI4
	 NG0l5HCuYk7XNOSuXyUDbw7aX8tFpfs6mTIIKtIEmKYxUE8W868Fd0XyljnThQP6gh
	 TGAqxs8Wl0g9Q36Dh6GSShc19y6ATszf+T129beY=
Received: from [IPv6:240e:358:115d:1f00:dc73:854d:832e:2] (unknown [IPv6:240e:358:115d:1f00:dc73:854d:832e:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id C349766F26;
	Mon, 26 Aug 2024 02:32:11 -0400 (EDT)
Message-ID: <b39ba1dea300c905f377af4cf3702ce4226cabc7.camel@xry111.site>
Subject: Re: [PATCH v2 0/2] LoongArch: Implement getrandom() in vDSO
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, Jinyang He
 <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>
Date: Mon, 26 Aug 2024 14:32:05 +0800
In-Reply-To: <Zr4K77uPi3CMfE-S@zx2c4.com>
References: <20240815133357.35829-1-xry111@xry111.site>
	 <Zr4K77uPi3CMfE-S@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-08-15 at 14:04 +0000, Jason A. Donenfeld wrote:
> Thanks for posting this! That's very nice to see.
>=20
> I'm currently traveling without my laptop (actually in Yunnan, China!),
> so I'll be able to take a look at this for real starting the 26th, as
> right now I'm just on my cellphone using lore+mutt.

Hi Jason,

When you start the reviewing I guess you can check out the powerpc
implementation first and add me into the Cc of your reply.  There seems
something useful to me in the powerpc implementation (avoiding memset,
adding __arch_get_k_vdso_data so I wouldn't need the inline asm trick
for the _vdso_rng_data symbol, and the selftest support).

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
