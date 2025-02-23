Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4770C28F4;
	Sun, 23 Feb 2025 06:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740290688; cv=none; b=bGz0HzZCGpjIDDnTk5zEMWx5DK8iB0COvlyPxNimeAjPyNG56kera9dn6TYjjsQNzbZrQ7KrDjCVOlLz5WjCzBftgqlu/Wix2KeucV00R8TPpC+lPzj6QuiAKKGzBtCS1C4Ow8pGP+lbZDIr7VqsRSLfOI+6qkCBEFictgS53m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740290688; c=relaxed/simple;
	bh=n0O1JZZjjleF6676nwLMFsaML3VzH9LfZzFJ/eiegKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TzlledwPdI/7UfVkJm7X2bWAP18v1N/GP2qnJUO7Ik+se81vZZz6BmnDPvRi1z9Z7QejFf2NiZy7ZPZLDptm2VIu6+ESoTeFzaevukxqddMYQgG8DZ7XMrz2JZJsZ9OUNTYbiFVzHMoKxCnxtJ1zznBdBZBq+yH3HTyHt5/ZpYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MKTy7aBm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MKTy7aBm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3W1TQW4sSxEmiuPUJLAn0b3rBebiDRQeiRiov06/Av8=; b=MKTy7aBmtB7kQBNQV7/Q9qv6er
	g/xNMQpxPp+ZrND/VH1Uq7EF6dk4MmdcgbwVIpYZm2WEa/rA14FFIYfQ2ouy2ePX1Ddwg4E/frzPz
	wYxsaafZvZhllGQcbkfgSHFSxQGeGmiOcXzTPtSlBLhEFmg6QO/54OOgLYI0DRWBe46o/xdNiiIn/
	2cAWDZ0KQx4cJH8s/OJagImw+4TaE7dT2GzkSAlKER7m3rDGpEUcsZHtfrzr4xJAd3Zn6uVuFYce4
	ScIkQfnKyYP43o7bxZnQB3uMnPSiaZsnjh3imfHFlQ4q18ryEgpppxyToTjMDGHRIQewhWcEff8X/
	+B3HMwzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tm56K-000yJc-0D;
	Sun, 23 Feb 2025 14:04:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Feb 2025 14:04:28 +0800
Date: Sun, 23 Feb 2025 14:04:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <21cnbao@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Minchan Kim <minchan@kernel.org>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
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
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <Z7q6bCF-RjPXSpIx@gondor.apana.org.au>
References: <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
 <lu3j2kr3m2b53ze2covbywh6a7vvrscbkoplwnq4ov24g2cfso@572bdcsobd4a>
 <Z7poTnlv-1DStRZQ@gondor.apana.org.au>
 <u7t7gibspxu3lujdl4hambr72qd6o5u33udbojihngznlyistk@gmyyhwjuiwxc>
 <Z7qNf4NerHrflmfV@gondor.apana.org.au>
 <cxspxz5jeiigd34cl7x3asyx4lowefjpffj3ip4mwpxdwh34e6@xzpqbmlihbcg>
 <Z7qYUCAqh2YFQ908@gondor.apana.org.au>
 <o7qvt25dxoxcxj5ec2tbf5y5nopi4mkiuklo63rnyc7bldxwdm@2l5lkllmaynk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <o7qvt25dxoxcxj5ec2tbf5y5nopi4mkiuklo63rnyc7bldxwdm@2l5lkllmaynk>

On Sun, Feb 23, 2025 at 01:02:41PM +0900, Sergey Senozhatsky wrote:
>
> if I understood it correctly.  Which would make it: return 0 on success
> or -ENOSPC otherwise.  So if crypto API wants consistency and return -ENOSPC
> for buffer overruns, then for lz4/lz4hc it also becomes binary: either 0 or
> -ENOSCP.  Current -EINVAL return looks better to me, both for deflate and
> for lz4/lz4hc.  -ENOSPC is an actionable error code, a user can double the
> dst_out size and retry compression etc., while in reality it could be some
> SW/HW issue that is misreported as -ENOSPC.

When you're compressing you're trying to make it smaller.  It's
always better to not compress something rather than doubling the
buffer on ENOSPC.

In any case, no software compression algorithm should ever fail
for a reason other than ENOSPC.

Hardware offload devices can fail of course.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
