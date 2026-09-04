Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8CB22423A;
	Fri,  4 Sep 2026 09:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515777; cv=none; b=a1glW+ah8WY4xpOpu7+TfxqJ+mUZDP1s+xlO1VpTfHOyQ7moSsHi1O5AWD/pCku+uoN9dztuLxaSxgktTR2WquHoBLswpHLnu/2KSuhzAefvyjAPKt+zYT2jutKqBMmcQyEMLUETzrvzSk1su83zsfE7xZWZCp2qHhKXmZ6QC5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515777; c=relaxed/simple;
	bh=MDriEovPluIGXestrLSmsUow9nlWr4kKyyFfm6ywp0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B1QWJhXnCRajycWZlYbGVOVkHxiIzoJmGosFqQQeF8SHVwVMhw+K4nRFyQbrTHFUE7LUhLirxd1zNzdb6vP5GBVOeHMHvP/5VZYXxfvCHEAGd2tNIrRG+NRBZ2n7CTXnuDveFW6iqvm2Lg6tiOYRVmZ2uplhHOZMbdmaQODmyBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mcNT8osH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mcNT8osH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ojRUjj+cZCTxru3WjSd8zL3Kj+BHX9iV/2jTor1K98s=; 
	b=mcNT8osHEzkQF+h9ajcNdgz45Cv30qiPe27K21mmllBrcwnhQuwo+LClewHPY5S9f4+eHXHHg69
	/m1MmZDxeglwcMU61PkIonA5bO9KEsVDswj2blHT5CdtnPO6BS2w30bs+reFPUmAbOyJD97Mto29o
	8oJs14KzHIjsA25jMkdZLGJiYcnwKkdbPGHX1gl/h0QHiZE82M9djIlk0Eb7TcLuzVlW07NLOH2kl
	Z4JmhQxUOYpufcRa4DqDHQypumfIQHGyBLS4mwau/8jcDviKoBRBroaFZkW8wgRz0adH+jOEQuZwI
	hw4fx4FzuiFAJ8rbI7tIHMScVyBhVKAfDADA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2QeZ-0000000AnBE-29mY;
	Fri, 04 Sep 2026 17:56:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:56:11 +1000
Date: Fri, 4 Sep 2026 19:56:11 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: amcc: pass core_dev to request_irq
Message-ID: <apqVuySxYVj77wqY@gondor.apana.org.au>
References: <20260812191555.93423-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812191555.93423-1-rosenp@gmail.com>

On Wed, Aug 12, 2026 at 12:15:55PM -0700, Rosen Penev wrote:
> Instead of using a get_drvdata function to get the proper struct, just
> pass the proper thing directly.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
