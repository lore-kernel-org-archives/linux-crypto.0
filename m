Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75CA38657A;
	Tue,  7 Apr 2026 06:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775543309; cv=none; b=JpA7yAE57HqiiwQPnAybRexSpw93Nn/POMvfxjoJcDH0ZdRcDmZBN3PKdF4gBHrpr/O8r96Rcp1f079QC95rftishEB2NkcwcS9XGoc18WWMf1F1BUI+AT9a9cBFsoByIuZgVw/krAMSqHhDfzTQJrCRJMpDH8Uajnu4u6ZrEHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775543309; c=relaxed/simple;
	bh=upBaE4cGbmF50cumJBR5qxyds0bnpS/2O8LmwmYLWVA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ErRXLelU3HgzaPyQTL3O7ECr9OJ8LWbWN9q9SZCw6SeJp5vTlj2/YZdJNl7GPImc4gKL82CjHWBY9u2sFSA3Fm1qKEfWxS4QpcI/mwBPKYLT0ioOwiEyrYXRjNLcb6BrwcFGyZ/aRFmx8cJA8Bp4BhrewSy3M9nx+FNpdaqMYCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=WPpqtNq0; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="WPpqtNq0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zM25rvTHQ4j/fFzxXC/W2rgL+pkGK3S3whdzkHXc+eE=;
	t=1775543307; x=1776752907; b=WPpqtNq0ur1YvyGWhmbmdAP3Cr1FxyNhb2hQFVPIja/mR0F
	NDNmYbbO/DN+iUEsxnucFPN/qJK5eNYAmhpjSiUIKOi1AT7ntV75laFQUoAoFCL4QHBQwNcaUqB71
	/i2BKQnH6FpLbMHf2QdM4RDTKalBPELarU0BtR5VcbJwEkNURRUU2X8rDXCKMds9+svwwFQez6x0/
	Hfo3Jnf5rm5BexJOpFn/X7TP2HOSWttLnDszw4S2Fpgg24j4Rg1cCx/4OZKPwHeQlToQKUX7M4DiH
	dzCgQx8lZOKLYvs8qVDxiUOQzMrXVh1mCJ4mWubes2UzaFkvveu80LvdSGocp9Fw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w9zvB-0000000C3Qk-3aKc;
	Tue, 07 Apr 2026 08:28:22 +0200
Message-ID: <b4a8265d1814eb63be9a64ab4581439829f22fb0.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 0/6] Consolidate Michael MIC code into
 mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>, Eric Biggers <ebiggers@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 07 Apr 2026 08:28:20 +0200
In-Reply-To: <adSjHlfi15v_U62B@infradead.org>
References: <20260405052734.130368-1-ebiggers@kernel.org>
	 <7f69d6e6c2057858eda5c65ec77be44d72c6ac78.camel@sipsolutions.net>
	 <20260407061508.GA7934@sol> <adSjHlfi15v_U62B@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-04-06 at 23:24 -0700, Christoph Hellwig wrote:
> On Mon, Apr 06, 2026 at 11:15:08PM -0700, Eric Biggers wrote:
> > Just to clarify, mac80211 already contains the michael_mic() function.
> > And every driver that needs Michael MIC already depends on mac80211
> > except for ipw2x00.  So bloat-wise I assumed it's probably better to
> > make that one driver depend on mac80211, rather than make every driver
> > pull in the Michael MIC code (by moving it from mac80211 to cfg80211).
> > But if you prefer that the code be in cfg80211 we can do it that way.
>=20
> To me the most sensible thing would be to have a separate module for
> the code.  If you don't want to expose it too widely for understandable
> reasons, keep the module in net/wireless/.
>=20
Maybe, but that'd probably be more overhead than anything else? The
text+data is 725 bytes (on x86-64).

johannes
