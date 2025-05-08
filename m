Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EEF4B1E6F
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 01:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746668308; cv=none; b=WLZ6xUdt9gqgRSGaUj/BpJ1jUIoR0N+QIf1rEANiZ4q/ZLFMRnEw0Rq8OkhiCiOshZsmvTNI6qvByqdEJXmqSo7/tq+PTAVpxneeClPZ5nzvl0utuUwyoMlgVc43Dpep5CKrdS1EVNA29ea0uk5cv5TQ1L7PaxKQTc7im48t414=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746668308; c=relaxed/simple;
	bh=0oC5jJG7M+xDoSuE+i/4KPomJOd8KPJIJ/AcLJKNm9I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=i9xbbjCjuzLcsbJzW7GwufGGd9JfGV8xr2HxrQxjInVTEY5MGvhncj4gW/7lhvzAyfHP7xQaDAdizbLnijVNkQvt0GmyE0xbIIDAS/y2GFGTChMoo5eq+OhbMeHD8I00Y5jKZzJHGtVFfnvH/5cyKAgJ46HH0arVO9YDLOnA8MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gf2rSIyz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gf2rSIyz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4DL/sF/lt2pNiX8ONAJ2XcdbRYc1bavHnLJcYfQuHkk=; b=gf2rSIyz9WcP2bFqZL7t3uNG+Z
	c6TTJrWMne4uXHNVhWZk30iXSan9bFG11+cVdflTGhLm/OPIjfXwgncUOQCcKOGSnagPmWWEhPlgl
	bmKygmVA9yXZZit0J5BxKF4MGWkY4afGm4vB9ke+0DG5piMdbb5RPiGOX1+81Rn94UHDCO+2dQlAa
	8fmmTKBjI+0KfqlXxR197sLV3WYy8ERRp9/eHgUtdFcn5TaWQ037vAnUaKc3Raqh/l+vVSMzu3XZH
	UXs5ax9AJ4o7b/3ZG2lHKmm4GcnqjkUfh82Rl7L0ygN9IihRlhu5ntn3wCPkv3OtZI2EibS+XxeSQ
	v8iHgPxw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCqDJ-004Pex-1y;
	Thu, 08 May 2025 09:38:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 May 2025 09:38:17 +0800
Date: Thu, 8 May 2025 09:38:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	ardb@kernel.org, linux@leemhuis.info, lkp@intel.com
Subject: Re: [PATCH] crypto: arm64/sha256 - fix build when
 CONFIG_PREEMPT_VOLUNTARY=y
Message-ID: <aBwLCXZ83PahQoa_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507170901.151548-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Fix the build of sha256-ce.S when CONFIG_PREEMPT_VOLUNTARY=y by passing
> the correct label to the cond_yield macro.  Also adjust the code to
> execute only one branch instruction when CONFIG_PREEMPT_VOLUNTARY=n.
> 
> Fixes: 6e36be511d28 ("crypto: arm64/sha256 - implement library instead of shash")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505071811.yYpLUbav-lkp@intel.com/
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/arm64/lib/crypto/sha256-ce.S | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
