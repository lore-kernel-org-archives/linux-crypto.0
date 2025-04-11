Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF03B1EE019
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 06:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744352068; cv=none; b=tlT8DprsiBkesp+tBYKefWKgO6/TGVyNo6+k5B6pTiz2efor5Q0yscPMOloK9W697fOVNoWDXfJsc2t2X7kGa7zLV+aUCsoAUzmcSOoBk9d4hHfetxA0rm9y5tHq+VP2caFzHmCnrkVEZ8u1k0Z8KM4C5qVJhqvYms9RVOnjVZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744352068; c=relaxed/simple;
	bh=OMOxbyHsl4zWmnhLNSxzok3ZnypMd2G2hXvEee+UgGY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUzQwCC8rGdu6JIrppmn3neyr0b4qyz9ARm59wwQ7Bpr6TB4qWBWm8LTpQj4YHMsLnU5ELWHOEfhFciVeOtNDiZQeNOdAvi2QjfIAVDTQ9Ct1kq49HM3iS5IuCgq/yLF6yWie0yu/lOFuhpiNUCqSxsIQpM1maLwbIGZEQsLuFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=hfPzwChZ; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="hfPzwChZ"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 53B6EJ2b2029694
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 01:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1744352059;
	bh=4TtG2HX46QMvQavP6E832BsI6DtzpZCWOkxbT6i6OEE=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=hfPzwChZX0VxKu0nkh4kVLcN78Ut4Ub+dvhWun1MB1znqIWQha3ieLqAWA6dMZAey
	 R/HdXXygABqxUzNlt/GFIvFYcLHAwYsg3xJFHywtIfxK5SsQRRp8NLv8GN8Y1t6r7w
	 WV2cfGRPpKGyvtnORDBmknyhxiLbFy/51m7QXOhw=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 53B6EJYC017908
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Apr 2025 01:14:19 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 11
 Apr 2025 01:14:18 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 11 Apr 2025 01:14:18 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 53B6EHgT090604;
	Fri, 11 Apr 2025 01:14:18 -0500
Date: Fri, 11 Apr 2025 11:44:17 +0530
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
Message-ID: <20250411061417.nxi56rto53fl5cnx@uda0497581-HP>
References: <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <20250411053426.5vmvji5nthajphzo@uda0497581-HP>
 <Z_iqg1oxdPecgzlK@gondor.apana.org.au>
 <20250411054458.enlz5be2julr6zlx@uda0497581-HP>
 <Z_isukjVYANljETv@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z_isukjVYANljETv@gondor.apana.org.au>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 13:46-20250411, Herbert Xu wrote:
> On Fri, Apr 11, 2025 at 11:14:58AM +0530, Manorit Chawdhry wrote:
> >
> > I see the chaining patches in 6.15-rc1.. [0] Are you planning to revert
> > them as well?
> > 
> > [0]: https://github.com/torvalds/linux/commits/v6.15-rc1/crypto/ahash.c
> 
> With the multibuffer tests removed there is no way to call into
> the chaining code in 6.15.
> 

root@j721e-evm:~# uname -a
Linux j721e-evm 6.15.0-rc1 #3 SMP PREEMPT Fri Apr 11 11:37:56 IST 2025 aarch64 GNU/Linux
root@j721e-evm:~# modprobe sa2ul
[   42.395465] omap_rng 4e10000.rng: Random Number Generator ver. 241b34c
root@j721e-evm:~# [   42.515589] Unable to handle kernel paging request at virtual address fefefefefefeff46
[   42.549426] Unable to handle kernel paging request at virtual address fefefefefefeff46
[   42.558286] Unable to handle kernel paging request at virtual address fefefefefefeff46
[   42.592270] Mem abort info:
[   42.623088]   ESR = 0x0000000096000044
[   42.628660] Mem abort info:
[   42.631496]   ESR = 0x0000000096000044
[   42.635478] Mem abort info:
[   42.655279]   ESR = 0x0000000096000044
[   42.661660]   EC = 0x25: DABT (current EL), IL = 32 bits
[   42.681101]   EC = 0x25: DABT (current EL), IL = 32 bits
[   42.687850]   EC = 0x25: DABT (current EL), IL = 32 bits
[   42.701449]   SET = 0, FnV = 0
[   42.704524]   EA = 0, S1PTW = 0
[   42.727712]   SET = 0, FnV = 0
[   42.731640]   SET = 0, FnV = 0
[   42.755404]   FSC = 0x04: level 0 translation fault
[   42.760711]   EA = 0, S1PTW = 0
[   42.763923]   EA = 0, S1PTW = 0
[   42.793049]   FSC = 0x04: level 0 translation fault
[   42.798305]   FSC = 0x04: level 0 translation fault
[   42.809586] Data abort info:
[   42.812463]   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[   42.830629] Data abort info:
[   42.833982] Data abort info:
[   42.854520]   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[   42.860776]   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[   42.880775]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[   42.897045]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[   42.902752]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[   42.913445]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[   42.931845]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[   42.937545]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[   42.948838] [fefefefefefeff46] address between user and kernel address ranges
[   42.968662] [fefefefefefeff46] address between user and kernel address ranges
[   42.976773] [fefefefefefeff46] address between user and kernel address ranges
[..]

Maybe it's not the chaining but the way chaining was implemented that
requires us to start using these correct API helpers otherwise we crash
so I think we would require the following patch.

Regards,
Manorit

> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
