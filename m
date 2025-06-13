Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268A3257459;
	Fri, 13 Jun 2025 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807072; cv=none; b=d8ZNIlDELpvrv0786mh53gW9cDajVmPk7K3OJ8A3AAaCy00iUsaFGPXnvbWXM72k/lLfNC+vn4CSblxQHYFNYmR/PA3LoyvTsdQ78ExbUOtE1CAYLRipAjsFjGddLmRARJLxstrO5aBsvDR/rv9yP4n5FT1GNLnCmg/2RFIH+aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807072; c=relaxed/simple;
	bh=R3l20k8NlcV+2vzrwNKSEKC7MbB6GE6PnqzX8CF2UTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mSwzEURvfdk9vxEZtc7hrEX34PZwZOS5h+jhqAlTHw0hVgeGFT1cqdQ8z5kSwv6Oo9fsPgE/FA3epuGf2A0UrF+Pcrf+M+rLzImZ96q78Q4RgXB+ZZTtq1NjVgSolOA1Rsbd2F30iapKPI9ZL+7DEiJL+3GvsaSNAt1EFnxHP+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iousuU5S; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iousuU5S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=19OIBPV2PRRFQAHbdt8ehcYkv41yzHgzQ1sV7QGszuY=; b=iousuU5SVXu9veggwS19mD4kzy
	RSJOoNfKueUDDkryO20lzJyCl2EJnt0zpD+dx0CMBKL/bGKqFa4cIpTHkUKI8qPYVRXbPxyn7WTgt
	/65fBEbRilYaRTc5ECDfq341WfrdUvtyZD5d+TgrbrEi6dBdj8WECFy+6oCbqfmK1tYTXNzNDsWMB
	fcfbreHPuhiipbJlj0i/McTN51jxT2RnMzCdH1ow4MF7ql65j3eeRuJv9zZXbWpkxZni9BFXLxfS8
	SrWuUXA5SNjnNJSoSWuRgeTJ1D4RwpMCI4BR+kVpl8SfbuO2+Upru5Q5wDB64Bb8ach5h+kgrof+/
	AxCvquNA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQ0kb-00Cstk-09;
	Fri, 13 Jun 2025 17:31:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jun 2025 17:31:05 +0800
Date: Fri, 13 Jun 2025 17:31:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Diederik de Haas <didi.debian@cknow.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH v2] crypto: testmgr - reinstate kconfig control over full
 self-tests
Message-ID: <aEvv2QL-EJ3zF2XK@gondor.apana.org.au>
References: <20250612174709.26990-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612174709.26990-1-ebiggers@kernel.org>

On Thu, Jun 12, 2025 at 10:47:09AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Commit 698de822780f ("crypto: testmgr - make it easier to enable the
> full set of tests") removed support for building kernels that run only
> the "fast" set of crypto self-tests by default.  This assumed that
> nearly everyone actually wanted the full set of tests, *if* they had
> already chosen to enable the tests at all.
> 
> Unfortunately, it turns out that both Debian and Fedora intentionally
> have the crypto self-tests enabled in their production kernels.  And for
> production kernels we do need to keep the testing time down, which
> implies just running the "fast" tests, not the full set of tests.
> 
> For Fedora, a reason for enabling the tests in production is that they
> are being (mis)used to meet the FIPS 140-3 pre-operational testing
> requirement.
> 
> However, the other reason for enabling the tests in production, which
> applies to both distros, is that they provide some value in protecting
> users from buggy drivers.  Unfortunately, the crypto/ subsystem has many
> buggy and untested drivers for off-CPU hardware accelerators on rare
> platforms.  These broken drivers get shipped to users, and there have
> been multiple examples of the tests preventing these buggy drivers from
> being used.  So effectively, the tests are being relied on in production
> kernels.  I think this is kind of crazy (untested drivers should just
> not be enabled at all), but that seems to be how things work currently.
> 
> Thus, reintroduce a kconfig option that controls the level of testing.
> Call it CRYPTO_SELFTESTS_FULL instead of the original name
> CRYPTO_MANAGER_EXTRA_TESTS, which was slightly misleading.
> 
> Moreover, given the "production kernel" use case, make CRYPTO_SELFTESTS
> depend on EXPERT instead of DEBUG_KERNEL.
> 
> I also haven't reinstated all the #ifdefs in crypto/testmgr.c.  Instead,
> just rely on the compiler to optimize out unused code.
> 
> Fixes: 40b9969796bf ("crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS")
> Fixes: 698de822780f ("crypto: testmgr - make it easier to enable the full set of tests")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This patch is targeting the crypto tree for 6.16.
> 
> Changed in v2:
>    - Made CRYPTO_SELFTESTS depend on EXPERT
>    - Removed 'default y' from CRYPTO_SELFTESTS_FULL
>    - Improved commit message
> 
>  crypto/Kconfig                 | 25 +++++++++++++++++++++----
>  crypto/testmgr.c               | 15 ++++++++++++---
>  include/crypto/internal/simd.h |  6 ++++--
>  lib/crypto/Makefile            |  2 +-
>  4 files changed, 38 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
