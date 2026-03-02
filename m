Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A442F36C9DD;
	Mon,  2 Mar 2026 12:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454469; cv=none; b=UnIUsiKYs+XTgPOlBBKiK/J/rD1bPQEPvct3LGiukDZSDeAygeOkXEKeTxhnPQsjl8X780/+Um4UWyvb/DBR3OKmxDCpQW8i0eFiqWMo1lHt2IHqeYf5HVU28+3JtN/iWcvNJR/N/46weGMO6r/wA3JyMSA+zdyT/UHOoxuG2rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454469; c=relaxed/simple;
	bh=1ckF6QdQkyCk2xZqDdMsVw1xiETxNXFsBBEulVknFrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGurImul8iaAvyRXJVYcHKKcizGRxagywWD1+t3akHeCCxGL/DQzADqYKwqJ2o7bW5s9awEgdiA7X9aXq40IoL2Q4CJpSSjRtMR/BG3uC3Z9GjyLVrLjf+wYy6yYCgPlsKDawAM6c2B/W55XE0wa8gK5z6wyDlJ0ZVATVllMW74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aNDXOFMt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aNDXOFMt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=XNdAL0oi2itesvkRrR2aHWdmQUgtRHss82mYI7NB3+s=; 
	b=aNDXOFMtVxX7EEtMULIBEj8WRGHAKEHyIkTfvitD2ZbTRfpIhtF9kNOk5BRxWlWpWsRMHLx1UM+
	1ae/qxlbkh/x2j2Df+7hfq4dZ4Q2jYI8IGll7QQL3kWhNWFIoM2R+b3yqB93dDcqHH1bzfzVmr0k7
	eX2zP+rhYwOpXWx/zIccfJbc0H9NRrADQ1O11h3FEHA6xII/nsEfObUOEfYWKC1Yi/griTfNr22RB
	iooksmQyMgeED+X0X3XBrmLZu7yflkyQIk5TIBbotb8HbOqwEr0tj8DdzjlqBl1f8govH66Xnr5e+
	UuvmnR7R9wzHIMn2TlHA0MFqmVKxuOCuuNNw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vx2NA-00AlHc-36;
	Mon, 02 Mar 2026 20:27:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 02 Mar 2026 21:27:40 +0900
Date: Mon, 2 Mar 2026 21:27:40 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ethan Tidmore <ethantidmore06@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
	Tero Kristo <t-kristo@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sa2ul: add missing IS_ERR checks
Message-ID: <aaWCPBaiv1QZpZ6n@gondor.apana.org.au>
References: <20260216231609.38021-1-ethantidmore06@gmail.com>
 <aaJjsnV8rGLpxha_@gondor.apana.org.au>
 <DGRTCXXMP7OJ.ZETCDPV2WZN4@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DGRTCXXMP7OJ.ZETCDPV2WZN4@gmail.com>

On Sun, Mar 01, 2026 at 04:53:50PM -0600, Ethan Tidmore wrote:
>
> Since this is a callback I'm not sure how to propagate the error. Nor am
> I aware of the specific teardown required for this driver. I'll just
> drop this patch for now, hopefully I was able to draw your attention to
> this possible issue

You can pass the error up by giving it as the second argument to the
callback function.

In any case, thanks for reporting this bug.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
