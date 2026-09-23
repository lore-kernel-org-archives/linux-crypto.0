Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCD93DD854;
	Wed, 23 Sep 2026 08:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153256; cv=none; b=CZf9TQPuP9D1C1JXeyXvhY/J9Gh2nBiXXpgFBzMJpjLVPhxp5Ci+QCcaq1SCG5MK9Rcdcu2Gi8lZmPXckSay7D1qhIysHDNfeCmzHtpDzZZ6xXXI+X8CRe4JO1sv5QyjuGdxIt0xQ9UaTPz72vjxQnH428t13LhvMazrRHI7ULA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153256; c=relaxed/simple;
	bh=w9QCjmVv/+clwxiZc0X22JapOnxYij653w1ktmsdzM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLNasvL/2+k7g6mBp/mU0/dJLAdGbDxOBlIKAaBvJKhPQquwyDyUXXcME4yP12jRs6mGfl1p/QeAU2RY4Hb6p5F3dH9Rq3XeS3xtsRtL/K2oI/aI5dYm4vcB2jfIQ0ih/eGGdad/xkIqkYVyR/X8UbBWe8jWfYCggCfUGwKK0QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=puvBONRe; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="puvBONRe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ry4RQ8/T+Zuo8SG1GFJEEQVID1pTfizQBMx0ZSUeqYU=; 
	b=puvBONReKfgTkDezv00He/R+2G/bnOh1zk55QFfWN9Y4C6IlDr7pfm/wE9ol/0XrJv+4o+Exf38
	nDecLmwHVDrt6lt5t/Egh1Xel2r7ggR/FvIizxE1PXfT+gaTIldNvgNx+CXr5X5ENA/fXUVeVEWyR
	KDXhg/wppnHMlTdxNEg2s0gdfwIHNEd4X+CKLInA9kaIJFOjmsjQARrxj/oT2XMfrCGTN2Ma+KAlj
	+WEfqMZ2QbClobuHUJwKrNI8DGUp75ei9RUFoudyvXN/StItIuwxuin52BSyHDPISevMyrMwGlNZo
	JdVxp5bs7+FHErTQZZTakyv1OATHlK1O6JdA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9IdO-0000000Gy9H-3MZd;
	Wed, 23 Sep 2026 16:47:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:47:22 +1000
Date: Wed, 23 Sep 2026 18:47:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Olivia Mackall <olivia@selenic.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: starfive: propagate clock and reset errors
Message-ID: <arOSGqzzWTjH5J7S@gondor.apana.org.au>
References: <20260830131753.3744-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830131753.3744-1-pengpeng@iscas.ac.cn>

On Sun, Aug 30, 2026 at 09:17:53PM +0800, Pengpeng Hou wrote:
> The StarFive TRNG probe and resume paths ignore failures from their clock
> and reset operations. That lets the driver register or resume while its
> hardware access prerequisites were not established.
> 
> Check each transition, unwind only the previously enabled clock on failure,
> and propagate the error to the probe or PM core.
> 
> Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/char/hw_random/jh7110-trng.c | 39 +++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
