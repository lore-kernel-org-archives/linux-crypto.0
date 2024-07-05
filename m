Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0063D149C42;
	Fri,  5 Jul 2024 11:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720177295; cv=none; b=iq95KuvlTdGCEf/E/ltaIeclOJ97FzSsgGypt8qAaEZOgo7Fhd32blxJUZaQtuLrobi6KGyx2/HuRbFFRXXG2kPZ6DawPxUf/8v4L3LaoAXLHmRu7KuA8roHuTF3K0MLV6o4uGJ3V3Y87uyMf2ffV6XbTXz/B06nPE/fQ65z13Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720177295; c=relaxed/simple;
	bh=KzvfaDWRjU809yYCoeOQ+J97c8ySnCM5lrAb48DcVbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMBztBsGEFctbN5e9JFjFP73Nedwy5y6l3qBq5wFSazYcYApdZJfPip0Ie9lnra8q2NPdYw1GEA/BQLkNiQWx6ReHo6cEL6oilavylMaiMn02QDG3tEm/Lv1QdTn+dq3/N975+H80Uxr+HfEk+lSgaAjyH3zCTrvp4FDQDlqBMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sPggW-006VDq-0H;
	Fri, 05 Jul 2024 21:01:14 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jul 2024 21:01:00 +1000
Date: Fri, 5 Jul 2024 21:01:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia Geanta <horia.geanta@nxp.com>
Cc: Marco Felsch <m.felsch@pengutronix.de>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - enable hash api only on ARM platforms per
 default
Message-ID: <ZofSbH2Fu/xLnzif@gondor.apana.org.au>
References: <20240626155724.4045056-1-m.felsch@pengutronix.de>
 <258feb43-382d-4ea0-9164-357924350dec@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <258feb43-382d-4ea0-9164-357924350dec@nxp.com>

On Fri, Jul 05, 2024 at 09:39:19AM +0000, Horia Geanta wrote:
>
> I disagree with compiling out the hash support.
> 
> If needed, algorithm priority could be changed - even at runtime,
> using NETLINK_CRYPTO messages (needs CONFIG_CRYPTO_USER=y/m).

We should change the default priority.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
