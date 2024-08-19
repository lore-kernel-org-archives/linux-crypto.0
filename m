Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994BC1E4AB;
	Mon, 19 Aug 2024 13:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724072518; cv=none; b=cqzj18c7NO5+u0t33iAlBvGlTwaNSsS8MkfY1mOKZEH9kgwUxO/frdElKJct0TEoYNDEKHAjmQk5Ef+MfIZBH+SuH6Z1rzPs3p12R6CEDBmYr5kNqIZlu8C5X/Sx7RtCdGnK0h64J6DhN8Q6UMB8xWz8D1veXMviZXLhlvbcXZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724072518; c=relaxed/simple;
	bh=o8xZW8wTLYW7JRYcDtoiBbEO/tSJ7QYm/0dAP+l8DZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUKKgiG50t1SV3k14VlhHjSjRh+M9xslFOa54wqcghYWmZrA7cTKYBssaMdlQ7r7Dh7Idtu8awt8E0knf3kwkk/xhnqwI/g2clXXSAg3H9ulPk/TH70bT5Q5dRziax92c/Hy7TO8vRDqyJ4yPKESyrdQvW3gogmZd4wPFWQZ5Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=arNa1j+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="arNa1j+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3616DC4AF09;
	Mon, 19 Aug 2024 13:01:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="arNa1j+r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724072514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o8xZW8wTLYW7JRYcDtoiBbEO/tSJ7QYm/0dAP+l8DZE=;
	b=arNa1j+rInvSnH4yEzfxRUVZF7oKNQpg+gNY689yQ+1jFuW5EJMLce3HMWIaJocOxSW60n
	d0Y/6LkoMXqT7IQ/8YZ+LhyK20MqU4hcgwWpoKIdqOaPyLKrVdM4IqQK5Rj5S6RTZvl8tW
	G8ZNdhO+9tOQGD31XzQFJT9zzXxi9Xg=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5a096ca8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 19 Aug 2024 13:01:54 +0000 (UTC)
Date: Mon, 19 Aug 2024 13:01:48 +0000
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Xi Ruoyao <xry111@xry111.site>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: 
Message-ID: <ZsNCPKo9XZG52Yph@zx2c4.com>
References: <20240816110717.10249-1-xry111@xry111.site>
 <CAAhV-H5a42p6AAda=ncqCdmpHyc_tpXHjDVHq_F1pPZumfGeLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhV-H5a42p6AAda=ncqCdmpHyc_tpXHjDVHq_F1pPZumfGeLw@mail.gmail.com>

> I don't see significant improvements about LSX here, so I prefer to
> just use the generic version to avoid complexity (I remember Linus
> said the whole of __vdso_getrandom is not very useful).

I'm inclined to feel the same way, at least for now. Let's just go with
one implementation -- the generic one -- and then we can see if
optimization really makes sense later. I suspect the large speedup we're
already getting from being in the vDSO is already sufficient for
purposes.

Regards,
Jason
