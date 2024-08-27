Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584E81C461D
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771247; cv=none; b=dhNegQSZT6moo4rH7+8OyXivEj6KHzEdF4cxuy6yZrjVL3Ln5L4y2oMPpDfhnJi49+ixz6wfmrcm/EkWmHxffvIQpqcefcr45yx3r8I8XL0f1x2Oo2MhCpUfB0+5X9GZN5CyQVnRHDixjd9UgT6hWVKSseyLi+YAVkDKWp6a3Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771247; c=relaxed/simple;
	bh=KaGQyekPXd142nRQ/Ok0VoclbqLqXysS2oncYyHg4PY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jp+/Ehq6DAKtDlkcy23sZih1oA4uQVEkUc947LC9rzq8idbLiFWuQnK7NpVnhi87h09Rwg2+sX2WBU/WKuDxzUQ7Grv5baF0y9sjbfNPuA/jVi+ZhD0H6yBGvidR3jo8cTHlF/ADKEH29xsqQ9E8S0ZtbtuS+kibF/Zg4WteXE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=XiaWIWMh; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="XiaWIWMh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724771245;
	bh=KaGQyekPXd142nRQ/Ok0VoclbqLqXysS2oncYyHg4PY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=XiaWIWMhxI1cTGR5zaK4N6vU73rPY5XvcXft1dcnRKLwhCLwkCO3vPvOOkQ4apLq5
	 ukgUP+8xj8a2/DLdScJ9iQ6GfIQEuYROmRd8NTKCKNJ6f7pbQeQa1AkgN5ILmjtEtP
	 U+8HTcGXdZJwTScWEkIC4dbQOffedb/dGIE097NA=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384))
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 283EA66F26;
	Tue, 27 Aug 2024 11:07:22 -0400 (EDT)
Message-ID: <feb185771f368d8d112b77c2a156056f0b74f9ad.camel@xry111.site>
Subject: Re: [PATCH v4 1/4] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>, Huacai Chen
 <chenhuacai@kernel.org>,  WANG Xuerui <kernel@xen0n.name>
Cc: linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, Jinyang He
 <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>
Date: Tue, 27 Aug 2024 23:07:21 +0800
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
> diff --git a/arch/loongarch/vdso/vgetrandom.c b/arch/loongarch/vdso/vgetr=
andom.c
> new file mode 100644
> index 000000000000..b9142a5b5d77
> --- /dev/null
> +++ b/arch/loongarch/vdso/vgetrandom.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserve=
d.
> + */
> +#include <linux/types.h>
> +
> +ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags,
> +			 void *opaque_state, size_t opaque_len)

Self note: I got a -Wmissing-prototype warning here and it needs to be
fixed in v4.  I had

> +{
> +	return __cvdso_getrandom(buffer, len, flags, opaque_state,
> +				 opaque_len);
> +}

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
