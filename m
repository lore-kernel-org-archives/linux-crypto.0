Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09B21C4605;
	Tue, 27 Aug 2024 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724767261; cv=none; b=flIRDVQ99AMU2elzhQbpVlMMg7Z3PRKkpzwYs2raYPKBKeB18KNF+vhPyGhP58LmQG49mEgYhqiq5dyGZ4mNUh+b1s/GTLlpY8ffadX9neyJDN0atizO9Dsf0DtQkJMl043TgGP8vBNNCz/kRtg6NUtjb7LxVeq0tC+ZQH+Aj5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724767261; c=relaxed/simple;
	bh=JvyalLSIkokyACh1R/ou2ejO2zgHFp5NoP78kaK6Kc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PL2q5p0fqO9KDOJn7By9eO0IAh/vRUL7vqOb91U4mpkN3gktYiqNj6qJsV/DalK1B19vDd19/bKFiDCupNfsUTbOm6DYzs0JHeFo4lwXLXP5JgEQRdIs41mAyPOYgXJSBvv2Z93dbWmBtfd26plppN60+y0KPTT/Sxwxk5dH5Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=PoYda3z0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PoYda3z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE75EC61041;
	Tue, 27 Aug 2024 14:00:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PoYda3z0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724767258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JvyalLSIkokyACh1R/ou2ejO2zgHFp5NoP78kaK6Kc0=;
	b=PoYda3z0eXzivv+nAGV/jfx64y4k9gasRbO07wevJlR/7cWW6cllQexHbbcKnV9W+X7h4w
	mmkeevFFZxBTbJdKH0CeneXu043D9EGTbnHXTAKZrHD3TKM7lztuQNk1TyOmqaVLlKxZzd
	s0Y7f9kSF77ldZTiiiS/PIOtfVbqYR0=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b2179eb6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 27 Aug 2024 14:00:58 +0000 (UTC)
Date: Tue, 27 Aug 2024 16:00:52 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 4/4] selftests/vDSO: Enable vdso getrandom tests for
 LoongArch
Message-ID: <Zs3cFJ9qvPrFt_FK@zx2c4.com>
References: <20240827132018.88854-1-xry111@xry111.site>
 <20240827132018.88854-5-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240827132018.88854-5-xry111@xry111.site>

On Tue, Aug 27, 2024 at 09:20:17PM +0800, Xi Ruoyao wrote:
> Create the symlink to the LoongArch vdso directory, and correct set ARCH
> for LoongArch.

FYI, I think you can squash this into your 1/4 commit. Ideally this
whole series reduces down to 1 commit, once I take the two general bug
fixups you're finding.
