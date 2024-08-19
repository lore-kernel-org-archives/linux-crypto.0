Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C67012B176
	for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2024 15:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724082881; cv=none; b=EUqjjVK58nyIaslqS9xg8XDErh/NEDr5CV/6Nsmd9e+iCB7Ra052YOkdy/VOvgpcsGPD3swxK6WyfeNpkuaptjKCOZUZMZVaUvm5ut1dEqpkwA6G/4PoCDPzX+aokaGAqKoWKLdbMtbe2UrjG3PaHEuR8sEXFMwKMDZRB410jgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724082881; c=relaxed/simple;
	bh=oSmLQncAkEs2Zw8wryDIMacsQInU88bocr9yYTzc/Io=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HNjkIN5R1TtOLmwY4hf70Du52o51vOIcXI4giBC6W/+nfCFH9w7h1O9tb8slQmGtK+1eUi9m1rxilSdigXza5dCXh/bc+sMco+SC8KS+aKEFH5poac+d9uk4bj+JsMxhSA/IKRv3hD88Kivawpb124Jm2etTPaAuOJAQ9Ie041w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=AXE3x4ro; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="AXE3x4ro"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724082879;
	bh=oSmLQncAkEs2Zw8wryDIMacsQInU88bocr9yYTzc/Io=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=AXE3x4roBYWZ/cv7KGH25qAWtFH638p4aVwrPRXFo8eNimZUS5kwvjq839xj7whVF
	 +VKHdBlK959bpZJOGet2jtsRPWgcub9Lbm+reXmVsNoILpN6Ak/X88ZnaIg7Uro3SN
	 DbgTqjsA99/ufV2mOqHBM3zX3fBnVZ7h810XS6vs=
Received: from [192.168.124.6] (unknown [113.200.174.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 4AB426656F;
	Mon, 19 Aug 2024 11:54:37 -0400 (EDT)
Message-ID: <46567f45f41512e8e43a37a5caaf08b6be810f3d.camel@xry111.site>
Subject: Re:
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, Huacai Chen
 <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, Jinyang He <hejinyang@loongson.cn>, Tiezhu Yang
	 <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 19 Aug 2024 23:54:29 +0800
In-Reply-To: <d10c0e620ae26e0c53e50aaae6efc87719b034f0.camel@xry111.site>
References: <20240816110717.10249-1-xry111@xry111.site>
	 <CAAhV-H5a42p6AAda=ncqCdmpHyc_tpXHjDVHq_F1pPZumfGeLw@mail.gmail.com>
	 <ZsNCPKo9XZG52Yph@zx2c4.com>
	 <d10c0e620ae26e0c53e50aaae6efc87719b034f0.camel@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-08-19 at 23:22 +0800, Xi Ruoyao wrote:
> On Mon, 2024-08-19 at 13:01 +0000, Jason A. Donenfeld wrote:
> > > I don't see significant improvements about LSX here, so I prefer to
> > > just use the generic version to avoid complexity (I remember Linus
> > > said the whole of __vdso_getrandom is not very useful).
> >=20
> > I'm inclined to feel the same way, at least for now. Let's just go with
> > one implementation -- the generic one -- and then we can see if
> > optimization really makes sense later. I suspect the large speedup we'r=
e
> > already getting from being in the vDSO is already sufficient for
> > purposes.
>=20
> Ok I'll drop the 2nd and 3rd patches in the next version.=C2=A0 But I'm
> puzzled why the LSX implementation isn't much faster, maybe I made some
> mistake in it?

After some thinking this seems making sense: the LoongArch desktop
processors have 4 ALUs able to perform the scalar add/rot/xor
operations, and the throughput is already maximized for ChaCha20 due to
the data dependency.  The advantage of LSX seems just to avoid reloading
key from the memory (because the register file is large enough to hold a
copy of it).

Perhaps LSX will be much better on those embedded processors with 2 ALUs
and 1 SIMD unit (if they don't downclock with heavy SIMD load), but I
don't have one for testing.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
