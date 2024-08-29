Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33EE1ABEAF;
	Thu, 29 Aug 2024 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724940419; cv=none; b=TyaYu35Q+xv96Kp9e1BdAUTV1AAqSWvWsqmcII8gTICqV1g/1CuGh4YphPM+KsmfEGD1l6teOPdFoxIJnf89SbH7V7s/9pXq6OhJpikaNQq4kqu88ZwrAT5TuqBtehuyhOBkoQwdoDOiQPTIOiBQw0ChcEYZburvurKJk02yTqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724940419; c=relaxed/simple;
	bh=0S0yRpTpB8yDAp2PnEOxUn8pAAxSOhZjZhcRIfE3S74=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PCzvty5W4r64kQDq+oyGygFLWgO9zkQQQVRjCflmhqoZ6gy41nUP3witi9Wi9RIylmxIIRkZTBCZ+ym7sVzMd7sdc4eZeX+q2F2fxbnvtoHZRLQVv4eUiA9xSp2t86H5eFJRU8Psv7uiLo31tK2BDovj/uBN53fpWY+Pndyy8OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=RP02U9sZ; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="RP02U9sZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724940414;
	bh=0S0yRpTpB8yDAp2PnEOxUn8pAAxSOhZjZhcRIfE3S74=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=RP02U9sZkbOfdFPO8mfb67sv7a7pUPB1RkXe0tOFUw1oK+k3Pdd7QhkvEk+EuzCcm
	 s/x0TZLUUesMrgjSZMkxhFutpEP8H8mIiqTlrxBI1cS0lc791ysBI+l/hts/fl+RmN
	 2mqCBWCuIS1pcPcdWPZMRWCPMk0F7w5598CqkERM=
Received: from [192.168.124.6] (unknown [113.200.174.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 7AD2966F26;
	Thu, 29 Aug 2024 10:06:51 -0400 (EDT)
Message-ID: <a3373ad5f92a4120bd0c8e0c751eb7617e035cf6.camel@xry111.site>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, Tiezhu Yang
 <yangtiezhu@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Christophe
 Leroy <christophe.leroy@csgroup.eu>
Date: Thu, 29 Aug 2024 22:06:47 +0800
In-Reply-To: <ZtB5pqfp0Lg6lzz6@zx2c4.com>
References: <20240829125656.19017-1-xry111@xry111.site>
	 <ZtB3RczHN00XDO52@zx2c4.com> <ZtB5pqfp0Lg6lzz6@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-08-29 at 15:37 +0200, Jason A. Donenfeld wrote:
> On Thu, Aug 29, 2024 at 03:27:33PM +0200, Jason A. Donenfeld wrote:
> > One small question just occurred to me:
> >=20
> > > +static __always_inline const struct vdso_rng_data *__arch_get_vdso_r=
ng_data(
> > > +	void)
> > > +{
> > > +	return (const struct vdso_rng_data *)(
> > > +		get_vdso_data() +
> > > +		VVAR_LOONGARCH_PAGES_START * PAGE_SIZE +
> > > +		offsetof(struct loongarch_vdso_data, rng_data));
> > > +}
> >=20
> > Did you test this in a TIMENS? On x86, I had to deal with the page
> > offsets switching around depending on whether there was a TIMENS. I
> > tested this in my test harness with some basic code like:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (argc =3D=3D 1) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (unshare(CLONE_NEWTIME))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 panic("unsh=
are(CLONE_NEWTIME)");
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (!fork()) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (execl(a=
rgv[0], argv[0], "now-in-timens"))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 panic("execl");
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 }
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 wait(NULL);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 poweroff();
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > Because unlike other namespaces, the time one only becomes active after
> > fork/exec.
> >=20
> > But maybe loongarch is more organized and you don't need any special
> > handling in __arch_get_vdso...data() functions like I needed on x86.
> > Just thought I should check.
>=20
> Normal results:
>=20
> =C2=A0=C2=A0 vdso: 25000000 times in 0.287330836 seconds
> =C2=A0=C2=A0 libc: 25000000 times in 4.480710835 seconds
> syscall: 25000000 times in 4.411098048 seconds
>=20
> After applying
>=20
> diff --git a/arch/x86/include/asm/vdso/getrandom.h b/arch/x86/include/asm=
/vdso/getrandom.h
> index ff5334ad32a0..5cb1b318ebe3 100644
> --- a/arch/x86/include/asm/vdso/getrandom.h
> +++ b/arch/x86/include/asm/vdso/getrandom.h
> @@ -32,8 +32,6 @@ static __always_inline ssize_t getrandom_syscall(void *=
buffer, size_t len, unsig
>=20
> =C2=A0static __always_inline const struct vdso_rng_data *__arch_get_vdso_=
rng_data(void)
> =C2=A0{
> -	if (IS_ENABLED(CONFIG_TIME_NS) && __vdso_data->clock_mode =3D=3D VDSO_C=
LOCKMODE_TIMENS)
> -		return (void *)&__vdso_rng_data + ((void *)&__timens_vdso_data - (void=
 *)&__vdso_data);
> =C2=A0	return &__vdso_rng_data;
> =C2=A0}
>=20
> the results are:
>=20
> =C2=A0=C2=A0 vdso: 25000000 times in 4.403789593 seconds
> =C2=A0=C2=A0 libc: 25000000 times in 4.466771093 seconds
> syscall: 25000000 times in 4.428145416 seconds
>=20
> The difference is that when it finds the shared data in the wrong place,
> it thinks the RNG is uninitialized, so it always falls back to the
> syscall, hence all three times being the same.
>=20
> If you're unsure how timens handling works on loongarch, try this test
> yourself and see what you get.

$ unshare -r -T --boottime $((365*24*3600))
# uptime
 21:54:36 up 365 days,  5:38,  0 user,  load average: 0.05, 0.08, 2.82
# /home/xry111/git-repos/linux/tools/testing/selftests/vDSO/vdso_test_getra=
ndom bench-single
   vdso: 25000000 times in 0.499528591 seconds
   libc: 25000000 times in 6.968980040 seconds
syscall: 25000000 times in 6.987357071 seconds

So it seems normal in a time ns.

And from a comment in arch/loongarch/include/asm/vdso/vdso.h:

/*
 * The layout of vvar:
 *
 *                      high
 * +---------------------+--------------------------+
 * | loongarch vdso data | LOONGARCH_VDSO_DATA_SIZE |
 * +---------------------+--------------------------+
 * |  time-ns vdso data  |        PAGE_SIZE         |
 * +---------------------+--------------------------+
 * |  generic vdso data  |        PAGE_SIZE         |
 * +---------------------+--------------------------+
 *                      low
 */

And VVAR_LOONGARCH_PAGES_START is 2:

enum vvar_pages {
    VVAR_GENERIC_PAGE_OFFSET,
    VVAR_TIMENS_PAGE_OFFSET,
    VVAR_LOONGARCH_PAGES_START,
    VVAR_LOONGARCH_PAGES_END =3D VVAR_LOONGARCH_PAGES_START +
LOONGARCH_VDSO_DATA_PAGES - 1,
    VVAR_NR_PAGES,
};

So get_vdso_data() + VVAR_LOONGARCH_PAGES_START * PAGE_SIZE should have
already "jumped over" the time-ns vdso data.

OTOH it seems we are wasting a page if !CONFIG_TIME_NS.	Maybe:

enum vvar_pages {
    VVAR_GENERIC_PAGE_OFFSET,
#ifdef CONFIG_TIME_NS
    VVAR_TIMENS_PAGE_OFFSET,
#endif
    VVAR_LOONGARCH_PAGES_START,
    VVAR_LOONGARCH_PAGES_END =3D VVAR_LOONGARCH_PAGES_START +
LOONGARCH_VDSO_DATA_PAGES - 1,
    VVAR_NR_PAGES,
};

Tiezhu: how do you think?


--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
