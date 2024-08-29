Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE331922F1;
	Thu, 29 Aug 2024 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724942693; cv=none; b=JDbSzFlgTijPdDOGe1UxIWF1OR9sT9y3JB5czrG2WzWUC9MUfjwwCHuudiPH2477y8JR4EMgnc0EkCJQttprk33J2D25afwY99yE4XUi1DJUsNt8CpbpiWllrvKEh6dxuZqLKa9NtEQW2TYI/L3A/7BSBtk6OvrLENDO1012++o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724942693; c=relaxed/simple;
	bh=YN5yNp4XlCp7LjXWlGz86hgJZ5nYnEokwYCmKdqb6xg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U3lFyY+Zsu2vLey4ftzxtNvakBMxn1msdzw992/P39hqRfQZIaCrNfwePcdsFUvyfh5FDQumKfE8v50/7/OPVZSVy3McKnC62SoAuLhIMUwUsFE3qDjCBpz0IhMmEW0HyZ3LPrIWuP1e4s1a+qCNV5XsBiW/UKFyTCfuG5Z6Eyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=YZV3tiEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="YZV3tiEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0815C4CEC5;
	Thu, 29 Aug 2024 14:44:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="YZV3tiEW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724942689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=em0njsUAXOJS7+NmJUjK8AWGxPR3Ii25X9Y4rjxzDJ0=;
	b=YZV3tiEWAIpKuCaXEnaRkSHi7Nxo9a1wLJOQ1Sf1uWJuDXxy/ayHfz7pH5dKHsVKc3mNF5
	EDfP6pXBgESyO5I0jrKrZ4i5Dz1MVjTZ3xnqtnI7jkhtjDBZVGLT9N68cx2e8yqqzMa2zD
	HqXsFwoCBiEip/IToj7i9dsjcuDmcKg=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bda16223 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 29 Aug 2024 14:44:49 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7093ba310b0so326869a34.2;
        Thu, 29 Aug 2024 07:44:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUcU4A+nwnXbsD6ts+nxHV91SC9CnY4fs1RWd5DoGt2sbIQEf19DZDX8cr00zzFCGDntFZwWFyEUTd0TwE=@vger.kernel.org, AJvYcCXPNCVqmxAGbM1wsnT2XE9MW8VubQQBznOO7yVOJpIbAD+CW3/QVQ0o+rRO/t5wj+xEsH8aAZ89SPQJqzTc@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6onYsN91SQiIuCu4LjIfTOonuPBXOxnSrylBHza26ZWVi/0zY
	jRzEYwYsRz6zN8UxKy7kzFT7CzAqMoLrgpfkzlfXX4yyO1jsQHNScE65zkpNsupuHKLMXoObceb
	a9UReycuVvfjKD0qmEhuONjhnRPo=
X-Google-Smtp-Source: AGHT+IFJFrP+7ciDdf49r1WxVQMZ4slbYd8niK13QH/LcjAK9dSq+dZxL8xUkF3KdsiF8Kxxnl37aJ2kSqeju0SYw6I=
X-Received: by 2002:a05:6830:628b:b0:709:621b:f336 with SMTP id
 46e09a7af769-70f5c3922cbmr3323136a34.16.1724942688205; Thu, 29 Aug 2024
 07:44:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829125656.19017-1-xry111@xry111.site> <ZtB3RczHN00XDO52@zx2c4.com>
 <ZtB5pqfp0Lg6lzz6@zx2c4.com> <a3373ad5f92a4120bd0c8e0c751eb7617e035cf6.camel@xry111.site>
In-Reply-To: <a3373ad5f92a4120bd0c8e0c751eb7617e035cf6.camel@xry111.site>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 29 Aug 2024 16:44:36 +0200
X-Gmail-Original-Message-ID: <CAHmME9p+-0S-a3kjsv75irmLdGpW6rUWBVm87E4-Z9hpWyA7YA@mail.gmail.com>
Message-ID: <CAHmME9p+-0S-a3kjsv75irmLdGpW6rUWBVm87E4-Z9hpWyA7YA@mail.gmail.com>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO implementation
To: Xi Ruoyao <xry111@xry111.site>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 4:06=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> On Thu, 2024-08-29 at 15:37 +0200, Jason A. Donenfeld wrote:
> > On Thu, Aug 29, 2024 at 03:27:33PM +0200, Jason A. Donenfeld wrote:
> > > One small question just occurred to me:
> > >
> > > > +static __always_inline const struct vdso_rng_data *__arch_get_vdso=
_rng_data(
> > > > + void)
> > > > +{
> > > > + return (const struct vdso_rng_data *)(
> > > > +         get_vdso_data() +
> > > > +         VVAR_LOONGARCH_PAGES_START * PAGE_SIZE +
> > > > +         offsetof(struct loongarch_vdso_data, rng_data));
> > > > +}
> > >
> > > Did you test this in a TIMENS? On x86, I had to deal with the page
> > > offsets switching around depending on whether there was a TIMENS. I
> > > tested this in my test harness with some basic code like:
> > >
> > >        if (argc =3D=3D 1) {
> > >                if (unshare(CLONE_NEWTIME))
> > >                        panic("unshare(CLONE_NEWTIME)");
> > >                if (!fork()) {
> > >                        if (execl(argv[0], argv[0], "now-in-timens"))
> > >                                panic("execl");
> > >                }
> > >                wait(NULL);
> > >                poweroff();
> > >        }
> > >
> > > Because unlike other namespaces, the time one only becomes active aft=
er
> > > fork/exec.
> > >
> > > But maybe loongarch is more organized and you don't need any special
> > > handling in __arch_get_vdso...data() functions like I needed on x86.
> > > Just thought I should check.
> >
> > Normal results:
> >
> >    vdso: 25000000 times in 0.287330836 seconds
> >    libc: 25000000 times in 4.480710835 seconds
> > syscall: 25000000 times in 4.411098048 seconds
> >
> > After applying
> >
> > diff --git a/arch/x86/include/asm/vdso/getrandom.h b/arch/x86/include/a=
sm/vdso/getrandom.h
> > index ff5334ad32a0..5cb1b318ebe3 100644
> > --- a/arch/x86/include/asm/vdso/getrandom.h
> > +++ b/arch/x86/include/asm/vdso/getrandom.h
> > @@ -32,8 +32,6 @@ static __always_inline ssize_t getrandom_syscall(void=
 *buffer, size_t len, unsig
> >
> >  static __always_inline const struct vdso_rng_data *__arch_get_vdso_rng=
_data(void)
> >  {
> > -     if (IS_ENABLED(CONFIG_TIME_NS) && __vdso_data->clock_mode =3D=3D =
VDSO_CLOCKMODE_TIMENS)
> > -             return (void *)&__vdso_rng_data + ((void *)&__timens_vdso=
_data - (void *)&__vdso_data);
> >       return &__vdso_rng_data;
> >  }
> >
> > the results are:
> >
> >    vdso: 25000000 times in 4.403789593 seconds
> >    libc: 25000000 times in 4.466771093 seconds
> > syscall: 25000000 times in 4.428145416 seconds
> >
> > The difference is that when it finds the shared data in the wrong place=
,
> > it thinks the RNG is uninitialized, so it always falls back to the
> > syscall, hence all three times being the same.
> >
> > If you're unsure how timens handling works on loongarch, try this test
> > yourself and see what you get.
>
> $ unshare -r -T --boottime $((365*24*3600))
> # uptime
>  21:54:36 up 365 days,  5:38,  0 user,  load average: 0.05, 0.08, 2.82
> # /home/xry111/git-repos/linux/tools/testing/selftests/vDSO/vdso_test_get=
random bench-single
>    vdso: 25000000 times in 0.499528591 seconds
>    libc: 25000000 times in 6.968980040 seconds
> syscall: 25000000 times in 6.987357071 seconds
>
> So it seems normal in a time ns.
>
> And from a comment in arch/loongarch/include/asm/vdso/vdso.h:
>
> /*
>  * The layout of vvar:
>  *
>  *                      high
>  * +---------------------+--------------------------+
>  * | loongarch vdso data | LOONGARCH_VDSO_DATA_SIZE |
>  * +---------------------+--------------------------+
>  * |  time-ns vdso data  |        PAGE_SIZE         |
>  * +---------------------+--------------------------+
>  * |  generic vdso data  |        PAGE_SIZE         |
>  * +---------------------+--------------------------+
>  *                      low
>  */
>
> And VVAR_LOONGARCH_PAGES_START is 2:
>
> enum vvar_pages {
>     VVAR_GENERIC_PAGE_OFFSET,
>     VVAR_TIMENS_PAGE_OFFSET,
>     VVAR_LOONGARCH_PAGES_START,
>     VVAR_LOONGARCH_PAGES_END =3D VVAR_LOONGARCH_PAGES_START +
> LOONGARCH_VDSO_DATA_PAGES - 1,
>     VVAR_NR_PAGES,
> };
>
> So get_vdso_data() + VVAR_LOONGARCH_PAGES_START * PAGE_SIZE should have
> already "jumped over" the time-ns vdso data.

Oh good. Thanks for checking. So it sounds like there's just Huacai's
set of comments and we're good.
