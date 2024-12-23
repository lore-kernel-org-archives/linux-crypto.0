Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE37B5473E;
	Mon, 23 Dec 2024 12:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734956495; cv=none; b=ZjiJVXWZAlHGu4JsSVTuJ1V3gJox1hEPJ10Swpxmtg8ADb6cxAAuyvewpCJQ00/vcrxQECLPLbJhmf+s0pA3qj85N9gBtoep7uvNgRf4DRoU4BVf/UBj4ixCPybVZEIHj7Ptq5pUXicvmiwwfhJISyLJmmwQc4CURdPuDJw/J0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734956495; c=relaxed/simple;
	bh=+Uh7GavcIz7YhZr5DUVmOs+Vyg41HksO8KtvD7505UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXfocQc9lY742vNvshjYMVLDd3356JLGddcwn7KVB2iR3Lh/WA2Nk+/X7/8iPeAN7mgFGRdRirUlvKdScizbY6zKFMEqPIg8NPUwL6rqlSQ7BPUpVuy/TBVHpRcemaqVOeo9F5/Tff1RTIKNWf+TtjWNwakDUrFfCqOnkuOFJ3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=lgPuGWap; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="lgPuGWap"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=auoxJUtXlCxFo04JJqoDs3pCgdoS1JhRfCkNTB8rgvo=; b=lgPuGWaphtY/N7zz
	P+gtYjUy9+4zaJZ/J8uYagKEqZHg9I65Du3SBZ2n6EZBbHh+GC13Ggt44mg/aWY/KonbSfDhUXqsR
	VpEPYKTazyh452CibX2y5xJRfrlL4nO/po66kr+n0hzYpx5LgD+ZuNFfYoGcudfBzsihqQP37iVsR
	zqJd8JcYGV2U3j/UdX5hRNUI6JIYEONbWOtB6RxeoUkKKeBw0xMcBnz1M0DnULDfV+j+o/TebGVD2
	znJbTvDosW/RpPjMd1ggTd2nu09dB+QfLVsxVV2CbnAYYkTbmetj/aqnD7GrSQqwq7/YS00JDcSMc
	jeR1EzznCIjg8nstRA==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1tPhR9-006rao-1S;
	Mon, 23 Dec 2024 12:21:27 +0000
Date: Mon, 23 Dec 2024 12:21:27 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] crypto: lib/gf128mul - Remove some bbe deadcode
Message-ID: <Z2lVxyYtIROPAtHE@gallifrey>
References: <20241211220218.129099-1-linux@treblig.org>
 <Z2eTGr3l-Zu_Tgi3@gondor.apana.org.au>
 <Z2f-CXgNGkstB4ds@gallifrey>
 <Z2jQsb6d2PCKyRZ1@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Z2jQsb6d2PCKyRZ1@gondor.apana.org.au>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 12:20:26 up 228 days, 23:34,  1 user,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Sun, Dec 22, 2024 at 11:54:49AM +0000, Dr. David Alan Gilbert wrote:
> >
> > Thanks!  I'd appreciate if you could also look back at one
> > from September:
> >   async_xor: Remove unused 'async_xor_val'
> >   Message ID: 20240929132148.44792-1-linux@treblig.org
> 
> The MAINTAINERS entry for that file is:
> 
> ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
> R:      Dan Williams <dan.j.williams@intel.com>
> S:      Odd fixes
> W:      http://sourceforge.net/projects/xscaleiop
> F:      Documentation/crypto/async-tx-api.rst
> F:      crypto/async_tx/
> F:      include/linux/async_tx.h

That is who I mailed at the time but it didn't go anywhere.

Thanks again,

Dave

> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
