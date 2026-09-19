Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706463955CC
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 01:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789779721; cv=none; b=mI6p3j/rKjrS6FEIucHFfTKnVN+MPGj7cuzSrralY+llGHQMyZYtyJzQOXpOwXQ7Vwy7V1lJeF7NiI4S68bV6osK21GDEfiks5OVL8+TvPk6dTp/hx2YleYno6hYXjLeVrjo/8/ujQMICOX6/z9Olf1CNbnN16YbwC0iHPkJlHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789779721; c=relaxed/simple;
	bh=wP9CnpZUntYucp4xgYdLv11I25qT3eW6rVVbK6KrRzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GCejcCTXLfDajrpAh6kXoh0LggZWNCsvQVfhoY4TOH9Kg+zUTDshw996x4l07Bqg5LhQqze2mGRXkcQzqh4YUR+snlwrQoOU1+sMJhzCch5uT0uci+m7fN94ZmltE0Fsz9GH9guVmQ7oNJL5fZVjW+Pm5rCDoF0UERLYHOcXGWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WKOBruWs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WKOBruWs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DK/FER0BvYzs8cfrS9oZzO1VGwcGiSeZe/YTRF2fAuQ=; 
	b=WKOBruWst5rKfG2KsiuuP1isUuv8h9Mu5MQkUhN1JbyHDR9TWoyLwWsQJHYe48xqVBU7p5KEgRZ
	k7lEAhYSRvbQnQGw6YpdB0esQAoZe8aOOCU/bglG8aujKq9rOWap9CvZceNN6LEams/M1mgmQ5RH+
	i9bBXijnNhyVgagHmkrohVzHsX5QnZSTPwiPt67clIvDKk5r4KmPpN69l5iPfD39lHa8zdI55tgqH
	E1bdpb+NJfTHF7XkDGjgPHs1jIJs7eUGLr4ponj547mzqRHie7uRoSbQKhX5emd15Vl1FX8vYgvUz
	qcs6FY1Qqqj9kuNkrQfALrO5neWwIPMFPC1g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7jSf-0000000Fc52-3TfJ;
	Sat, 19 Sep 2026 09:01:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Sep 2026 11:01:49 +1000
Date: Sat, 19 Sep 2026 11:01:49 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?utf-8?B?2K3Zhtin2YYg2KfZhNmF2LfZitix2Yo=?= <ha2020anan@gmail.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: jitterentropy - add fast hardware jitter mixer
 extension
Message-ID: <aq3e_Qnxpt_HH8jg@gondor.apana.org.au>
References: <CANai08PJ9bKRn3JkgUP7SFHn+qXLoE_JDerRv-UtMkELZXu-wg@mail.gmail.com>
 <aq0JkKUIkWApYWb_@gondor.apana.org.au>
 <CANai08NMZTJpm1=4=09i-qzZyminPuwmv4yPn2Nu3etbqN4_8A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANai08NMZTJpm1=4=09i-qzZyminPuwmv4yPn2Nu3etbqN4_8A@mail.gmail.com>

On Fri, Sep 18, 2026 at 06:30:27PM +0300, حنان المطيري wrote:
>
> I have resolved the formatting and spacing constraints. Attached below
> is the clean, uncorrupted v2 patch file containing the fast hardware
> jitter mixer extension for the jitterentropy subsystem.

Sorry, but when you post a new patch you need to change the Subject
line, e.g., by changing v2 to v3.  Please read

	Documentation/process/submitting-patches.rst

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
