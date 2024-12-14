Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AA3EBE
	for <linux-crypto@vger.kernel.org>; Sat, 14 Dec 2024 04:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734151198; cv=none; b=RxoY+XEbFMNqAjisAAFoisQ//g89p4ZE5RQl70q4VXsnyJgWOgV8b4rDWRzdW5+WP4Pt9SRMvZTpnKm8zNlwEZvcNijep9s0kHFC7BtJG0liNbWHw3Q3aUgpkZHgqwioNPXIm1wHypP3GmgMXvIUJhG2EjXx/vRziNL07alo1UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734151198; c=relaxed/simple;
	bh=/IUVA0fevxMD+qdenfLjtlNeDnDXXK9XqN9X6CqTCLE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Tc1ZOYUf4EDP8NRIZIsQcRP0EPBEZcKOcXWlgT5yGXrMZbJBUJVC3Uy4/l87esvhja7m3mrR96cRhmCcw21e9r6zISJninDg9D4ATUI3bhSUC1qrt/H2Aseynm7P4AUSoqJtpEThcsx75jg2iIicLuCCS/vnXiceNSdVkINsRzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YlJN4FEP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YlJN4FEP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=r/HpSQZwmseo9rDVHNNPLSwfRN+z5edQANw0G1dEzAc=; b=YlJN4FEPOoxStEHXvAGrVTJzda
	ZEGAqhEa4S4tPopJz4twfi2+MOogH5SRtDML1p0xqpg1k+0420a3dXmM7CEV7o8Lrdgw2jZjZRcpE
	0CiOZ0OAGlJurncucn0GplEj20u2z4YeCNTDc4K1KLmpKTXasuJA7f1WYdc+00od6iFEWSrbvf2+v
	gsXsUXzdLn+OgZoJmPHQehzyvC9keVzMgjFZjj9E2/gSRxE0hzfV1q9BmWBiQ0ZkfTosIXjKpHa7K
	Ng2twiehu3O+iKzV+0kR4D3YlE24G58ovrf7udSKxVIlE+yDBPFAYa162+g4g1bol0ULBIwWy3bw7
	Ude6tmbA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tMJjP-001RRD-2M;
	Sat, 14 Dec 2024 12:39:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Dec 2024 12:39:40 +0800
Date: Sat, 14 Dec 2024 12:39:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Hannes Reinecke <hare@kernel.org>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
	linux-nvme@lists.infradead.org, ebiggers@kernel.org,
	linux-crypto@vger.kernel.org, hare@kernel.org
Subject: Re: [PATCH 01/10] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
Message-ID: <Z10MDHc8fYhLyfbw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241203110238.128630-2-hare@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Hannes Reinecke <hare@kernel.org> wrote:
> Separate out the HKDF functions into a separate module to
> to make them available to other callers.
> And add a testsuite to the module with test vectors
> from RFC 5869 (and additional vectors for SHA384 and SHA512)
> to ensure the integrity of the algorithm.
> 
> Signed-off-by: Hannes Reinecke <hare@kernel.org>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> ---
> crypto/Kconfig        |   6 +
> crypto/Makefile       |   1 +
> crypto/hkdf.c         | 573 ++++++++++++++++++++++++++++++++++++++++++
> fs/crypto/Kconfig     |   1 +
> fs/crypto/hkdf.c      |  85 ++-----
> include/crypto/hkdf.h |  20 ++
> 6 files changed, 616 insertions(+), 70 deletions(-)
> create mode 100644 crypto/hkdf.c
> create mode 100644 include/crypto/hkdf.h

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
