Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C94EAD2;
	Sun, 25 Aug 2024 11:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724585387; cv=none; b=O+C5HwumGd9/y0qIh/iB5B0F02qAb2C6j7uBNwDxdIpe3iBf0tDXGGpORpTZtHOQWjPeEdHps+bUr2QK5e8J2VCmTQVWVWDO+wi0VkyrXzp9QYqAM3uCaIQ/V0VGLLVHOZCGzfR0XCD+REps0OWziDP/6e1/bZjjYbGgRVCFafw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724585387; c=relaxed/simple;
	bh=M4pRoAHGHu1qm+pixB3vLyBtEqc4XHIgT7Gs2zoKjBY=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kxA3oW9svHQqUryfcvn/qnS9/WGZR1zYbXeJtG4wENWhjQgek1H8wxD1I1D99Tw9faefkdIwdynRNu7qgJ48wno8fFnhpp4vViqzXcZG6fgnh22uQKIqcZm4NILxBF/6xKbYFM7zsuhGxxhnZXUuq2k3i0Cp91WSKFMTHOZc37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=xKyMuIZp; arc=none smtp.client-ip=198.47.23.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="xKyMuIZp"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47PBTQqU073280;
	Sun, 25 Aug 2024 06:29:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1724585367;
	bh=ExNoaWI/xODsv0v9/4PIKH89wZSK+FQsMCSXGYthPC0=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=xKyMuIZpVB1h9o68KYZT7w37JFH+lqoY9ZkQOz3j+2S7ICvBX54/iV0fP0mp1nlb0
	 SEZEncF0iGDduRhJejz/AtDHPNDycm1if6FPxOGzQ1Ylu6gRNS2KY5y8wfqdMso652
	 QJS8ruBVSRF8uPgNDhGQO7MlGj/VVTRGZnKH5sFA=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47PBTQ4Z069588
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 25 Aug 2024 06:29:26 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sun, 25
 Aug 2024 06:29:26 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sun, 25 Aug 2024 06:29:26 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47PBTPoj057650;
	Sun, 25 Aug 2024 06:29:26 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Daniel Jordan <daniel.m.jordan@oracle.com>
CC: Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Waiman Long <longman@redhat.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] padata: Honor the caller's alignment in case of
 chunk_size 0
In-Reply-To: <iqhynhx6xx67b2jpjazmzufh63nh24uqsawn7thlvlo4ezb3pp@rtvz6u5cc4ug>
References: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
 <iqhynhx6xx67b2jpjazmzufh63nh24uqsawn7thlvlo4ezb3pp@rtvz6u5cc4ug>
Date: Sun, 25 Aug 2024 16:59:25 +0530
Message-ID: <8734mson6y.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Daniel Jordan <daniel.m.jordan@oracle.com> writes:

> On Thu, Aug 22, 2024 at 02:32:52AM GMT, Kamlesh Gurudasani wrote:
>> In the case where we are forcing the ps.chunk_size to be at least 1,
>> we are ignoring the caller's alignment.
>> 
>> Move the forcing of ps.chunk_size to be at least 1 before rounding it
>> up to caller's alignment, so that caller's alignment is honored.
>> 
>> While at it, use max() to force the ps.chunk_size to be at least 1 to
>> improve readability.
>> 
>> Fixes: 6d45e1c948a8 ("padata: Fix possible divide-by-0 panic in padata_mt_helper()")
>
> Looks fine.
>
> Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
>
>> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
>> ---
>>  kernel/padata.c | 12 ++++--------
>>  1 file changed, 4 insertions(+), 8 deletions(-)
>> 
>> diff --git a/kernel/padata.c b/kernel/padata.c
>> index 0fa6c2895460..d8a51eff1581 100644
>> --- a/kernel/padata.c
>> +++ b/kernel/padata.c
>> @@ -509,21 +509,17 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
>>  
>>  	/*
>>  	 * Chunk size is the amount of work a helper does per call to the
>> -	 * thread function.  Load balance large jobs between threads by
>> +	 * thread function. Load balance large jobs between threads by
>
> Though whitespace changes like these just add noise...
Thanks for the Ack, would keep these in mind from next time onwards.

Kamlesh
