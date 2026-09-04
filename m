Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498BF438488;
	Fri,  4 Sep 2026 09:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513723; cv=none; b=M8kSlTe9g3dYOWE2cFTkT3IIx3Y4YtMvZpmvf7gYBaPEsdYXtVpJvtu8xtxMfyNLBRui/obJAZU6DRMr5cJwvY0eTKe7/KMlX4p3nnjzCsoUAp28AaKv/VgCX/JoU/LZsKf6JjvfhPMlk4sJbsYknPZupUmxItUirsVi+IM/NXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513723; c=relaxed/simple;
	bh=dpjtHQuIqcEy5YgOV3lEWfajQ/P92LwNw397B/sVp/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+xYc5JPOh9Ky+pqYx0yqzRiZnHPs+9zHYJKiszukItSqxxOO6HN6DUGd+I2q/fgFXs+98phKTZz3aheQFk72/2QlXYjI59pRixuVgwrNs/nHX3dEgncqeU0YhuzF6U5Q+gsvvT8OrpJ2HbJcXD4cDLcYH9a8RpOPz99C4O/PFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KK1jtfoX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KK1jtfoX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nyhgmlJ342aqIEKreHRT7sYlEx9Rg+CU7rQEcFQGurk=; 
	b=KK1jtfoX4B9kYMjcFHnrPnl+dhl7lvk55QMp6a4/WQgRqYeYU59XQFQqG+tkLM2ZO+khQzvfEHi
	Pwn/xo48l5U5IeXaxR8k+G6B8I6VuoJ4K3FZp0ARVt/Hhn4/bonjPe6rBm8ArWWxzSp2XrhVGjXUY
	yiE9R5bX41vmn1w07LZf72pXO68+gSZDqX8EAyEV/jZ4fjsKiXPpjqLdN6/buW47GiMmHIq6d6hvG
	Q9xeSP5BCbK3FJ3GsZQZ1WeD8heRNpgUJAkpYTSQZ//5QfSJDGa1TBIHT7VYcRoSh4nTMW7RDqBNC
	HAOnXvMzoEImtprZ7b4DD5g+WtUmex/q3PMw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Q7H-0000000AmVy-1Dtf;
	Fri, 04 Sep 2026 17:21:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:21:47 +1000
Date: Fri, 4 Sep 2026 19:21:47 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] crypto: img-hash: fix IRQ teardown ordering and
 fetch clocks early
Message-ID: <apqNqxlGP5v8_vzo@gondor.apana.org.au>
References: <20260811212030.20057-1-rosenp@gmail.com>
 <20260811212030.20057-3-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811212030.20057-3-rosenp@gmail.com>

On Tue, Aug 11, 2026 at 02:20:30PM -0700, Rosen Penev wrote:
> The IRQ handler schedules tasklets, so free_irq must run before
> tasklet_kill in img_hash_remove(). devm_request_irq only freed the
> IRQ during devm unwind, after remove() returned, leaving a race in
> which the handler could re-schedule a tasklet during teardown.
> Replace it with request_irq and free the IRQ explicitly in remove()
> and in the probe error path.
> 
> Assisted-by: opencode:deepseek-v4-flash-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/img-hash.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

There are much bigger problems with device removal while the
Crypto API is actively using the tfm.  There is no point in
fixing these issues until the bigger problem is addressed first.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
