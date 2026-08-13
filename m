Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C3F31F9B9;
	Thu, 13 Aug 2026 01:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786583415; cv=none; b=hApci8OWGo6TxFMBdxwXojSeqNHeEKSJpy2cj4WCoIhKGNSEq3E/Lt4I+3aqkVqMw8TQCljNd2HMEKk1f+TkgP9kEnRghsZjQL5MSAut3aIEuWAgUeuPTDfcu6Naa0WuYzqtotujkrnLe/5AxAA3WrhbpFSOqpyzgvOjTiPxnEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786583415; c=relaxed/simple;
	bh=VkSGC0OU4VPw5S5dtdkBIVTB/XkClntAMpYkRYwVx00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNHWg1wIvEH03765AP6FpUIgWrBsk9beRbmgBRiCdwPLh1BpLVe6bFcbU6sY2GP4sDSshsbB2/ISv8/DhF6bPV6lPxiXJ4AslAM+ShEREFAdxin70oBhTFasyE+a9X2SdgkafCvBDscM7O067Gmb0ZBx9rjSupFxCJoqMExb/kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=DklMtR0o; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="DklMtR0o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=TYj4Q9MHLne3qqPIEYRKc5SmwMzj4mK82ZpLq0TjrxQ=; 
	b=DklMtR0oa0l/eMCrImdAJP/YdUZy4pLSzvtYVY9LmRtddlV6toLc619Sy0eyIYfSr6lXE3KoK06
	HdNevCY+B2c5rQ2FJ01U28hbQx3FQsr6tMz25wLLW5RQ+XO3Xn/vAnx58JCSzeyVAYCNtiZPuiHgy
	C9G4oe40PzTl89czyY1ffJAqnnbHYl+Ba5Ls3eM6jbVHvkd91zKdMdgwwbkRJ73YB7wtPR9vnty0I
	5eGytcaGKoRBM/BXbeQ2UmtU9NIfbsj3EwCj+G69ZXS8uUxHpTWpUaUjJUQs/p3O1HJf+COrtp4W+
	Pocd1IS78FBHT0k7gCd73kQpQ+HoGLyQUfOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wuJxH-00000004SS9-1g2s;
	Thu, 13 Aug 2026 09:10:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Aug 2026 11:09:59 +1000
Date: Thu, 13 Aug 2026 11:09:59 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam/jr: fix use-after-free in interrupt handler
 teardown
Message-ID: <an0ZZ9JPSDY5y0MN@gondor.apana.org.au>
References: <20260730231603.1169539-1-rosenp@gmail.com>
 <anmHccSuAF5apZr2@gondor.apana.org.au>
 <CAKxU2N9rmMAvnWLc1y7vGL4-md3kF4Bom_qnKEoHZE_k+xDvkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKxU2N9rmMAvnWLc1y7vGL4-md3kF4Bom_qnKEoHZE_k+xDvkw@mail.gmail.com>

On Wed, Aug 12, 2026 at 11:54:00AM -0700, Rosen Penev wrote:
>
> > The driver needs to be modified so that it can fail gracefully
> > if the hardware is forcefully unbound while a crypto op is ongoing.
> That's a much bigger change than this one, which I cannot test.

The thing is that as Sashiko has pointed out, if we apply fixes
like this without solving the bigger problem, it'll just make that
issue worse.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
