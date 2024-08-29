Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAE1193077;
	Thu, 29 Aug 2024 13:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724936750; cv=none; b=Re09j/5Ppz4fx3dm/L5E2A/tBtfhr/OFB6w0uQOKZPkkRugM8w2ycJL+cndE3aLlYFGtraZiCVL5RxZ29mdwo6wDugLP06JKDz4p1R2qk6jDTR4SrQbH8yN+LwiiRz53xk2bJRZ1c3syj++5CczCbyT0EFgvsZI6L+iYaMW9VfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724936750; c=relaxed/simple;
	bh=AbSBCcQESNZ01X9cJly73vYG37Uf90FCB8dLFUAoilw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IZQuBJYCiAzSOb2UETXs8SUXAj3GSMN4im5LMP04eMmt6lCsavm5TIOrHANyVxpcXU+bKzFINxSVl7nNny4KxlOh5ajErdiBNhYqhekg0dlLB7utr9D7qJlGw8b8J7xx7h8+wRqT++tZhwXuAolC/b6PuvhdDityNKruvjloHv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=CeaSpp3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="CeaSpp3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB79C4CEC1;
	Thu, 29 Aug 2024 13:05:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="CeaSpp3z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724936746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GEBN9RGX4gVYaxQyDKMgArd+XSmyXIBDljl8TMdKAs4=;
	b=CeaSpp3zI+KSDTIA5bVaLT5Gxodjx0BrDG6ls+4m79dHAiARP+ER7wjewC2JhkrWs7Fp4N
	XgK/2uypukdW2N4pnfl+RL742y7XQzoKdsoJaJJMamZtFQO3Oj7LfAS/JB75AI6TExoET/
	RUjPQZc/BmcDlJmtnVrnQTYPluYQ48I=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7d924092 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 29 Aug 2024 13:05:44 +0000 (UTC)
Date: Thu, 29 Aug 2024 15:05:37 +0200
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
Message-ID: <ZtByIdPicun5PqDO@zx2c4.com>
References: <20240829125656.19017-1-xry111@xry111.site>
 <5fc8fc031c338f438fcd4aa5eaeb26b60d869405.camel@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5fc8fc031c338f438fcd4aa5eaeb26b60d869405.camel@xry111.site>

On Thu, Aug 29, 2024 at 09:01:05PM +0800, Xi Ruoyao wrote:
> On Thu, 2024-08-29 at 20:56 +0800, Xi Ruoyao wrote:
> > diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
> 
> Oops stupid I.  Please remove this hunk applying the patch.
> 
> I'll remove this in v6 if needed.

While we're on the topic of herps and derps,

> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---
> 
> Cc: linux-crypto@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Cc: Jinyang He <hejinyang@loongson.cn>
> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>

Typically all of the Cc tags go before your Signed-off-by and enter the
git history of the commit. "Here's who received this letter" sort of
documentation. (But not a big deal and something I can fix up upon
commit, of course.)
