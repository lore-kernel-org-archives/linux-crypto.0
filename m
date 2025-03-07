Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FBE1F94C
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 03:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741316697; cv=none; b=ljTL6aXi/lf9IJq71sF4XC6xmCvDIExZFGNe7ZPnTx/l78otzdE5FjFu5Q+fizxwTHk0sTms4o7+e3SZg0DPcNLOyieBqO69uumlU04R4PHMLKbPpJI0ncO+cLSGu8PXIxUfVOVLlZsW+JpiNGI2mlRiLKmgggHUHsQhy1IrxK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741316697; c=relaxed/simple;
	bh=vxVBlmIfQUhQC8V2ezyuCk06Lje/Q8Nx53IgVLzZlkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EL0fpODoUym7i0umoNS2aQ4D/LiRG6iFPBemymfJi1bdZ5GJJqH3nP6sjEQz0l841a47N2j+C5Seagaut8cp2FeHCon7TzuZiNKOGmZ3RBVwEJfy5D05DRSP2svPGaqOHG0NIp2uPRw8eVxeIV4Jgm+1AVpLefibF1mP0H1yucs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Q9QkXarl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Q9QkXarl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=L/H0+n14T3y48lvuyS9qixXyVf8pdohivRtADTP+dls=; b=Q9QkXarlL4WbnrmLfnyuZxvm0a
	l0MeF4YUaI9HB3vkyRAlkTT2cFtWJEBpwkLMlkhHwvgSP3Fn+yneOSYBYlboNwmcnf6RFTzalUGj8
	AVAEjidnWCrBnhGM6ZXRX0PbI+oNtNLLCimINq+r8qzeg1RuMbOPsmbJvumANLffPVvYeNovYg7Oa
	th2jS0W1dUpzMwkvcrFQQnixFiXcUR44Fo8EApysaEZmnSAnOlHlydJJXDpHWDPc8u4xO0xI3o426
	bK/Q0b1QWsrgEjxq+C5p02kjJhgXEY+oY2X7aibDhnhdxydpSqkj/t2NV3mNiJy4tE2tLr1cf3FO8
	8ZwWpXFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqO15-004UEO-2G;
	Fri, 07 Mar 2025 11:04:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Mar 2025 11:04:51 +0800
Date: Fri, 7 Mar 2025 11:04:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: skcipher - Elinimate duplicate virt.addr field
Message-ID: <Z8piU4Sy3ErUlXPP@gondor.apana.org.au>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
 <20250306031005.GB1592@sol.localdomain>
 <Z8kT90qXaTo15271@gondor.apana.org.au>
 <20250306033658.GD1592@sol.localdomain>
 <Z8kZL2WlWX-KhkqR@gondor.apana.org.au>
 <20250306035937.GA1153@sol.localdomain>
 <Z8k7ttZ7PwjBC-AS@gondor.apana.org.au>
 <20250306172942.GF1796@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306172942.GF1796@sol.localdomain>

On Thu, Mar 06, 2025 at 09:29:42AM -0800, Eric Biggers wrote:
>
> Those unions are ugly, but I guess this is good enough.  Please also delete the
> /* XXX */ comments, fix the typo in the title, and resend this as a real patch.

I'm going to keep the XXX comments, which is more about the fact
that we're mixing skcipher_map/unmap with skcipher_next and
skcipher_done_src/dst.

But I will add a new comment to skcipher_walk to make the virt
fields the official way of accessing the pointer.  That way the
user is guaranteed to not change it from under us.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
