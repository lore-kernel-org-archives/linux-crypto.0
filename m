Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5293A1B7
	for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 05:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714022292; cv=none; b=WF4Cv/0uFZSLxsz+zgX1j/gBIuGDZELyvVqOVNzytyhRvlH4yQpQU4lXAHH4/R/HwbYzsr1t0UuHUIT+cIyV24IldLku9tak++RgvVB1RWKDJcuFSI3qrC+OWOEIFaBZzmXbZfEFDjaBoj68QEEG10wHsZJ+8I+xzSO1ZlSJT9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714022292; c=relaxed/simple;
	bh=E5MmqFwiAXqxPyR9bmU7FgCbWt9lOc9HJe+ioCH1kkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QByKW7s2cDvo2/vzii6kbq6rAR5oUi885PNwji05tfiwfaiNZtPBY+o+so9nzVAYKJ+szbdLdQZBDhD+sLhBoalIwTdWkuGqJTnNB/TMzMB4x02jLNV4U9mqbAWmjbYJxxZPe/XcrWgvh4xe1DT1RkrjJDl1lPUadZXOIXriObs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rzrUb-0067TH-Jb; Thu, 25 Apr 2024 13:17:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 25 Apr 2024 13:18:15 +0800
Date: Thu, 25 Apr 2024 13:18:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 1/2] certs: Move RSA self-test data to separate file
Message-ID: <Zinnl2Y11i0GHLEO@gondor.apana.org.au>
References: <20240420054243.176901-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240420054243.176901-1-git@jvdsn.com>

On Sat, Apr 20, 2024 at 12:42:42AM -0500, Joachim Vandersmissen wrote:
> Herbert, please let me know if this is what you had in mind. Thanks.

Thanks, it's pretty much what I had in mind.
 
> diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
> index 1a273d6df3eb..4db6968132e9 100644
> --- a/crypto/asymmetric_keys/Makefile
> +++ b/crypto/asymmetric_keys/Makefile
> @@ -24,6 +24,7 @@ x509_key_parser-y := \
>  	x509_public_key.o
>  obj-$(CONFIG_FIPS_SIGNATURE_SELFTEST) += x509_selftest.o
>  x509_selftest-y += selftest.o
> +x509_selftest-$(CONFIG_CRYPTO_RSA) += selftest_rsa.o

This doesn't work if RSA is a module.  So you need to play a bit
more of a game with Kconfig to get it to work.  Perhaps define
an extra Kconfig option for it:

config FIPS_SIGNATURE_SELFTEST_RSA
	def_bool (FIPS_SIGNATURE_SELFTEST=m && CRYPTO_RSA!=n) || CRYPTO_RSA=y

and then

x509_selftest-$(CONFIG_FIPS_SIGNATURE_SELFTEST_RSA) += selftest_rsa.o

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
