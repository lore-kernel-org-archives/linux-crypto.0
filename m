Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BEE17C7C9;
	Fri, 20 Sep 2024 15:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726845072; cv=none; b=Au3kpZrD0fypGOr1iAL8kh7WHtB0YCoGtbOWMW7XLvxE+/5UgPirVFyJuKiGjjlO3xhWBsIkxP/SgbEh5OhWx+o3bAWU/nxdkmmeA7GdE5X3vf0yvXbijBhT4UCyqMZjeiHtho/bJoI5WP8vMCKrYynQ0a9yB22sxzjnDf5yrbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726845072; c=relaxed/simple;
	bh=LHIrL4+IOK7TTq6FT8QQMFr9RgfnqS9Hr5wbe/S6Epw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQVME6Ob7ZoqGnK0cfWsdkNOxIo5X0YysruvwwuZkV6lJUxPPHIHEGvpeMUanMO6V7Cw8+djMSqaJ6cTG7bn4pGOowpsgTe+7mFzC2Qw8+bqDYCN5wZJmvHtmacTxWtuwKE0FS3hDrPVDfdjKuf6/UWF+LgaBW5fZSrqTwuwNoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=A8Qs13nH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="A8Qs13nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A68C4CEC3;
	Fri, 20 Sep 2024 15:11:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="A8Qs13nH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726845068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/sgZZCfozFmaQM131uVRt5yID4XaoLqKTLeHDmO9BnM=;
	b=A8Qs13nHy5gGuOu7rsPLfBuYvzqkgOUO79+5OW9ZnrGY8ya/EZywhrSla32AH6zmPanvc9
	t3Jy+cXb5R+rxElnj19IFpADdrajDNayV8G2SlrIVPnjyT3krU8DF0aLM5ynKvKn3fGp8v
	8YOG77L+lXvC0My1wHfu3/PbDCO3Nbo=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 81ef0f0a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 20 Sep 2024 15:11:08 +0000 (UTC)
Date: Fri, 20 Sep 2024 17:11:05 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] LoongArch: vDSO: Tune the chacha20 implementation
Message-ID: <Zu2Qif3n7oIMweJ2@zx2c4.com>
References: <20240919091359.7023-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240919091359.7023-1-xry111@xry111.site>

On Thu, Sep 19, 2024 at 05:13:59PM +0800, Xi Ruoyao wrote:
> As Christophe pointed out, tuning the chacha20 implementation by
> scheduling the instructions like what GCC does can improve the
> performance.
> 
> The tuning does not introduce too much complexity (basically it's just
> reordering some instructions).  And the tuning does not hurt readibility
> too much: actually the tuned code looks even more similar to a
> textbook-style implementation based on 128-bit vectors.  So overall it's
> a good deal to me.
> 
> Tested with vdso_test_getchacha and benched with vdso_test_getrandom.
> On a LA664 the speedup is 5%, and I expect a larger speedup on LA[2-4]64
> with a lower issue rate.
> 
> Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Link: https://lore.kernel.org/all/77655d9e-fc05-4300-8f0d-7b2ad840d091@csgroup.eu/
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>

That seems like a reasonable optimization to me. I'll queue it up in
random.git and send it in my pull next week.

Thanks.

Jason
