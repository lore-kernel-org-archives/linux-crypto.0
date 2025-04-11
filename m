Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5FF1E7C0E
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744358317; cv=none; b=JWOnnWGWD+ApcapcIVuHeDSsYjWbH9rXeSjW24k5ZfPAqVFpD4SEUa1X1kfvIxI4gklsdgrxLu0Ne1Z8v3SpmXrEO/5lTjONH8EBbEsexSTmgFt34uz1czUtcZvnhAyGjmxY9uU+caPtdcuIsh2uDceMDW+y93CqwGsFdUFwNmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744358317; c=relaxed/simple;
	bh=Cyz638jl3+AmMrLdy+tMNMQe+lyEkxU0b6Qce5ecno4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtqeLo+4vFTiKpdUXDJ28UAZo5D4OZePn+mw3PF1hBcBX+mTOs6Z1I1sqiKMewnZ9DsP4RzbQp0Gta88KgYaSlywG+Z79LMAw6fk8Qk2ztfAPpfw+/NAx7Z74vwlzQVDmikJDCbxY5RQhr5rK2TF2ayF8aaHBjb4lTOZwA+R4uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=DalTzKk1; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="DalTzKk1"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 53B7wNxZ2055924
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 02:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1744358303;
	bh=iFid11ZYXxMf/Wch5gZbVEu+JFBg1Tf7jvh2yjWnLu8=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=DalTzKk1rMulK8ytPOi3OoHk9Y5eOftUJhYwSOHmLu3Tvsq2FwyxVN0VFXekZjVgp
	 t721Wh3z1W9dtbKix6kZAAMqzGnuF+POTrYgp/xw5aKJDuEEcTcomNMy7iAKgCcYJd
	 iEZBxSsZivbzjYnqoEqyUcHEvgMzniSEkdz4qnpk=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 53B7wNWU116929
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Apr 2025 02:58:23 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 11
 Apr 2025 02:58:22 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 11 Apr 2025 02:58:22 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 53B7wLEh062361;
	Fri, 11 Apr 2025 02:58:22 -0500
Date: Fri, 11 Apr 2025 13:28:21 +0530
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
Subject: Re: [PATCH] crypto: ahash - Disable request chaining
Message-ID: <20250411075821.tdle3l3n2zpk5nmy@uda0497581-HP>
References: <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <20250411053426.5vmvji5nthajphzo@uda0497581-HP>
 <Z_iqg1oxdPecgzlK@gondor.apana.org.au>
 <20250411054458.enlz5be2julr6zlx@uda0497581-HP>
 <Z_isukjVYANljETv@gondor.apana.org.au>
 <20250411061417.nxi56rto53fl5cnx@uda0497581-HP>
 <Z_jBSnzQ-B-IVghn@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z_jBSnzQ-B-IVghn@gondor.apana.org.au>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 15:14-20250411, Herbert Xu wrote:
> On Fri, Apr 11, 2025 at 11:44:17AM +0530, Manorit Chawdhry wrote:
> > 
> > Maybe it's not the chaining but the way chaining was implemented that
> > requires us to start using these correct API helpers otherwise we crash
> > so I think we would require the following patch.
> 
> You're right.  This needs to be disabled more thoroughly for 6.15.
> Please try this patch:
> 
> ---8<---
> Disable hash request chaining in case a driver that copies an
> ahash_request object by hand accidentally triggers chaining.
> 
> Reported-by: Manorit Chawdhry <m-chawdhry@ti.com>
> Fixes: f2ffe5a9183d ("crypto: hash - Add request chaining API")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

This fixes it, thanks!

root@j721e-evm:~# uname -a
Linux j721e-evm 6.15.0-rc1-00001-gdcd7f62f8e5e-dirty #4 SMP PREEMPT Fri Apr 11 13:18:03 IST 2025 aarch64 GNU/Linux
root@j721e-evm:~# modprobe sa2ul
[  414.110972] omap_rng 4e10000.rng: Random Number Generator ver. 241b34c

Tested-by: Manorit Chawdhry <m-chawdhry@ti.com>

Regards,
Manorit
