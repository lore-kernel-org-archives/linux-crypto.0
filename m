Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14C119308A;
	Mon, 23 Sep 2024 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727095700; cv=none; b=M7NlFkoRnQYl8uThvzKCfUrGhkuc5x53BUjO+ABLPjqcE+eIjk46bKolPs0QAMJ6o0Zw1xy6AcFi/B6eaCAKbPScmn7KpVn88YqR8TbL2EkS0mAvDhS5mhM2n9g8Bz0UUUYeoC1plTyqisrtlrNKM3Z3unSwKXZcs+7QfMErtPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727095700; c=relaxed/simple;
	bh=WuStnSNKwvQZgEPx7G0FIjblHsWPHjNTi5mS6OkIrFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZtnpI0qs3qLyJEhIkQl/ivI9fC5uPLD3cLWYtfoxjbueKrbh8rnBrbWh9brAJff9za9+kDDlA5+AG4h0nIRzPGkc+QcF5SWuQky6Uoopl/qOTzRNxARTPSab2IGS6aa+4IYhUmCEjvBxcOklur0cu4KV//ePTUFId6Qn7Ee1jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=SPD7zqub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SPD7zqub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8CBC4CEC4;
	Mon, 23 Sep 2024 12:48:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SPD7zqub"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1727095695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qpvkt7qOaEtJ8Zm5fTtyShRLRVDg7RGKt8Rc8mLONhQ=;
	b=SPD7zqubemn3aYcla4InoPy0A2IspA+u2NMGKac/xVY6RWKvd/uvOT0wnqAUn42EAWolUI
	nww9kJecwrEOIU5xh1EMIZkUajmc+Zk6lvYTg0wXTIMASoDp7Z1VvW7pJTGwtcKhlQ+G0B
	0EW4j81PN9nVkisbBEydSmoPSdA1f2I=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3a25d15c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 23 Sep 2024 12:48:14 +0000 (UTC)
Date: Mon, 23 Sep 2024 14:48:11 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] LoongArch: vDSO: Tune the chacha20 implementation
Message-ID: <ZvFji_xpV0tWxZIn@zx2c4.com>
References: <20240919091359.7023-1-xry111@xry111.site>
 <CAAhV-H68HOsX4=yZAmnCMW0VWf5SsqEckcHJQytSzjK8dHHW6g@mail.gmail.com>
 <b9bc6db245775b0a2e990467f414071e82b06a29.camel@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9bc6db245775b0a2e990467f414071e82b06a29.camel@xry111.site>

On Mon, Sep 23, 2024 at 04:06:41PM +0800, Xi Ruoyao wrote:
> On Mon, 2024-09-23 at 15:15 +0800, Huacai Chen wrote:
> > > +#define line3          state12, state13, state14, state15
> > > +
> > > +#define        line1_perm      state5, state6, state7, state4
> > > +#define        line2_perm      state10, state11, state8, state9
> > > +#define        line3_perm      state15, state12, state13, state14
> > > +
> > > +#define        copy            copy0, copy1, copy2, copy3
> > The indentation here is strange, it seems some of them are spaces and
> > some of them are tabs.
> 
> Oops indeed.  The tabs after "#define" should be a space instead.
> 
> Jason: can you edit it for me or do you want a new revision of the patch

I've fixed it in tree.

Jason
