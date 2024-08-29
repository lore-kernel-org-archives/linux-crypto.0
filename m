Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53180194A67;
	Thu, 29 Aug 2024 13:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724936474; cv=none; b=iGTNeFjY1XN5suuuJQ+W6x6BdKZO0Tn3uH205m0WECL/RMm9nLsNFLAi1Y/9zKQoLEULxZWdhgDvyRGk1p1BizX7PnhsTLXuBzMRZPNYCrnGdTCt1Oe60UHsTHr8msCF80M3+mGwY+zgORAe/rD9hWa9kW7XcV3+ayy8ypaNu2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724936474; c=relaxed/simple;
	bh=iaMzCBEFcBuOTA+Y95+j3XbqrzZqHRO9KGANgwR72TM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u6FUyBxz5ImHWbRgA0rXtS97hv2YhXXKkYE9nGJ/majjXT2Qk8NIlTjbdUK5ZCILqiI1mx/H8qQWnvSmtfug94WHAj4a7QMFz70YQpHIEobxaOtpdd4iZOZHzr9iJkVa7SOjnSeTTcT0HesT4zmlc6h/A7FVN+6Z2tZUzaVVVE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=hZml8b7s; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="hZml8b7s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724936472;
	bh=iaMzCBEFcBuOTA+Y95+j3XbqrzZqHRO9KGANgwR72TM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=hZml8b7sduKqpX99GPbiyEbdduetVWMi15jkP5eLw5gIltZfa/5amtHeKjj3BOTiP
	 XwAkN3nSVfWSoxIIS3VbsFcAuHRE0SIdcwMnvR7M5eyLggPt6lb+phqhvIRsWYzXLh
	 7eXOF91OGPhj0LeW120knkNkvnV15f1ZGr3s7S3Y=
Received: from [192.168.124.6] (unknown [113.200.174.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 695BE66F26;
	Thu, 29 Aug 2024 09:01:08 -0400 (EDT)
Message-ID: <5fc8fc031c338f438fcd4aa5eaeb26b60d869405.camel@xry111.site>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>, Huacai Chen
 <chenhuacai@kernel.org>,  WANG Xuerui <kernel@xen0n.name>
Cc: linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>, Tiezhu
 Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>, Thomas
 Gleixner <tglx@linutronix.de>, Christophe Leroy
 <christophe.leroy@csgroup.eu>
Date: Thu, 29 Aug 2024 21:01:05 +0800
In-Reply-To: <20240829125656.19017-1-xry111@xry111.site>
References: <20240829125656.19017-1-xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-08-29 at 20:56 +0800, Xi Ruoyao wrote:
> diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/=
asm-offsets.c

Oops stupid I.  Please remove this hunk applying the patch.

I'll remove this in v6 if needed.

> index bee9f7a3108f..ab258878d551 100644
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

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
