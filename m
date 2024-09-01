Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8721E50B;
	Sun,  1 Sep 2024 13:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725198454; cv=none; b=qH8Aq6PlaqmAXkBae5LuCQ3OxeP5WAwsAgCGkdjbtHNjVdR0xhocd11Bp9JYgwSZAz9ltjo7NHVT+d/9b2rYBTrBDBT/4tQIZa+UNpbom/nz7N3ryX/qqNNDVODDGSUOIOPoACvsDvH/zjypfzFCsoLbNIatK0ZTy9em/oY6h2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725198454; c=relaxed/simple;
	bh=XamAJwkcE4RlQwZG6nJIRA/QZ8FcgfYqq2TZ5ANsWRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZqCRTaeFrBy3DVhr2F4D0k49ll880ZCFoq0NEKSBNQJrdBiGxjejnkmkhdi8ZVgtuLE6RL2JPeDpe4W+/K641iePGGPu8mMkzWY2PfChUu0mMsBclRm0C8cSq4Dk6nmlEkoXUQTdYRjOFBNBFzBNuDvGyichYENMW7wUBQK/c8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=pL79mIoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pL79mIoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3C8C4CEC3;
	Sun,  1 Sep 2024 13:47:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pL79mIoK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1725198450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XamAJwkcE4RlQwZG6nJIRA/QZ8FcgfYqq2TZ5ANsWRA=;
	b=pL79mIoKLVYmU426yTHH8G3MZvyjxlRHK0lCVmFrI2yBiATjKB3VZ/6VGdXtYuQzuBZ0l/
	Mr632K1eKf9rmHDiDz1dWKgsxCYlsUt1NM9uPYDa0E728KB995WlYOK2yN34dSwUQfafX2
	ec66ImvZHfoVRLezcopJ/21pa6MFlr8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2a9893d0 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 1 Sep 2024 13:47:30 +0000 (UTC)
Date: Sun, 1 Sep 2024 15:47:27 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 3/3] selftests/vDSO: Enable vdso getrandom tests for
 LoongArch
Message-ID: <ZtRwb7j1x9vtPea3@zx2c4.com>
References: <20240901061315.15693-1-xry111@xry111.site>
 <20240901061315.15693-4-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240901061315.15693-4-xry111@xry111.site>

On Sun, Sep 01, 2024 at 02:13:12PM +0800, Xi Ruoyao wrote:
> Create the symlink to the arch/loongarch/vdso directory, and correctly
> set the ARCH variable for LoongArch.

As this selftest stuff is currently in flux, and the latest rendition
means it's not necessary to fix up the ARCH variable and such, I'll just
fold this in with the actual implementation commit, because it's now
simpler than before, and may be fixed up yet again.
