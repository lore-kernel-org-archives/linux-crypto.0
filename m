Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E0CEEB3;
	Tue, 26 Aug 2025 01:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756170840; cv=none; b=Gw4aSk5S+VPG6t1iZjo7qqHi6mVq0PknvYpJ/b5WorjoztWCSSAH9AThQVWbOYHByEGOTVpRXf1A7IZ/JYVmyHA60tSpXMUoWtbpBYlDmEs2ZGlgrsHBWplX+nYnO9Mga7AoFyt6PmwFNKlJLJ2/FgZsucQLnaTAScccYNtTDRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756170840; c=relaxed/simple;
	bh=DSnkrlQap2de5NIIN1j1Qu/t9WNnkMruYXQFGkYVJ30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7WcffHqWr2hamLGzuB2dnzheR/DgqjQFrkH92zOwc9QrJMJqA4PxddvIg6CIP9iqBJmQ58usSAPg3QYwGfgiKQg9SbbCk/Q6pmdfzhCd7foQ+96u/gYHJqdo1x/Md65IFD6QAnrPVbCpPhw6NJJmgrYWfySDwyv0z5KFMC51WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=T6hjPgwa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="T6hjPgwa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GahGKMyDDWWgzcOoacVh1GqObdQHZAFm0vAPse1Lvgc=; b=T6hjPgwauSAvz2ezFKh/PyMHbd
	/zvg0/xfZQcNOwdWxylETa7s3AVJSbxho0c2nTbmk34LaHMzeXj+1mldn2Mp6d2f0uBLuxkzAiepb
	R0icvWn6tUqu+kxWUy655QEiqVk0WnjrwO6toSvK1qNYVU+svqBBQy5q+jvAUYW5b4KMPFyGelNhf
	xGqE6u+jzP8xGZRJeUfUyL3R9AKfTNTtjGGz9AmnH9u3iH0fFAFTjDBtQa5CqV1WJtaBe63hi9J2w
	DqxRidDI/ZOFLHYIPazSG25R8Ax0kq1blnQpxcMBiUemYX94HtY8a7ShYZO8WJoqY2bOnwWibi2uH
	xuVIpBog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uqi08-00HGCY-0J;
	Tue, 26 Aug 2025 09:13:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 Aug 2025 09:13:24 +0800
Date: Tue, 26 Aug 2025 09:13:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
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
Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <aK0KNAmQh_JVgnML@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aKv28XTvAITuq-p8@gondor.apana.org.au>
 <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>

On Mon, Aug 25, 2025 at 06:12:19PM +0000, Sridhar, Kanchana P wrote:
>
> Thanks Herbert, for reviewing the approach. IIUC, we should follow
> these constraints:
> 
> 1) The folio should be submitted as the source.
> 
> 2) For the destination, construct an SG list for them and pass that in.
>     The rule should be that the SG list must contain a sufficient number
>     of pages for the compression output based on the given unit size
>     (PAGE_SIZE for zswap).
> 
> For PMD folios, there would be 512 compression outputs. In this case,
> would we need to pass in an SG list that can contain 512 compression
> outputs after calling the acompress API once?

Eventually yes :)

But for now we're just replicating your current patch-set, so
the folio should come with an offset and a length restriction,
and correspondingly the destination SG list should contain the
same number of pages as there are in your current patch-set.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
