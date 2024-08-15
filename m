Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E370C1A7067;
	Thu, 15 Aug 2024 14:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730681; cv=none; b=NVkWDo6kRhhg85Xep3Nmy5aut0+bpRkN3vCvIIeCXwPFN97eG8GuobC2BKRgkdAH1uuainMrCnCPkbg7hKth4PAeMbsppIUADOEvTH/+kl0k2YKuydIpSsgnX0HOWvkxpdEJ2F55Xr7QlkY6ArU/K1Q8+tpwWfW0PSB/FI8eyD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730681; c=relaxed/simple;
	bh=oI4Njtrz3f3cOr/Bq0juBxKf9F8C6k8Igyvr+X9RoUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYbTuy//GkxUy0oc76mzfdyMzYEr9xuKSrNpYHRAo2QMYbI9Hp6SOzFqbNBk0w0bT1mgLttMOOyKsK/AnlNTpLSwdytJ1pBSwraUvlbphY8uUuzRmXFU5cfrea2qKbWwGLlM3JRJLY+dZUfu8lbgMI9uKYsAuTZ0xJjMOpLHnDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=VbACV/S0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VbACV/S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8492C32786;
	Thu, 15 Aug 2024 14:04:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VbACV/S0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1723730677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oI4Njtrz3f3cOr/Bq0juBxKf9F8C6k8Igyvr+X9RoUg=;
	b=VbACV/S0dn0devzS7P/KCfw+Yc7httfWCbwSkx1M7ykaNm7OBxd9QdyCerLKREIEOBYjve
	X5qQmTN+wrpKE+FmlTQccnsrIjq5YbWsOfVERNWTluPAcnuSb4i2g5f6mJ4rvssy4vvpqf
	/PlhbNgqMEc5qJrLxRr6fWbXd5vXHas=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f60e08eb (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 15 Aug 2024 14:04:36 +0000 (UTC)
Date: Thu, 15 Aug 2024 14:04:31 +0000
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 0/2] LoongArch: Implement getrandom() in vDSO
Message-ID: <Zr4K77uPi3CMfE-S@zx2c4.com>
References: <20240815133357.35829-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240815133357.35829-1-xry111@xry111.site>

Hi Xi,

Thanks for posting this! That's very nice to see.

I'm currently traveling without my laptop (actually in Yunnan, China!),
so I'll be able to take a look at this for real starting the 26th, as
right now I'm just on my cellphone using lore+mutt.

One thing I wanted to ask, though, is - doesn't LoongArch have 32 8-byte
registers? Shouldn't that be enough to implement ChaCha without spilling
and without using LSX?

Jason
