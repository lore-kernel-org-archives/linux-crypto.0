Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352D317DFF3;
	Fri, 30 Aug 2024 12:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725020689; cv=none; b=C4VCAAxtXQdWjgw5SR6sQWK/WiPn6tMHvQXhMfDmx5L+V8MXDSdBewn4/6OlwRno9C/FdGIlpohmzMn/RzWnjfZV8OsyikyJCHMNWZU+m9Vb/mBio6PXmhqJZFCma63H7vy73eE4oQJtnWp3M06ATWeK2E4kNA9/OQ434UHbBnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725020689; c=relaxed/simple;
	bh=arSSC7yrgoqYrVYvxrg/UwpXlN+Ck/ce6cg79PBX6YU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLnKFgnSVwmbpWGwKdVmkvAuaIB4Kleb4nrv+0fIatb0mLIWZyan+KKsc5HED6zB2PyvdB+J3tKxndGs6NdseVUs68p+eWFVkGvRFEXYfw4Mo4RP/Gf4oMjcYO1g9nMxa4TetLf2D5QlWo0t594IdUIi8QutT44hBuxIVZkv3as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=VBxOqaix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VBxOqaix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC588C4CEC2;
	Fri, 30 Aug 2024 12:24:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VBxOqaix"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1725020686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UaHyC375XagNncqUHXwoXPMDMG2IygUDT52s5SwIcCk=;
	b=VBxOqaixJOl1tWv7Xr4olCPsdH7oc259xNzqEy+uChGMmqKCVSmdgt3bl93xWd1CurA0X3
	WCO9ELBNoBheZERuWW6iOkmueeRL/8Mmbhq5GmtU83XWlLCl40JZiPHmmJc+jUbjE79u37
	iRmctuVXxEDGMBGZsLTEmJynnxhPWJ4=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9657f912 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 30 Aug 2024 12:24:45 +0000 (UTC)
Date: Fri, 30 Aug 2024 14:24:41 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	Jinyang He <hejinyang@loongson.cn>, Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
Message-ID: <ZtG6CYPF9hUHaAqZ@zx2c4.com>
References: <20240829125656.19017-1-xry111@xry111.site>
 <ZtB3RczHN00XDO52@zx2c4.com>
 <ZtB5pqfp0Lg6lzz6@zx2c4.com>
 <a3373ad5f92a4120bd0c8e0c751eb7617e035cf6.camel@xry111.site>
 <CAHmME9p+-0S-a3kjsv75irmLdGpW6rUWBVm87E4-Z9hpWyA7YA@mail.gmail.com>
 <57d648ed2143df2f5951f8e972cc4c3b2d40c46a.camel@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <57d648ed2143df2f5951f8e972cc4c3b2d40c46a.camel@xry111.site>

On Fri, Aug 30, 2024 at 05:05:38PM +0800, Xi Ruoyao wrote:
> On Thu, 2024-08-29 at 16:44 +0200, Jason A. Donenfeld wrote:
> > > So get_vdso_data() + VVAR_LOONGARCH_PAGES_START * PAGE_SIZE should have
> > > already "jumped over" the time-ns vdso data.
> > 
> > Oh good. Thanks for checking. So it sounds like there's just Huacai's
> > set of comments and we're good.
> 
> Both Huacai and I (we've discussed a little off the list) think it seems
> more natural to separate the implementation and the self test into two
> patches.  Do you think it's acceptable?  If not we can live with one
> consolidated patch though.

I'm not such a fan, as wiring up the test makes the whole thing more
"hermetic", but it also doesn't matter to me that much, so if you two
prefer that, that's fine with me and I'll commit it like that.
