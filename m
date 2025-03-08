Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DF31624F7
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 10:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741431161; cv=none; b=Ym8IPtKVxEz3aUHorOFA/BOslEbBj1rf5nEK2liFTvkrIO8HxSD0bJplU0COrYpvuyAJwlSLJDTBq256eFxsOFrRewX6r6lUx3RL7LZYXAs92SGU8mG8oGpyUQmVR6dcLwB0RRI9y78HlrKB+KEWBq6N5KAO3YxiI/d5tPzDSlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741431161; c=relaxed/simple;
	bh=vcm7wqbSCkLaHyEuQijggd1ynGR1VqDiUiTMyrPKZjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZARu0KENk3gmsk6lkg10BkLqIOOJoYAYw4RXqaqsRo5HPvWQzG6TB31hnvGVFq9K6HAEYjQ06AbyfvMgbI36Q2+0SqppHdRBJkNHnjhH08zPQfVwkq5tjy4HhtCPhviFP2JLpYqqQp2nefeWdfue51/oD7NaEqnIcMrDEKi/CwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=i1sK6gTk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="i1sK6gTk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i4Ioxi0BaDs9kAfH6w51xLNZKkDtNdTfN/rFTJ6CFf4=; b=i1sK6gTkvcpfmbyhqhZaB1EGwB
	SNpnEVFztU0kK4s7I3ZyNPX8JStBIUJKRkVRhoLki4KodWYzQK51qpck/RShojrokWu5Lv849kDNe
	pleLiWpjlf09keClWuE9xS/JXZ9NAN74f8HU+iEykiWovfwWrvdKqPwHdX1EtVbOuEQcaktnSV27m
	VDGsceJgL0uGnelhdpSGS0mfsZbuUxEzNMADw3bdzGznG+glonqasrezBEAo4YAnyKIH26s4wuxYD
	vV1wMAg6D7cEsnJKZAJFZrDVtXvP/qZxjY8PtPwtOLGxiMVRkL6v+HUIQTltPF2xmxcEZcLzPTBI6
	rzhn/iuA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqrnH-004qJo-0i;
	Sat, 08 Mar 2025 18:52:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 18:52:35 +0800
Date: Sat, 8 Mar 2025 18:52:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/3] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <Z8whc1HklIA3rBNi@gondor.apana.org.au>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
 <18a6df64615a10be64c3c902f8b1f36e472548d7.1741318360.git.herbert@gondor.apana.org.au>
 <20250307213749.GA27856@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307213749.GA27856@quark.localdomain>

On Fri, Mar 07, 2025 at 01:37:49PM -0800, Eric Biggers wrote:
>
> There's no user of this yet, but presumably this is going to be used to replace
> some of the bizarre code that is using the "null skcipher" to copy between two
> scatterlists?  For example the code in crypto/seqiv.c.

It was actually for zram:

https://lore.kernel.org/all/Z8kiRym1hS9fB2mE@gondor.apana.org.au/

But yes we could definitely replace the null skcipher with this.
Do you want to have a go at that?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
