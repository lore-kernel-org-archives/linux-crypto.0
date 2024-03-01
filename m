Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F47339B1
	for <linux-crypto@vger.kernel.org>; Fri,  1 Mar 2024 10:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709289433; cv=none; b=UPfSt2LAUnLftrTDUDi5d5jMpYxeu54AtIBK8K8ph4lUNWDbNEGSdw1uyza4uQ/t4fd8dpa/faG50hoEHA9Hxt4+MZPWSnJvNOCgbOv3K4FsaWTmfAD/wSwVxrIjqI5YJBpBxO3xixIQmOcSIEebIWKUQ3KbFVotfhCycFbHzqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709289433; c=relaxed/simple;
	bh=vnrrAWvuoftL1aeJ8dlr+yyTDXmBz2ZGBPG90GMHP14=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=fL4dBlLqJrGLBDF+K2p/SmBkmioyi0MywIQbhgCNci1dUXuYqSdbKp1ooa5glqR5DK1MMuqMj94+CTY0gNPmFBJbycM2VaS0oI2AXupsZ96txCUunbcU/WLha+kq6PFEaNBQDnvmMB7ote6eHUMX8duqZDcYmPO1Szt2oRaVaVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rg0GG-002HF1-Nv; Fri, 01 Mar 2024 18:37:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 01 Mar 2024 18:37:19 +0800
Date: Fri, 1 Mar 2024 18:37:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, clabbe@baylibre.com
Subject: Re: [RFC PATCH] crypto: remove CONFIG_CRYPTO_STATS
Message-ID: <ZeGv37BjlO11V0+a@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223090334.167519-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove support for the "Crypto usage statistics" feature
> (CONFIG_CRYPTO_STATS).  This feature does not appear to have ever been
> used, and it is harmful because it significantly reduces performance and
> is a large maintenance burden.
> 
> Covering each of these points in detail:
> 
> 1. Feature is not being used
> 
> Since these generic crypto statistics are only readable using netlink,
> it's fairly straightforward to look for programs that use them.  I'm
> unable to find any evidence that any such programs exist.  For example,
> Debian Code Search returns no hits except the kernel header and kernel
> code itself and translations of the kernel header:
> https://codesearch.debian.net/search?q=CRYPTOCFGA_STAT&literal=1&perpkg=1
> 
> The patch series that added this feature in 2018
> (https://lore.kernel.org/linux-crypto/1537351855-16618-1-git-send-email-clabbe@baylibre.com/)
> said "The goal is to have an ifconfig for crypto device."  This doesn't
> appear to have happened.
> 
> It's not clear that there is real demand for crypto statistics.  Just
> because the kernel provides other types of statistics such as I/O and
> networking statistics and some people find those useful does not mean
> that crypto statistics are useful too.
> 
> Further evidence that programs are not using CONFIG_CRYPTO_STATS is that
> it was able to be disabled in RHEL and Fedora as a bug fix
> (https://gitlab.com/redhat/centos-stream/src/kernel/centos-stream-9/-/merge_requests/2947).
> 
> Even further evidence comes from the fact that there are and have been
> bugs in how the stats work, but they were never reported.  For example,
> before Linux v6.7 hash stats were double-counted in most cases.
> 
> There has also never been any documentation for this feature, so it
> might be hard to use even if someone wanted to.
> 
> 2. CONFIG_CRYPTO_STATS significantly reduces performance
> 
> Enabling CONFIG_CRYPTO_STATS significantly reduces the performance of
> the crypto API, even if no program ever retrieves the statistics.  This
> primarily affects systems with large number of CPUs.  For example,
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2039576 reported
> that Lustre client encryption performance improved from 21.7GB/s to
> 48.2GB/s by disabling CONFIG_CRYPTO_STATS.
> 
> It can be argued that this means that CONFIG_CRYPTO_STATS should be
> optimized with per-cpu counters similar to many of the networking
> counters.  But no one has done this in 5+ years.  This is consistent
> with the fact that the feature appears to be unused, so there seems to
> be little interest in improving it as opposed to just disabling it.
> 
> It can be argued that because CONFIG_CRYPTO_STATS is off by default,
> performance doesn't matter.  But Linux distros tend to error on the side
> of enabling options.  The option is enabled in Ubuntu and Arch Linux,
> and until recently was enabled in RHEL and Fedora (see above).  So, even
> just having the option available is harmful to users.
> 
> 3. CONFIG_CRYPTO_STATS is a large maintenance burden
> 
> There are over 1000 lines of code associated with CONFIG_CRYPTO_STATS,
> spread among 32 files.  It significantly complicates much of the
> implementation of the crypto API.  After the initial submission, many
> fixes and refactorings have consumed effort of multiple people to keep
> this feature "working".  We should be spending this effort elsewhere.
> 
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/s390/configs/debug_defconfig            |   1 -
> arch/s390/configs/defconfig                  |   1 -
> crypto/Kconfig                               |  20 ---
> crypto/Makefile                              |   2 -
> crypto/acompress.c                           |  47 +----
> crypto/aead.c                                |  84 +--------
> crypto/ahash.c                               |  63 +------
> crypto/akcipher.c                            |  31 ----
> crypto/compress.h                            |   5 -
> crypto/{crypto_user_base.c => crypto_user.c} |  10 +-
> crypto/crypto_user_stat.c                    | 176 -------------------
> crypto/hash.h                                |  30 ----
> crypto/kpp.c                                 |  30 ----
> crypto/lskcipher.c                           |  73 +-------
> crypto/rng.c                                 |  44 +----
> crypto/scompress.c                           |   8 +-
> crypto/shash.c                               |  75 +-------
> crypto/sig.c                                 |  13 --
> crypto/skcipher.c                            |  86 +--------
> crypto/skcipher.h                            |  10 --
> include/crypto/acompress.h                   |  90 +---------
> include/crypto/aead.h                        |  21 ---
> include/crypto/akcipher.h                    |  78 +-------
> include/crypto/algapi.h                      |   3 -
> include/crypto/hash.h                        |  22 ---
> include/crypto/internal/acompress.h          |   7 +-
> include/crypto/internal/cryptouser.h         |  16 --
> include/crypto/internal/scompress.h          |   8 +-
> include/crypto/kpp.h                         |  58 +-----
> include/crypto/rng.h                         |  51 +-----
> include/crypto/skcipher.h                    |  25 ---
> include/uapi/linux/cryptouser.h              |  28 +--
> 32 files changed, 77 insertions(+), 1139 deletions(-)
> rename crypto/{crypto_user_base.c => crypto_user.c} (98%)
> delete mode 100644 crypto/crypto_user_stat.c
> delete mode 100644 include/crypto/internal/cryptouser.h

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
