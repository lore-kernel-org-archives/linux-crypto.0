Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232493546C7;
	Mon, 13 Jul 2026 05:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783919729; cv=none; b=C2tkbR8v5sAXgAfgtol7BrjqY0HG6RDWXmGCuHCT1nhzKp7YbH4Tea8S+bOUZBVMUh0ZohPmLotrVFUJQ+2tQmLgY806Wb2JfIYIDjEC0AUZS0DXNzzlBGbBZBIkglI7BTWEeh3TvyXeTUO7Q6/KccpRxWgV10zju4I2wNVUb8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783919729; c=relaxed/simple;
	bh=FMwoXKgt/66LmyVRP8/Blbd2HF2YsjDyH0jX1MI6WVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUNNoh+O9lWrwGVwJX1OU7we2LwTwNe+ksmZMnn0gTzzyrmH+NZc3iVjvjnpjWx+7oKcsxUa0aQ/ssEuVQdeePj4SSc4uoS8KAAv38I2B2QEqsK8CoxfY+l7BKFd160ym7+KxilVQh7RjgypKueXcc2pt6h96v2PFSeK/c+FiXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=r1qpNT6z; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="r1qpNT6z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=W3A/KaKrG9kFNeF/9Jpjyh+rlFeZTpLWeLsBrxYd7/Q=; 
	b=r1qpNT6z2MeUG28TKQntSINtHBj9mHUpQDDX4jPjdk7pi+BFTFxfZMp3wDXFAraMdlHb61j8gGW
	swP8siMmTvfisEAX8FbpjcqyXeiAe8DT7DQW9hokSV1UWLfXZOlWHb5GaNZSwkCZTinhkmXv0n7pb
	1/j39LERZHHmd+Jft3fURJi7J4DDoWKrNmPLFiqtjC7OjSU+LdE6QT1tEpauo92OdM4B1FRyyX55R
	6tjEAP6hFk0aaF0A50SYwsXJgQJTEiK6niBYqGG+oigMWuozhNjwHq1mKom9MA3FGnnDNO9vNIsho
	ezAPGsKq6qJEkrykDomkyvJX4F09WLoPQo1A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj90i-0000000CyxY-3jTC;
	Mon, 13 Jul 2026 13:15:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 15:15:20 +1000
Date: Mon, 13 Jul 2026 15:15:20 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: NeilBrown <neil@brown.name>
Cc: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>, tgraf@suug.ch,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com, kys@microsoft.com
Subject: Re: [PATCH v3] lib/rhashtable: clear stale iter->p on table restart
Message-ID: <alR0aECzoQyjBuhY@gondor.apana.org.au>
References: <20260707164115.4979-1-blbllhy@gmail.com>
 <alMDzpDrUzdB8e0r@gondor.apana.org.au>
 <178391853109.3371781.15191213695629915459@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178391853109.3371781.15191213695629915459@noble.neil.brown.name>

On Mon, Jul 13, 2026 at 02:55:31PM +1000, NeilBrown wrote:
>
> I think that patch is good and fixes a problem that needs fixing.

Oh I get it now.  It was rhashtable_walk_next that was dereferencing
iter->p, not rhashtable_walk_start_check.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
