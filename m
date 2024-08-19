Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9483215534B;
	Mon, 19 Aug 2024 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724072605; cv=none; b=QYT7JndCcAExGylSbePC694zMk9D7yLEFUsfjQQ0GxTe8c3/9/tG32kxmzl0X2+3vu7sLqu0gMSiY+R+H6CkigyXOk0L0jVUopC0J2jeSryEgT9QBSfjZXVx6F4fbcuApC6vU2jpmw1zL/0CtWfOqVh38S6+Pdj3Z8cxJVdd6AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724072605; c=relaxed/simple;
	bh=PjXrRZcb+FlH2Hb31dEg0qn9M0ysN5PSiPHLtd32xko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIlMfenkALkLbQraTNDRt3l7k1F8R2i1J2aKzi/w9j1EBKLzlWzmMmaaJXI8JWG1n13qlhNg+K+l+O9Ou7OWzmMScVIz72P25vKib3KiCYE7HOS9JWSl6gCK9hI7LufQoGp2mtd6g+SnvBRZFQWbZHEsEItYOaCyrni/meu/Xtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=H2QOu1jX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="H2QOu1jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475B7C32782;
	Mon, 19 Aug 2024 13:03:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="H2QOu1jX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724072602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=36Oua8ejF0JNSAOs6+JFPQVjTsJJP2Ju4Jneqj3yaik=;
	b=H2QOu1jXLwzX7iD1y+r17foiXy6nIplMI+IPLD5S7YnlXP4FLzC0svfNEQkRPqB4C8phbr
	Cp31UEEpxxdrFXhOKlRNw7JA5f/x4ca6YfulU41kCfBsE/3MCIvQ5yheE7LaP00JpZvIWw
	csmNbedGysHKeuC7FSM61hzxd3QIEvU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id acb6be41 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 19 Aug 2024 13:03:22 +0000 (UTC)
Date: Mon, 19 Aug 2024 13:03:17 +0000
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Xi Ruoyao <xry111@xry111.site>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 1/3] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
Message-ID: <ZsNClVFzfi3djXDz@zx2c4.com>
References: <20240816110717.10249-1-xry111@xry111.site>
 <20240816110717.10249-2-xry111@xry111.site>
 <CAAhV-H7TKg98QXtrv9UmzZd9O=pxERvzCsz83Y+m+kf0zbeCkA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhV-H7TKg98QXtrv9UmzZd9O=pxERvzCsz83Y+m+kf0zbeCkA@mail.gmail.com>

> > The compiler (GCC 14.2) calls memset() for initializing a "large" struct
> > in a cold path of the generic vDSO getrandom() code.  There seems no way
> > to prevent it from calling memset(), and it's a cold path so the
> > performance does not matter, so just provide a naive memset()
> > implementation for vDSO.
> Why x86 doesn't need to provide a naive memset()?

It looks like others are running into this when porting to ppc and
arm64, so I'll probably refactor the code to avoid needing it in the
first place. I'll chime in here when that's done.

Jason
