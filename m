Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F061A01B9
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 14:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731767; cv=none; b=a1Y1kO3nj8On/kpByqpchQdNXl7As70kkijQvxjo0+8qupxtXXLktV7Y9g09aGLY5qJXV07tYNiUgaAYsGrSTohVzA3gUuWthv3iuSmgbtcvitPLNPwmnA3g3ns1AYniBIzaSogYHlQRmi1RbFHYmCzoKCXN30TkRMdiFwbHHC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731767; c=relaxed/simple;
	bh=ICqgEAlYxLMRUQ5X2ysP7oB5piwO9M6V0hHbg4nVa+w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c6DGXn1l162s7xEsM//KCfwQSVbP2mFaMk1WyvJe3BCRugCOca3d4QboJXfVXPhNd2W/yaPmszyOAQdTmAkW9Putks/eyhLRK9dSlPcyD7//GAK+D8vB/X9RS2C6YmToLSWBXODMJv4Z9oNCkYBc7TgtgTWcfeRh9VcIOC8GhuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=S3CKv3n1; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="S3CKv3n1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1723731764;
	bh=ICqgEAlYxLMRUQ5X2ysP7oB5piwO9M6V0hHbg4nVa+w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=S3CKv3n1KXmB1LZ0/dSeX2wG7FJaRusF5xHm0yCfeQRQvphiP/G4dXAjfw79UFZ4V
	 JHZLHuE+/DDMEiCEW3F5nPk6aQllIiNvAyTVn9PqHl6yIv7/EUfZElfDMi+KIFpE4Y
	 ItyEQAUGE409YkvMRejxGek6TSCjM6uWgt8JXzcE=
Received: from [IPv6:240e:456:1030:181:abd4:6e7f:e826:ac0f] (unknown [IPv6:240e:456:1030:181:abd4:6e7f:e826:ac0f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id F194F66F26;
	Thu, 15 Aug 2024 10:22:38 -0400 (EDT)
Message-ID: <eae5ab91ee6a6eb96c397b4ff6470b72e9bf3086.camel@xry111.site>
Subject: Re: [PATCH v2 0/2] LoongArch: Implement getrandom() in vDSO
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, Jinyang He
 <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>
Date: Thu, 15 Aug 2024 22:22:31 +0800
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
> Hi Xi,
>=20
> Thanks for posting this! That's very nice to see.
>=20
> I'm currently traveling without my laptop (actually in Yunnan, China!),

Have fun!

> so I'll be able to take a look at this for real starting the 26th, as
> right now I'm just on my cellphone using lore+mutt.
>=20
> One thing I wanted to ask, though, is - doesn't LoongArch have 32 8-byte
> registers? Shouldn't that be enough to implement ChaCha without spilling
> and without using LSX?

I'll work on it but I need to ask a question (it may be stupid because I
know a little about security) before starting to code:

Is "stack-less" meaning simply "don't spill any sensitive data onto the
stack," or more strictly "stack shouldn't be used at all"?

For example, is it OK to save all the callee-saved registers in the
function prologue onto the stack, and restore them in the epilogue?

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
