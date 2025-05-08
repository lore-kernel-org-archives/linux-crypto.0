Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B48872624
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 19:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746732089; cv=none; b=UA0lhvwQON2mK9LCjRUOcxw23gRVPbzbfET/Ho+v9XDnRaJIS1ZXKoJIK4uW2wT4FUl4e+vA0x9+/YRoKAzMUyFFVJn0O+U9uwZK9uO23v+ndclFSQTWZ4crLW5UnXKcWuxDvjDqFk3YnfNKoZ7sIpMzVrBvomk3kRGEmqm/eYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746732089; c=relaxed/simple;
	bh=INFtWfoFKzfi8BRZ5KQsSQzDdt0mkEqNMfs4pBazRGY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gwRzm2kPViCxi/XwrDE+cUhP4Dz1Lk4DaPK3O2S1hhVmpix4jH9wlyWZJohClABrPDCtuDmvqmVRyNQaBzIdlho4dXwzPij+AepEcYTOjaG7adHcvznF4WzqzIdzKrmZEjyLdqESA2EceJQSxpzvnpKkbtvl6PXUv3YhDYJwrbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OG4K6vgi; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OG4K6vgi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746732088; x=1778268088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=INFtWfoFKzfi8BRZ5KQsSQzDdt0mkEqNMfs4pBazRGY=;
  b=OG4K6vgirEWRziI46VmtRss4/WxpoDyOBJxWG4LPfTiORc9JjWZCH4Qu
   I9W3l4okiHk9Ac1h7R6qE0DZo9kVNyY84JRlDsEJ0o31NyJ+pZCjLu8Th
   3XvcIZ4eOVwVJEpBd9m7kk54q/e+1fCM56QTvPf0YS45onOt7t1qLUeVo
   GBYfS22PxwXKQrT0OQKfbdA7LdqGFldSebgk5A4hA5TnBvArdNragmNLz
   XjC1hk5rGPNzqbeJhUeyvniFBP40pY3yv8T91wwd5IXquZcxeerXcBxlk
   tVufEQVWqZo9fqFBs7BGyVAqoBJYfpewLlh0VtXnhdvffFuQc1a4IoEAp
   w==;
X-CSE-ConnectionGUID: d3gWltBDRJ6UdoolVlDUzw==
X-CSE-MsgGUID: gnOVVW4uQBOL+tvkH3VUxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59201016"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="59201016"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:21:27 -0700
X-CSE-ConnectionGUID: Ij+eRQsGS06G6G4NSwNq7A==
X-CSE-MsgGUID: Fh48hn0LT5GMSBeCUppjKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136398228"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa007.fm.intel.com with ESMTP; 08 May 2025 12:21:26 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: senozhatsky@chromium.org
Cc: ebiggers@kernel.org,
	giovanni.cabiddu@intel.com,
	hannes@cmpxchg.org,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	minchan@kernel.org,
	nphamcs@gmail.com,
	yosry.ahmed@linux.dev,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com,
	wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: Re: [PATCH 2/3] crypto: acomp - Add setparam interface
Date: Thu,  8 May 2025 12:21:26 -0700
Message-Id: <20250508192126.28232-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <2auyg2ozb5zppeadmufewg7pt4lam27iyimceqwtnqzt2avf4s@5sri6qk3bmhe>
References: <2auyg2ozb5zppeadmufewg7pt4lam27iyimceqwtnqzt2avf4s@5sri6qk3bmhe>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Sergey,

It is good to know that you are planning to move zram to the
async crypto API. As you correctly observed, the Intel IAA driver is
based on crypto acomp, which is Ok because we are currently working on
upstreaming “zswap compression batching” [1] as the first kernel user of
IAA. Our plan is to integrate IAA batching with zram, for which the
embedded crypto acomp dependencies in iaa_crypto are the first challenge
to overcome, while preserving the crypto interface for zswap. 

I would like to get your thoughts on whether the crypto_acomp batching
interface in patch 10 [2] of the above series would be acceptable for
zram IAA integration. If not, I was planning to create a layer in the
iaa_crypto driver that would allow interfacing with zcomp without
crypto. I figured it would be good to get some early feedback from you
before I work on a potential zcomp interface for iaa_crypto (which is
non-trivial), in light of your plans to move zram to use async crypto.

[1] https://patchwork.kernel.org/project/linux-mm/list/?series=958654
[2] https://patchwork.kernel.org/project/linux-mm/patch/20250430205305.22844-11-kanchana.p.sridhar@intel.com/

I will add you to [1].

Thanks,
Kanchana
