Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2195137C914
	for <linux-crypto@vger.kernel.org>; Sun, 12 Apr 2026 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776000187; cv=pass; b=BOLWqmlVas3o+RduEv/+VEalqX6Hv3ctIJ0ZD2b9D6kJI/bx1KgroDx28E1Nb1JExxcVfT2WLxrdZEl/1tn2JPSMQz9+PtMiCbAzmrN6Vg/ovv837LCj/B/MOX2yZAdqoSYxWuP/QhwfWXNqQIFGimkUl6fO7j7o8OTQaJ7ZC+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776000187; c=relaxed/simple;
	bh=1p6x7PvyQL+5PGqdAnx23TY8v0cVXdqCOnUZdmPD2Po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ng4tRDlopiGY1SIQhRNq8Jkv6BFMVVBNBzASKGygQFn8R8CGigqwaJ6q8OV/scKIoOReyrPtejx1XzeJ2cCw2cwpm5Xdzpm8ZodtxA6j97SpvxKAExfdXJ0vLx4yE8oE21TItu+yVX7+bOUjrjU6xVLwxRkY4XZjvswAkJNwfCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dccArJm9; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dccArJm9"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b9c1da7ac63so541556466b.0
        for <linux-crypto@vger.kernel.org>; Sun, 12 Apr 2026 06:23:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776000183; cv=none;
        d=google.com; s=arc-20240605;
        b=Qa8b1qo9tKbAj1ESD7YjER9riVuRwX6A1OREQyIvWepOP5EKcJyXlXUSKiatcaaXqm
         Stub9z3zN7nQKrGKAdmdRbUcicrjryWb9U6HHh7s9kyX3HORDC6WIZxTDABJNFPfsUoE
         qR+GA/mq5L9fM82GRPI1abVoXK+ty6VDG1W+apeYWma1L4GE6G7LAyn+aeSJaM45SJOA
         SwmM2mFfRGK88GTYCKRwPBGZ+YbcTqTC8fKU1y/+16RjT9xWxb79/Wra1rC6/2Qh7R86
         8r5B2UP/Nkrgwc8xBumkI3JRGr2Z2GEO9Qt4nzWHElFrizNcIbbJXABjDYSTzJ602NcF
         NQGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
        fh=QrX/m6xswvee+UX8qeWsNxHkx1omDUiCWPRcMNOxC5I=;
        b=cGmUHw8Cbldbqjl2T4o2ps2FPIK8Zseb7M3yU1oxcJBSdwfxctBjHq0Opjs126Ym7r
         hRfu1+mzVLYyWMV9nbUduZhThBjFfEym2/df4b2ff7kJSuNxaLcmNj3y94JBpPgC0fRC
         a5hro7V55dbEmveQlEHNx/XNZKWuxxue/01zjfs6pjl7Ld/nIhMTt4fO6X1Z/HX+Z6fK
         HITEYnnbT+zA9zMH7yw7UU3HJcdvJhwAEfKSu6iT8fJ7pf2Y/gVt0vTx7UUTWMdJ+cbA
         ajsUuXqmNQSwmHZLK1UYZhGWZ7ExQ7iylInNROzS9eknjxkGWloux8uNFqA2NoqrC6Q3
         WKog==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776000183; x=1776604983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
        b=dccArJm9v6h9Fdk8lDGNWZnQG14AQ9ZokHDnv7DAL1GW0R6BDoMR0waR0wHnO++sNY
         YJPJSDf/Eo4Jqw4GQ8Gz/T/rsLkNap5uTZ+EpwANfeQ1dFGXyG88+fN/49+h4JvC9C7c
         2+asFn0yzVsL4n2hJqrH+GINWtCINsNrMCDz6yHqeLWKks0EsNy7ssNes4vhdFLCd+tg
         k2Ys2/EuxonOOeyCkSNs/L20e6zSdmHhXIY25hzHxXat+VjZowRiCo0VNk9bdjlPvxYt
         DV9owUMCQ8VWv/4Ldm8HtUCj9QQlhYJyZr8JnJBv87EbzYIfO7KpnQu2sRPezsHrfV9J
         1U2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776000183; x=1776604983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
        b=luFHi6lqyylcz5vUVKczhyaGeDbe/d3mniWTTNa2k00D0UmJDeJ/mGRwSOwO05glOn
         F3kLdexlm8Vmof+fYOG3RTtnGTuokutmxwNlQt4/7TQLWldMx89jF7JnLgMWkgYvoZJs
         LDPG7Na9mDU2Olghidm6JYbuxhHGPjv/dqneJV0dlZHvVPY6vJWJ9jHo1xGzuHquLbmC
         fkbt8IMNttyjSJIIIWSOXnN4VzcQAWuyIutJW5FxJe6Ql2oxISIYi/OIDYO+krmob61X
         tltkU+ju3oLOl0d7RetgGNoyuytk6P9mM/+QLgPhZ0KTfD17poHCPu6mQ7FgpLk9r8NK
         DgzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVO57MIPvYVt3JtD0HJqUtDYbp3Hnk6QCfWv7JK5N+rhgqQ/hxiwB2UNLjVzc+cyjBzXNOnndO6bTpJ9YY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlNoe/ppPiwIr4kZVcJCz4rD3JdTNYM+mD2n/PkLzUS6RQQ9uw
	tBECwaCT+9IbHWd4dL4/zyyT2G5DL8TlVvDVapENpbPvHkThQ4RXSU4Wr45AITbAfKQYvqVpfT+
	FJ1Xo6sub2vrPXixaUVoM5SM+r2xBtaM=
X-Gm-Gg: AeBDietL/oFl8VT5I36xosO6zdIRKso2blpoJA6qSJTT7sYW9hIxwDOWzjLQzdafza/
	eSC6/aM7DELewvF4POZnP3haQrwt4oN4evzoCMmKGFdVjhjcPwoBaW2B6eBI9oSaJM+eAJIMNh2
	k9K86LJ4G5ceV6xObYpOfPA1PQh89SGJncKmllZ7nkoKy4B8ZOcwjkqeDpynmhY23fANG2rpl3j
	43nfPpEix9Z2gSZ8nL0RPJLZTPwQgDo8WoiitRi1xYKi5WxjVW5PkPsF18+dO12b1OF9D3VfyzE
	nW3VijbgGiqARrZZmJgkOlOZJ2aiajr8K0TsyXO3
X-Received: by 2002:a17:907:e113:b0:b9c:6ef1:ed18 with SMTP id
 a640c23a62f3a-b9d727aa4fdmr352963766b.25.1776000183133; Sun, 12 Apr 2026
 06:23:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120319.131582521@kernel.org>
In-Reply-To: <20260410120319.131582521@kernel.org>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sun, 12 Apr 2026 15:22:51 +0200
X-Gm-Features: AQROBzAeMsaeSVePCJ__tEd4f2rWAY6MixXzp_fii2b8vyUpLt4xjSbtYzENFaw
Message-ID: <CA+=Fv5S68wZQapeaYTspOfsuGk=nBj60sx-ojHBSqrxV59Q+ZA@mail.gmail.com>
Subject: Re: [patch 23/38] alpha: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>, 
	iommu@lists.linux.dev, Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2026 at 2:36=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:
>
> The only remaining usage of get_cycles() is to provide
> random_get_entropy().
>
> Switch alpha over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
> and providing random_get_entropy() in asm/random.h.
>
> Remove asm/timex.h as it has no functionality anymore.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: linux-alpha@vger.kernel.org
> ---
>  arch/alpha/Kconfig              |    1 +
>  arch/alpha/include/asm/random.h |   14 ++++++++++++++
>  arch/alpha/include/asm/timex.h  |   26 --------------------------
>  3 files changed, 15 insertions(+), 26 deletions(-)

Hi,

The Alpha side looks fine to me.

I've applied this patch on top of v7.0-rc7, built a kernel successfully,
boot-tested it on an Alpha UP2000+ (SMP) without issues.

Acked-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
