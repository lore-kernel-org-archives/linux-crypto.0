Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18C7286A9
	for <linux-crypto@vger.kernel.org>; Thu, 27 Mar 2025 09:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743066614; cv=none; b=D3kej1XmaAxRLqX8wO9D7KcsX9OC5wmtPqKD1VtAIDf3j+UA3TMZcdqlUDNO6vUeG4XGObOIqcBSjJQoVvi4eBtOyUXiSm9s+BvQrff/QhdmZd/NCG1vOtoumzh0Y+Lgn/V51qmEiN5Rge0QRX/+TVfilLiaybQEAiS+UHyhnnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743066614; c=relaxed/simple;
	bh=xDpITVy0In+Q2Lu8Y86IsZ9lDVbUxrToEYZgzqQXMbE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFmQt2rOC07nl1k/SfBwrYJfBCDMDjztw+MlW/cjpsVC58OhwUYzyYLiYqOSO3r1hHGoAfrmKLB5C4pPzK2/OEJKNnvpRf8TsnBGvq/nEVyxcPMZ5oYXOcfAw6cXCPSRLPXf17oB7i1Ptc7ZHeZ7clNW/t/9xyalFOKvIgRB874=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=xgX1Wjg4; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="xgX1Wjg4"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 52R99uKc1810127
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Mar 2025 04:09:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743066596;
	bh=SRUYY8+cRgz8SGioHerTsRFBMetF8iuq9h6W617b87Q=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=xgX1Wjg4oLLs9BLlrsV/A5d/QBe44iGbPTkJBjgp8k50kInqY/Rs95yXYfXksfcGR
	 DgJYBtoJlYAVn64IQfADYZ+7PRwmP6l4/FS2Qodls2HZKiAkZmCRvK/LIdFChqL39O
	 sdtAbI9PamrUebYVEYW3dV7bRB5WrLmwBh3W4opM=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 52R99ufW051904
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 27 Mar 2025 04:09:56 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 27
 Mar 2025 04:09:56 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 27 Mar 2025 04:09:56 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 52R99tuX029359;
	Thu, 27 Mar 2025 04:09:55 -0500
Date: Thu, 27 Mar 2025 14:39:55 +0530
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
Message-ID: <20250327090955.6hgrpfe7cl2f5twm@uda0497581-HP>
References: <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <Z-P78_9NKGMBFs3s@gondor.apana.org.au>
 <20250327073427.amcyd4t6qvs7kw35@uda0497581-HP>
 <20250327081555.nhcggnqxetwbnidx@uda0497581-HP>
 <Z-ULBwaDsgWpYzmU@gondor.apana.org.au>
 <20250327084014.t5x5rfk3yzwiehgo@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250327084014.t5x5rfk3yzwiehgo@uda0497581-HP>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 14:10-20250327, Manorit Chawdhry wrote:
> Hi Herbert,
> 
> On 16:23-20250327, Herbert Xu wrote:
> > On Thu, Mar 27, 2025 at 01:45:55PM +0530, Manorit Chawdhry wrote:
> > >
> > > [   33.040345] sa_run: 1182: req->size: 40187, src: 00000000f1859ae0
> > > [   33.046426] sa_run: 1183: sgl: 00000000f1859ae0, orig_nents: -22
> > 
> > Thanks for the info! The filler SG initialisation was broken:
> > 
> > ---8<---
> > Initialise the whole full_sgl array rather than the first entry.
> > 
> > Fixes: 8b54e6a8f415 ("crypto: testmgr - Add multibuffer hash testing")
> > Reported-by: Manorit Chawdhry <m-chawdhry@ti.com>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> 
> Thanks, this fixes it.

Though it really makes me wonder.. I was actually thinking that it was
our driver problem and not something core as when I fell back to the
software fallbacks everything was fine... How is it possible, do you
have any insights on that? Is something missing?

[ Without this patch + the patch mentioned below ]

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 35570c06eb3c..90d754bbea9b 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1417,9 +1417,9 @@ static int sa_sha_run(struct ahash_request *req)
        if (!auth_len)
                return zero_message_process(req);

-       if (auth_len > SA_MAX_DATA_SZ ||
+       if (1 || (auth_len > SA_MAX_DATA_SZ ||
            (auth_len >= SA_UNSAFE_DATA_SZ_MIN &&
-            auth_len <= SA_UNSAFE_DATA_SZ_MAX)) {
+            auth_len <= SA_UNSAFE_DATA_SZ_MAX))) {
                struct ahash_request *subreq = &rctx->fallback_req;
                int ret;


This passes the tests.

root@j721e-evm:~# modprobe sa2ul
[   53.380168] omap_rng 4e10000.rng: Random Number Generator ver. 241b34c

Regards,
Manorit

> 
> root@j721e-evm:~# modprobe sa2ul
> [   35.293140] omap_rng 4e10000.rng: Random Number Generator ver. 241b34c
> 
> Tested-by: Manorit Chawdhry <m-chawdhry@ti.com>
> 
> Regards,
> Manorit
