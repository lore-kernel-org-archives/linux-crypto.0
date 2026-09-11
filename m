Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28F12F7EE4;
	Fri, 11 Sep 2026 05:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104647; cv=none; b=HZGwMRoSQB2qpotUTiqXQ6u3RAmX6UuyGFvK0aDseZaSwgfeKjeKYsfHESl79/G3s7HXrF8W7QRc5POPfvmxgWkghFpALxC8CHa38RZJdaBzYXjoYY7pGkEnzuoq4syDJuIwVGC8fiyTgPy8AXr1MbNo3QBJA3zL+V+KzLlmJ0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104647; c=relaxed/simple;
	bh=kqLOW4vPBYyD7OU6mGwgBc1GuUJkM5GEZ5s6moopCSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pzRTU0r/XYQIwAyVotv3Wl0ZiGpnR03rCOUpcrKy9KJNE+Kx2Xe2FlfNqkdQ+bL/P6TGmSy1JUofTB3ivs6UQJ9nAiFDPVBxa8GHzTiX04JvDjZtKGfgX1q+NYal/7Hr0J+6vN1bovmL4cP1v7wa2LuwCLzFZITWLSIivqdutIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Let7sX4q; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Let7sX4q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rgJozweawLpWUJj1d7YiUL9Emkn589aJkBOuWhRLNx0=; 
	b=Let7sX4qt9HjiuqCfTJ64/c11W+w5Zgm0wUOEs9tadrWnxu1Y9jv8S0XaT0jQwCiWzmEd6XUBbj
	U/ICqd5/gNGF3w89nLfvRdcBLKXGDRvioH4iF9gOEuS35EtlrS+f8wWZV3y9BUecn+xvrAWigmHYs
	APgBPK5CmbUDH4YtYiqnW5Su+voMyMse36GHQwbjB3EPrr0MCcL10klvxLGS6VuHWSAqfazLdWlth
	qg9Ol3UYxfA5uMACWfHeTi5Qxs4IDW/xe3NFaYEiK29lWDV/WNTAu2o6+XsXeKO7s7ic50xuNKvDq
	zqk4ZionA+AWMm2My/1zun2BtB2prmIGTgew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tqN-0000000CuB5-2nhO;
	Fri, 11 Sep 2026 13:30:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:30:35 +1000
Date: Fri, 11 Sep 2026 15:30:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Haren Myneni <haren@us.ibm.com>, Dan Streetman <ddstreet@ieee.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] lib/842: reject malformed streams before invalid
 memory accesses
Message-ID: <aqOR-_Q_citLLJqQ@gondor.apana.org.au>
References: <cover.1787978627.git.kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1787978627.git.kmehltretter@gmail.com>

On Sat, Aug 29, 2026 at 11:18:48AM +0200, Karl Mehltretter wrote:
> sw842_decompress() backs the crypto 842 algorithm, the NX-842 software
> fallback and zram's 842 backend. Two malformed-stream checks are missing:
> 
>   - indexed and short-data templates can write beyond the caller's stated
>     output capacity; and
>   - a repeat after one to seven bytes of short data reads before the
>     output buffer.
> 
> The first underflows the unsigned remaining length, so every later capacity
> check passes. The decoder keeps writing past the destination and can
> return success with an output length the caller will trust.
> 
> The decoder already returns errors for format, capacity and CRC problems;
> these two cases perform invalid accesses instead.
> 
> Patches 1 and 2 add the checks. After them every output write site is
> capacity-checked, repeat cannot read before the output, and all input reads
> stay bounded. Patch 3 adds KUnit cases for the three malformed streams and
> for three valid streams at the exact acceptance boundaries, so the new
> rejections cannot regress into off-by-one.
> 
> The KMSAN reports from
> syzbot+e774233ff687aada969e and syzbot+8f77ff6144a73f0cf71b are unrelated.
> They trace poison from uninitialized swapped-page storage, not these bounds
> failures.
> 
> KUnit under QEMU 10.2.1 TCG, two vCPUs:
> 
>                   baseline      fixed
>   i386              3/6          6/6
>   x86_64            3/6          6/6
> 
> Baseline runs applied patch 3 alone: the three boundary cases pass, the
> three malformed streams wrongly return success. A fixed x86_64 lockdep
> kernel also passes 6/6.
> 
> Separately, an x86_64 KASAN QEMU run exercised all three malformed cases
> through zram's compressed writeback path by corrupting the backing-disk
> contents after writeback. The baseline reported two out-of-bounds writes
> and one out-of-bounds read; fixed readback returned -EIO in all three cases
> without a KASAN report.
> 
> Karl Mehltretter (3):
>   lib/842: reject output overflows from index and short data
>   lib/842: require a complete history block for repeat templates
>   lib/842: add KUnit tests for the decompressor
> 
>  MAINTAINERS                      |   1 +
>  lib/842/842_decompress.c         |   7 +-
>  lib/Kconfig.debug                |  15 ++++
>  lib/tests/842_decompress_kunit.c | 144 +++++++++++++++++++++++++++++++
>  lib/tests/Makefile               |   1 +
>  5 files changed, 167 insertions(+), 1 deletion(-)
>  create mode 100644 lib/tests/842_decompress_kunit.c
> 
> 
> base-commit: cf72cbb39da84b6f02f90c07f33b102fc10b16f0
> -- 
> 2.53.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
