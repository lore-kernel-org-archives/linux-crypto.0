Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47279202C2A
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 05:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744350311; cv=none; b=fNOsyG9bQL9CroAFxtwRQmz5S6Gz51w6UMgf3bsVRkSoFo5vZ4nw9aI3OzicX++TzGQEfB1LxWstQL8AHpvrrmdRINy3xwi5RqWAyV++79RUKPZ7ThPvhzBPxr1f/Lgm0H7GnJeJuMCOMm/QyW7WiooDp7s5+t4NTK96do0Tlw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744350311; c=relaxed/simple;
	bh=U5XfffUYzxbO8TVvJFXziKB7YQ9cJ3zz35D6SdbMS5U=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udeR4hrfCE3eQaDQl9JinIqeH9uINAudNuPtAhLZY3Qb8Q+W0AMScJR+65NqhdaxB8CkjubG84REnXFsaSF/hjOzavl/ZWPxyZkCJC8JzWCBDDiUznITKb4WrMRTxYhZSjSYYdn1OYDDhx+bEKtL5wIHVgTD8tLHAFx7EfafSQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=c1ebZMqa; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="c1ebZMqa"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 53B5ixn21350839
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 00:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1744350300;
	bh=1wzu4NdGKy78BOcliZZL+gVTWRt7/T2C3pCbt2qm6dY=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=c1ebZMqayPWara66LK6EIIC50+XlJVW005wGOq+namBdAoNkiyyvlmcbi+oc33sV1
	 zshFnM0FRoksU2usBTeWh/qbSTUjZ3ae/RHPLFW/uIaFqkk6g1gyfE8DmRWXGOP6AN
	 mPrGHygjlMLW7e/LjsYclQ2NiKf9jVVAbl+g5css=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 53B5ixEI033383
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Apr 2025 00:44:59 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 11
 Apr 2025 00:44:59 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 11 Apr 2025 00:44:59 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 53B5iw90032457;
	Fri, 11 Apr 2025 00:44:59 -0500
Date: Fri, 11 Apr 2025 11:14:58 +0530
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
Message-ID: <20250411054458.enlz5be2julr6zlx@uda0497581-HP>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <20250411053426.5vmvji5nthajphzo@uda0497581-HP>
 <Z_iqg1oxdPecgzlK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z_iqg1oxdPecgzlK@gondor.apana.org.au>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 13:37-20250411, Herbert Xu wrote:
> On Fri, Apr 11, 2025 at 11:04:26AM +0530, Manorit Chawdhry wrote:
> >
> > I see multibuffer hashing is reverted but with chaining changes we would
> > require the following patch.. I see the chaining changes in 6.15-rc1 but
> > I don't see the following patch in 6.15-rc1, could you queue it for next
> > RC?
> 
> This patch is in cryptodev.  There won't be any chaining in 6.15
> so it's not needed there.

I see the chaining patches in 6.15-rc1.. [0] Are you planning to revert
them as well?

[0]: https://github.com/torvalds/linux/commits/v6.15-rc1/crypto/ahash.c

Regards,
Manorit

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
