Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD2A1758F;
	Sat, 31 Aug 2024 06:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725086451; cv=none; b=fKiB0pKYHc7+8tgN4PJN1ZVTlQeug202YqW2pLKRI42ThreXBlSwdYdDStdgjKz47qDE2B8fZrNc6cMXHR+YvyQ0jWTGQBWqrX0ZPBVji2KK9f09N7+4HVaFrQ/ShHpqfenpxE7ztD5G7bu97C/A9P3AImhjV/GQqpst0TbI+KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725086451; c=relaxed/simple;
	bh=RFKkWahrHogOFYvG9oZhWec6joqLXHhuYXPdlQEfWx8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sZnEfawSJhFPnV78f2+z048DxNOiZ9EV+6tYN4jAgT5dCNBvwr+L/PLyItWKzpayORriV1Mhujloqu6aKsLOfOqqKmz51RcyyV4vEuL9bUkhcRpCntPS6tRx7qJURUOvfRa4aX9geQl5MF82U0ZWbo65K6N2IIvoQelzupzylak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=hHPb2PII; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="hHPb2PII"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1725086440;
	bh=RFKkWahrHogOFYvG9oZhWec6joqLXHhuYXPdlQEfWx8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=hHPb2PIITHcMqB2stg4nNQPqJqEX2RVQWzRkTeooT5vdIgWwWpRody3qEK/XP76Mr
	 bMmbfbxm+Fh95l1l09kwe/BXvjusm2Df0s1sC0eh6dcdKbH+fopep3TtzKOgkZ+9n4
	 H/5Td7PBxaDKIj8Q9rHkpSUi3wAByuGWXs/AGWSU=
Received: from [IPv6:240e:358:11f9:d100:dc73:854d:832e:2] (unknown [IPv6:240e:358:11f9:d100:dc73:854d:832e:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 91F1D66F26;
	Sat, 31 Aug 2024 02:40:33 -0400 (EDT)
Message-ID: <1bd7a61241f09331d27d8ad0df04726941c45f85.camel@xry111.site>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, WANG Xuerui
 <kernel@xen0n.name>,  linux-crypto@vger.kernel.org,
 loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org, Jinyang He
 <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Christophe
 Leroy <christophe.leroy@csgroup.eu>
Date: Sat, 31 Aug 2024 14:40:25 +0800
In-Reply-To: <CAAhV-H5Srpno_m+_dPS=Z-sdRrdXS3xEoG8tEaAB=8QqswTK9w@mail.gmail.com>
References: <20240829125656.19017-1-xry111@xry111.site>
	 <CAAhV-H5Srpno_m+_dPS=Z-sdRrdXS3xEoG8tEaAB=8QqswTK9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-08-29 at 21:18 +0800, Huacai Chen wrote:
> > -obj-vdso-y :=3D elf.o vgetcpu.o vgettimeofday.o sigreturn.o
> > +obj-vdso-y :=3D elf.o vgetcpu.o vgettimeofday.o sigreturn.o vgetrandom=
.o \
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 vgetrandom-chacha.o

Huacai: do you prefer to remove this line break as well, or Makefile
still has a line width limit?

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
