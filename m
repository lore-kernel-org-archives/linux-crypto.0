Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61021862
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 00:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724112476; cv=none; b=SrzfOG0kXUODOCCdZLp2OqrHHJlFiRLIynm2QGOANGTnHaxoeao6Hy4BdSKACvJdZy699rIZ6ZzSOaxqT+QurWyKldlhnqEaE63Y2oucHw17bWxlr/DRJ04Zr2bAf5rb3j8OfNDTSWaljovZsWrHGd85/uFgfOPD6V4b5eRnZOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724112476; c=relaxed/simple;
	bh=kAggRSDu583wxxJ9jzUF7klJtT8ZvbPXIdmEoblBV/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B9Mnt9jZ8iVJ7CDxggc412dPsYrDli/9QWc0NcMhy0ktRhrhZKijMOtyF77c0gsst7Eo36QoxrVBG0980FbsYInANNwo+WrRv3H6pKtRU4AdGGKw9OisUukQ8SPySMqlA6jNYUXG7waIBatvw/MQzkfvgY25dnb5f3wT/oDn5Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Avfr3PSb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Avfr3PSb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724112473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpEXdW1E+Fg0C4DaKnGXHprFckkZuEg6MAwJNzIzuEs=;
	b=Avfr3PSb5KSUkZQ0yHPjuVFRc+RtSalhFbtKqcH6fG9fym5e7moB70i2icnfq3HbGM42wx
	7zJa1SQgSVnoo3FGfBp13rGII7SWjspuJ/c+LJWhUJTR4VihU0Xu3SPp5Hi2JS/1kbfVPh
	StP9dNgpLzy7N9ZgYskRv3ppyqipbWs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-OcQH1AmoNvCjTLEIB2pnIA-1; Mon,
 19 Aug 2024 20:07:50 -0400
X-MC-Unique: OcQH1AmoNvCjTLEIB2pnIA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FD161955D45;
	Tue, 20 Aug 2024 00:07:48 +0000 (UTC)
Received: from [10.2.16.112] (unknown [10.2.16.112])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D39FF19560A3;
	Tue, 20 Aug 2024 00:07:46 +0000 (UTC)
Message-ID: <0d8c956b-9397-4268-830b-2abe19ec3066@redhat.com>
Date: Mon, 19 Aug 2024 20:07:45 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
To: Daniel Jordan <daniel.m.jordan@oracle.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: steffen.klassert@secunet.com, akpm@linux-foundation.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Zrbm--AxRXgfHUek@gondor.apana.org.au>
 <e752f094-adb4-4448-8bc8-e2460330eaec@redhat.com>
 <ZrgXtLI1R5zJ9GFG@gondor.apana.org.au>
 <91d29649-ca88-4f6c-bf1d-19e49c9555df@redhat.com>
 <ZrgsU-1PdxvUVMOW@gondor.apana.org.au>
 <88c188dc-3664-45db-b54a-11feca59d7d2@redhat.com>
 <Zrgy1TDikPSkzaYP@gondor.apana.org.au>
 <c5cc5ea9-1135-4ac6-a38f-652ed07dae17@redhat.com>
 <ZsBNZXfVZbtZnb2Y@gondor.apana.org.au>
 <dgtppozpgkm2gtv7nnvranbkjudr7bwuvfe7hjbznipozcxyzd@3qcag7izn4fj>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <dgtppozpgkm2gtv7nnvranbkjudr7bwuvfe7hjbznipozcxyzd@3qcag7izn4fj>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 8/19/24 18:29, Daniel Jordan wrote:
> On Sat, Aug 17, 2024 at 03:12:37PM GMT, Herbert Xu wrote:
>> On Mon, Aug 12, 2024 at 10:04:07AM -0400, Waiman Long wrote:
>>> Anyway, using DIV_ROUND_UP() is a slight change in behavior as chunk_size
>>> will be increased by 1 in most cases. I am a bit hesitant to make this
>>> change without looking into more detail about the rationale behind the
>>> current code.
>> I don't think it matters much.  Just look at the two lines after
>> the division, they're both rounding the value up.  So clearly this
>> is expected to handle the case where work gets bunched up into the
>> first N CPUs, potentially leaving some CPUs unused.
> Yeah, the caller is supposed to use min_chunk as a hint for what a
> reasonable amount of work is per thread and so avoid wasteful amounts of
> threads.
>
>> But Daniel wrote the code so he can have the last say of whether
>> we should round up after the division or after the other two ops.
> I think either way works fine with the three existing users and how they
> choose job->min_chunk and job->size.
>
> The DIV_ROUND_UP approach reads a bit nicer to me, but I can imagine
> oddball cases where rounding up is undesirable (say, near-zero values
> for size, min_chunk, and align; padata_work_alloc_mt returns many fewer
> works than requested; and a single unit of work is very expensive) so
> that rounding up makes a bigger difference.  So, the way it now is seems
> ok.
>
>
> By the way, this bug must've happened coming from
> hugetlb_pages_alloc_boot(), right, Waiman?  Because the other padata
> users have hardcoded min_chunk.  I guess it was a case of
>
>      h->max_huge_pages < num_node_state(N_MEMORY) * 2
>
Yes, I guess the hugetlbfs caller is the cause of this div-by-0 problem. 
This is likely a bug that needs to be fixed. The current patch does 
guarantee that padata won't crash like that even with rogue caller.

Cheers,
Longman


