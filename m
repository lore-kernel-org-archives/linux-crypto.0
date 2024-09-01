Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E6514B08C;
	Sun,  1 Sep 2024 13:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725198768; cv=none; b=dLj1gYGYypuhZNsFtPyvnZOM1YJmYci/GMrLhi5GHXfV08J6lrWLbjbeZvEVrIQ19zia8SUw3bXr4wgjFInc4MSwVQy8DRWto/vKQzGb32aLn52BbRoralB+HoIHh6rDDSPImQ0/F7QSEIlzWx8j+j44dOwFKgZaIUWARAveFKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725198768; c=relaxed/simple;
	bh=0y9K93UXwjJsnbCt45ij1skIhcCJfrm/4S4x14vT7/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sd44b0CrX3ntXaJIpial/ZEYCUumj4s2MbHBVcd6aNo+3TBbOMpbJDpWxjLcHCxGmW7lIxQzPHaR9axk4mRLPkt1aObM0JKIVo3kG3eiICby7BjJ+gd0TSOgFvktA1B/wXhk6awLz1fI5q+YjXR7YjcoaQm+s/QWbyIhmECJP9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=GDHW4TeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GDHW4TeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE28C4CEC7;
	Sun,  1 Sep 2024 13:52:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GDHW4TeE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1725198765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=etCXFA7FgpS49ISdfZUHG9OzdfOQOU8I699EsHvxUFE=;
	b=GDHW4TeEXUUXCNXahhp2AvhU30mV3fDnpc9IoxrCMM6cDDAQ4B14kHCCUL1UlxlGBNfx3B
	vfxZk0pwVozNlbNpZFWXP3xIZcHE3WdF0ULKlLTqvl0m6z7XF7WXMCA2bG7wshisOVnd/S
	jxTwpMAhrbQLrcHHDkhmg2bpjMij94Y=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 410e3d40 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 1 Sep 2024 13:52:45 +0000 (UTC)
Date: Sun, 1 Sep 2024 15:52:42 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 2/3] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
Message-ID: <ZtRxqspL856yVgz9@zx2c4.com>
References: <20240901061315.15693-1-xry111@xry111.site>
 <20240901061315.15693-3-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240901061315.15693-3-xry111@xry111.site>

On Sun, Sep 01, 2024 at 02:13:11PM +0800, Xi Ruoyao wrote:
> Hook up the generic vDSO implementation to the LoongArch vDSO data page
> by providing the required __arch_chacha20_blocks_nostack,
> __arch_get_k_vdso_rng_data, and getrandom_syscall implementations.
 
Applied, thanks! Congrats on being the first implementation after x86 to
do this.

Jason
