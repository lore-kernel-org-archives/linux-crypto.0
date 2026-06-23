Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8A037C109;
	Tue, 23 Jun 2026 13:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222284; cv=none; b=WZw/AGzPv8IdT7XiNoNwvjnkufbEMBBY0LpCDLBqTrXBw3hUlF4PNAJcf0z3f6JrOloCnnmrSqbe1In+9ZKWGLj0pK98uzhqNVKD/+BglRQp+3yQcmuV6Ial4mRM79o3KN40oOLoHEnpdSXJxPRNxcWkzS3jqtrn7B6y3N+D1zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222284; c=relaxed/simple;
	bh=bmJEfaGA/HL/+Rmr9wa/IHUYDf0IFENblFDia8vZaWU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=oBNSM1kOPvZUamITMgaUVXdQxX8Zgmf6kPenfkKmSzDIToXL1m7qP1DbPo6dvehvZQcQ9j1ZPhg0lA05kg7lLj0eQtlMkm3HD6leNbcpnO0p/RdxuDMZUQB+jNhVR0EsUyWINpqgjHSI7t1jrzqyeeDB856EAPAL2IsrXJY5x9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id E09EFC23;
	Tue, 23 Jun 2026 15:37:01 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id AF18E6015CB6; Tue, 23 Jun 2026 15:37:01 +0200 (CEST)
Date: Tue, 23 Jun 2026 15:37:01 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Fabian Blatter <fabianblatter09@gmail.com>
Cc: ignat@linux.win, herbert@gondor.apana.org.au, davem@davemloft.net,
	stefanb@linux.ibm.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecc - Optimize vli additive operations using
 compiler builtins
Message-ID: <ajqL_VMVA6n-gfQP@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGtAT=nJOAxecN+eYVwkzQAUcr2BaBhAO=ni9hWqdRKUQ06=fA@mail.gmail.com>
 <20260607112435.42804-1-fabianblatter09@gmail.com>

On Sun, Jun 07, 2026 at 01:24:35PM +0200, Fabian Blatter wrote:
> This patch uses __builtin_addcll, __builtin_subcll when available and
> otherwise __builtin_uaddll_overflow, __builtin_usubll_overflow. the
> latter have existed since ancient gcc versions, so no third fallback
> is needed.

crypto/ecc.c is derived from https://github.com/kmackay/micro-ecc/,
which seeks to be a portable ECC library.  I suspect the portability
goal is the reason why it doesn't take advantage of compiler builtins
or other optimizations.

The kernel is much less encumbered, the minimum compiler versions are
apparent from Documentation/process/changes.rst.  If these compiler
versions support the builtins you're using then everything should be
alright.

> I have put the add_carry and sub_borrow inline functions with the
> preprocessor logic for builtin selection directly in crypto/ecc.c.
> Please let me know if you would like them to be somewhere else.

Seems reasonable to me.

> This is quite interesting, since, as far as I know, the kernel compiles
> with gcc and O2 by default, yet the macro-level benchmarks still show a
> performance increase. The effect seems to be reversed when crypto/ecc.c
> gets compiled. Or maybe the linux kernel uses some additional
> optimization flags, I am unsure.

You can compile the kernel with V=1 to see the full command line.

> However, most of the time, the patched version outperforms the original
> one by a wide margin:
>  - On clang -O2 or -O3, vli_add and vli_uadd show a 4.074x and 5.384x
>    speedup.
>  - On gcc, vli_uadd shows a 74% performance increase at O2, 
>    and a 2.07x speedup at O3.

There is precedent in the tree for overriding the default -O2 with -O3,
see lib/lz4/Makefile and arch/mips/vdso/Makefile.

It might be worth using that for crypto/ecc.c if it doesn't cause
breakage and yields a significant speedup.

> I am happy to make any changes to this patch if you like.
> I could also look into making `vli_cmp` and `vli_is_zero`,
> or others constant-time in a future patch.

Your patch LGTM and I don't see a need for a v2.

Previously we discussed replacing the ECC point multiplication algorithm
used by crypto/ecc.c with a newer constant time Montgomery ladder.
If you are interested in continuing working on crypto/ecc.c,
this might be a worthwhile topic:

https://lore.kernel.org/r/aftFAexDFrYbIeBM@wunner.de/

Thanks,

Lukas
