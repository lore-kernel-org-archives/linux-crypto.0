Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5081AE854;
	Thu, 29 Aug 2024 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724938674; cv=none; b=ipmVKFD2dXGk2zLRJQRurM1ACorChXK52GfgvaGvBr4NZvHvt3BaX5WLOhDn8CiNypSNo5hcU2aWu14Rs+31OKJRZD5CqDdQd6TvCoAE44zQmlXkytBZP4IMi0YBquoXOIcsNQ71Q4gWvy9jVdEJuY76otuPN9cyzpiAu/7kq9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724938674; c=relaxed/simple;
	bh=5j+pCu/063iK1q0f2lIBnWsUUADZMQILRbJ/J12nbOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNr4wvf+j5GSyZ4m7V97b0MkNT06PwcqaVWTfYAIPCDNy2dqiwnNbtFawPggLhndVszNrgTKH2MuzqxjGzAtPX6MXMvavt3OF2wq/un7DwEaakM7eKu2h4qTvIZ8lvLZnQA1zALJSMSEuZK0o7Cq9Pvn8F6fT3XZheos8/7qHDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=OXv9i1KY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OXv9i1KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00B4C4CEC7;
	Thu, 29 Aug 2024 13:37:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OXv9i1KY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724938670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DgOsAY+IzUzI2LVe8MyPw3usnxayg4MxSPg3sYPdlME=;
	b=OXv9i1KY5QeZZTYveePJOryfkIKWmKvFq3/LUkOyROXCUcvRHQ8fi89gGDI9UUGydvSqLA
	J6g+Jez3wfR4VBLZZmsAd0xZPFSr8K6ccj+mgODzlLL4xYT1RrwlPL0NOMx4W3CpwkyRGY
	b5+AUQWIwtbVTeUwyglJrSj3QPZ6tL8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ba520353 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 29 Aug 2024 13:37:50 +0000 (UTC)
Date: Thu, 29 Aug 2024 15:37:42 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
Message-ID: <ZtB5pqfp0Lg6lzz6@zx2c4.com>
References: <20240829125656.19017-1-xry111@xry111.site>
 <ZtB3RczHN00XDO52@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZtB3RczHN00XDO52@zx2c4.com>

On Thu, Aug 29, 2024 at 03:27:33PM +0200, Jason A. Donenfeld wrote:
> One small question just occurred to me:
> 
> > +static __always_inline const struct vdso_rng_data *__arch_get_vdso_rng_data(
> > +	void)
> > +{
> > +	return (const struct vdso_rng_data *)(
> > +		get_vdso_data() +
> > +		VVAR_LOONGARCH_PAGES_START * PAGE_SIZE +
> > +		offsetof(struct loongarch_vdso_data, rng_data));
> > +}
> 
> Did you test this in a TIMENS? On x86, I had to deal with the page
> offsets switching around depending on whether there was a TIMENS. I
> tested this in my test harness with some basic code like:
> 
>        if (argc == 1) {
>                if (unshare(CLONE_NEWTIME))
>                        panic("unshare(CLONE_NEWTIME)");
>                if (!fork()) {
>                        if (execl(argv[0], argv[0], "now-in-timens"))
>                                panic("execl");
>                }
>                wait(NULL);
>                poweroff();
>        }
> 
> Because unlike other namespaces, the time one only becomes active after
> fork/exec.
> 
> But maybe loongarch is more organized and you don't need any special
> handling in __arch_get_vdso...data() functions like I needed on x86.
> Just thought I should check.

Normal results:

   vdso: 25000000 times in 0.287330836 seconds
   libc: 25000000 times in 4.480710835 seconds
syscall: 25000000 times in 4.411098048 seconds

After applying

diff --git a/arch/x86/include/asm/vdso/getrandom.h b/arch/x86/include/asm/vdso/getrandom.h
index ff5334ad32a0..5cb1b318ebe3 100644
--- a/arch/x86/include/asm/vdso/getrandom.h
+++ b/arch/x86/include/asm/vdso/getrandom.h
@@ -32,8 +32,6 @@ static __always_inline ssize_t getrandom_syscall(void *buffer, size_t len, unsig

 static __always_inline const struct vdso_rng_data *__arch_get_vdso_rng_data(void)
 {
-	if (IS_ENABLED(CONFIG_TIME_NS) && __vdso_data->clock_mode == VDSO_CLOCKMODE_TIMENS)
-		return (void *)&__vdso_rng_data + ((void *)&__timens_vdso_data - (void *)&__vdso_data);
 	return &__vdso_rng_data;
 }

the results are:

   vdso: 25000000 times in 4.403789593 seconds
   libc: 25000000 times in 4.466771093 seconds
syscall: 25000000 times in 4.428145416 seconds

The difference is that when it finds the shared data in the wrong place,
it thinks the RNG is uninitialized, so it always falls back to the
syscall, hence all three times being the same.

If you're unsure how timens handling works on loongarch, try this test
yourself and see what you get.

Jason
