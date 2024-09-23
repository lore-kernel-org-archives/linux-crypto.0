Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4417ACA6F;
	Mon, 23 Sep 2024 08:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727078813; cv=none; b=tg/cYbwhyPHDUbuWDqy2I9kXSl52hpe1SvCa98VNGHu4gJp2JOLSDXL3Pt0wQ/oCMp8Ssz1tjwdGxLsUMj6gkHK76k6sL8FIezj7/wjU/aOZdM21EMLvDPykYZknAnDHEqtRkPRfBf/KV4iLgkAmqDkVNki+b7bGl30OG4VS/BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727078813; c=relaxed/simple;
	bh=GewCYpn7wGDokXcE/Vr2HFRzlGkSFHvHRMly3QB/peg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dbSFl+50Qn/9n9JTcupYHnTLsF6dCjbFA0G8mGyEzZtbcJur8YquQhtzoVl1Gi+bhJ6uh0Xwj7qE7YWJjySFX4RBIiJciOYE9M8yCZPoEGrAF7uPO9+OLy9zLRCEs1tdRfQ9c0rEDLtniskI2eUvUb08Pokv/QtvW6SsIOggo20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=VwRqGhpt; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="VwRqGhpt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1727078811;
	bh=5KtvWm6qpjSQg+2gDWl73WfOq7D5a6uUcZ0pBi0T1zs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=VwRqGhptmGPmicXYLwfjXw8EkJxL4xu4YU/gvJYn3qIfU/rX0NZBXtgpyofiIin31
	 tRul/v7v2aOjaMSewLTOF5KVY8MWt/QVfQB4PRD+76hv5fokvJ/lqI0+XozVCAm16l
	 CyF8vY0fA9gUjQuU0NpIuny80jobLl+vMMbBcW14=
Received: from [IPv6:240e:456:1020:3a44:c13d:8652:53f6:a6b8] (unknown [IPv6:240e:456:1020:3a44:c13d:8652:53f6:a6b8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 5C0651A3F81;
	Mon, 23 Sep 2024 04:06:45 -0400 (EDT)
Message-ID: <b9bc6db245775b0a2e990467f414071e82b06a29.camel@xry111.site>
Subject: Re: [PATCH] LoongArch: vDSO: Tune the chacha20 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: Huacai Chen <chenhuacai@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>
Cc: WANG Xuerui <kernel@xen0n.name>, Christophe Leroy	
 <christophe.leroy@csgroup.eu>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, Jinyang He	
 <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann	 <arnd@arndb.de>
Date: Mon, 23 Sep 2024 16:06:41 +0800
In-Reply-To: <CAAhV-H68HOsX4=yZAmnCMW0VWf5SsqEckcHJQytSzjK8dHHW6g@mail.gmail.com>
References: <20240919091359.7023-1-xry111@xry111.site>
	 <CAAhV-H68HOsX4=yZAmnCMW0VWf5SsqEckcHJQytSzjK8dHHW6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.0 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-09-23 at 15:15 +0800, Huacai Chen wrote:
> > +#define line3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 st=
ate12, state13, state14, state15
> > +
> > +#define=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line1_perm=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 state5, state6, state7, state4
> > +#define=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line2_perm=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 state10, state11, state8, state9
> > +#define=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 line3_perm=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 state15, state12, state13, state14
> > +
> > +#define=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 copy=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 copy0, copy1, copy2, co=
py3
> The indentation here is strange, it seems some of them are spaces and
> some of them are tabs.

Oops indeed.  The tabs after "#define" should be a space instead.

Jason: can you edit it for me or do you want a new revision of the patch
to fix it?


--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
