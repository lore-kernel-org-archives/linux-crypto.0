Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6CA23E358;
	Fri,  6 Feb 2026 11:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375681; cv=none; b=idYrL+wEr69enb5Z5IYfkKKEPoDF/DXYvDlwOVDay4KEcKoYiEDyKiHKq1R8cGhwn3DlczBoAoMrAClLycIWuhbV1mlO7Yu7FY6g/W8bXTxZjsOig84FmZ3IG8//eyEwXTX/GeFH+9+qzLeENN2pjl/NXVNdKGWLIjfgFY8Y7uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375681; c=relaxed/simple;
	bh=P76IjNaCAtqrZdLbWeIPLog0YrdDchYEbR2qitTbmvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIdACmuVeBMQwGJl52nvgSrzLAasrZyO+dS4rIfjXAJPvmMxWjLB2/RwW11Nm/e3Je5lSlNqyGi71qmvZhPQOsT4EZmKEF24z+8EQkkmoaVEFjxSPbwzraRaeEMZFEedu0GQvkDJsy3tw10nFMXN6MPL1ishA1XBQ7Ms0FeD09o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jqVDy2tT; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jqVDy2tT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4c3wICExOaH2Qt5JnJegplIbDc0MsM1CljlE6J+r8PY=; 
	b=jqVDy2tTt/L2dqEpGRX9IreiRGhX8cW99zGcfbR5MLM8r84MeVt+a8y1PH5jl3NkkPaxwazerf6
	4ogZZlZ4Fa61HmMLkDpRgPpq48ZbLHFfQQfONYNzNfxICt+rwwmf09LM8XMd0+hgR0C+/di5BG72F
	bYelFn8WdY8LWdjitgDI33lx0PyYt3YyK8NAWw0QTDsIVqImZLGEVPXzORbLVYqn6kcbviefPLX4f
	69d9LhzojpqOLGH2CiIricwZcuB8A97P4XFU+8Mq+8j6VugHcb5BxnVsktdmmls0pchWItujFRBzf
	27G0Y0okM/C1pF9HyOSViQbY2nQPj9mEEmUg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJaB-004zWi-2U;
	Fri, 06 Feb 2026 19:01:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 19:01:03 +0800
Date: Fri, 6 Feb 2026 19:01:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: testmgr - Add test vectors for
 authenc(hmac(sha384),cbc(aes))
Message-ID: <aYXJ75641iRjG4MP@gondor.apana.org.au>
References: <20260131173902.3487-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260131173902.3487-1-olek2@wp.pl>

On Sat, Jan 31, 2026 at 06:38:47PM +0100, Aleksander Jan Bajkowski wrote:
> Test vectors were generated starting from existing CBC(AES) test vectors
> (RFC3602, NIST SP800-38A) and adding HMAC(SHA384) computed with Python
> script. Then, the results were double-checked on Mediatek MT7981 (safexcel)
> and NXP P2020 (talitos). Both platforms pass self-tests.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
> v2:
>  - typo in commit name
> ---
>  crypto/testmgr.c |   7 ++
>  crypto/testmgr.h | 311 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 318 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
