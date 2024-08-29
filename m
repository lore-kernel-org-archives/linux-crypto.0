Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB331AD410;
	Thu, 29 Aug 2024 13:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724938069; cv=none; b=Ku0tUBph8iYYyj6IcgVps8S7djMC5LH+kIDnhtdr3cmGTEmOgXEm3R2Gg8utHJFZNB1HqkAq6NlsTcYGqDu1Sl8zmgoS44LZ/sGhMb6ippV7K1W6CeojZUd1oAjEZrwnjxOcwd99/9SIAF+EQd9Ep9zlgjp4RZxqPZX26MmOycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724938069; c=relaxed/simple;
	bh=LUsbM8CohYpsuFyB+hZrpQ8iet1wK/qnP6ARKmCHLJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5q1mmyCCmnNGPI0GgThn2yTlQNGk2mfwuESj12sIiJD9ozycdFGls2GXWz8vChe7RXhbATeOgvt+8fqByCSzVB+cU0mnd/wBteyzohTKlgJOxGq+/elJwzrecECDI+g2FLSMB+iesFAuBKLtgM5X2jXT442aWzx+Rgzu1UpMaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=EpXra3FX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EpXra3FX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0257CC4CEC1;
	Thu, 29 Aug 2024 13:27:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EpXra3FX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724938066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WlCLoCiqnGVD1bl9+OZsTIXM2oG7ARmd4+f6I8UiZkE=;
	b=EpXra3FXZb7rX7Jwos+s8/FmDE+H8viWFPpOFVm7qCUsSKsGEttv4bdIr70XvxOxCGxROD
	qRv8jE4BsXhfs2j9B0DCRFypKHgVsOgBVskRuMG1sbqvFH1SmWz+MakNU8Nsx5Y1/r180C
	B8G1QkDRlu1LO6H7evWnkvLudVamTF0=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ba4c5ba7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 29 Aug 2024 13:27:46 +0000 (UTC)
Date: Thu, 29 Aug 2024 15:27:33 +0200
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
Message-ID: <ZtB3RczHN00XDO52@zx2c4.com>
References: <20240829125656.19017-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240829125656.19017-1-xry111@xry111.site>

One small question just occurred to me:

> +static __always_inline const struct vdso_rng_data *__arch_get_vdso_rng_data(
> +	void)
> +{
> +	return (const struct vdso_rng_data *)(
> +		get_vdso_data() +
> +		VVAR_LOONGARCH_PAGES_START * PAGE_SIZE +
> +		offsetof(struct loongarch_vdso_data, rng_data));
> +}

Did you test this in a TIMENS? On x86, I had to deal with the page
offsets switching around depending on whether there was a TIMENS. I
tested this in my test harness with some basic code like:

       if (argc == 1) {
               if (unshare(CLONE_NEWTIME))
                       panic("unshare(CLONE_NEWTIME)");
               if (!fork()) {
                       if (execl(argv[0], argv[0], "now-in-timens"))
                               panic("execl");
               }
               wait(NULL);
               poweroff();
       }

Because unlike other namespaces, the time one only becomes active after
fork/exec.

But maybe loongarch is more organized and you don't need any special
handling in __arch_get_vdso...data() functions like I needed on x86.
Just thought I should check.

Jason
