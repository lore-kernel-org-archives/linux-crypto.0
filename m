Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BF52222AA;
	Thu, 22 May 2025 09:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905041; cv=none; b=uE+G4pqO468X/QaLTuhX4ucTKeLqwEQ+xYfD9JcnjB80OJKJmVHZampNPP/wNtQlHuInl4g6VAznjLnScaLYakRDn3zCIrklCUKHt5k7KefEICUCAiy9maMfv5eJYi/rxQxyFToyUCtpXoZzEhiFqWWPA9LF1j8fyVHs+K7pp0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905041; c=relaxed/simple;
	bh=Z7C3FkAdhDHl65bFDBkjPkW9Dg4HAVtrSrOqaJxFKWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iw7cfm2lEamWYYSBQR+icFUDC36o4/mZw1w7boQDaUD7NxYqexRqDwTShivdrHluZlgpT0vmbmkkonC7GIqazxl190opdHq1Tfhc7DI0li0167I7jV5O2izF00QhUwjJbWq+7irTUJ3YgbijbCh3I7P5xmcc8pK96cA46tKNgR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DXG0JjPa; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DXG0JjPa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ovSNxS1fxSZa/ELAjpofGQwNWi6OG9AFazGPgh1bUW4=; b=DXG0JjPacEV6yXspg7m4Xr92+o
	vGpdqeeGNGlMZniWnaQsTkjILGmjFDGY4WxO8BFjL7226oansI/k5FEucju9x4FsafhCqQTeiFKyQ
	Ble/i56GQIc7/+ZTIXmjS/MEwklm9tN85IAQFRNWgIsuPGOTjwa5xQcU+Cg4vHKXaYXNRKQeMalkI
	qqSb4zKGlopsq4ErcgdUP+15LtSryZ687ptpOFLWMe5Wx8OTpC89Gy6gwueCnuIf75z/gCE1MewHI
	FQVFqozo2v77zSYz61o1oQZyrm17iX4S49m+EuzpDiIi6jgVpqA5p//O8cH2nOob5ae4nyKYFmg6G
	ukacg3YQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uI1wg-0082sF-0h;
	Thu, 22 May 2025 17:10:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 May 2025 17:10:34 +0800
Date: Thu, 22 May 2025 17:10:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	fcallies@linux.ibm.com
Subject: Re: [PATCH v11 5/6] s390/crypto: Add selftest support for phmac
Message-ID: <aC7qCsLN84LfWy-e@gondor.apana.org.au>
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-6-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522085755.40732-6-freude@linux.ibm.com>

On Thu, May 22, 2025 at 10:57:54AM +0200, Harald Freudenberger wrote:
>
> +	if (!(crypto_tfm_alg_get_flags(tfm_base) & CRYPTO_ALG_TESTED)) {

I think a better helper would be

	if (!crypto_ahash_tested(tfm)) {

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
