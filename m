Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0981C0DC2;
	Tue, 27 Aug 2024 13:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724766726; cv=none; b=ZbCWHo50M3Z3Vpwp8ZsSDpjgJ7+daHaHhtwydBedLyKkybeMQoDU+NmnIa4SDnBlLv6l9SNg59g9LnsNtCQ66Htc2IbxVoljkNjIDMTc/yp+4KhlmM7q8fKO2XGsZafXC3KVx4VsxQLebl8cFnFR79F6RnzsXIswjmSl2whMM5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724766726; c=relaxed/simple;
	bh=cpftRq1MGxM6pWfMg4n4/OrCF1wmoUSMMKpPRxhC87Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxmMwv5c+0pUdqfALHYt0eeY+ws9DNL05hHm+ru9UmRt/SF2XjFvEbSrwf5NqZ8KTnjWyZ+y1hhrwGKO8QhV0HlsLNqdZ6XgKxTppa3aBSf+gjTQc3OGeWB3mHezZKyW/xy8D4PH0og15xr3KbmlfTczVv6IBXTtxbq/0BJyjLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=bfJZRloH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bfJZRloH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6170C4FF03;
	Tue, 27 Aug 2024 13:52:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bfJZRloH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724766722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cpftRq1MGxM6pWfMg4n4/OrCF1wmoUSMMKpPRxhC87Y=;
	b=bfJZRloHItMTjYUqzycVFvQI8q8Ltvw6qXJ2xC8puUH61HoMkC9AHDIXzYY8MUj+XNPfeS
	Nu/gXUNnZ70Ahvs4PDFCBOS19wT5OFvaGgNRYo69K6nuCXWoFgXuwUkETzNkiwXiI4h8OK
	OTCO79Rad+GeYMTmhlWmaaAlnmhwHeU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 11066c2d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 27 Aug 2024 13:52:02 +0000 (UTC)
Date: Tue, 27 Aug 2024 15:51:56 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>,
	tglx@linutronix.de
Subject: Re: [PATCH v4 0/4] LoongArch: Implement getrandom() in vDSO
Message-ID: <Zs3Z_OrAHCL2Nv-T@zx2c4.com>
References: <20240827132018.88854-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240827132018.88854-1-xry111@xry111.site>

On Tue, Aug 27, 2024 at 09:20:13PM +0800, Xi Ruoyao wrote:
> Cc: linux-crypto@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: Jinyang He <hejinyang@loongson.cn>
> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
> Cc: Arnd Bergmann <arnd@arndb.de>

BTW, you might also want to CC future versions of this to
tglx@linutronix.de.
