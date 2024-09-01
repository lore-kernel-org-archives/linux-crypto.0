Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098D26AC1;
	Sun,  1 Sep 2024 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725214418; cv=none; b=rbQo6P4xxc187xhVtxT0Usygq0nCLmvVZp/Gt7a2XNhsHP7WdKcgicQLrLkXDCCSl3i/g48IItekto09NU2yc9tFmbid6NjcZx3uPUUnQX+aeL6Qnw7Zw8kf4zpm/TLEtwOyVwmBww4+DRScmRCWm37fy/eeW3inzmWb8UeolDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725214418; c=relaxed/simple;
	bh=8bFsb/Kg+oKrN7UPejG3VG1h9YhkGnd8f8e2upPerx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueQS/RiJXXYFJFGmO2FVWo0HfvICWc8c+SaWFSF5dK5iRbpEtEImpxsM0udxVoGa7mDtVNzxj00G72WNExkrIkdVnhUEwF49HnI8TuA39DofXDE8p6KD85s7NRpGZMyjMW8Xx9c/wCRSf8S4fnXRXtB2yy9DEVBgmBFBx1NObr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=TK9HU+Y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TK9HU+Y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F78DC4CEC3;
	Sun,  1 Sep 2024 18:13:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TK9HU+Y7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1725214414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P0Sidj1H8Qcz0CWMMwkZtDT18vLKpbapMI5RCkKFcJk=;
	b=TK9HU+Y7uKrl6RxHL6q4YqAZ6a0U1IPtNMvVGGlfv1QDDw5Fl4zl5+lEZjZ6ptVEFnmSwS
	KpK6Ax2FjEenUNMJv9E+S+lc/1QdVy17JhL0Xp+IwP8PNFFdPZhyBn7dkHLbaL6ncTCDcQ
	SZIAVAQcUQQFyYEz0+mfHtVTcHbvYjs=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id df977e1e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 1 Sep 2024 18:13:34 +0000 (UTC)
Date: Sun, 1 Sep 2024 20:13:31 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Xi Ruoyao <xry111@xry111.site>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 1/3] arch: vDSO: Add a __vdso_getrandom prototype for
 all architectures
Message-ID: <ZtSuywuMyYw316HL@zx2c4.com>
References: <20240901061315.15693-1-xry111@xry111.site>
 <20240901061315.15693-2-xry111@xry111.site>
 <88982e01-9d69-4ac6-a423-ecfe700abc1b@csgroup.eu>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88982e01-9d69-4ac6-a423-ecfe700abc1b@csgroup.eu>

On Sun, Sep 01, 2024 at 08:06:51PM +0200, Christophe Leroy wrote:
> 
> 
> Le 01/09/2024 à 08:13, Xi Ruoyao a écrit :
> > Without a prototype, we'll have to add a prototype for each architecture
> > implementing vDSO getrandom.  As most architectures will likely have the
> > vDSO getrandom implemented in a near future, and we'd like to keep the
> > declarations compatible everywhere (to ease the Glibc work), we should
> > really just have one copy of the prototype.
> 
> It is a good idea but it have to handle all architectures, not only half 
> of them. If you look into vdso_config.h in selftests, you can see that 
> there are two names:
> 
> __kernel_getrandom is used on arm64, powerpc, s390,
> 
> __vdso_getrandom is used on arm, mips, sparc, x86, riscv, loongarch

I thought about this too, but actually it looks like the __vdso_* ones
are already being handled this way, while the __kernel_* ones have their
own special thing going on. See include/vdso/gettime.h. So this patch
makes __vdso_getrandom() just like the other ones in gettime.h, which is
fine with me.
