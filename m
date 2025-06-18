Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9316927FB3B;
	Wed, 18 Jun 2025 08:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750237130; cv=none; b=fVyokrSUPEMhfWxiIXkyTk/pzy3wd3c7pNhrGS0HxchdxCvpckclSOZnX0A3T19UbxR91/2yneOydi5yVx6wTFPXAuc+iKiCm8eZLjDeUOJYp1OceH8iL+mLCcgGXC1aJ80ehm5IWQDe1G8cFtdijiZ8dlClyhYiPYh+S3Ak0/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750237130; c=relaxed/simple;
	bh=5M+epsQJuYsgtW1xT9tVo9CfIRyK4mYVTJnnaBSlvFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sukt6m1GSFwu/gSDAMFmiZnoB084BsXKLp9CCbh3VrVsOgFBk5E8HrXFJGWSnSBc64Tp5YxrrM9EMKMmiwBWxVFD4G4kReKrO1OfpKfrDVPyD1z34BEk9ZxDbYbWdMhKuIzhnxZVgT2rKnGB0+95PWA7hcGaZZCT9u6L/e5j/+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PfNtoGMP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PfNtoGMP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i1ZZ6oG+6yWbqdMTo+o/eUA7r/zkbPIbRks8u9ynkkg=; b=PfNtoGMP/g2nY1Q8g6u7kajrt7
	FLJjZMKAqegDssrNVJ4TxFwGQknxnmZ+Z9D3IejKLYz5dHGAQcsN4Edu6UyewIsXHSinmrgPVJM8Q
	pt7+VOWGNvRPxSNDiq9VpfGFFcLsv06r3pdDX+doEBm0RcMYmDgR/PODTyGCdzGaxaC787R4IAUdR
	zH2rAlJI9gdiVBbOVipgPnK/ieBKOSG+7Hj+aHlZRqWliHly8xyR/450/k4Pz6uOiZcy7MS3s6vwI
	X27CSq8buiN+bBMvN4rJk6jb0yvQe94YPv2Cx2q4rWdjSwRuW6JAo9yfVElvvUzhg2xVTvKlIUb9B
	r5xgJJhw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uRoNl-000u17-0R;
	Wed, 18 Jun 2025 16:58:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 18 Jun 2025 16:58:36 +0800
Date: Wed, 18 Jun 2025 16:58:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	dengler@linux.ibm.com, ifranzki@linux.ibm.com,
	fcallies@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com
Subject: Re: [PATCH v12 0/6] New s390 specific protected key hmac
Message-ID: <aFJ_vFIrVWZX-_5r@gondor.apana.org.au>
References: <20250617134440.48000-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617134440.48000-1-freude@linux.ibm.com>

On Tue, Jun 17, 2025 at 03:44:34PM +0200, Harald Freudenberger wrote:
> Add support for protected key hmac ("phmac") for s390 arch.
> 
> With the latest machine generation there is now support for
> protected key (that is a key wrapped by a master key stored
> in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
> for the s390 specific CPACF instruction kmac.
> 
> This patch adds support via 4 new hashes registered as
> phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).
> 
> Changelog:
> v1: Initial version
> v2: Increase HASH_MAX_DESCSIZE generic (not just for arch s390).
>     Fix one finding to use kmemdup instead of kmalloc/memcpy from test
>     robot. Remove unneeded cpacf subfunctions checks. Simplify
>     clone_tfm() function. Rebased to s390/features.
> v3: Feedback from Herbert: Use GFP_ATOMIC in setkey function.
>     Feedback from Holger: rework tfm clone function, move convert key
>     invocation from setkey to init function. Rebased to updated
>     s390/features from 11/7/2024. Ready for integration if there are
>     no complains on v3.
> v4: Rewind back more or less to v2. Add code to check for non-sleeping
>     context. Non-sleeping context during attempt to derive the
>     protected key from raw key material is not accepted and
>     -EOPNOTSUPP is returned (also currently all derivation pathes
>     would in fact never sleep). In general the phmac implementation is
>     not to be used within non-sleeping context and the code header
>     mentions this. Tested with (patched) dm-integrity - works fine.
> v5: As suggested by Herbert now the shashes have been marked as
>     'internal' and wrapped by ahashes which use the cryptd if an
>     atomic context is detected. So the visible phmac algorithms are
>     now ahashes. Unfortunately the dm-integrity implementation
>     currently requests and deals only with shashes and this phmac
>     implementation is not fitting to the original goal any more...
> v6: As suggested by Herbert now a pure async phmac implementation.
>     Tested via AF_ALG interface. Untested via dm-integrity as this layer
>     only supports shashes. Maybe I'll develop a patch to switch the
>     dm-integrity to ahash as it is anyway the more flexible interface.
> v7: Total rework of the implementation. Now uses workqueues and triggers
>     asynch requests for key convert, init, update, final and digest.
>     Tested with instrumented code and with a reworked version of
>     dm-integrity which uses asynchronous hashes. A patch for dm-integrity
>     is on the way but yet needs some last hone work.
> v8: Added selftest. With the selftest comes some code which wraps the
>     clear key into a "clear key token" digestible by PKEY. The
>     selftest also uses import() and export(), so these are now also
>     implemented. Furthermore a finup() implementation is now also
>     available. Tested with AF_ALG testcases and dm-integrity, also
>     tested with some instrumented code to check that the asynch
>     workqueue functions do their job correctly. Coding is complete!
> v9: As suggested by Herbert use ahash_request_complete() and surround it
>     with local_bh_disable().
> v10: Split the pkey selftest patch into 3 patches. Slight rework of the
>      setkey function as suggested by Holger: When selftest is running
>      as much as possible of the production code should run. So now the
>      key prep with selftest is one additional if/then block instead of
>      an if/then/else construct.
>      Code is ready for integration and well tested.
> v11: Utterly rework with the insights collected with the paes rework
>      and the basic work done with the pkey rework over the last 5 month.
>      Note that patch #1 effectively reverts commit 7fa481734016
>      ("crypto: ahash - make hash walk functions private to ahash.c")
>      from Eric Biggers.
> v12: Fixed some typos, adaptions to 128 bit total counter,
>      misc_register() invocation was missing in the patches series,
>      added Herbert's proposal for a new function crypto_ahash_tested().
> 
> Harald Freudenberger (5):
>   crypto: ahash - make hash walk functions from ahash.c  public
>   s390/crypto: New s390 specific protected key hash phmac
>   crypto: api - Add crypto_ahash_tested() helper function
>   s390/crypto: Add selftest support for phmac
>   crypto: testmgr - Enable phmac selftest
> 
> Holger Dengler (1):
>   s390/crypto: Add protected key hmac subfunctions for KMAC
> 
>  arch/s390/configs/debug_defconfig |    1 +
>  arch/s390/configs/defconfig       |    1 +
>  arch/s390/crypto/Makefile         |    1 +
>  arch/s390/crypto/phmac_s390.c     | 1048 +++++++++++++++++++++++++++++
>  arch/s390/include/asm/cpacf.h     |    4 +
>  crypto/ahash.c                    |   26 +-
>  crypto/testmgr.c                  |   30 +
>  drivers/crypto/Kconfig            |   13 +
>  include/crypto/internal/hash.h    |   30 +
>  9 files changed, 1133 insertions(+), 21 deletions(-)
>  create mode 100644 arch/s390/crypto/phmac_s390.c
> 
> 
> base-commit: 1029436218e50168812dbc44b16bca6d35721b0b
> --
> 2.43.0

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
