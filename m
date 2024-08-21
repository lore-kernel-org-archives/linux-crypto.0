Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CB416EB76;
	Wed, 21 Aug 2024 21:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724274672; cv=none; b=QqQbSNsoKKzf76hIisRzYmdbRn6g2ser6yjPoq63GxOlFV3slSFmZ4PrDxCkQsTAzbBh2wXC+9uHjS0zrbdG+4W/hQ4nVJj++yoKFJps2l1/rpZ0UVZwprLPWwZpz+7fawxm+Ztm7TYuqXxAr42KL8bGDCYEiRlKfeuJxqZAqYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724274672; c=relaxed/simple;
	bh=mN41pj977FmWYbSRwVaWkMoGypbYHhGNkyDUK/aF7ww=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=INsuPPf3I3AcECtBk34+J+7GnjYTLpaAtMfV8sbb/JLqQN4x8eqZ9awwf5aae1Fc+fpsyxwzITgyaKh+wMhZ2puwuAeb+AN6dvJ9BiGdPVsRPwxBVk1Zi8fOHcAxJiBu9Bmsn0uRIXWq9jvFCBrM5uhud4yLeVbWzqyk1xm78So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=P/mdg3IP; arc=none smtp.client-ip=198.47.23.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="P/mdg3IP"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47LLAxC2042110;
	Wed, 21 Aug 2024 16:10:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1724274659;
	bh=e+Pe5qHbfIoXGrIPUqhyvZ1/ONTkySDiDp/bXEauUI8=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=P/mdg3IPZbeTLD2Mcbat27nti+8lIg7qCR6xXJH7viPS1BMTvUv7FijzkXRTj9Ye2
	 Q4pCmS8FHwUC3+BvoShSMM6FW64FnNfsUAlCcALFVzPdbOjs8cH3+xuy2k7BBExdH2
	 jgdiYSnhQ18IQ3CN8wW5pR7UzZjdA4l3h78RfY+s=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47LLAxpN114191
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Aug 2024 16:10:59 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 21
 Aug 2024 16:10:58 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 21 Aug 2024 16:10:58 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47LLAwjl057124;
	Wed, 21 Aug 2024 16:10:58 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>
CC: Waiman Long <longman@redhat.com>, <steffen.klassert@secunet.com>,
        <akpm@linux-foundation.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
In-Reply-To: <87bk1mnvn9.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
References: <e752f094-adb4-4448-8bc8-e2460330eaec@redhat.com>
 <ZrgXtLI1R5zJ9GFG@gondor.apana.org.au>
 <91d29649-ca88-4f6c-bf1d-19e49c9555df@redhat.com>
 <ZrgsU-1PdxvUVMOW@gondor.apana.org.au>
 <88c188dc-3664-45db-b54a-11feca59d7d2@redhat.com>
 <Zrgy1TDikPSkzaYP@gondor.apana.org.au>
 <c5cc5ea9-1135-4ac6-a38f-652ed07dae17@redhat.com>
 <ZsBNZXfVZbtZnb2Y@gondor.apana.org.au>
 <dgtppozpgkm2gtv7nnvranbkjudr7bwuvfe7hjbznipozcxyzd@3qcag7izn4fj>
 <ZsQWV_j5zMuYWqvH@gondor.apana.org.au>
 <3kexyvcrc5pxp4cqlgt7tvdbo3hbt225w76kczjdlzwitpeuto@addhycc4evbe>
 <87bk1mnvn9.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Date: Thu, 22 Aug 2024 02:40:57 +0530
Message-ID: <878qwpoa3i.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Kamlesh Gurudasani <kamlesh@ti.com> writes:

> Daniel Jordan <daniel.m.jordan@oracle.com> writes:
>
>> On Tue, Aug 20, 2024 at 12:06:47PM GMT, Herbert Xu wrote:
>>> On Mon, Aug 19, 2024 at 06:29:52PM -0400, Daniel Jordan wrote:
>>> >
>>> > The DIV_ROUND_UP approach reads a bit nicer to me, but I can imagine
>>> > oddball cases where rounding up is undesirable (say, near-zero values
>>> > for size, min_chunk, and align; padata_work_alloc_mt returns many fewer
>>> > works than requested; and a single unit of work is very expensive) so
>>> > that rounding up makes a bigger difference.  So, the way it now is seems
>>> > ok.
>>> 
>>> In that case let's do the max ahead of the align check:
>>> 
>>> 	ps.chunk_size = max(ps.chunk_size, 1ul);
>>> 	ps.chunk_size = roundup(ps.chunk_size, job->align);
>>> 
>>> If we do it after then it may come out unaligned (e.g., job->align = 8
>>> and ps.chunk_size = 1).
>>
>> Sure, I think Kamlesh was the first to suggest max, so maybe Kamlesh
>> would like to make the change.  I'll send a patch otherwise.
> Thanks for consideration, Daniel. I'll send a patch.
Sent.

Just curious about one thing on line 495,

nworks = max(job->size / max(job->min_chunk, job->align), 1ul);

what happens if both min_chunk and align are 0.

cheers,
Kamlesh
