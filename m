Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CEE1C84A1;
	Sat,  6 Sep 2025 07:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757145353; cv=none; b=rtfdQRxG6QvNBAIXTWpd8CWJbqaMwZNk/kRE2g5nUfSYb+1MlgrFCTo+tHklZNT7LhL8fXAjIFwxIlUK9fVPbbBQWT+m72AnY74CXXUyNaJv9aC+MykIJkeOFY8mBj6kV7sx3NSVr+D5fO8cyrOhp/ycrwyou6NfMyq8HwjdaXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757145353; c=relaxed/simple;
	bh=JCtNx9IsXm7arBLs/DMEtCES8D7uHj6PtBUyMBTia1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfNCIth2zYram3+Ye5oX4b9hj6uRu6CqVEoV62lDf43Y/hQWOTx2u3F6kzfw4oQkymbwe61Rzh2GEjMqQIjIZKbZAqbgVCM/rWMUr78rWI9kOEPCjBinM2KC1c46m91SNtK9WroYFDNk7M+A9UPcdDbF5jVMKUbPmeoMzrilDG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PhxU81B6; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PhxU81B6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f1aKR/b5OQnfapkQ3pJ/XnQxKh7Fko8d5DMBKsrfg70=; b=PhxU81B63QeSEWfhJBXAmpCye3
	5lRRHLb8Uf9DB+Hwu/JIaCTyPx+o7fyl0I0tIcwMBTbRLJV2j1cHV+NmNW4oeC6WhUDB3dYy4aOzQ
	NnIvaDE2xYSuEgaLo6y5TEiBf3xVxrHpNnhyiNRjAAt5zaHF0LVOcnMqW/2L1Tfust6wPEkg3he9D
	OsbEWwrAwiLm//fXCk6rYKVQp6ofLcW+iHdG7JJ8EkjJrvce8RC6eGBf0+LXmGFKolgtRh+mKI1Zk
	1hrFdaqbIIZgByoZZ0k1K5Omvg+TFgIjt5KWC2s9Fp2FTEVfXT3ISSD7fY+FiX2iEYYMaWcYHLQqE
	/iOaZ3tQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uunWV-003BM0-0V;
	Sat, 06 Sep 2025 15:55:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Sep 2025 15:55:43 +0800
Date: Sat, 6 Sep 2025 15:55:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Moulding <dan@danm.net>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: [PATCH v2] crypto: acomp: Use shared struct for context alloc
 and free ops
Message-ID: <aLvo__F7Q1jISpaE@gondor.apana.org.au>
References: <20250830032839.11005-2-dan@danm.net>
 <20250830172801.6889-1-dan@danm.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250830172801.6889-1-dan@danm.net>

On Sat, Aug 30, 2025 at 11:28:01AM -0600, Dan Moulding wrote:
>
>  	union {
> -		struct {
> -			void *(*alloc_ctx)(void);
> -			void (*free_ctx)(void *ctx);
> -		};
> +		struct acomp_ctx_ops ctx_ops;
>  		struct crypto_acomp_streams streams;

I added the union because I was too lazy to change every file.
Since you're changing every file, please get rid of the union :)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
