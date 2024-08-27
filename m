Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47088F54;
	Tue, 27 Aug 2024 13:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724766562; cv=none; b=dKuQedeF6cEpFCeO87/ARXowHdmBsd5sb8ICWWnJMtuyUVjNXNTf4vfKoTwA9P5cbvqGb+Mqhs5ZJinDA7+pyc/EiZuFvFIgKlBm1oWGTYsbDUJwN7a/M1FCETylLzjeiE5c9FqGVXK9Obde3d0WGdihF3EfQwRrqTsd7PYfFrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724766562; c=relaxed/simple;
	bh=+dVKf7i/YopxAAhOCEdf5Jg9hDudBZfGqD9iK1aNg7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z1J0p7F5Ek40OBZSb24kJ3RTMNM29i1Gx95tiV2E3xdZTi/HlC9StctoodsstBxtpbCskhWNz8T0jXgpyNWBoTl5a5Zvg/kS9Xp6ztrafgePvMoZ43+S5Vbxw/MiAfzDOtkYfwKhPKss5k0Cvpk/D6eI8DRq7XXFBIzO9a6Iwfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=khEWJ3vL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="khEWJ3vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DB0C4E693;
	Tue, 27 Aug 2024 13:49:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="khEWJ3vL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724766560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZzQfhKnzTguXl76//OV34+FR8A/uMxLd0aB/p455GQ=;
	b=khEWJ3vLQNPb+mJQrvRTQ0/jd+84SUzfZLbfLyGBdNLkr8gcU2B+FBql8GElmBICffXGO3
	BAw/eQai9nfcsuJXPz4+oOxnfziearnSYl8sOU/oLrz3w1N7epuXVDIz8Kv1/EqZvvB0kT
	0f1brmyuUf3/1ZUzYUXDQ/gLKkptKis=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 261e8df7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 27 Aug 2024 13:49:19 +0000 (UTC)
Date: Tue, 27 Aug 2024 15:49:14 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 1/4] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
Message-ID: <Zs3ZWm-218Cb_ir0@zx2c4.com>
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
> +	register long ret asm("a0");
> +	register long int nr asm("a7") = __NR_getrandom;

The first line is `long` and the second line is `long int` here. Just
call them both `long` like usual?

>  struct loongarch_vdso_data {
>  	struct vdso_pcpu_data pdata[NR_CPUS];
> +#ifdef CONFIG_VDSO_GETRANDOM
> +	struct vdso_rng_data rng_data;
> +#endif

If VSO_GETRANDOM is selected unconditionally for the arch, why the ifdef
here?

> +obj-vdso-$(CONFIG_VDSO_GETRANDOM) += vgetrandom.o vgetrandom-chacha.o

Likewise, same question here.

> +	/* copy[3] = "expa" */
> +	li.w		copy3, 0x6b206574

Might want to mention why you're doing this.

    /* copy[3] = "expa", because it was clobbered by the i index. */

Or something like that.

But on the topic of those constants,

> +       li.w            copy0, 0x61707865
> +       li.w            copy1, 0x3320646e
> +       li.w            copy2, 0x79622d32

What if you avoid doing this,

> +
> +       ld.w            cnt_lo, counter, 0
> +       ld.w            cnt_hi, counter, 4
> +
> +.Lblock:
> +       /* state[0,1,2,3] = "expand 32-byte k" */
> +       move            state0, copy0
> +       move            state1, copy1
> +       move            state2, copy2

Use li.w here with the integer literals,

> +	/* copy[3] = "expa" */
> +	li.w		copy3, 0x6b206574

Skip this,

> +       add.w           state0, state0, copy0
> +       add.w           state1, state1, copy1
> +       add.w           state2, state2, copy2
> +       add.w           state3, state3, copy3

And then use addi.w here with the integer literals instead?

I don't know anything about loongarch, so just guessing.

BTW, can you confirm that this passes the test in test_vdso_chacha?
