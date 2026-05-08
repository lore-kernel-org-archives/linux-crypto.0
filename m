Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8868925A357;
	Fri,  8 May 2026 02:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778208678; cv=none; b=MsY89VQsDvQPCDM9TLeToR/H4LQw0ZeD32q5Q3orchz/drWrr0T+hN3XgWzRufKWoLjh+0bDY1WaenrWSSKyhaPC353rNTZBengzGmS5EQgNR2ndNut89TYOy2Tv7WVzFbN00m6pnrSW5p4QpXVw+W6L+SEp0JtTRjshtlFvNgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778208678; c=relaxed/simple;
	bh=gxhOubjutu2qe+ybX9CTsnHGgiAQmJApdp08in3zORQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKxEWtZNeZRGTCX+jKlSp7rnbR4Du5m4mWdLdQO7o9DEGT/UIEXXZIN1jHWtTQtA/88CLBpOI7z67YUznEuF4cD1xgOjq47ra7u7WK1i+8sEiKhjrfmr662WhALAugFAotgY9Y1+TuhvWVXsRqwyRQZHcOXBfoS0PK3iCKaoP00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Dmu+Z378; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Dmu+Z378"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=LyxaTfhQHkEjXWt/Y3rNuARMEz7W4m5Qml3h+IJzcDM=; 
	b=Dmu+Z3789Xx2rJ1QOF+gd0iW+agfw6Sde4tk0qE4Y65cSaQuUvz/BrjoV8Vm35Tnvry6jE5mWtM
	uv3VnoOlIhEI8uwqyoH/UIS42Asvb/RFhKqEda6r4LpRQOZDzER19+JP9EL6UpFXnehbyV1vctxIU
	mhYaGX4W74JzBXkXGqYWKRoI0mYCJ6+en3OKrzRa8hn7J8oSXSzdipgHrZd4IJQJhkrYTKKzFhlnF
	qU63KQuIFuag7/VGxh6HAKW9ETzUgfXQsyqZc5saMWTfUAzFxiRP+9FoxTtC24wdvmXmYZYkXpxqB
	pi0emhlgYSIRlRddPmfEIP02VBEQ0sIFgrPw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wLBJ1-00CHNP-2Z;
	Fri, 08 May 2026 10:51:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 May 2026 10:51:11 +0800
Date: Fri, 8 May 2026 10:51:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aaron Esau <aaron1esau@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: acomp - fix dst-folio branch setting src instead
 of dst in acomp_virt_to_sg
Message-ID: <af1Pn-IzTMu85dXH@gondor.apana.org.au>
References: <20260507233748.327004-1-aaron1esau@gmail.com>
 <af1K4d8cxGOvlJxY@gondor.apana.org.au>
 <CADucPGTSNG3m=v9HuyZ=qr_-Qycccc9jjKU5K7O3LrHdEXgRaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADucPGTSNG3m=v9HuyZ=qr_-Qycccc9jjKU5K7O3LrHdEXgRaA@mail.gmail.com>

On Thu, May 07, 2026 at 09:49:08PM -0500, Aaron Esau wrote:
> 
> The patch was generated against v6.15-rc6 (82f2b0b97). The buggy line
> is at crypto/acompress.c:240 in that tag, and the index hash
> f7a3fbe54 matched (I just checked again).
> 
> Could you double-check?

We're currently at v7.0 heading towards v7.1.  The bug that you're
reporting does not exist in v7.0.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
