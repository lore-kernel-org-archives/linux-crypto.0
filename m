Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69540353ED9;
	Wed, 23 Sep 2026 08:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153262; cv=none; b=GLIWoJ+6UgYJRGI+1cPSjaWECyH6Ot08osLbiPNaOMrnp1bU3Ht0kJ2OKVbfbSMWvwwshEKsszVzppp/hyNJ/iZJGHOLQzX/HiFiE8ztdnfTWxRIUdueJFN9E0er04ZPRwHHDFr0Z5IYUXB2C4km9/kR50jfLJ6d8Jj4tNi+xqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153262; c=relaxed/simple;
	bh=b8bb5xRZ7cH3sAG7knHaZQcAUOoD8dtSx3panS3Vny0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u4Hgn6yn7jZWGbIiP9IgIGHz1/SxzR0h4OwuafO6/vwoHLjbWfmv3MU+Sj9TsZap/jSONo/9T6h0HcHurMBlv3i6c8epLK5+PRUgA7+U8x3bfSkM+R91EPeyzwParR0w7JRrd3wXkpXYF3/XZcUjXXG5nmEJgYmhNvOUGAnqIcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pDEZ6SYS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pDEZ6SYS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bIvcDWnJA7ANdmb2jS7I+mzPuTwA4/C5NFzq0COuFbE=; 
	b=pDEZ6SYSimnzAL/vEM8RtfPq26V5VEFMtDtiXK9h//Xadd6YDUdFWY+m/srVuoM+dajGquDe+uI
	juPUdL3Y9090P7lXsejA5esOaTrPvSCrExsQiAyhGqN3s1GP9Cst5ngJKRv1Fvp/HSIe5ATRRP6/M
	n1u3KGZRyuoQEd6f6J4y0Y9wRpkCw7W60/JJGsUzkAP5gHvTD9hf3/wyFPfdckA+weEVSRZ7AMDUY
	Eo3IjwUQHku1xpwCGAyWweuvKWJjAKCzGWJ7khdY8//0QeuHqNUcdr5M9EyToRvG2kDElyn+wyRav
	3glMpa0slzawBFn4zeT+mxCaRDxWKqb0wFmA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9IdX-0000000Gy9n-20of;
	Wed, 23 Sep 2026 16:47:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:47:31 +1000
Date: Wed, 23 Sep 2026 18:47:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	"David S . Miller" <davem@davemloft.net>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: starfive: propagate clock and reset errors
Message-ID: <arOSI-P7GAt4gHZW@gondor.apana.org.au>
References: <20260830134835.10572-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830134835.10572-1-pengpeng@iscas.ac.cn>

On Sun, Aug 30, 2026 at 09:48:35PM +0800, Pengpeng Hou wrote:
> starfive_cryp_probe() publishes the crypto device after enabling its clocks
> and deasserting its reset without checking whether those operations
> succeeded.
> 
> Check each hardware activation step and unwind only the resources that were
> actually enabled before returning the error.
> 
> Fixes: 42ef0e944b01 ("crypto: starfive - Add crypto engine support")
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/crypto/starfive/jh7110-cryp.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
