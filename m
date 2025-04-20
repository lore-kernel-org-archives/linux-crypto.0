Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B056015D1
	for <linux-crypto@vger.kernel.org>; Sun, 20 Apr 2025 05:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745128122; cv=none; b=ls1//jnvwzM17jNJsO1eoE4otWF4UOHPaBbEyyQHgPk4o8aHL3YbbwgCg+B/k/RScc65V4czJE90zvdkExHUC3roDIRjwARwrevyPlAnZRQ/hPspy0PHRtpyUivHo1YB/UeXss9AonJ9fwoHC8joUv6yevzLkTyKcE/jZSx8U60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745128122; c=relaxed/simple;
	bh=XhHh6No0gY1AYMvfv2M3xfXKgRzZpoY7I4GnRxB8c0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4u/Pk+UWI5jvfCAmSXi/Kj6SEiEADyqe0VqfwQ8Js3zdVRk9EYlLzerNILRxN+BDqAQ//BL4SvA8DHM5/XjwieO2BQN3DZFjiJ8PgKWtIrZD+D0jhNbGSiK4OQbaA0HyRvxaG/ZKp9CAzh1OF1FYUOBT/oMqOzZRgSk08fio4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lLkl7jJI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lLkl7jJI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ujVreHS8m+/okmbF4k2UcFzkrS9Qk7UPaz7rwa/Fuzs=; b=lLkl7jJIiAzu9J9kS7p0f6cMdL
	zLRDS6Z3kl6HmvwS+q2XNfOILMZrAuFQCGqOA9t1tnnCwq9ygu0ICRfs7Y5s/gzoXmbVrbb15ZrXM
	0PmtayxWSL++hu3PSxyCJYF3n6QNqkbUURh6RVPLvDojjk/2eOXlPM51wnzPrM54S6X0SC6wlCEoM
	BkzO/xvIdc66zevFEHcKZUYs/d19xKrJEgFxDojeCyA1BpGoP2BvTTk8utHaIxOlhZ5p7JYny3jnL
	Lj8a76oCKh8JOa6tER1Qi8cXne7SG8sczFGKLaaL/oBZ0F9WDhaXe3XnCZea6kcjci5915Oa9qCp3
	c/jeEbkg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u6NXY-00H5ss-0q;
	Sun, 20 Apr 2025 13:48:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 20 Apr 2025 13:48:28 +0800
Date: Sun, 20 Apr 2025 13:48:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: Re: [PATCH] crypto: public_key - Make sig/tfm local to if clause in
 software_key_query
Message-ID: <aASKrChEbHxVsED1@gondor.apana.org.au>
References: <Z_9gygoIHTH7A9Ma@gondor.apana.org.au>
 <aASKMEe53YQvqiS9@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aASKMEe53YQvqiS9@wunner.de>

On Sun, Apr 20, 2025 at 07:46:24AM +0200, Lukas Wunner wrote:
>
> Hm, I've tried to reproduce the warning with W=1 and W=2 to no avail
> (with gcc 14).  How did you trigger it?
> 
> FWIW,
> Reviewed-by: Lukas Wunner <lukas@wunner.de>
> 
> I suppose this may have been introduced by 63ba4d67594a ("KEYS:
> asymmetric: Use new crypto interface without scatterlists").

It was with Debian stable gcc 12 so it could've been fixed already.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
