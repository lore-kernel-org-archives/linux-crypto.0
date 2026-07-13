Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EDF3148D9;
	Mon, 13 Jul 2026 03:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783913178; cv=none; b=MPyk1PJNeAeBnvmqGa67j2Xxh9JNvNtdq3f078H3zcK8eMQ4At8phGaRc7i8JO249tk65z8NAT0K17VyXJaXU40L8uvwlNtKpaLIWk1Yhbotw6acInniWZZ+nYx/dXP3MU/FVnw3pBI4GVnjkUSO3+7Vg0NldssnjEA9fEytsvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783913178; c=relaxed/simple;
	bh=XU8PwunInvAHerjBwgKLfc/8URkqNPuUHurJTz9emKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rLY32ZlKId0a8sOzAswHS/RERQIWxRHnLf0/hr113YDyB7yYjIJsg771HlPX0qpu9CLkyhQYhbtpEGV6RSzIx9/fHH2VJvqyo1Gfsq4CpldskIoAWVq0lDldW1Cl8/5Vw3GtI0rCRHdMRAA4B2nEWIMisBSLwy1nmLNoyX0ABNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=E9GPj/aN; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="E9GPj/aN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IhCzXW7viQCr5P9GDimMf/pCmw5MR5jf9qVyHnLRLks=; 
	b=E9GPj/aNAG7kzwjLhA5EDr2vi61TWm6o8Q2H6hXZfQCxJsDJVwdVZRfqxNR1qmdggdNZswG1aR3
	FbWGN3D2FM+rxZx2YiPycds7ue2pbzbVJwS+4WuHFeqbHEkb5qXCawIxVP+jGeg1MXqaQ8Z3nZht3
	lJK7qGP508KqY0ZnXzbLWWvD++x+2oy0ygnjE8aWw29wBda0f2C5FtJRsHbjZbAI7E72AghxGF2TW
	IshnflBpOzBGeb4YJdpHf8mR9ASjLbYmVAkdcPFEIbreQeorJaCEMmQlCzunH5x5PFVPbGAz/eXh9
	ZZGFyxh3GKCedpRbPnwmd+B2YRp6SvvTYafg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj7Iu-0000000Cy46-0wAx;
	Mon, 13 Jul 2026 11:26:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 13:26:00 +1000
Date: Mon, 13 Jul 2026 13:26:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Thomas Richard (TI)" <thomas.richard@bootlin.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregory.clement@bootlin.com, richard.genoud@bootlin.com,
	u-kumar1@ti.com, a-kumar2@ti.com
Subject: Re: [PATCH v3] hwrng: core - Stop/start hwrng_fillfn() kthread
 before/after suspend-resume
Message-ID: <alRayMNo3D46Tdby@gondor.apana.org.au>
References: <20260703-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v3-1-b7165cb9cf38@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v3-1-b7165cb9cf38@bootlin.com>

On Fri, Jul 03, 2026 at 11:20:20AM +0200, Thomas Richard (TI) wrote:
>
> @@ -506,6 +501,29 @@ static struct attribute *rng_dev_attrs[] = {
>  
>  ATTRIBUTE_GROUPS(rng_dev);
>  
> +static void hwrng_start_hwrng_fillfn(void)
> +{
> +	BUG_ON(!mutex_is_locked(&rng_mutex));

BUG_ON is not acceptable.  Please use lockdep_assert_held.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
