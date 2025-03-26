Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5A51C84A3
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 12:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742992303; cv=none; b=UQJIVDHQVnENUJUzzhvZjj8qoh8HQjcInI3n8aV2MT6bYCI9aDwgKuNcXoOar9Ml3NsHUA26T4t88QGVClbQxsVFoyt2cSv4kGywK476YD3wXUF3Bdn59qH0P5Mq5ZhKOJ2v7395SEzkwn3sjZCnA8xzUmcVESgkVmbvPu6br1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742992303; c=relaxed/simple;
	bh=z4O+ivqe01q7d/ymba9PfgZVkuC2BEyooHcwiJ0C/DM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkvnG3tM1jHb5BJfe4Kh3bl74P1yzcFORytB/WKo3lzByjULkBXaL4Dlp6AdT1ypBFOgdymHUowepDaf3Ccetf4l9fbKA0p7DbVwZNt33BcwLLFO1wdfj9Uqp7XmaVa8Qs/kK913Kj548J/Vo5Vdi0DDeSSqd2DWjBTnqS3nync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Bd/78zWt; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Bd/78zWt"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 52QCVMIj2180033
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 07:31:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1742992282;
	bh=Oj3B4tOXOKFMU4SBSgqHHHhyYa8dUFMLyKkITes1m/M=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=Bd/78zWtAVcgKp4uM8110Cav6iTSnBDGgCOAE5imbcW4e59ax37BEPmnS5kZG42M+
	 vdZWEszcSbgphYTDPPhMB77hVzBZ03AjTEy1JUY9yikFw2qyKp3P90cD32bJBkrVWz
	 9PXMLlUwUvMkG1CEgF/STpFhv/7KKtkWa4N7LTvA=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 52QCVMHr010564
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 26 Mar 2025 07:31:22 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 26
 Mar 2025 07:31:21 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 26 Mar 2025 07:31:21 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 52QCVLxt122063;
	Wed, 26 Mar 2025 07:31:21 -0500
Date: Wed, 26 Mar 2025 18:01:20 +0530
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
Message-ID: <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 18:05-20250326, Herbert Xu wrote:
> On Wed, Mar 26, 2025 at 03:30:27PM +0530, Manorit Chawdhry wrote:
> >
> > Thanks for the quick fix, though now I see error in import rather than
> > init which was there previously.
> 
> Oops, I removed one line too many from the import function.  It
> should set the tfm just like init:
> 
> ---8<---
> Rather than setting up a request by hand, use the correct API helpers
> to setup the new request.  This is because the API helpers will setup
> chaining.
> 
> Also change the fallback allocation to explicitly request for a
> sync algorithm as this driver will crash if given an async one.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks for the fix! Although, it still fails probably due to the
introduction of multibuffer hash testing in "crypto: testmgr - Add
multibuffer hash testing" but that we will have to fix for our driver I
assume.

[   32.408283] alg: ahash: sha1-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(9/13/uneven) src_divs=[100.0%@+860] key_offset=17"
[...]
[   32.885927] alg: ahash: sha512-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: use_digest multibuffer(6/9/uneven) nosimd src_divs=[93.34%@+3634, 6.66%@+16] iv_offset=9 key_offset=70"
[...]
[   33.135286] alg: ahash: sha256-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(15/16/uneven) src_divs=[100.0%@alignmask+26] key_offset=1"

Tested-by: Manorit Chawdhry <m-chawdhry@ti.com>

Regards,
Manorit
