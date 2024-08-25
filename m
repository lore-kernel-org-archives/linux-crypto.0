Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28513EAD2;
	Sun, 25 Aug 2024 11:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724585659; cv=none; b=O1WIHVAC6SlgMtOl5HmR7BYjEaeV28BwPXmdK92+nR4ORJX7785CUB0xbjH2YIF1tsi+Mybbe8QyuqUcZmWruZL/Pkp4cKBxFVTCFa8T2g7ubNcxIpE3KMnEoQ3FUIV/6QH0JOAIzuaq2HmKleWvCsUA6ncKZPepMCZIoPMxJ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724585659; c=relaxed/simple;
	bh=5Kwj/8iCHipZV61jMJdc6ga3SUBrkiOL8U3JCvxOQIY=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Sgn7BnFlWYfv7/qxAiN1MIL6/6vJWCrJ5hy4dgtVdlKjspkmbTXyprjY8414K0U2L+mCJAjZQZbemDPaEToTzoY40iodOyGI4c8U6hg50ave68+ijEhbiCZlGsiyawH22vwJAZqxGhJMdA8UZFVrnuUPilwnFB5t2Zz+gFrJZzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=hvVSIEIM; arc=none smtp.client-ip=198.47.23.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="hvVSIEIM"
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47PBY20O074045;
	Sun, 25 Aug 2024 06:34:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1724585642;
	bh=p1FVXtuN8H0HbaOvNJKiJv8U9+CTJuRUpgpahYDlLWE=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=hvVSIEIMl9hK1fKSmKgDnL+bbtS3bqW/ht7NzIkxzlDgbD37A9xBO3ZFI70O1jSkC
	 ecm5qcln8L7gBKVdM69mFTywIk3v+xTr4PlvQ2/rD8j7qPziZhG7idlKWXwmSMrvsG
	 /2G+jY4rV55/umX5tBvQcT+2FrtNXKqvK262yytU=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47PBY1ne011215
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 25 Aug 2024 06:34:01 -0500
Received: from flwvowa02.ent.ti.com (10.64.41.53) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sun, 25
 Aug 2024 06:34:01 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by flwvowa02.ent.ti.com
 (10.64.41.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2507.34; Sun, 25 Aug
 2024 06:34:01 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sun, 25 Aug 2024 06:34:01 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47PBY0NR054206;
	Sun, 25 Aug 2024 06:34:01 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Waiman Long <longman@redhat.com>,
        Steffen Klassert
	<steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu
	<herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] padata: Honor the caller's alignment in
 case of chunk_size 0
In-Reply-To: <21df0502-3f16-4afc-9f3c-7825ded578c4@redhat.com>
References: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
 <21df0502-3f16-4afc-9f3c-7825ded578c4@redhat.com>
Date: Sun, 25 Aug 2024 17:04:00 +0530
Message-ID: <87y14kn8ev.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Waiman Long <longman@redhat.com> writes:

> This message was sent from outside of Texas Instruments. 
> Do not click links or open attachments unless you recognize the source of this email and know the content is safe. 
> Report Suspicious 
>  
> On 8/21/24 17:02, Kamlesh Gurudasani wrote:
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
>> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
>> ---
>>   kernel/padata.c | 12 ++++--------
>>   1 file changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/padata.c b/kernel/padata.c
>> index 0fa6c2895460..d8a51eff1581 100644
>> --- a/kernel/padata.c
>> +++ b/kernel/padata.c
>> @@ -509,21 +509,17 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
>>   
>>   	/*
>>   	 * Chunk size is the amount of work a helper does per call to the
>> -	 * thread function.  Load balance large jobs between threads by
>> +	 * thread function. Load balance large jobs between threads by
>>   	 * increasing the number of chunks, guarantee at least the minimum
>>   	 * chunk size from the caller, and honor the caller's alignment.
>> +	 * Ensure chunk_size is at least 1 to prevent divide-by-0
>> +	 * panic in padata_mt_helper().
>>   	 */
>>   	ps.chunk_size = job->size / (ps.nworks * load_balance_factor);
>>   	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
>> +	ps.chunk_size = max(ps.chunk_size, 1ul);
>>   	ps.chunk_size = roundup(ps.chunk_size, job->align);
>>   
>> -	/*
>> -	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
>> -	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
>> -	 */
>> -	if (!ps.chunk_size)
>> -		ps.chunk_size = 1U;
>> -
>>   	list_for_each_entry(pw, &works, pw_list)
>>   		if (job->numa_aware) {
>>   			int old_node = atomic_read(&last_used_nid);
>>
>> ---
>> base-commit: b311c1b497e51a628aa89e7cb954481e5f9dced2
>> change-id: 20240822-max-93c17adc6457
>
> LGTM, my only nit is the use of "1ul" which is less common and harder to 
> read than "1UL" as the former one may be misread as a "lul" variable.
>
> Acked-by:  Waiman Long <longman@redhat.com>
Thanks for the Acked-by, Waiman. I understand your point, though Daniel seems
to be okay with this, so will keep it as is this time.

Cheers,
Kamlesh
