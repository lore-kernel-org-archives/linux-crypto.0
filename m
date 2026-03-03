Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEF6199FBA;
	Tue,  3 Mar 2026 03:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772509050; cv=none; b=fj8Jx4x11Sv4F+LlSszXGBfB43NSTtsekK9pALG62tfQgYzGM4gY5nXG0/yZtWqZBeN5GyUqMQLJzXcjzRJ7+Xu5GNdbLcUMwr9bq7ir2WqHV93VyxoYEYi3GGCkZs93ueHwa/tfA77C27m8Buib8kDpKHPNYxnmgOSsgYJ5bm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772509050; c=relaxed/simple;
	bh=kCQr+GYkgeYokkJGJahG0A0MDa5iA4GPJDphMwdoFXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dcs5+nD/zrfJuv/CBgdByPoEw0y0AsSZkEHm/OQhFfcgeeo/projDbGCOnv62kSAJc7XGNfk5Hm4dLSA1eG0HyGDoh4N2M8s/cac2S+Ff3vxSTS48p92ZbpLT5qOQBzlQOWcjDhpBphHiGgZI/ZxQ9Oec58C5t02/YUSCstOpXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cTQwhipV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cTQwhipV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=hxA+lES6ha5IvVPfIMUkNYMuOY4BSguYjMmoN453szw=; 
	b=cTQwhipVqdaZy/naN/4FhYn7J+zEC4s4jLHkXVabZegR3uPP0xU2C2d2qQXgaUwo02SSoWhuNUt
	5k76qmWIYqnKDCkc47+TmxDgzTPBKhbWsZgopThfuymwJpJkGeAd5zv1EVimJJB4cKGVJraXxt7Kb
	eHPTb56c9ngdWEcmc0PDO8FDhdaPt7O7yZlCMxyxVVSTmBiMgLtVpzth6Kgq+okVQZt3MYkNh/NIN
	tuclr8kXak9+nAcIggNJ/OZK8DcystyXE3riNvTNC+pJTueFBjufUQVOGlfIDydSoc4fBsADm0idx
	ALYIN+Rvm5wVoZZ+89sFBB64hEQb5L+qRMEQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vxGZP-00AzNY-0e;
	Tue, 03 Mar 2026 11:37:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Mar 2026 12:37:15 +0900
Date: Tue, 3 Mar 2026 12:37:15 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Cc: Joachim Vandersmissen <git@jvdsn.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@microsoft.com>
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
Message-ID: <aaZXa9GHhbvmyqLR@gondor.apana.org.au>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
 <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
 <aaKtujHwV0zDFWxi@gondor.apana.org.au>
 <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>
 <145cfedf-7510-44b7-b1b7-6569144e7b21@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <145cfedf-7510-44b7-b1b7-6569144e7b21@linux.microsoft.com>

On Mon, Mar 02, 2026 at 04:51:38PM -0500, Jeff Barnes wrote:
> 
> For instance, ceph, samba, tls, to name a few. They all instantiate the
> gcm(aes) template. They all construct their own IV. They are all compliant
> to SP 800-38d. I am pretty sure that at least one constructs it per 8.2.2
> while the rest construct per 8.2.1.

Perhaps they could switch to IV generation in a way that's similar
to seqiv?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
