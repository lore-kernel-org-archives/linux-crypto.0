Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763831CD2C;
	Fri, 20 Sep 2024 09:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726825090; cv=none; b=rZP3EysnAHl2n6T1rzc/cNUhHoVJJ8iR7fbrGlAf43I+H4glIRMK/qxxSG58GPrfFsX1m/voR0zFMwtXo5Xe8FNyD9eJzwoGkXzQ48xX3nkym3JboOfGV3jl5KRn+5XymWOgdsBuQspWG+SKCqzu1b0EPd4Krw7XAerjqUmnZYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726825090; c=relaxed/simple;
	bh=zrcIwAMuAWkfsz35vSNkxOlMouu2YIEF3sxN+NveNUU=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QeRLLmoGw5mMLx0qjmWgjKqoGLVJA10a8ON7bl0M9jh3buRd7qeb2eQ8UTBFZylnyzJjk3vhBUAMmMCRT6QbFspuW7yEpMrbCNWfvS1TUjsFumQTGoNvaEWu8Se2tHUqNVSWA8tTvztRCD+zGmMv/HXW0UJHHILcCGVGlxB/blk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=a3kWlhvp; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="a3kWlhvp"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 48K9bKjn025160;
	Fri, 20 Sep 2024 04:37:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1726825040;
	bh=D0mskHRaG8uO51XB0w+Qjupk2ywjqNEa2TOnwxQtqhQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=a3kWlhvpf7IkGjWVT7lDFl5kpISZbS1j+VWuBtJR9VfBSU3nRHit4EI73t62rGy8m
	 hMuak9pesVjAl9mfLUqywH+IJBAmsyq72nQxbgDpafsse10uCQUWAmJ3Q3itijTb/k
	 Qfx183o9yeTivmeYQ6bqd1Ht+sdtxnzoXLoHXf5w=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 48K9bKDD015708
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 20 Sep 2024 04:37:20 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 20
 Sep 2024 04:37:20 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 20 Sep 2024 04:37:20 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 48K9bJLg087632;
	Fri, 20 Sep 2024 04:37:20 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Danny Tsen <dtsen@linux.ibm.com>, <linux-crypto@vger.kernel.org>
CC: <stable@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <leitao@debian.org>, <nayna@linux.ibm.com>, <appro@cryptogams.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <mpe@ellerman.id.au>, <ltcgcw@linux.vnet.ibm.com>, <dtsen@us.ibm.com>,
        Danny
 Tsen <dtsen@linux.ibm.com>
Subject: Re: [PATCH v3] crypto: Removing CRYPTO_AES_GCM_P10.
In-Reply-To: <20240919113637.144343-1-dtsen@linux.ibm.com>
References: <20240919113637.144343-1-dtsen@linux.ibm.com>
Date: Fri, 20 Sep 2024 15:07:19 +0530
Message-ID: <87ldzmll80.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Danny Tsen <dtsen@linux.ibm.com> writes:

> Data mismatch found when testing ipsec tunnel with AES/GCM crypto.
> Disabling CRYPTO_AES_GCM_P10 in Kconfig for this feature.
>
> Fixes: fd0e9b3e2ee6 ("crypto: p10-aes-gcm - An accelerated AES/GCM stitched implementation")
> Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
> Fixes: 45a4672b9a6e2 ("crypto: p10-aes-gcm - Update Kconfig and Makefile")
>
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
nitpick
checkpatch complains
Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' -
ie: 'Fixes: 45a4672b9a6e ("crypto: p10-aes-gcm - Update Kconfig and
Makefile")'

There is no rule for 12 characters, but it is generally preferred.
I guess it is just a typo for you as you have correctly added other
Fixes tag.

If you end up re-spinning, please correct this

Also, just to understand,

"A Fixes: tag indicates that the patch fixes an issue in a previous
 commit. It is used to make it easy to determine where a bug originated,
 which can help review a bug fix"

from 
https://docs.kernel.org/process/submitting-patches.html

should there not be just single Fixes tag? as bug originated from one
commit, may be the commit that actually broke the functionality.

P.S.
Not expert on this, just trying to learn.

Kamlesh
