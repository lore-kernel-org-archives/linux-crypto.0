Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64A629D279;
	Tue, 16 Sep 2025 03:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757995200; cv=none; b=HlkYY79NV5t7H1LMooL+mcmCncEvs5DCILZ1DDbi9eoEV2RUpsnoJ51/BgH7ksMQQXqBXY0N9UJqd1tpm1RnWq1hSEHlW4uIGheBjGDn2mlPMODXEpZib8FQrJcRTBvbut/Ml0VLpHCJSJJo2k7NSnGUk93TTJskkP0zhDr6XAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757995200; c=relaxed/simple;
	bh=rRR+h2Of2ec2W/pKONpv4dnqtbBWLA0qnIeYqw6yMm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mp8Js2a8Q6e2PVB9RNKCCKfaYVPjjLGbb/nCtLf8RXpZtYczh+HNQOEaMmLCe1bbu2aHCXHwOKlhSNEoI3avNzHmEUuEuIN5rHvVzU7H9/7Vl0Ddm7xUceaUx0wwysdiXUoQ16G3Xjc1yIVjdzceAycdo5kqLfhHhTi1DFdC7Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=p7cf7XAQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="p7cf7XAQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2vUTPFHm75Ea9EOz3VvhkjFKSeOEWnsMrsXTTXp82iQ=; b=p7cf7XAQdZSW7R99LRwdY6ci/B
	bvMTd0KbdZI8A9qhA32xqKqlUjyT0HhgY6fxA6fTa6c06wL7YmbyKPp3Q2fCmk9wF4VjRPMya/0dX
	jztddGiu4DAznRFkYEEvQCsOMcnrnKkdjE4rjcFxh/zK3SMUwK4cfGAwQ2Jzxvfoha7tfpKJaDyno
	mgCC59Yc5Mc8A+Vr6NSgWIWpfybaAt2zQ9d6e8MwisO/Y6MgLHUzpE6adXOPRoZScgeut7RISoXdU
	0xozuZKiGbT74UERqcfPERjjpoNAn4cBjRQeQ5tx5W10VMvmVZelMwlExx97IyS/gKarSk0VcYQYH
	ina4lyZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uyMbi-005lGP-2i;
	Tue, 16 Sep 2025 11:59:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Sep 2025 11:59:51 +0800
Date: Tue, 16 Sep 2025 11:59:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: [v2 PATCH 1/2] crypto: ahash - Allow async stack requests when
 specified
Message-ID: <aMjgt0tHK2JZD1B9@gondor.apana.org.au>
References: <cover.1757396389.git.herbert@gondor.apana.org.au>
 <9d6b10c1405137ab1d09471897536f830649364f.1757396389.git.herbert@gondor.apana.org.au>
 <f1b90764-b2f4-ff90-f4c4-a3ddc04a15f6@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1b90764-b2f4-ff90-f4c4-a3ddc04a15f6@redhat.com>

On Mon, Sep 15, 2025 at 05:06:51PM +0200, Mikulas Patocka wrote:
> 
> Would it be possible to export the function crypto_ahash_stack_req_ok, so 
> that I could know up-front whether having a request on the stack will 
> succeed or not?
> 
> Perhaps the function crypto_ahash_stack_req_ok could take "struct 
> crypto_ahash *" argument rather than "struct ahash_request, *" so that I 
> would know in advance whether it makes sense to try to build the request 
> on the stack or not.

I think the pain point is the use of SG lists.  If we could convert
them to something like iov's then you should be able to supply stack
memory unconditionally.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
