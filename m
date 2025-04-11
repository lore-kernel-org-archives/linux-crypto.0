Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588C11C8620
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 05:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744349835; cv=none; b=jme3wmHeh7SQ9do14n6b4+zhA8Si80TpxTnI0mrW4SF5lO3gfpuz8HiyOd1mBlMGxbHD0oY36igSVeA8ba0vkiFHV1pVXhISwqv3HCFEmw8UNNmrCuh6cWV0g0MtoAwyFKAi677a2PmNeurzvbx25bD4tYSTfGXbqXUWQy3KjoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744349835; c=relaxed/simple;
	bh=JXzm/nq06cQ47/kUnSU57gGNvme4GNr33T+ftOWYsh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXMeKUwKL39ditMzg9w9XeLCiQJ/GIkya5kbXqycQEIWpeZCK0Eee35wXrD5XDn0v/Rthk2x3SC318aXEBBIB8T+gJvNYlzgL+IHJhf1b1b+H+FYNrfYvHW199fTU1+0FqI3MK7bvj7kzl8Y+mqy3sSHPv+2eJaFVse/bxHYC4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UIDHl1DE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UIDHl1DE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yfk0OhVHs13/0v4kde7gDNYc1sXyYK9di/yKR4oIXv4=; b=UIDHl1DEbUZkuaLFdbCzEcOsSr
	M/54NGPC6hBq6R9P4SEmo140XNsaU7EsbcH5nsSv1QF87JFWJ8Y0Hln7f2yiJdDoIxJe0Ro70/zCo
	gg5ws0u0VMq/padXZixnjUF7b7O9r6QKDnY1MJFFDuxQ26sz2CmQki2tBvB7Tez8+6nFa2WE/Nozy
	FJf+SQqdpJZi2Ymv+dyhLgwFvKiI/LsBbsgVc5WVtI/vkLrCgF8X+xnswhOq1lnjdJVf1MLfPVmdM
	zuj63anAsJ5NzItthKavQTWSLCacFwXPtuwWjU7t9627DLIaE4DK8GNQba4NMIcGW75yQhVJr17e2
	FRmeEuzQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u374d-00EkAh-1K;
	Fri, 11 Apr 2025 13:37:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 13:37:07 +0800
Date: Fri, 11 Apr 2025 13:37:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, Udit Kumar <u-kumar1@ti.com>,
	Pratham T <t-pratham@ti.com>
Subject: Re: [v2 PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <Z_iqg1oxdPecgzlK@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <20250411053426.5vmvji5nthajphzo@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250411053426.5vmvji5nthajphzo@uda0497581-HP>

On Fri, Apr 11, 2025 at 11:04:26AM +0530, Manorit Chawdhry wrote:
>
> I see multibuffer hashing is reverted but with chaining changes we would
> require the following patch.. I see the chaining changes in 6.15-rc1 but
> I don't see the following patch in 6.15-rc1, could you queue it for next
> RC?

This patch is in cryptodev.  There won't be any chaining in 6.15
so it's not needed there.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
