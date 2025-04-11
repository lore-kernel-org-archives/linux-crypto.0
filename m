Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109EB23A9
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 05:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744349679; cv=none; b=nANLfDmbB/e4SG+98NJGpx2XIBk3Uj6r4jIQSdkXVSXDuGMzwHj5qVRSGhxEv+Hm11uVLsiEViQGTkqJJD0Rnsyb/Ns/QuhT+jgCQota8Fm4PS9rOThSxCZVRCMEt7n/Pa9itiNNP29wjyq99PgbagyDr36gz0ZLMqpW5wAoGrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744349679; c=relaxed/simple;
	bh=HY7zhSN4Kf8pEVXq7S3ycNbONHbruN+fIJlLgKXXnAs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJt/7AGBiodEZ2rbvTllN1eXfAsjSyw3Z2ogXUWujg6GtAG5cLtZyxNV39QQU007Ry/+8+lIM0tJdexENP80J/FoY4wxIe/KkV67nDBBj8pPguSJAD5b6LXwmIqRorhuav7OBE8VXHhsPUxZCfpVeNC2irzN7AfJGnVSEVpzpCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=KD0dC+m9; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KD0dC+m9"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 53B5YSS71488709
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 00:34:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1744349668;
	bh=fWHDXjRYcjZGsZnFFoNubUTyut7L6YPQzLhvzd2jb7Y=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=KD0dC+m98l4CM/mkb1ugANqKqhEkb9aYazFPONeG+JpEXrLeQvGlA/plPGmIYrBY0
	 scIGjR/NMqyWgwA8/mIxDL3sj+xKKgXbr6uhtkOR3Gu3e2q4Z++W08zomsZEQCMY7Y
	 TlY1+evahjTDfOnX9yEDW2HSiFqtmqQE+8K/5/Gg=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 53B5YSg2122384
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Apr 2025 00:34:28 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 11
 Apr 2025 00:34:27 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 11 Apr 2025 00:34:27 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 53B5YRJl021369;
	Fri, 11 Apr 2025 00:34:27 -0500
Date: Fri, 11 Apr 2025 11:04:26 +0530
From: Manorit Chawdhry <m-chawdhry@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers
	<ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Megha Dey
	<megha.dey@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>, Udit
 Kumar <u-kumar1@ti.com>,
        Pratham T <t-pratham@ti.com>
Subject: Re: [v2 PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <20250411053426.5vmvji5nthajphzo@uda0497581-HP>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 18:01-20250326, Manorit Chawdhry wrote:
> Hi Herbert,
> 
> On 18:05-20250326, Herbert Xu wrote:
> > On Wed, Mar 26, 2025 at 03:30:27PM +0530, Manorit Chawdhry wrote:
> > >
> > > Thanks for the quick fix, though now I see error in import rather than
> > > init which was there previously.
> > 
> > Oops, I removed one line too many from the import function.  It
> > should set the tfm just like init:
> > 
> > ---8<---
> > Rather than setting up a request by hand, use the correct API helpers
> > to setup the new request.  This is because the API helpers will setup
> > chaining.
> > 
> > Also change the fallback allocation to explicitly request for a
> > sync algorithm as this driver will crash if given an async one.
> > 
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Thanks for the fix! Although, it still fails probably due to the
> introduction of multibuffer hash testing in "crypto: testmgr - Add
> multibuffer hash testing" but that we will have to fix for our driver I
> assume.

I see multibuffer hashing is reverted but with chaining changes we would
require the following patch.. I see the chaining changes in 6.15-rc1 but
I don't see the following patch in 6.15-rc1, could you queue it for next
RC?

Regards,
Manorit

> 
> [   32.408283] alg: ahash: sha1-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(9/13/uneven) src_divs=[100.0%@+860] key_offset=17"
> [...]
> [   32.885927] alg: ahash: sha512-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: use_digest multibuffer(6/9/uneven) nosimd src_divs=[93.34%@+3634, 6.66%@+16] iv_offset=9 key_offset=70"
> [...]
> [   33.135286] alg: ahash: sha256-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(15/16/uneven) src_divs=[100.0%@alignmask+26] key_offset=1"
> 
> Tested-by: Manorit Chawdhry <m-chawdhry@ti.com>
> 
> Regards,
> Manorit
> 
