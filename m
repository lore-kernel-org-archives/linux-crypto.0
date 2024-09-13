Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19201BB6AB;
	Fri, 13 Sep 2024 06:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726208900; cv=none; b=mSPJVfR9+b1pe8qaW+xZK6jfIsvyoJuxPDFfNFG44odjjkc+mpERUBzCaCrfEeRTXF2SQDJsFQ6z0lw1sF6wnhgsg3RLwxvdjlkxiAvYrmDhMAaBGnpIC9DP6QGgEMRX+rl5tbDGvru26PMUhuWExraOXQ9jyDJxE4mOeyFWri8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726208900; c=relaxed/simple;
	bh=d1213FnV/G5E9q1+1VPEwN0hPEot4dntSrXSPpLQseA=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NqN1QJqZ1VHFMUt04RC+PPRPEz1Lkl/JztFkgLgBSAnqKGKAAyLH0nux30dUPgVJWhdPkaEIo3RN9ZlkHucF96M0AyVfVU+zpelTIfTb0ytodnvug4zPmvbA24TCALHBUD+3Av7wVm/YbfLjpb3vTdV2mR//8KOvnNj3R54TPo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=i5tpeFrv; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="i5tpeFrv"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 48D6MSnn029205;
	Fri, 13 Sep 2024 01:22:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1726208548;
	bh=GRmZ18pvPzToAni3UO6ERJ/c8A6oDPuUhhPN9lQ0soI=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=i5tpeFrvSkm3jTxmJzVAL1yAIkuc8XzeOBN1R8gIxH+yUpolFpl4hy1hGeAlebZaT
	 hhjBfrGlGQP/h/2akru2NOHfIvCBNY3QtN8j1505YbEi0Emxycm6Cv6RlgPBrf7HGG
	 mNRU+spnwxdVYRPCqzsCldXdK5rpUl8IGGrv/GRU=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 48D6MSS0013694
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 13 Sep 2024 01:22:28 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 13
 Sep 2024 01:22:28 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 13 Sep 2024 01:22:28 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 48D6MRWY065337;
	Fri, 13 Sep 2024 01:22:28 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Michael Ellerman <mpe@ellerman.id.au>, Danny Tsen <dtsen@linux.ibm.com>,
        <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <leitao@debian.org>, <nayna@linux.ibm.com>,
        <appro@cryptogams.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <ltcgcw@linux.vnet.ibm.com>,
        <dtsen@us.ibm.com>, Danny Tsen <dtsen@linux.ibm.com>
Subject: Re: [PATCH 1/1] crypto: Fix data mismatch over ipsec tunnel
 encrypted/decrypted with ppc64le AES/GCM module.
In-Reply-To: <87seu4qmv6.fsf@mail.lhotse>
References: <20240912174537.1409567-1-dtsen@linux.ibm.com>
 <87seu4qmv6.fsf@mail.lhotse>
Date: Fri, 13 Sep 2024 11:52:27 +0530
Message-ID: <875xr0m5ss.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Michael Ellerman <mpe@ellerman.id.au> writes:

> Danny Tsen <dtsen@linux.ibm.com> writes:
>> This patch is to fix an issue when simd is not usable that data mismatch
>> may occur over ipsec tunnel. The fix is to register algs as SIMD modules
>> so that the algorithm is excecuted when SIMD instructions is usable.
>>
>> A new module rfc4106(gcm(aes)) is also added. Re-write AES/GCM assembly
>> codes with smaller footprints and small performance gain.
>>
>> This patch has been tested with the kernel crypto module tcrypt.ko and
>> has passed the selftest.  The patch is also tested with
>> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.
>>
>> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
>> ---
>>  arch/powerpc/crypto/Kconfig            |    1 +
>>  arch/powerpc/crypto/aes-gcm-p10-glue.c |  141 +-
>>  arch/powerpc/crypto/aes-gcm-p10.S      | 2421 +++++++++++-------------
>>  3 files changed, 1187 insertions(+), 1376 deletions(-)
>
> As this is a bug fix it should have a Fixes: tag, and probably a stable
> Cc as well.
>
> But that diffstat is really large for a bug fix. Is there no way to fix
> the issue in a smaller patch? Even if that is just disabling the feature
> until it can be fixed in subsequent commits?
>
> cheers
The commit message says "The fix is to register algs as SIMD modules"

and

"A new module rfc4106(gcm(aes)) is also added."

and I also see some indentation changes.(This can't go with fixes patch,
will just add the noise)

Would suggest to break the patch in three.

I see a big subject line, have you ran the checkpatch?

Kamlesh
