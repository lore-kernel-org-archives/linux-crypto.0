Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F7C4C92;
	Sat, 17 May 2025 00:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747442795; cv=none; b=KZAnqmOzqIUHjH3/tvP9HZgEcqnhdQwtqhP78OellvL7brO41v6tf0MY6HLId0TtSUulJ3Zl1nb1MeGh9abRFQux+gaRvjS3+FNgjJ4N/XBLXHr6Wlivi5vMmoL8jXeDRwBtRARMVv0uSsPGIDhmv3V58d34h9ayD+YZZXGzAP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747442795; c=relaxed/simple;
	bh=46aGTMbwZQ5iNg5aPtu2TgpP9K1VUPCWEZQeFqbZdyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkNcyUftX1YcgVm3Nw36wO9eOPZY2Ri5GNvBuKq1CD6qMvxHTacHKalBTsRtEUs7esN7euhbfN7Wu+GqedEyP3EG5vkIL6s+3SRLYSSwXYNUoTikHrOA5PlZ6JupfWJBL1TvpyT7//pyv4m4ZzRgygf8wX/x0YFlAABoQALABR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JoL/vL5R; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JoL/vL5R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eAq1Jx0B5XZ2PSqnPCuf5t72QghPB10tZtJQZtu4EYU=; b=JoL/vL5RSA3VQgc7UYQTBpL0YU
	eNTrmw2DV68hq62u/q9auxIDR2GDfgE6DNjrKvJWi9U8YhpXt2gwx37q6eg0+V/raCiC9m2OPIktp
	tniKdUJ+WlAJe2qW3HwWV/d6jp2zhl63W6wIkSXhNvRek/agsmzAkf5C7fai9F8vIKBhCqLrG4KH+
	paY/0BY3EL8enr5AhRdtybTvtezc9W3HriUWuAF9EVF36ocuNs//wgozd2wjDl3IhYmG/qTATLR5/
	VEt9BV8nKig3SVDm8veWEAdIF6Ba/sQEVh5xpDO8YdoRLXjhjE6MICuBD0LVlWk5qOVjSfR/i4jC4
	LVifh/ew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uG5gk-006jLa-24;
	Sat, 17 May 2025 08:46:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 May 2025 08:46:06 +0800
Date: Sat, 17 May 2025 08:46:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate
 batching support in acomp & drivers.
Message-ID: <aCfcTpLgFp4lPaZK@gondor.apana.org.au>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
 <20250508194134.28392-11-kanchana.p.sridhar@intel.com>
 <aCL86_v0jaqW8jxS@gondor.apana.org.au>
 <PH7PR11MB81215CF69F51F2801F4767CDC993A@PH7PR11MB8121.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB81215CF69F51F2801F4767CDC993A@PH7PR11MB8121.namprd11.prod.outlook.com>

On Fri, May 16, 2025 at 07:17:36PM +0000, Sridhar, Kanchana P wrote:
>
> It appears acomp_do_req_chain() and acomp_reqchain_finish() compress the

That's the fallback path.

A hardware driver capable of batching is supposed to declare the
bit in cra_flags that bypasses the fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
