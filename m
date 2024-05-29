Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABE3167DB1
	for <linux-crypto@vger.kernel.org>; Wed, 29 May 2024 09:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716975696; cv=none; b=ZIBsvNMzxMEzyalsSB5/MODMPwlQ/TfCRKTqIYdajQdwveRaMu7mG/y8TvucTNQMimderqrWIJ5w2DQa35jVBBUEZfDXDlaFbu+nSYNCxv5cmzj1yfZd6HtDmqLspvT+HvhD3aRxLkf29RAWRvSGeQMM0EXvPwMo/rtnmflhSYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716975696; c=relaxed/simple;
	bh=stDehELQ+xUuvtK5+vh9KNm4A6emf/Bv/YoUo+hEQ/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNjH0kd1oZEiK/YRIiJNP0vBuhOEx/TtADckllctS25P6R7LDyqCrzkeyK3dySeMviLkO2J0nfOytoJfAnHdYHrmyesPB9N8eNZzZJ6n6N2iQCc5MCDgF+rLXv2AOFvmo4kOTEAg5+NqcY5v9LAL+ug8xE8xrXia6Bz0Aj41JO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCFoE-003Lq5-21;
	Wed, 29 May 2024 17:41:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 May 2024 17:41:28 +0800
Date: Wed, 29 May 2024 17:41:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org, vigneshr@ti.com,
	j-choudhary@ti.com
Subject: Re: [RFC] crypto: sa2ul - sha1/sha256/sha512 support
Message-ID: <Zlb4SHWuY9CHstnI@gondor.apana.org.au>
References: <878r02f6bv.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878r02f6bv.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>

On Wed, May 22, 2024 at 04:42:52PM +0530, Kamlesh Gurudasani wrote:
>
> For incremental hasing, we have to keep the FRAG bit set.
> For last packet, we have to unset the FRAG bit and then send the last
> packet in. But we don't have a way to know if it is last packet.

I don't understand.  Can't your user just submit the request as
a digest instead of init+update+final? Wouldn't that already work
with your driver as is?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
