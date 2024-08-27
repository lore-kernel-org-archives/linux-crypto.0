Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23041E520;
	Tue, 27 Aug 2024 14:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769061; cv=none; b=OdZiVB5nEIlCkszolCY9mD5upiKL+APTrBigc+VoAXKFwSaF+CUFnuaJkUR96D5XFQOG3X14/mlVoAbXENcZuYx00h+p35dgw9vPhqmW6rHUDtMa0HGfT6lkGLis7M4Nh4BMjxW+8ZJKpNVUYU/0IwXCcEautishdtprDU1HXA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769061; c=relaxed/simple;
	bh=I/g4Mgsnqu0wOZhORD+sLLYWz00xbECb0lXOYoALqc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r1l7gm/rVUEhjGDgevJFyJiWUff4KejgTqnOg1xoxt18h3G4P4BxG8wCEIUbUOVPj5Sgvkneh9oGf4sjFbI75wXmRZxGYmfJbtkKXcNd/cYaTFa+Q2eFh8wzc9c3sXZmdmWcDQxLEZmrTNbgK0c5ryE7eeejiaexeCOnoy2K9ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=DVBFZT7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DVBFZT7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991A7C4AF1C;
	Tue, 27 Aug 2024 14:30:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DVBFZT7F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724769058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lHEV/tYg5CgsRIEkox+e5xHFtM7hGGs4lfdCumcD7W4=;
	b=DVBFZT7FmogJh/83PD5AwPyfYVBDvj/+HRn4tZJ8r+W3BY/Kw7d1RB+oA8739w39tKppEe
	6kctRkGme40/JKchGzItYECwjnH6DItd9ZWSlA40CGTAdUMUvBAf3MLgdbICgf8qCs0+Aw
	DBCGUZMgEytcZfqRodpIL7rxTADpLM0=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 55bdd37f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 27 Aug 2024 14:30:58 +0000 (UTC)
Date: Tue, 27 Aug 2024 16:30:52 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 1/4] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
Message-ID: <Zs3jHMxpR_jUFg9o@zx2c4.com>
References: <20240827132018.88854-1-xry111@xry111.site>
 <20240827132018.88854-2-xry111@xry111.site>
 <Zs3ZWm-218Cb_ir0@zx2c4.com>
 <f404ae352a8cba3e035c9d5a10b553fb4497bb02.camel@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f404ae352a8cba3e035c9d5a10b553fb4497bb02.camel@xry111.site>

On Tue, Aug 27, 2024 at 10:26:53PM +0800, Xi Ruoyao wrote:
> > And then use addi.w here with the integer literals instead?
> 
> LoongArch addi.w can only handle 12-bit signed immediate values (such a
> limitation is very common in RISC machines).  On my processor I can
> avoid using a register to materialize the constant with addu16i.d +
> addu12i.w + addi.w.  But there would be 3 instructions, and addu12i.w is
> a part of the Loongson Binary Translation extension which is not
> available on some processors.  Also LBT isn't intended for general use,
> so most LBT instructions have a lower throughput than the basic
> instructions.

Very interesting, thanks for the explanation.

Jason
