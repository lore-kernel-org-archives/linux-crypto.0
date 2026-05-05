Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC35126F476;
	Tue,  5 May 2026 08:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777970447; cv=none; b=n7gnDsovhbHn9WRld05YBxT/8E0qssADw8Fh2i5YzgeSS/IzpiJonnB778F9NyM3iO8vdwdFdw318Xxo0hZ8YlpwFSvZpDmB2cSYmzGkFxiQeRuaGPzfDVmnoCXSlUUEEA2BhTzcc5DyJwP2IrB7BEo0Tyop6B8/SYfTLmFaNV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777970447; c=relaxed/simple;
	bh=eZjz8xthQWJgQ4IA/xATiPtzfeSEGqvYniFwztnXEMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ue7a5sGMczZc6hjBWjbz7ajcXXfv9ekO743MC87Z+F8lgJ+FQ8VmuIhJ075dYiQpKweZSwygfXICCb6CKHfI/STZzkcHJEvBpFaRFtCtH2wy9XpreQltsDy6/SXT61AM3KIJIUBXHlHj1DjKtmLsC2878hiGkmHBeyooDCial1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JXa4dr1c; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JXa4dr1c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=hSy739jVv7MhgYJMQpxnYMz+mhMg83aR/yDgNDI+2Lg=; 
	b=JXa4dr1cptQoCl3Yqm3gUn/5ARv7rTBkBzpjiIlV2p3Aijqvl2JmBRKY6WuZxpV195uMhl4g1Dh
	w9OYgTpukEXZi6o4+iozCRBrUchxVspb6T7mFJSc7U/QcDbdGqkJYoNRP/avBTSCcJwxuORvNvT85
	TIUwYfRsTovZV6OFtgpdNpzhtCrFBq4IGs0RFQCLAZup/HUiLVHynZC7FZTwHMoHFme8eDgZnPCXJ
	fNPhJit72rxc20FMgAytbFTGxjMLipQE4mu75WDrjSZrBoU0qjimRAQ32o5Ev6twReyTz5lgqsGfj
	mjeXivdnUGrFrYyTzCub+kbsTa8zN4v6GyIw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBKL-00BMwk-36;
	Tue, 05 May 2026 16:40:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 16:40:25 +0800
Date: Tue, 5 May 2026 16:40:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <afms-fn-mpwJPfa-@gondor.apana.org.au>
References: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>

On Wed, Apr 08, 2026 at 08:15:49AM +0200, Lukas Wunner wrote:
> Andrew reports the following build breakage of arm allmodconfig,
> reproducible with gcc 14.2.0 and 15.2.0:
> 
>   crypto/ecc.c: In function 'ecc_point_mult':
>   crypto/ecc.c:1380:1: error: the frame size of 1360 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]
> 
> gcc excessively inlines functions called by ecc_point_mult() (without
> there being any explicit inline declarations) and doesn't seem smart
> enough to stay below CONFIG_FRAME_WARN.
> 
> clang does not exhibit the issue.
> 
> The issue only occurs with CONFIG_KASAN_STACK=y because it enlarges the
> frame size.  This has been a controversial topic a couple of times:
> 
> https://lore.kernel.org/r/CAK8P3a3_Tdc-XVPXrJ69j3S9048uzmVJGrNcvi0T6yr6OrHkPw@mail.gmail.com/
> 
> Prevent gcc from going overboard with inlining to unbreak the build.
> The maximum inline limit to avoid the error is 101.  Use 100 to get a
> nice round number per Andrew's preference.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org> # off-list
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  crypto/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
