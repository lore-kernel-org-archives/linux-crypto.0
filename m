Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661D4207E1A
	for <linux-crypto@vger.kernel.org>; Thu, 27 Mar 2025 08:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743064833; cv=none; b=MPumnanWW9BbTrBMNXf57RRWTCNac22iEh8NEfjbgJOyJrPlZzx6gZ7ctkvDwYDcAFpQoQD1uOXVVP8o6CzYLslhkA3RMzpriYXcDyKro1u63yW2NkvQRhZA7dkD600CQ8EkUojOyih6KyaXGASPsu0RgccX178+lujBHF2xQyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743064833; c=relaxed/simple;
	bh=axaW07951RIWgyXdoP6thqKvO+sCwN8Vq5lOx9HtUng=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WRHT7AW/R/DXO/2oXTxa7q7SIAUVsE6xcjA1vrnu7NKDtlQ3ql9fqgWxekZyF6FTqB76sgNUeKxduS2G9/PVz2+7afkrXcnl4SEb7J3pfkxFT7S1qvb3TdM2vEC6vrBkdrjlFsVtyJHCtNi3c3nknYrPlOCpFZoDgCPDjo0c/VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=yinQ4lk0; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="yinQ4lk0"
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 52R8eFqg2336316
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Mar 2025 03:40:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743064815;
	bh=DhDM6HN6mIGybUSlqUCkL+RjKMAaybn5Vu8+eT0gn7I=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=yinQ4lk0uoL7XOvQv/Rixiat1xb1dBU2CoXupIsDnfzuKOl9r0Po9Ocqc79sdkaPD
	 RHp+UKWF6C7sXeJ+SLWVsmELaeVEm+CVLc0G0z1MG966hKHjd3vcTnlBGDuKUnDtRQ
	 T6CruzY/O1gSjndOj1Xq83He9wrigNSSjGFC6T24=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 52R8eFiF055108
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 27 Mar 2025 03:40:15 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 27
 Mar 2025 03:40:15 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 27 Mar 2025 03:40:15 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 52R8eE9M122750;
	Thu, 27 Mar 2025 03:40:14 -0500
Date: Thu, 27 Mar 2025 14:10:14 +0530
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
Subject: Re: [PATCH] crypto: testmgr - Initialise full_sgl properly
Message-ID: <20250327084014.t5x5rfk3yzwiehgo@uda0497581-HP>
References: <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <Z-P78_9NKGMBFs3s@gondor.apana.org.au>
 <20250327073427.amcyd4t6qvs7kw35@uda0497581-HP>
 <20250327081555.nhcggnqxetwbnidx@uda0497581-HP>
 <Z-ULBwaDsgWpYzmU@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z-ULBwaDsgWpYzmU@gondor.apana.org.au>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 16:23-20250327, Herbert Xu wrote:
> On Thu, Mar 27, 2025 at 01:45:55PM +0530, Manorit Chawdhry wrote:
> >
> > [   33.040345] sa_run: 1182: req->size: 40187, src: 00000000f1859ae0
> > [   33.046426] sa_run: 1183: sgl: 00000000f1859ae0, orig_nents: -22
> 
> Thanks for the info! The filler SG initialisation was broken:
> 
> ---8<---
> Initialise the whole full_sgl array rather than the first entry.
> 
> Fixes: 8b54e6a8f415 ("crypto: testmgr - Add multibuffer hash testing")
> Reported-by: Manorit Chawdhry <m-chawdhry@ti.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

Thanks, this fixes it.

root@j721e-evm:~# modprobe sa2ul
[   35.293140] omap_rng 4e10000.rng: Random Number Generator ver. 241b34c

Tested-by: Manorit Chawdhry <m-chawdhry@ti.com>

Regards,
Manorit
