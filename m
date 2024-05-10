Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5259C131192
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 08:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715328957; cv=none; b=uscaxicvsYV1uxL/JcOXskbpVdGsizYfG5XFuz0hycS7bP4wSlPxLkf66cOL6a3aheNA807gvY9EFtjf8ykJztFxWWy7GAYyBSoTm7BzvllKH7e2hiDIkyLUN22b9WTLe8lvR85UCPzflRHSkFtFJJ3/kki33jUjSbN1YMjiz1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715328957; c=relaxed/simple;
	bh=HQITzmBiPB3jnXn587a3o0QM2oTj8Tg+BjGVgxXsoNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZW+DS2MCTso6QBauYocjVxQwjOaB0rwcTsU+CxPLfIm1nf42Hl1jo5hDXbIamM3Y50UZvll3dltV5AyCU2MHyDoStOf2hN5/ePBxQ+oL57h33kwlhteYa7DIzK9pnGx1ySUB3m7zpeNfhDhVmHjnGUEy1v3lWkNK8ap3dkzpnRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5LPy-00DHsQ-0S;
	Fri, 10 May 2024 16:15:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 16:15:50 +0800
Date: Fri, 10 May 2024 16:15:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v3 1/2] certs: Move RSA self-test data to separate file
Message-ID: <Zj3XtsHcwRAv_EvT@gondor.apana.org.au>
References: <20240503043857.45515-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503043857.45515-1-git@jvdsn.com>

On Thu, May 02, 2024 at 11:38:56PM -0500, Joachim Vandersmissen wrote:
>
> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> index 59ec726b7c77..68434c745b3c 100644
> --- a/crypto/asymmetric_keys/Kconfig
> +++ b/crypto/asymmetric_keys/Kconfig
> @@ -86,4 +86,14 @@ config FIPS_SIGNATURE_SELFTEST
>  	depends on PKCS7_MESSAGE_PARSER=X509_CERTIFICATE_PARSER
>  	depends on X509_CERTIFICATE_PARSER
>  
> +config FIPS_SIGNATURE_SELFTEST_RSA
> +	bool "Include RSA selftests"

Please don't ask questinons in Kconfig that we can avoid.  In
this case I see no valid reason for having this extra knob.

One question for FIPS_SIGNATURE_SELFTEST is enough.

Oh and please cc Jarkko Sakkinen <jarkko@kernel.org> since he
picked up two earlier fixes for this and it's best if this went
through his tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
