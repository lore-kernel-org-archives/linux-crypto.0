Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C3B75804;
	Sun, 25 Aug 2024 11:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724585298; cv=none; b=DxmL347DKF0GOqIBp5MiSiUMe46jN5IuSXABlQ9Y8vxw+rTEpnst7DZqR96n81mQMxi4HdOdRct7wQUzf60QyaBaRu+TpBRbpRSxLkslm1f/XsVdnWyn8pXIfApt1MFMQZkkgIeDZTpBA/LlT7J/+Z7ijyF5lqnT76TEMH4/Q0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724585298; c=relaxed/simple;
	bh=aKL2+WnKMItoTgXl5Q9BEp9gPqH6uqq5r/lOHNMsaEY=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YBfMjPqRv+sls/4xojDKkwWIusSketA87EFJZJZr79r8FHKkC68T2uq0VntLQWElLmRDNXImoaIm8VnFaFPcbDEGLCusFo0yqsN63P+2waduRZd/M/qOJkXXWG7AlCzG8Dh4d6p3VUH2xS8gL2SHz51OtloEhfxb1mgRkYqkPdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=xHqlT4v6; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="xHqlT4v6"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47PBRuPO100175;
	Sun, 25 Aug 2024 06:27:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1724585276;
	bh=13HkAd8uIykV2ZLB5tTbdO7zhur6caaq5inBbOyHjmw=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=xHqlT4v6fbGGgSfnbPvmOhZZ/UYMOO6qdOIttVNDXkvxFL95dkBDUHOZUJfwNz3Jl
	 nsTh+92JrT7U0U3GsRCqgSUi/ESVlr7vEG2HXhS7/7auXOjSp8iXZDH5+56Ve7y4a0
	 uXuYdtuJKu/pw0bBbK66MtlWR1lX8ZalGLef+fHM=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47PBRuhQ068991
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 25 Aug 2024 06:27:56 -0500
Received: from lewvowa01.ent.ti.com (10.180.75.79) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sun, 25
 Aug 2024 06:27:56 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by lewvowa01.ent.ti.com
 (10.180.75.79) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2507.34; Sun, 25 Aug
 2024 06:27:56 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sun, 25 Aug 2024 06:27:56 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47PBRtPh056683;
	Sun, 25 Aug 2024 06:27:55 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan
	<daniel.m.jordan@oracle.com>,
        Waiman Long <longman@redhat.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] padata: Honor the caller's alignment in
 case of chunk_size 0
In-Reply-To: <20240821154136.a09fa0e80903aa9ae17d43bd@linux-foundation.org>
References: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
 <20240821154136.a09fa0e80903aa9ae17d43bd@linux-foundation.org>
Date: Sun, 25 Aug 2024 16:57:54 +0530
Message-ID: <875xroon9h.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Andrew Morton <akpm@linux-foundation.org> writes:

> This message was sent from outside of Texas Instruments. 
> Do not click links or open attachments unless you recognize the source of this email and know the content is safe. 
> Report Suspicious 
>  
> On Thu, 22 Aug 2024 02:32:52 +0530 Kamlesh Gurudasani <kamlesh@ti.com> wrote:
>
>> In the case where we are forcing the ps.chunk_size to be at least 1,
>> we are ignoring the caller's alignment.
>> 
>> Move the forcing of ps.chunk_size to be at least 1 before rounding it
>> up to caller's alignment, so that caller's alignment is honored.
>> 
>> While at it, use max() to force the ps.chunk_size to be at least 1 to
>> improve readability.
>
> Please (as always) describe the userspace-visible runtime effects of
> this change.  This helps others to determine which kernel(s) should be
> patched.  And it helps others decide whether this fix might address an
> issue which they are encountering.

Thanks for the review, Andrew.
Honestly, I'm not sure the effects would be visble to userspace or not.
or even how to reproduce it.

I have fixed according to discussion here,
https://patchwork.kernel.org/project/linux-crypto/patch/20240806174647.1050398-1-longman@redhat.com/#25984314

Kamlesh
