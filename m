Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999EB189900;
	Wed, 28 Aug 2024 14:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855174; cv=none; b=Rv2miX3Cf0rMiM5w91rt8E3rrK8kldT16sNyUFsFagmcFswCFv9VtR4+3gB5Gq15zvAnWdq/5Ug1hwYl8e2Fmyk25Y0Fl8cvTeiDn9eHO/enFBPgF0VO81t5RY6feulkKxjMRoyQQCnkNDhvl7pEopVZ23Qj6pqk9xGSZXPTQUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855174; c=relaxed/simple;
	bh=ntWBtU0LxavRuCqVpYA1JLpHXD8k/GlRirf2mXQ6TV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9JX2srPYnZ8WlxxY2ryU2ScwX/gQaNOoB621NWN9yABhURw+MoZIpnIEK1T/2YXOMlVYXhcu/fMBgDhrSBvkbT25UexpTPXMweei9hmYjPrD6Sw3RrTYc76wTZwotn8E+KY1FwMbvB9SXAY299DbXT6EKdpP8W6b/GMVThxK1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=RyhV1h1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RyhV1h1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4833DC4CEE1;
	Wed, 28 Aug 2024 14:26:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RyhV1h1T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724855171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=du+xceswDXlbktWATgQZJXZ9xdKcBi7Wp3qaqXDfzeA=;
	b=RyhV1h1ToMsAKGBKVqGsMClc9ZWYDbjalfZLiPEDjveqMAOHP7CzFL1omPwRxEdZjGwLiq
	O4UJw/r2gNRGjlGi12OpLy6W3DEWeaFocFOshEzB1ja+xg8g79i8v9s9cby3+wJHWb3PbL
	hE7cWC8bgG5O4+Y+BIirXixDnc92Z8g=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6fa3f4ce (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 28 Aug 2024 14:26:11 +0000 (UTC)
Date: Wed, 28 Aug 2024 16:26:07 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 1/4] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
Message-ID: <Zs8zf5SWLUVgbu1q@zx2c4.com>
References: <20240827132018.88854-1-xry111@xry111.site>
 <20240827132018.88854-2-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240827132018.88854-2-xry111@xry111.site>

On Tue, Aug 27, 2024 at 09:20:14PM +0800, Xi Ruoyao wrote:
> diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vdso/vgetrandom-chacha.S
> new file mode 100644
> index 000000000000..2e42198f2faf
> --- /dev/null
> +++ b/arch/loongarch/vdso/vgetrandom-chacha.S
> @@ -0,0 +1,239 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserved.
> + */
> +
> +#include <asm/asm.h>
> +#include <asm/regdef.h>
> +#include <linux/linkage.h>
> +
> +.text
> +
> +/* Salsa20 quarter-round */
> +.macro	QR	a b c d
> +	add.w		\a, \a, \b
> +	xor		\d, \d, \a
> +	rotri.w		\d, \d, 16
> +
> +	add.w		\c, \c, \d
> +	xor		\b, \b, \c
> +	rotri.w		\b, \b, 20
> +
> +	add.w		\a, \a, \b
> +	xor		\d, \d, \a
> +	rotri.w		\d, \d, 24
> +
> +	add.w		\c, \c, \d
> +	xor		\b, \b, \c
> +	rotri.w		\b, \b, 25
> +.endm
> +
> +/*
> + * Very basic LoongArch implementation of ChaCha20. Produces a given positive
> + * number of blocks of output with a nonce of 0, taking an input key and
> + * 8-byte counter. Importantly does not spill to the stack. Its arguments
> + * are:
> + *
> + *	a0: output bytes
> + *	a1: 32-byte key input
> + *	a2: 8-byte counter input/output
> + *	a3: number of 64-byte blocks to write to output
> + */
> +SYM_FUNC_START(__arch_chacha20_blocks_nostack)

I can confirm this works:

    $ loongarch64-unknown-linux-gnu-gcc -std=gnu99 -D_GNU_SOURCE= -idirafter tools/testing/selftests/../../../tools/include -idirafter tools/testing/selftests/../../../arch/loongarch/include -idirafter tools/testing/selftests/../../../include -D__ASSEMBLY__ -Wa,--noexecstack    vdso_test_chacha.c tools/testing/selftests/../../../tools/arch/loongarch/vdso/vgetrandom-chacha.S  -o tools/testing/selftests/vDSO/vdso_test_chacha -static
    $ qemu-loongarch64 ./vdso_test_chacha
    TAP version 13
    1..1
    ok 1 chacha: PASS
    
Just waiting now on a v5 as discussed and acks from the LoongArch maintainers on that v5.

Jason
