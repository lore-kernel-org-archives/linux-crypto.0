Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D2953AC
	for <linux-crypto@vger.kernel.org>; Thu, 18 Apr 2024 04:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713412895; cv=none; b=EgKGwuLwRTUrmVMvuhDuu3EDYl6VcdGKvtO7TL1dDG8Kg4hZNsIHMNYrEVI633ZHhSDg4qO3048Oj+KNIDFH5MRRJbaMXgPK4NA0HvfHD9buoo4v5ZW5/uJVItiiIuKxyqb3FwjDFqFAFuIIbDxxrDRzEnQD01wFuArCpF6WJU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713412895; c=relaxed/simple;
	bh=3f3S1hh1C8o2oiA1OLbjDxKgPobcfdLQau8toTxXxMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBKzydsgK7uHS2iEta0MBEnQyzDDLkO9gP6zaB1Ip8g5ihF9Ex5bqWMUEU3subHyjk75OxSl3BbNyf/uB6oWtj4cwY3R27ZZVHZCsIvicR8URkaMj5cRFAVijbFyNG2uvAbnVX8EdtkcastxStOscSp6D6m6wHuSXh4wUiMxGEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rxIxY-003Eoo-Th; Thu, 18 Apr 2024 12:01:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 18 Apr 2024 12:01:34 +0800
Date: Thu, 18 Apr 2024 12:01:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/2] certs: Guard RSA signature verification self-test
Message-ID: <ZiCbHhvDLvDD75c5@gondor.apana.org.au>
References: <20240416032347.72663-1-git@jvdsn.com>
 <20240416032347.72663-2-git@jvdsn.com>
 <Zh494tFvPQhxJ8j4@gondor.apana.org.au>
 <65bb88b5-5071-4836-9923-939218d9a883@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65bb88b5-5071-4836-9923-939218d9a883@jvdsn.com>

On Tue, Apr 16, 2024 at 08:39:28AM -0500, Joachim Vandersmissen wrote:
> 
> I did consider that initially, but I was unsure if this was the right path.
> From a conceptual standpoint, this module doesn't need the RSA (or ECDSA)
> functionality. If the algorithm is not present, it would be perfectly valid
> for the module to do nothing. However, I'm not opposed to removing the
> current check and adding the select to the Kconfig.
> 
> If I add a `select CRYPTO_RSA` to FIPS_SIGNATURE_SELFTEST, do you think I
> should do something similar for ECDSA as well (considering the other patch
> in this series)?

I think we should split the data out into individual files, leaving
only the test code in selftest.c.  Each individual file could then
invoke the test function directly on its data.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
