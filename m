Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE27B3A29F;
	Sun,  1 Sep 2024 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197999; cv=none; b=h6vDZDIcjlXgQ0fPYxBquEDf1xW3J49fpHjw39PlkUlMcqzr41Bp342t9fk0VHibHPer1AB6QTg/t2H77nxsvBVqaGlD8YJyJ+3IAPLOcKs+UpUYiaL0NKD0NOF3rqCC0N3kRf2te1VNH9WxGl3gpgZYfqFHknhsAvJbp7lEvkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197999; c=relaxed/simple;
	bh=ZqAiE1RLqm0j623x1aSzS6lYdmf47dsIk/9BgeMJwss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEyLSFUK4ym0SFqHeaa2JrcAX5w8yq3DVkM2YLD++3fHkOrMCxdp1MYnCWlUiyOhRrPPoYLRo2qKYeS7xLr0nee1AmV8EQjoiGlob6joz6QF0jDQLjBHEQ1MsrodAkNHZ7/KfSF2/U+6/AVMKyMgN40azPzf1+QoIp3wMEW0LNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=J6PglX3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="J6PglX3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B2EC4CEC3;
	Sun,  1 Sep 2024 13:39:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="J6PglX3A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1725197996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VD1wcF7Qb+VHpKiC+Y0JiaxySeBNxKbAGen5a4ZQCPU=;
	b=J6PglX3AACoJl2qbCqVApUcHoIzsCu20NNL2SsmTgdhdJiyMjGNwJHW1iksfRMEK9OlMqt
	5NiWKdpUXBTM/eF0orfmROdBVDr9oC0rSfNgtJnxSgjMov4CHmsuKGflMwrHHZ51dxo+H3
	ThGMJnRhGWaMEAODAlVNlBIdeDhxLDE=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2fedc0c9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 1 Sep 2024 13:39:55 +0000 (UTC)
Date: Sun, 1 Sep 2024 15:39:52 +0200
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
Message-ID: <ZtRuqESaAG8KMIsp@zx2c4.com>
References: <20240901061315.15693-1-xry111@xry111.site>
 <20240901061315.15693-2-xry111@xry111.site>
 <CAAhV-H4nE3s7e=ouh04VH=yY2iR+ofuEkv8p=2cChJi=jw=pMw@mail.gmail.com>
 <ZtRq22l9ZLIKP5cf@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtRq22l9ZLIKP5cf@zx2c4.com>

On Sun, Sep 01, 2024 at 03:23:39PM +0200, Jason A. Donenfeld wrote:
> On Sun, Sep 01, 2024 at 04:44:40PM +0800, Huacai Chen wrote:
> > Hi, Ruoyao,
> > 
> > On Sun, Sep 1, 2024 at 2:13 PM Xi Ruoyao <xry111@xry111.site> wrote:
> > >
> > > Without a prototype, we'll have to add a prototype for each architecture
> > > implementing vDSO getrandom.  As most architectures will likely have the
> > > vDSO getrandom implemented in a near future, and we'd like to keep the
> > > declarations compatible everywhere (to ease the Glibc work), we should
> > > really just have one copy of the prototype.
> > >
> > > Suggested-by: Huacai Chen <chenhuacai@kernel.org>
> > > Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> > > ---
> > >  arch/x86/entry/vdso/vgetrandom.c | 2 --
> > >  include/vdso/getrandom.h         | 5 +++++
> > >  2 files changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/entry/vdso/vgetrandom.c b/arch/x86/entry/vdso/vgetrandom.c
> > > index 52d3c7faae2e..430862b8977c 100644
> > > --- a/arch/x86/entry/vdso/vgetrandom.c
> > > +++ b/arch/x86/entry/vdso/vgetrandom.c
> > > @@ -6,8 +6,6 @@
> > >
> > >  #include "../../../../lib/vdso/getrandom.c"
> > >
> > > -ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
> > > -
> > >  ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len)
> > >  {
> > >         return __cvdso_getrandom(buffer, len, flags, opaque_state, opaque_len);
> > > diff --git a/include/vdso/getrandom.h b/include/vdso/getrandom.h
> > > index 4cf02e678f5e..08b47b002bf7 100644
> > > --- a/include/vdso/getrandom.h
> > > +++ b/include/vdso/getrandom.h
> > > @@ -56,4 +56,9 @@ struct vgetrandom_state {
> > >   */
> > >  extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key, u32 *counter, size_t nblocks);
> > >
> > > +/**
> > Though in this file there are already comments beginning with /**, but
> > it seems the kernel's code style suggests beginning with /*.
> 
> /** is for docbook comments.

I'll fix this commit up as follows:

From de99263bbd61f5199ecbd7ce6cf57ede8bc42c84 Mon Sep 17 00:00:00 2001
From: Xi Ruoyao <xry111@xry111.site>
Date: Sun, 1 Sep 2024 14:13:10 +0800
Subject: [PATCH] random: vDSO: add a __vdso_getrandom prototype for all
 architectures

Without a prototype, we'll have to add a prototype for each architecture
implementing vDSO getrandom. As most architectures will likely have the
vDSO getrandom implemented in a near future, and we'd like to keep the
declarations compatible everywhere (to ease the libc implementor work),
we should really just have one copy of the prototype.

This also is what's already done inside of include/vdso/gettime.h for
those vDSO functions, so this continues that convention.

Suggested-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Acked-by: Huacai Chen <chenhuacai@kernel.org>
[Jason: rewrite docbook comment for prototype.]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/x86/entry/vdso/vgetrandom.c |  2 --
 include/vdso/getrandom.h         | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vgetrandom.c b/arch/x86/entry/vdso/vgetrandom.c
index 52d3c7faae2e..430862b8977c 100644
--- a/arch/x86/entry/vdso/vgetrandom.c
+++ b/arch/x86/entry/vdso/vgetrandom.c
@@ -6,8 +6,6 @@

 #include "../../../../lib/vdso/getrandom.c"

-ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
-
 ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len)
 {
 	return __cvdso_getrandom(buffer, len, flags, opaque_state, opaque_len);
diff --git a/include/vdso/getrandom.h b/include/vdso/getrandom.h
index 4cf02e678f5e..0d3849145a89 100644
--- a/include/vdso/getrandom.h
+++ b/include/vdso/getrandom.h
@@ -56,4 +56,20 @@ struct vgetrandom_state {
  */
 extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key, u32 *counter, size_t nblocks);

+/**
+ * __vdso_getrandom - Architecture-specific vDSO implementation of getrandom() syscall.
+ * @buffer:		Passed to __cvdso_getrandom_data().
+ * @len:		Passed to __cvdso_getrandom_data().
+ * @flags:		Passed to __cvdso_getrandom_data().
+ * @opaque_state:	Passed to __cvdso_getrandom_data().
+ * @opaque_len:		Passed to __cvdso_getrandom_data();
+ *
+ * This function acquires a pointer to the architecture-specific shared vDSO RNG datapage, and
+ * passes it, along with all of its arguments, to __cvdso_getrandom_data(), whose documentation may
+ * be consulted for more information.
+ *
+ * Returns:	The value of __cvdso_getrandom_data().
+ */
+extern ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
+
 #endif /* _VDSO_GETRANDOM_H */
--
2.46.0

