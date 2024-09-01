Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3D4143895;
	Sun,  1 Sep 2024 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197025; cv=none; b=OJQx2wr8/I+48P2+zFNl52KkQOmHyL6AZvIGdDTQQTdqvuar+2RC9tDrV/933MEqVlKQjsO1Yd3oZWX+fRNlwV87GVraVUNc6b7Ph1ftiXn0A+qvRpu1cyZeSCkbV8jrvVWOJmwlNTbyPXuqrMyCbdfwEZu7bfUGhwL8QVqAZoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197025; c=relaxed/simple;
	bh=8vCGBwnBjc1xHPlc4gNnZpQ9DR1c/49T2LeD4HXaKBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fErzANjcVhyxnqhRdgLjjfBB4XlEhGVRKXPEU5LeC4GBoZDSFwwoXZhVyqwNxuCmDon+GssoZ/6ZEg8PPMoZMrlHbkhBbc/CM/XxtCZYK+qHzolVlVT6c19qhstZX+S9BaQj2JFnlHGOcbtdS8xx+lecHljE6vEKTeDKaJ76SrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=WDthme+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WDthme+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BECC4CEC3;
	Sun,  1 Sep 2024 13:23:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WDthme+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1725197022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGyZJQR060VSnwrNk7XiShFR1gPfOwXZ9cHqOSx6lPs=;
	b=WDthme+ORw/f5s94kpaO7bXjM/rsireYwa5oFT5YsVdJC25Bl+WLIJmLtvL711KuNynve6
	SVLbCxF89ajAFoLeROjfFKrk9L1QN7nTesDe5DNAo62uKnx2UJFjoMWK7KA4Rx4tKhfi0u
	JtQDIiBjbWK8E30Vf9rUyIUbFlcvbO8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 60b4ee00 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 1 Sep 2024 13:23:42 +0000 (UTC)
Date: Sun, 1 Sep 2024 15:23:39 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Xi Ruoyao <xry111@xry111.site>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 1/3] arch: vDSO: Add a __vdso_getrandom prototype for
 all architectures
Message-ID: <ZtRq22l9ZLIKP5cf@zx2c4.com>
References: <20240901061315.15693-1-xry111@xry111.site>
 <20240901061315.15693-2-xry111@xry111.site>
 <CAAhV-H4nE3s7e=ouh04VH=yY2iR+ofuEkv8p=2cChJi=jw=pMw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H4nE3s7e=ouh04VH=yY2iR+ofuEkv8p=2cChJi=jw=pMw@mail.gmail.com>

On Sun, Sep 01, 2024 at 04:44:40PM +0800, Huacai Chen wrote:
> Hi, Ruoyao,
> 
> On Sun, Sep 1, 2024 at 2:13 PM Xi Ruoyao <xry111@xry111.site> wrote:
> >
> > Without a prototype, we'll have to add a prototype for each architecture
> > implementing vDSO getrandom.  As most architectures will likely have the
> > vDSO getrandom implemented in a near future, and we'd like to keep the
> > declarations compatible everywhere (to ease the Glibc work), we should
> > really just have one copy of the prototype.
> >
> > Suggested-by: Huacai Chen <chenhuacai@kernel.org>
> > Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> > ---
> >  arch/x86/entry/vdso/vgetrandom.c | 2 --
> >  include/vdso/getrandom.h         | 5 +++++
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/entry/vdso/vgetrandom.c b/arch/x86/entry/vdso/vgetrandom.c
> > index 52d3c7faae2e..430862b8977c 100644
> > --- a/arch/x86/entry/vdso/vgetrandom.c
> > +++ b/arch/x86/entry/vdso/vgetrandom.c
> > @@ -6,8 +6,6 @@
> >
> >  #include "../../../../lib/vdso/getrandom.c"
> >
> > -ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
> > -
> >  ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len)
> >  {
> >         return __cvdso_getrandom(buffer, len, flags, opaque_state, opaque_len);
> > diff --git a/include/vdso/getrandom.h b/include/vdso/getrandom.h
> > index 4cf02e678f5e..08b47b002bf7 100644
> > --- a/include/vdso/getrandom.h
> > +++ b/include/vdso/getrandom.h
> > @@ -56,4 +56,9 @@ struct vgetrandom_state {
> >   */
> >  extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key, u32 *counter, size_t nblocks);
> >
> > +/**
> Though in this file there are already comments beginning with /**, but
> it seems the kernel's code style suggests beginning with /*.

/** is for docbook comments.
