Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2C94457CF;
	Fri,  4 Sep 2026 09:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515658; cv=none; b=BGksa5KJZ7Fyl4cHoj0Wk5BHOlQhQiYjITrjHti63Sy8ecvHRzX6x9c7qmFLMlNpqNdrvFAJ/Rgidfx9W2yKg9moQrZjDYNbYLeUzGyJyswVTAEdAzBs9LJvXyEizUnZ9hX753ZNqP3fGge3C1cMXUPwhJpn1xV4BF/p+oEcrm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515658; c=relaxed/simple;
	bh=3PqPENhDICk5l2MTOQIpMr5kGQQZtXFajQe/+Akmgng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lj2uaDyfZ6xGZvRgNQzlKLNhjVtMoxqFyNrjSqwyvjq1kFfcK97K4Ftm5MuKFIo3yl0dVkgVpElLqADD9jjwD05dkIP3byB9QyEtlyACU+sogrjoTOXx1Sey6ub5NEDewcFhvR907Dv+jxYp0R9DI8y8f5cyPzUPDRYMjbXr8cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Mq72b/Gu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Mq72b/Gu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=jkzKpJr5ODPtT7RRQbVPUAI/Zsdbk3dpgis03n8smN8=; 
	b=Mq72b/GunvR0Xlpl9NbdUZ+OLvy2kFr/yMbov0R1vfLB2uQDJ94sAOBoDPf31+1aDqvNCKSQHan
	18ZLLqijwjxEqyYWvVZd68hlp/oNqke9f71QnY6tKSY3Fe3ANVABcfOEhS74b59qIkGl0Mk8rb3x5
	kU9kWTOpmaLDj7aP2fxqq7LCLJUun/7hV1iFCemIUXEN6QqzTA3d02peiI40ibBUfJbvlpl8fH1+0
	dPRN+JzhEoM/WHvfDBbav7kC3Bv3WQ0mU38It/U6khtYvqB32QHX1Y+eFcvn5l7Vn9bmmxOYajbkO
	3y4QxtUC9hJ+TYt1lv6Zo7YKp+yu2sAcRK1Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Qce-0000000An6T-2EXA;
	Fri, 04 Sep 2026 17:54:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:54:12 +1000
Date: Fri, 4 Sep 2026 19:54:12 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] crypto: amcc: get irq and ioremap resource first
Message-ID: <apqVRJ6Ln4hCoE6u@gondor.apana.org.au>
References: <20260810191559.21977-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810191559.21977-1-rosenp@gmail.com>

On Mon, Aug 10, 2026 at 12:15:59PM -0700, Rosen Penev wrote:
> These functions can return -EPROBE_DEFER and require no special setup
> other than the platform_device which is already provided.
> 
> Avoids doing extra work when not needed.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v2; remove now dead error check.
>  drivers/crypto/amcc/crypto4xx_core.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
