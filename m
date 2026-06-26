Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80E637F8DB;
	Fri, 26 Jun 2026 16:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492093; cv=none; b=ex7IUgTnhzRrvV5rPv/T29H68LDH94Ajbe1HxP3rHGknooTIkaBuYkEHvw/o+L7YaqxlVG+4U8YghuEzij7r8CYTqLiuymYUzLxgtWWnKlBQr4NTacQBl2irjN75Zwp4O8k/6vilWe+sIx+vSOLk7dpyewcW5+qtq1uYROXjieM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492093; c=relaxed/simple;
	bh=oKmUTCkU5vkJKigNiyNEjJdUjg+AAzcV8q5fFuRtHgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lRG9arDkrGck2EjM4w+QMZLSKESewRstDt7e6LWvoLbLk9k5+/TbtsjTKSqo+wDlei/R1XSvh5Y1FFdonJEeYrmsFNMXnQrgMclQEUHg8rGENNBHWOsaY3CB0MFscWuO+abBS7qo2GRnlaevzhptTRZ8cpyQhluml8OAltKavNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MFflujch reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MFflujch"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 571E240E0031;
	Fri, 26 Jun 2026 16:41:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TfaXCwUB0Pi5; Fri, 26 Jun 2026 16:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1782492071; bh=ADxacD02dQ3O7qZRO7JLGvhTz+orY0cjlcqp6joinc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MFflujchlwk4Abj9tjcgCnq8OTnQQ/pSziCHpkktj8xsBxxxbUcAWz6KJA5jP5jgZ
	 GMhiJYd3H4SCrfrXiNygY373l5ZZABg2nyLCE7BbB57dwMSwV/cdwbduZtfNf3aKd4
	 DXqibixZDulULxE3CO96uhdm3Nro+JkUqM5zUlOIootTmizjkdBUpNUZztAZVQewvz
	 KlwleWSjo20pgW2vg45dEGX4oItTublq6QU25KgFW7iAZq3iNfwnAtpHye7D/ofZSn
	 ej+tDHs+5OG5zgBPemlExMjF0MZAEfmEMN5iIEpK3pGgXC0mVTDwaMhGYQQ/LXboI5
	 VQMZxcUf+NDA++2o/RJFeD06RSXganbXPluklhiRzQxjjVyMALacqwrBbHMoR81xcP
	 BY6VE3uZZrf9ttSh9fYpCuUyqfySNd22tls1T1IAyWxEc/7BDsgW1grpwASoap4wID
	 Fjt0dxgQUfRT0scjnqfESCHFnnnYEwp6e/QNZ4T/Z1T23mqVuGh9zrYhJP4mDqalVQ
	 7DzxL/otrk+NvkjSQmjDPVKU924c6+PATDsY6UDtW372LVktKIcQIxxEU7nYyoFlgx
	 AfButWofu3+gxd1T8+OiQm4lyh3Zx8+f3v00smb/SJLWa+HG6ZtZp8ubmc1dYzA3oT
	 JaJuuF+AnEb+H0QsDMOv8R08=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5009640E00BA;
	Fri, 26 Jun 2026 16:40:36 +0000 (UTC)
Date: Fri, 26 Jun 2026 09:40:32 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
Message-ID: <20260626164032.GDaj6rgHq4xPd-qjvG@fat_crate.local>
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
 <20260625150253.GAaj1DHZC8ULg6PzbI@fat_crate.local>
 <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 02:42:23PM -0500, Kalra, Ashish wrote:
> Hello Boris,

Hello Ashish,

lemme try to make sense of your AI reply...

> cpu_hotplug_disable()/cpu_hotplug_enable() are refcounted (cpu_hotplug_=
disabled++/--,
> with a WARN on underflow), so they have to be balanced. This flag colla=
pses them to
> exactly one outstanding disable per SNP-active window, because the disa=
ble and enable
> sites are not reached a symmetric number of times:

Well, why aren't they?

Why isn't a simple design where on SNP init hotplug is disabled - *exactl=
y*
one call to cpu_hotplug_disable() and on SNP shutdown hotplug is reenable=
d
again - also exactly one call.

I know why...

>   - On firmware without SNP_X86_SHUTDOWN_SUPPORTED, __sev_snp_shutdown_=
locked() does not

This function is one convoluted mess which does gazillion things. If I we=
re
maintaining that code, I would impose a mandatory cleanup phase before ne=
w
features are added. But I probably said that already before...

And because a lot of code from your set goes into areas I maintain, I wou=
ld
suggest you take the time and do that cleanup. Before that code goes
completely off the rails. And I'm willing to offer you review bandwidth a=
nd
other help I can with doing this right.

>   call snp_shutdown() (it's gated on data.x86_snp_shutdown), so SNP sta=
ys enabled in
>   hardware =E2=80=94 SNP_EN stays set and hotplug stays disabled =E2=80=
=94 while sev->snp_initialized is
>   cleared. Re-init after that is routine, the SNP ioctls self-bracket i=
nit and shutdown
>   (e.g. SNP_COMMIT, SNP_SET_CONFIG, SNP_VLEK_LOAD):

That init and teardown flow should be simplified:

You have multiple things which you need to do at different times

- per-CPU init=20
- global init=20

- per-CPU teardown
- global teardown

CPU hotplug toggling belongs to the global category. Instead of piling mo=
re
stuff onto that __sev_snp_shutdown_locked() function, you should take som=
e
time to clean it up, analyze what goes where and then simplify that flow.

So let's clean stuff up first, please, analyze the flow and determine wha=
t
goes where and then do it. Not bolt more stuff on what is already wobbly.

Thx.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
