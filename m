Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EB01DC99C;
	Sat, 15 Mar 2025 12:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742042690; cv=none; b=GepCO/d9Ce5LVEopZR8YitZEIlHpM8YP04ZppprkNQ4piQKlZrngpvIB9pAoVYM+QibINZHCCjXU2u9LtvwvTDO+C/3gumyvuWVcJQll+UGpLQctYejvdJzyfCkFx3+Vb1RZgPtNjh27RDqQD+xeHQXZQa2Ykk9OzMR2nj+v/hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742042690; c=relaxed/simple;
	bh=0SyWWPxkh/jr9ygniD6Y/E/3DXl0dsxx5nKuuFbZfo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uU2SyEDZ9KyMGThXhGUSwT2pwNlzFaxpQTbSub1fkEksfV2FroYZA2w1c7uFWVsnCxO3+sTB7MXoAyn6EOag4VXCV4NBt0Dqj7+2vXCjPiaiXXqaTs65E/Imq5o6xpjz1ex+d8fLInLPdTcOVshCipUAQfPVGjBe7ZDIwpVUr80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Rk+XFRTR; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Rk+XFRTR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=dUljyzWF3S7XDnU134pGASgsA1nXAkm8pnayZWUc2RY=; b=Rk+XFRTRtt2HAGTZ
	UqSloHe9nqoGJw5W8yIMrPobYFw6/DhMkJnGHNC8gywxhBdu+7GvoR1mGGkdG0PSccet220W/DQbc
	RVTCIqM4z6qYuZ1EVbaaWM5jvhF5I1RHemzNepyx34KogqCdRtwI7FRvr0l95aE+lVyDcKVCgt38+
	f9kpqJJZh5b8gcglRSHvWPNidQLz2+XMuIHV1OwSyWYqEHlHUykdNWb4HuCP2SaQKilvP10WO+v5L
	ytZhPigM2v0NACDmQrNgy63EOKBNOm0NXFaUbJLo2/cOkxBBOXzB7y7Q0MnV4KIS8AwgfmjBye3Al
	aP5WumRMVgEP3MkvSA==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1ttQsX-0053bk-0F;
	Sat, 15 Mar 2025 12:44:37 +0000
Date: Sat, 15 Mar 2025 12:44:37 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dan.j.williams@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] async_xor: Remove unused 'async_xor_val'
Message-ID: <Z9V2NQ_QxXC63Sh8@gallifrey>
References: <20240929132148.44792-1-linux@treblig.org>
 <Z9VDGGEWIpcyfFK_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Z9VDGGEWIpcyfFK_@gondor.apana.org.au>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 12:44:28 up 310 days, 23:58,  1 user,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Sun, Sep 29, 2024 at 02:21:48PM +0100, linux@treblig.org wrote:
> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> > 
> > async_xor_val has been unused since commit
> > a7c224a820c3 ("md/raid5: convert to new xor compution interface")
> > 
> > Remove it.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> > ---
> >  crypto/async_tx/async_xor.c | 26 --------------------------
> >  include/linux/async_tx.h    |  5 -----
> >  2 files changed, 31 deletions(-)
> 
> Patch applied.  Thanks.

Thanks!

Dave

> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
