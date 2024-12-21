Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E989B163
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 11:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734780456; cv=none; b=a+1g5KUFrpw1aSUQUCoGcvqITYKSzr6xpjgCWWFHPdp/K9Wu9ZMaI3xS8lUSSwQqURg9puL0osqTdllv5wWoWKf7mTZbmwLNaAT+NL9mU941ImP+amIFR+/uuq6hVSEupscrKdvzvnAGT9wEb1Ta0gXtVS+/9eZ5n4AZXacAGxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734780456; c=relaxed/simple;
	bh=EI2bncRqzkO+KlWQ1KnBHVi/+C7snf9MtRz/5iB1DRk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=eWpocBft7aaloSzNxTi3r2EumA/ajYLz/nmBtpS93F77Zku+ie7N8wop4Sv6VK5TMO1gE6bkGD/VeYavCN7EtZCS6ZR2C47hRyCWjC/E3aV+4tlgG/ih7pre0J3TvGs+R3VzKh7w1rZBQR0brqqzpsP9/D1qjqZ2YB9XNXacJKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=foKwQ7R7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="foKwQ7R7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3zz3dy8T8M7hmkIrbm7h8ZLbyEOPvvP+3AlkUEsdHAE=; b=foKwQ7R73xcQQB70TgIwg2eaBj
	CuH1GuOzcasFgZVxbNXzpydL7GaxKnBsGsud0vuHm1k2GMFqqYPDXR/Z5A2D7pY9ZTM2KBH1ziHWW
	th4GDadZjpNaXiegTPFOQJ7PD/rRmjsP6ae13BGWXJxA1dDfpOp5IM+SLBgDajgHwzhxgX4vdM2Zv
	CKkP/2sPOFPMFTKRpPgrRCKtoii9zuXv35573hAlVEhhX/ErphLaDAo4g9+l9YlnhbYO/vFwB8neU
	huPfg0wSErYFsoWb9EBM+HnetCbzbYteEtQnMeQ535wEwcn6UsFvOVAof6sHhZMaxmolMpMngWaKr
	n5E7kQHQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tOxQv-002QZ5-0s;
	Sat, 21 Dec 2024 19:27:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Dec 2024 19:27:30 +0800
Date: Sat, 21 Dec 2024 19:27:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 13/29] crypto: scatterwalk - add new functions for
 iterating through data
Message-ID: <Z2amIuU1sLDWBsSh@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241221091056.282098-14-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
>
> +       if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
> +               flush_dcache_page(scatterwalk_page(walk));

Does the if statement do anything? If so please add a comment
about what it does because it's not obvious.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
