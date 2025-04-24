Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE34D528;
	Thu, 24 Apr 2025 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745488406; cv=none; b=gHbaiF/46fPLbBir0I1xP6tAExnQGYmqBsRlmx4ZQ0wTsRuq/zjewMqF20dRz7ujuYL6tGEWcZvAjEWiMmnqr1Y2OOXYAXgkwyemr4BDWsatMVHjKUOAXEkxY/kvZLT521eNy0DfD2knELDWRBrPMfKvQR/FJmkYE+9Qkp+EpOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745488406; c=relaxed/simple;
	bh=+a8F1GE/DV7AcJZ6j9RT2Z0XwwF/zXXWY3WBY7US3TQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=KWMt8ZQoNzD9synL3lbZWWEM4X3eN5I4R9VcjYj15rE1w/SxQprLFSqe1oOtmpEShPdJ6Hi+ztfNhuXf11C42vVIFFjJv29OovxH+uRlUssx9v9DJUk1S44dSbN9j/MH8WwKehdGkR5tnpI/hpFJZBQLYrmhdwgFkykvN31Pn+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hh1CHvww; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hh1CHvww"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8tJL41rzj+W5wPS4oA7oBdTUYTp3XnQt8bhD/Uu9ztE=; b=hh1CHvwwEnASTY6PQ14jJjxgGC
	HkSScSVbN/EZdKwkVcledGI0gq4cVLL+yFBCk0Qghq/b+JgS9jjtK4pgMqHz+SiXzqfod9hC59OB5
	SSTmu9cj24Nq136QTNs7AUmn/cl/nkEa6IoWR9F8+OG6osHvaVAlsk9EWqar6Z2SimXrq3VNvnMxd
	MxRLO/xcRYyiYdBZB1cyen4H7Js+LiyOW6nZlIRF9S+7cifU0/5UEZbJZeRoCsrI+ua6x3m+AqL8t
	UGtRPjVNvgCj1I3Wt4H9SCDd5rvI45uRfZPK6CkQLNsBl82P/5aJBgTfun9a1+fg26leHJKSrsiSi
	YqPMiSbQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7tGg-000eQa-1q;
	Thu, 24 Apr 2025 17:53:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 17:53:18 +0800
Date: Thu, 24 Apr 2025 17:53:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/9] crypto: testmgr - replace
 CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS
Message-ID: <aAoKDnfJLyI7n58S@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422152151.3691-6-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
>
> -config CRYPTO_MANAGER_DISABLE_TESTS
> -       bool "Disable run-time self tests"
> -       default y
> +config CRYPTO_SELFTESTS
> +       bool "Enable crypto self-tests"
>        help

Please add a dependency on EXPERT.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
