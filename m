Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6899B1E53A;
	Sun,  1 Sep 2024 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725198347; cv=none; b=AzhYvWlM/zxVQf2bXf8W9ZrNnmCdKNhOreJhveuJfXXrfTYtuxzgbOMwCcoWE6MKXJ7yvQLQ4DdKbxOYrg6U0PbP0rJvVZa4cRG8CtLiEAKsEfJCm+PtsALq8kbjtHiAYDdKwEM7l9n98CR7IyVE7zTzvRZUOlVpupZq+Gi+7EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725198347; c=relaxed/simple;
	bh=eLsIdZiKRsJuyF/Z5iveQh5fELw+R6G3WGKzILEYDYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9ZdL+HMKr2I/bVNLsjfAlZ6HxI/DeT+2J5qoiiFnSkCpJOGVlJzYfJEdhqA/DL97uOkv7V20z2oVk4BSCmAQevcQmXUMwXUh+XF3D4Ag+3odheFeB4oIg7qFDPnn8MvVucQ/tZ5nkPjeLWXlUP7YZ9QtSGPYgW/M/rn7wHCsy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=dEcMB6k6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dEcMB6k6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C93C4CEC3;
	Sun,  1 Sep 2024 13:45:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dEcMB6k6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1725198344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1djzGstiFG+2xkRl5HcdY0oAwmtiFH3mmlRlw/iYevY=;
	b=dEcMB6k6RbvqLIYYVR9QVN6fHiz8IpCoCiovEl5b85nXB3QeZJpiN5WSe+oJU51pXNkdT0
	iY5DyZRMZLxfy8Vtc0bX3EsDI7NEYLLO2npnKuU2FKtvz87MR15ifTRPxhH1ELR+tZ2Smu
	9LsFgWmu2derznFzMvlBS2WpcgtpZos=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8ef1748e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 1 Sep 2024 13:45:44 +0000 (UTC)
Date: Sun, 1 Sep 2024 15:45:40 +0200
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
Message-ID: <ZtRwBGHNEVhE-Kf6@zx2c4.com>
References: <20240901061315.15693-1-xry111@xry111.site>
 <20240901061315.15693-2-xry111@xry111.site>
 <CAAhV-H4nE3s7e=ouh04VH=yY2iR+ofuEkv8p=2cChJi=jw=pMw@mail.gmail.com>
 <ZtRq22l9ZLIKP5cf@zx2c4.com>
 <ZtRuqESaAG8KMIsp@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZtRuqESaAG8KMIsp@zx2c4.com>

On Sun, Sep 01, 2024 at 03:39:52PM +0200, Jason A. Donenfeld wrote:
> > > Though in this file there are already comments beginning with /**, but
> > > it seems the kernel's code style suggests beginning with /*.
> > 
> > /** is for docbook comments.
> 
> I'll fix this commit up as follows:

Sorry, I was confused. Better:

From 6839d0a67e1c4d58980977d99d1b86b4649be4e7 Mon Sep 17 00:00:00 2001
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
 include/vdso/getrandom.h         | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

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
index 4cf02e678f5e..6ca4d6de9e46 100644
--- a/include/vdso/getrandom.h
+++ b/include/vdso/getrandom.h
@@ -56,4 +56,19 @@ struct vgetrandom_state {
  */
 extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key, u32 *counter, size_t nblocks);

+/**
+ * __vdso_getrandom - Architecture-specific vDSO implementation of getrandom() syscall.
+ * @buffer:		Passed to __cvdso_getrandom().
+ * @len:		Passed to __cvdso_getrandom().
+ * @flags:		Passed to __cvdso_getrandom().
+ * @opaque_state:	Passed to __cvdso_getrandom().
+ * @opaque_len:		Passed to __cvdso_getrandom();
+ *
+ * This function is implemented by making a single call to to __cvdso_getrandom(), whose
+ * documentation may be consulted for more information.
+ *
+ * Returns:	The return value of __cvdso_getrandom().
+ */
+extern ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
+
 #endif /* _VDSO_GETRANDOM_H */
--
2.46.0


