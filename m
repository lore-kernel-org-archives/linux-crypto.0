Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAD013FD84;
	Mon, 26 Aug 2024 08:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724662466; cv=none; b=VHeiEQ/YjCNHri2e/zljacQrlXrXzZgsi91HberUlugVCQ5AqHbEsvv/bqElRZ8WBR1YwDGwoeo9QMGFXCpVEV68T5USJEsHaaFt0ZaqH2uJb9Z/yY6cqhwrOEBq0qlmNEGJaTKb/svkXeI2Y9PBKI3ivkwe7MDRIzVJ6M13YMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724662466; c=relaxed/simple;
	bh=rR9SM/nBlqlqKsdKY9O/8t2YAXbtoNLDK4wyVeQBQ74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WGLE/87PDv/tiMjb+HIcvp+vP+JUYMRQhIBrBWCoE77O27iDpUvscLE4XgTaxNCYyt6EYGzw+CKWGbdnkOSLfi4y2jb8dq4nULH+YKDaZJ016z1D5TY8PnGO4WoBf6Wj0HD5L3ElccDBn4RRpIyAIVJMwTRRHPEwZGkrHf82NV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=jGFPOdTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jGFPOdTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C4AC4E696;
	Mon, 26 Aug 2024 08:54:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jGFPOdTQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724662464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AF81dAGwjtoyy9T08zoVHtx/QpSDpioe8XEVyMBlDxI=;
	b=jGFPOdTQ2tKl1v/SItPmVwABTErg9P4ahKTWxhM0XGcy4WilGBSWg5cAP59fRtVjqNpCn2
	2i20abVs1gPQNp4B3Bu0dPCCTC+UBg7sI+zL1CchuLcBxlVEG24LniL4piECyrEmjVI9Sl
	w9M+CbiYG5OpW0jSs2eeL0jDzR5CL5M=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4ea437a1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 26 Aug 2024 08:54:23 +0000 (UTC)
Date: Mon, 26 Aug 2024 10:54:18 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 0/2] LoongArch: Implement getrandom() in vDSO
Message-ID: <ZsxCuvkJLDrS1qX1@zx2c4.com>
References: <20240815133357.35829-1-xry111@xry111.site>
 <Zr4K77uPi3CMfE-S@zx2c4.com>
 <b39ba1dea300c905f377af4cf3702ce4226cabc7.camel@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b39ba1dea300c905f377af4cf3702ce4226cabc7.camel@xry111.site>

On Mon, Aug 26, 2024 at 02:32:05PM +0800, Xi Ruoyao wrote:
> On Thu, 2024-08-15 at 14:04 +0000, Jason A. Donenfeld wrote:
> > Thanks for posting this! That's very nice to see.
> > 
> > I'm currently traveling without my laptop (actually in Yunnan, China!),
> > so I'll be able to take a look at this for real starting the 26th, as
> > right now I'm just on my cellphone using lore+mutt.
> 
> Hi Jason,
> 
> When you start the reviewing I guess you can check out the powerpc
> implementation first and add me into the Cc of your reply.  There seems
> something useful to me in the powerpc implementation (avoiding memset,
> adding __arch_get_k_vdso_data so I wouldn't need the inline asm trick
> for the _vdso_rng_data symbol, and the selftest support).

Indeed, I just committed a bit of those fixups to the random.git tree,
if you want to base your work on that for the time being:

   https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/log/
