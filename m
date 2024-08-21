Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657DE1531D7;
	Wed, 21 Aug 2024 08:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724227883; cv=none; b=JHabnIcbduFqdkIN/yYsqpE/5ZvXqfO/Of0fMGrfxLRS2wF+kn6RYZoOznhbgqxtOAXVraO5lp+2n9nazd2xpeVv6s7EbHbKKTJIb5ga45GZISqXapRgpM8vB/qkxGOp5rCbs0KfayN6peM9cthAGdcnhV+4FMzouafp+zDUbsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724227883; c=relaxed/simple;
	bh=9hxNZK6v5CInN11tdPzCzlgTtj89NPU5MEoY7XUW4GA=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=htjZmxt1Yn24lNaqhU+xc39F6ahNVCE3fP3RxnvUou0M/cqpVBQmOieNhHF6kVJNFstugg0x117O8gAT7XNQNzZxKwg6ENJEIbY7NBpReLOpF0K7ry04yeo6+TwbvbWPRrUFNBQfb9ybKP1U7FxuMOwICQ3OzOs6mlTnPuVBR/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=yCf8tmn2; arc=none smtp.client-ip=198.47.23.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="yCf8tmn2"
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47L8Aqei059189;
	Wed, 21 Aug 2024 03:10:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1724227852;
	bh=Eaj7AVq33zet2jnoyBjCj2r6G6q687zl0HhGbgeZ8pE=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=yCf8tmn2KGAxsC0xX6RVubMmeaMPAwQViZG39VwvuKvPZBR7ju/1YaBMh7W7zHA/8
	 C7FxqzdCr8uqk/Pra6VK96YsSlqwzJe1I/mlQMiEO95vV5g6Bxp2ooSjcfwg6lp+eN
	 O6hFB9jFVBiG9JfsN9IHe+repkVp6FJx6ek2zIAA=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47L8AqRK104835
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Aug 2024 03:10:52 -0500
Received: from lewvowa02.ent.ti.com (10.180.75.80) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 21
 Aug 2024 03:10:52 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by lewvowa02.ent.ti.com
 (10.180.75.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2507.34; Wed, 21 Aug
 2024 03:10:51 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 21 Aug 2024 03:10:51 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47L8ApVH087519;
	Wed, 21 Aug 2024 03:10:51 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>
CC: Waiman Long <longman@redhat.com>, <steffen.klassert@secunet.com>,
        <akpm@linux-foundation.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] padata: Fix possible divide-by-0 panic
 in padata_mt_helper()
In-Reply-To: <3kexyvcrc5pxp4cqlgt7tvdbo3hbt225w76kczjdlzwitpeuto@addhycc4evbe>
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
Date: Wed, 21 Aug 2024 13:40:50 +0530
Message-ID: <87bk1mnvn9.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Daniel Jordan <daniel.m.jordan@oracle.com> writes:

> On Tue, Aug 20, 2024 at 12:06:47PM GMT, Herbert Xu wrote:
>> On Mon, Aug 19, 2024 at 06:29:52PM -0400, Daniel Jordan wrote:
>> >
>> > The DIV_ROUND_UP approach reads a bit nicer to me, but I can imagine
>> > oddball cases where rounding up is undesirable (say, near-zero values
>> > for size, min_chunk, and align; padata_work_alloc_mt returns many fewer
>> > works than requested; and a single unit of work is very expensive) so
>> > that rounding up makes a bigger difference.  So, the way it now is seems
>> > ok.
>> 
>> In that case let's do the max ahead of the align check:
>> 
>> 	ps.chunk_size = max(ps.chunk_size, 1ul);
>> 	ps.chunk_size = roundup(ps.chunk_size, job->align);
>> 
>> If we do it after then it may come out unaligned (e.g., job->align = 8
>> and ps.chunk_size = 1).
>
> Sure, I think Kamlesh was the first to suggest max, so maybe Kamlesh
> would like to make the change.  I'll send a patch otherwise.
Thanks for consideration, Daniel. I'll send a patch.

cheers,
Kamlesh
