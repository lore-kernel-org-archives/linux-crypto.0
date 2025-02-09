Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE3213BC35;
	Sun,  9 Feb 2025 09:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739094863; cv=none; b=tfyD2yP2/9flLEZIujfh3Kv1s8iMiW8hE74/H+m1O/ExHYo1/s9l1pTPsGHYVYXQ/1hdBxJ+gpr8mbjrZCA9DsOo/SmyCfOpaNWafwFBa/AlMoEC9n32TmQFuB2qk9pMGL60CGiH9RmW4AsKjWeYMfuXT79KWmGufhxs81pjTbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739094863; c=relaxed/simple;
	bh=4dkNU4GxdkoQ/flw31my10yXeCi2FzNapWMkjnhR5Zw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4KTMLW0gUtN6es7bSSgwbrqWqDa8XUAuIDM5QYcnLvOCnvIWjffvLsUfq7yVluBLL96uP046AGP095o8Wn4bAyIYSawcukseri9RVLnuf/RhJcDYKN0x2nTktYG7pH/oUvV6RkSl8faNKDNPH7C8u/mb4BumB0A2H7QAIKi2l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Vkv01s3P; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Vkv01s3P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IeV3iZzsP5VgszvwMvCQiZP/t4G4MGx+35kqmV6NRkk=; b=Vkv01s3POYlXab4PdJ2NWZv3yc
	6G1hkGAKlBsYP0uQDckBLTca5TjIppP7JpeJab0loi3ThPljAp4fzt76wmJowFyTavLlNTMo+OVbo
	upphMnGx5U/b6n78SYaCGoHZFzeL+GCBEx6RFLrjADQDrVN+evEJBTz0jBoybQHkGmFC0Se/em7Yt
	YNDFYhyZwWmNJ7KUTIwOkKUzFfW5r2dTZ5gtZYKAOCAG5IxSpUcKTTgJwJdrq3Nlbv/Ch5yEQ53bc
	PhEJDo8tsFupeRldt6G7aZ6oIbAkW3e+684fpG1t0dmMzfGxttdDXKF29celQfjH8IlLlT+CdvtMv
	AYCFCIeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th3o6-00GIQ1-02;
	Sun, 09 Feb 2025 17:54:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 17:54:14 +0800
Date: Sun, 9 Feb 2025 17:54:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dragan Simic <dsimic@manjaro.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	olivia@selenic.com, didi.debian@cknow.org, heiko@sntech.de
Subject: Re: [PATCH 3/3] hwrng: Don't default to HW_RANDOM when UML_RANDOM is
 the trigger
Message-ID: <Z6h7RoBpKd1ZDKhz@gondor.apana.org.au>
References: <cover.1736946020.git.dsimic@manjaro.org>
 <3d3f93bd1f8b9629e48b9ad96099e33069a455c1.1736946020.git.dsimic@manjaro.org>
 <Z6hyK-nU_mLxw-TN@gondor.apana.org.au>
 <1b5988c648403676342b4340c3d78023@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b5988c648403676342b4340c3d78023@manjaro.org>

On Sun, Feb 09, 2025 at 10:37:52AM +0100, Dragan Simic wrote:
>
> Could you, please, clarify why we need(ed) the defaults at all?
> Also, I'm a bit puzzled about what would be the defaults that are
> actually needed?  Are you actually referring to what I proposed
> in my earlier response? [1]  I'd appreciate a clarification.

In general there shouldn't be any default.  The only exception
would be perhaps for embedded boards where the RNG is always
present given the dependencies.  But in that case the default
should be conditional on the dependency (or perhaps the whole
config should become unconditional).

The current defaults are mostly there for historical reasons.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
