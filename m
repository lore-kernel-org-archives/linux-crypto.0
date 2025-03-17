Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8A01EB5D6;
	Mon, 17 Mar 2025 23:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742253973; cv=none; b=kALhqrT4fYGMa0VcZAIIpQhZ5Ph7dcw2LrWdBCeIF5Ohs97tPYFBg6PckAlo05s4J0ArzlnBco4IUVgClY2VV8CLmyefzAHLvPJD2vtPeR44CH7+XCgZoTI6I/RPuGsS6WyNrQYtfax35i1cRyPSnL1H+uH93FJ6Rf2AYlBykLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742253973; c=relaxed/simple;
	bh=k3TtNZTGFuLJ79v8k08kXG/em/EJur/CqUQeeA0H268=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s54/1dx6zRghzTfMPHznEfxJgq1DVPfFdjZGuLF1RQlBrcZRSmOvHPjrypcBihM/44P5uh/1DEZy+bongRr4zDHSLqjn/KoN5OlSbLpREZkiUMIuseo0F6GH1Unr6oyINk9gDb8SAg7r2vxqVUsDnG0YSj2sw9xHJFcpcWm0t7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LxR4tR/u; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LxR4tR/u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=17eE1Dmu5py2lzwJWpsTytuqSbm05meORUtCLNmenuY=; b=LxR4tR/uFbVtwzFem/86eO11R1
	R13pJWrls7OqF6bq1kjyLXCFHhlDy5U2pFdcDCM1hIpPmM1nE5zsUyOcXE2Q0t5XSqI+8fomYmnSy
	vmxweZFyQiLxAktv0zCk5MDpn5v/WpvwRjq3sU6vFLXbm5cswgB+QvpaPdLEfMD2zJIuDOyc+lAQT
	5xgSqk5Tr/ePjbIvzn5cEOvmOIvrJKFBn1ICJDpLZ+AlRIbQzRKNesye7rXNF/Z497m3FTjNFKk+z
	kS5rpJgbyxFEfTRAuX4RsqS+RHjShchdkCh+SiT4iChsej6X+N+LD9R2RdLxrJtZuTV3OLkVrEN8J
	4gYTIhXQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tuJq0-007mdj-1P;
	Tue, 18 Mar 2025 07:25:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Mar 2025 07:25:40 +0800
Date: Tue, 18 Mar 2025 07:25:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Message-ID: <Z9ivdJycm7v6l4LV@gondor.apana.org.au>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
 <Z8n5CCmELvpUwi3B@google.com>
 <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z8tJOi5G_3dpK31v@google.com>
 <PH8SPRMB00447B066A769C76F57F8800C9D42@PH8SPRMB0044.namprd11.prod.outlook.com>
 <Z88h1mPkYNM6yOGE@google.com>
 <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA3PR11MB812082535F1E6D63BC0F1412C9DF2@SA3PR11MB8120.namprd11.prod.outlook.com>

On Mon, Mar 17, 2025 at 09:15:09PM +0000, Sridhar, Kanchana P wrote:
>
> The problem however is that, in the current architecture, CPU onlining/ 
> zswap_pool creation, and CPU offlining/zswap_pool deletion have the
> same semantics as far as these resources are concerned. Hence, although
> zswap_cpu_comp_prepare() is run on a control CPU, the CPU for which
> the "hotplug" code is called is in fact online. It is possible for the memory
> allocation calls in zswap_cpu_comp_prepare() to recurse into
> zswap_compress(), which now needs to be handled by the current pool,
> since the new pool has not yet been added to the zswap_pools, as you
> pointed out.

Please hold onto your patch-set for a while because I intend to
get rid of the per-cpu pool in zswap after conversion to acomp.

There is no reason to have a per-cpu pool at all, except for the
stream memory used by the algorithm.  Since we've already moved
that into the Crypto API for acomp, this means zswap no longer
needs to have any per-cpu pools.  In fact, with LZO decompression
it could go all the way through with no per-cpu resources at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
