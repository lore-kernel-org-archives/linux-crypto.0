Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9191B155A30
	for <linux-crypto@vger.kernel.org>; Mon, 31 Mar 2025 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743416033; cv=none; b=S2GQEDgJyW0HglqBx5GYqcghZYb3sW9FACsFpRBwEjGIXY2eCEKuAlkzlw6EWhcuLSaV8NFoRiOgpivZkAe5dwsGb5Qq3rWHc2RtUWiW6pFGXd4sW+CMpQPk3whFMP54rHQhss/r9bTCNmTuI6SBvAHas5eB+hJ8nuZhLnkYmwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743416033; c=relaxed/simple;
	bh=Z6qqZt7GJL9yv5HgF+kxqHQwMwm4k+kgpY7T3WkL/ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I805L4tCKPIwyjgFFpFEDYmrS5sWc1xJwvIkiNQhpWaFS5lbOr65i0MIIVXJnZ1EoS4SwhqZG/ur5tEDlAztqO05Ovnw2fp+JM66gNmz/7fxNc2ZBZ9F6Vw8EsEZtpi1H/8ec6ofhXYILZhs+Uztb7+Oc4TzRv7nk5WhHYSdEC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SSw8L4UN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SSw8L4UN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2/EyFm0UKols51vj2YD7Yr5fyxGewcaWTkgDhoUYUYc=; b=SSw8L4UNAk6kJiiXDn6yQVw/Wa
	OLQDhWGLKfjFVTmupzK7990yv8hwPJMdVnVGE5IorduThkryM0ANcAXsdjCOdJACyU/0XDVTWiBbr
	d5S/S5Ql0fYK7U41A8wFZ0ucs/WTlZx05fkT1RrDN5QDVDf7csSakNtCDGcCG05ubruQdAFtSG99M
	2Y1cmDaTLxxgo2NybSpwEcuHjRqjBEbULoqYOhlReS+ibM6qJfgJifY+F7b0ocTFNMsyv+0Lti/XX
	wFQ1P0XaNPX6Mo8dQQp/iW98JOfyw9fZpuRuAR0qdDBM9RW12ufsis+PUuhH0ZOuDoHgnrvOPXLgp
	0CrWuJdw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzC9J-00BWwz-17;
	Mon, 31 Mar 2025 18:13:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 31 Mar 2025 18:13:45 +0800
Date: Mon, 31 Mar 2025 18:13:45 +0800
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
Subject: Re: [PATCH] crypto: testmgr - Initialise full_sgl properly
Message-ID: <Z-pq2cMlKS79sceR@gondor.apana.org.au>
References: <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <Z-P78_9NKGMBFs3s@gondor.apana.org.au>
 <20250327073427.amcyd4t6qvs7kw35@uda0497581-HP>
 <20250327081555.nhcggnqxetwbnidx@uda0497581-HP>
 <Z-ULBwaDsgWpYzmU@gondor.apana.org.au>
 <20250327084014.t5x5rfk3yzwiehgo@uda0497581-HP>
 <20250327090955.6hgrpfe7cl2f5twm@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250327090955.6hgrpfe7cl2f5twm@uda0497581-HP>

On Thu, Mar 27, 2025 at 02:39:55PM +0530, Manorit Chawdhry wrote:
>
> Though it really makes me wonder.. I was actually thinking that it was
> our driver problem and not something core as when I fell back to the
> software fallbacks everything was fine... How is it possible, do you
> have any insights on that? Is something missing?

I think the software SG walker simply exits if it detects a shorter
than expected SG list.  So if you ask it to hash 128KB of data, but
only supply an 8KB SG list, it will hash 8KB and then declare that
the job is done.

That is arguably suboptimal.

I'm in the process of rewriting the software walker to add multibuffer
support so I might fix this in the process.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
