Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB717E556
	for <linux-crypto@vger.kernel.org>; Sun, 12 May 2024 07:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715498205; cv=none; b=GCS8YMP0Q/VtGlZgfJe7fZHfaDXJcPbnp08VgcIWNFW4RRExY2a02FA3lCuZMFvzxZ/lJJkWsqYTKMqYg3BRy3zfj5tgdNt/Ix3QNbKQukCX3dAwdfkb8Ivfh7ouda1smcbQLUf1H9Y4aYq10r0vqjkRS6apxZN1FZwuB6ZGgJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715498205; c=relaxed/simple;
	bh=UdRZpwjksOiEp5OqlGEHGs/AkBHKKmEqxC7v//W2Ou0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hM0zqitW+mdCH7LE+tB/NUTXWgmw33KrD/X7xjiShv7vlUTjtvueAXEpoB2yuroLmH73rXfiFm9q6BLAcJP79EO1WAAfTYMugQORr18ZjbqvBIXupai+DBBQ+mu3b8ybArrdoiYFoRzF/t1I7WRBUoVU13TXsKzoDBLW1a5eQlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s63Rc-00E916-21;
	Sun, 12 May 2024 15:16:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 May 2024 15:16:29 +0800
Date: Sun, 12 May 2024 15:16:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v4 2/2] certs: Add ECDSA signature verification self-test
Message-ID: <ZkBszYFDttYHph8C@gondor.apana.org.au>
References: <20240511062354.190688-1-git@jvdsn.com>
 <20240511062354.190688-2-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240511062354.190688-2-git@jvdsn.com>

On Sat, May 11, 2024 at 01:23:54AM -0500, Joachim Vandersmissen wrote:
> v4: FIPS_SIGNATURE_SELFTEST_ECDSA is no longer user-configurable and will
> be set when the dependencies are fulfilled.
> 
> ---8<---
> 
> Commit c27b2d2012e1 ("crypto: testmgr - allow ecdsa-nist-p256 and -p384
> in FIPS mode") enabled support for ECDSA in crypto/testmgr.c. The
> PKCS#7 signature verification API builds upon the KCAPI primitives to
> perform its high-level operations. Therefore, this change in testmgr.c
> also allows ECDSA to be used by the PKCS#7 signature verification API
> (in FIPS mode).
> 
> However, from a FIPS perspective, the PKCS#7 signature verification API
> is a distinct "service" from the KCAPI primitives. This is because the
> PKCS#7 API performs a "full" signature verification, which consists of
> both hashing the data to be verified, and the public key operation.
> On the other hand, the KCAPI primitive does not perform this hashing
> step - it accepts pre-hashed data from the caller and only performs the
> public key operation.
> 
> For this reason, the ECDSA self-tests in crypto/testmgr.c are not
> sufficient to cover ECDSA signature verification offered by the PKCS#7
> API. This is reflected by the self-test already present in this file
> for RSA PKCS#1 v1.5 signature verification.
> 
> The solution is simply to add a second self-test here for ECDSA. P-256
> with SHA-256 hashing was chosen as those parameters should remain
> FIPS-approved for the foreseeable future, while keeping the performance
> impact to a minimum. The ECDSA certificate and PKCS#7 signed data was
> generated using OpenSSL. The input data is identical to the input data
> for the existing RSA self-test.
> 
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
> ---
>  crypto/asymmetric_keys/Kconfig          |  7 ++
>  crypto/asymmetric_keys/Makefile         |  1 +
>  crypto/asymmetric_keys/selftest.c       |  1 +
>  crypto/asymmetric_keys/selftest.h       |  6 ++
>  crypto/asymmetric_keys/selftest_ecdsa.c | 89 +++++++++++++++++++++++++
>  5 files changed, 104 insertions(+)
>  create mode 100644 crypto/asymmetric_keys/selftest_ecdsa.c

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
