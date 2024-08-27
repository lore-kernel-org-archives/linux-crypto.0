Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C66B8F54
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 13:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724765771; cv=none; b=Gv7fiDMiwKs/qdnrZT7x7xx+bfKRA9TXxf1Xhm0BEERpH6oawTAonmTkNGfUvt0B0jGvN+iNijlPZfbwMQQuouteVngxPLQeutQlZea8TJrFIgTrkTjMhyAL+bxKC22znzHJSg3r4m33Tirdc2J7KbWkHvGv6xkSiuaVtVdruLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724765771; c=relaxed/simple;
	bh=GTGzIZR0CANt6o8R1vL/vi7QxvJ9y+bEkhIVB/SLra4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AjpIGDpj36laPQMnr5hl/ztksjJ+esGD24f2NA0pGcuWw5sMMcuFoE7VPR8RPvlzxQB4rJfWUl+DI1AeadB6HtdCm0aUCKFYb9i7qfCZa7Fvzd8n/J6zOmGMTj1ZgbyuXzzjNzO9Y70kYC2sNw0HhUJ2bBKo8wtmh2cH3swe5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=DzsS9Czo; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="DzsS9Czo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724765769;
	bh=GTGzIZR0CANt6o8R1vL/vi7QxvJ9y+bEkhIVB/SLra4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=DzsS9CzoZnakCQtjSGCa2HYfsd1W2255M9yAipzTXdwm+2kVlvLCzbnjMLKZ/ojTW
	 f5PAa80QEpI8NhGgoU57Jc6lxt9qBHJ0qeGNR7Y4DdpLO1MEm5zEoYripQVZXNBMsc
	 PM2pPYfHyu9XjhdDaGSfOFb+d+QANrZ1ei43xOrQ=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 7D5D366F26;
	Tue, 27 Aug 2024 09:36:05 -0400 (EDT)
Message-ID: <2faae6a144eaaa12a06bdb07438a07217659ff3b.camel@xry111.site>
Subject: Re: [PATCH v4 1/4] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>, Huacai Chen
 <chenhuacai@kernel.org>,  WANG Xuerui <kernel@xen0n.name>
Cc: linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, Jinyang He
 <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>
Date: Tue, 27 Aug 2024 21:36:03 +0800
In-Reply-To: <20240827132018.88854-2-xry111@xry111.site>
References: <20240827132018.88854-1-xry111@xry111.site>
	 <20240827132018.88854-2-xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-08-27 at 21:20 +0800, Xi Ruoyao wrote:
> diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/=
asm-offsets.c

This change is unneeded now but I forgot to remove it.  Will remove it
in v5 but for now just waiting for other review comments.

> index bee9f7a3108f..86f6d8a6dc23 100644
> --- a/arch/loongarch/kernel/asm-offsets.c
> +++ b/arch/loongarch/kernel/asm-offsets.c
> @@ -14,6 +14,7 @@
> =C2=A0#include <asm/ptrace.h>
> =C2=A0#include <asm/processor.h>
> =C2=A0#include <asm/ftrace.h>
> +#include <asm/vdso/vdso.h>
> =C2=A0
> =C2=A0static void __used output_ptreg_defines(void)
> =C2=A0{
> @@ -321,3 +322,12 @@ static void __used output_kvm_defines(void)
> =C2=A0	OFFSET(KVM_GPGD, kvm, arch.pgd);
> =C2=A0	BLANK();
> =C2=A0}
> +
> +#ifdef CONFIG_VDSO_GETRANDOM
> +static void __used output_vdso_rng_defines(void)
> +{
> +	COMMENT("LoongArch VDSO getrandom offsets.");
> +	OFFSET(VDSO_RNG_DATA, loongarch_vdso_data, rng_data);
> +	BLANK();
> +}
> +#endif

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
