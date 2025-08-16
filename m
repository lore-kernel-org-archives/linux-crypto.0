Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A971E0DE3
	for <linux-crypto@vger.kernel.org>; Sat, 16 Aug 2025 09:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755336681; cv=none; b=nFQPF7BvofPKJ2/Ps9HXQL81HOpa24V+E1S4PDKWUJkAojqJsbs+jLEXHku4A2l0rWmiri+TXnRk5vdDau54TWINh3f5n9Bnj1WV0pcK9wT082CPggScqDdlB7PIrVpZyrFYP40bNmz/bkyfV1gInUEURUh9kGHuaEQl2JTUPBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755336681; c=relaxed/simple;
	bh=tAVBgovWion089VHZB0dY9J21VjBuUDQ/H8qgWqjXkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/955X6RtSbB4H9obbqbI8V0av6Zgw87duyaoflndXfag0rsSCAmYgpodr/adBYmBV/t2LgQNVrH/+kH+7DgfJGPbW6+1rzS+GHHdZPYwEwkTS4vgCl2WudLOc5XnnGA3oMDTHzgmlaCwxvABJPwxv+tVbz2OGUloXbSsVjYE7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=j8GzEt4K; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="j8GzEt4K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TIt5Mu6/+qUeI9Q9fB+XxJspkAmfmvsUKmcybcPr0fI=; b=j8GzEt4KmhElvEkqsfG15ndVYn
	idEdtfegOuj3h5Ye6ckhfMZtQ8nqTGmiRajKAkT+78P7kmLEqg1KpqkscXgwla39hl+MBsY5j93xg
	xmBXrUvighPwiQq/BhixX4hlWZDSAcCjYghb1f2qf7BkojQfQWHfiqknas2eDCT9BKm6khVJrOVoC
	DB/ZAc1bhspLmUoheuQnRmumOpLzGjGEjdNqBaA9iyeaZEQi1h6sXUxuMqL1Ziwgy0iiDp1T2ao3c
	JUrPRNkiCLm1zbGKjYMymJtT88JZoHl3Blf6yaQ9LQ7PMM43ZamwwOX05OG4ATyQzfNlMGTcBzkBY
	fz61ChKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unD0Q-00EmKv-2E;
	Sat, 16 Aug 2025 17:31:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:31:15 +0800
Date: Sat, 16 Aug 2025 17:31:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - add additional telemetry counter for
 GEN6 devices
Message-ID: <aKBP48SjAvcbiTux@gondor.apana.org.au>
References: <20250725090930.96450-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250725090930.96450-1-suman.kumar.chakraborty@intel.com>

On Fri, Jul 25, 2025 at 10:09:28AM +0100, Suman Kumar Chakraborty wrote:
> This patch set adds support for telemetry command queue counters for QAT
> GEN6 devices.
> 
> Vijay Sundar Selvamani (2):
>   crypto: qat - add ring buffer idle telemetry counter for GEN6
>   crypto: qat - add command queue telemetry counters for GEN6
> 
>  .../ABI/testing/debugfs-driver-qat_telemetry  |  27 +++++
>  .../crypto/intel/qat/qat_common/adf_gen6_tl.c | 112 ++++++++++++++++++
>  .../intel/qat/qat_common/adf_telemetry.c      |  19 +++
>  .../intel/qat/qat_common/adf_telemetry.h      |   5 +
>  .../intel/qat/qat_common/adf_tl_debugfs.c     |  52 ++++++++
>  .../intel/qat/qat_common/adf_tl_debugfs.h     |   5 +
>  6 files changed, 220 insertions(+)
> 
> 
> base-commit: 035a6a74c627b300b5e23448c42c05830a525b6a
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
