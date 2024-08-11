Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8E533C9
	for <linux-crypto@vger.kernel.org>; Sun, 11 Aug 2024 01:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723339839; cv=none; b=K25WnS9pvRkzMlevHjfX773XRa8xG4ereUUYuGQfVXGEiwWk+4kYceb1X3SGud6NsSCmvZNOcF4rnO4wmbLzEdPFxv1rkraX6EkUT3eUcfdO1HZF1ka2ayzMbNW9daNNBnsnXHklqkwQzv/QJtmVp4M8Ss9t9wnpHWGWh3NgmN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723339839; c=relaxed/simple;
	bh=rwxTacSsqq5yZxZCCk9LwOklyI/5rUVH+qneGn1PoCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mRUYZ7z3yWPROBegvMgYVLLJlJ5O2rLGS86cdhpZfXQg9qhk56V2di1uQZVcZcleRNTKlBQigALemSVPH2UVfwA3TSzB/78K9HpfXRt2NuIDHMI4UbhdoKy0dTMm7t/OQd86y30cAqw+5q/7FWrfBlbVbsOYqijFe7ED7jAjGWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KCbyT7DU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KCbyT7DU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723339835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J14+5lRnQsP0ngrAC8bOeli66OZFssq5LR5RO6HiXiI=;
	b=KCbyT7DUfbCRNtLayjXjdgdyE8wyAGuEuOkhA6XQi4Df86gaILIjCR8iN7SMiJLsIglSKj
	vnmW+GDksbEeQx0ZFUYq/3keSixTVKd7N9V6Iv27kddZJ/reQA/sClzLJkCdz0kVksqVan
	W4m8FSX77G0gHuRFlvsNM4OhuM3zeW4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-x5KfbBM_MUqtZUqJXPWI2A-1; Sat,
 10 Aug 2024 21:30:30 -0400
X-MC-Unique: x5KfbBM_MUqtZUqJXPWI2A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEFA31955F43;
	Sun, 11 Aug 2024 01:30:28 +0000 (UTC)
Received: from [10.22.32.2] (unknown [10.22.32.2])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC974197703E;
	Sun, 11 Aug 2024 01:30:26 +0000 (UTC)
Message-ID: <e752f094-adb4-4448-8bc8-e2460330eaec@redhat.com>
Date: Sat, 10 Aug 2024 21:30:25 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
 akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <Zrbm--AxRXgfHUek@gondor.apana.org.au>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <Zrbm--AxRXgfHUek@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15


On 8/10/24 00:05, Herbert Xu wrote:
> Waiman Long <longman@redhat.com> wrote:
>> diff --git a/kernel/padata.c b/kernel/padata.c
>> index 53f4bc912712..0fa6c2895460 100644
>> --- a/kernel/padata.c
>> +++ b/kernel/padata.c
>> @@ -517,6 +517,13 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
>>         ps.chunk_size = max(ps.chunk_size, job->min_chunk);
>>         ps.chunk_size = roundup(ps.chunk_size, job->align);
>>
>> +       /*
>> +        * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
>> +        * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
>> +        */
>> +       if (!ps.chunk_size)
>> +               ps.chunk_size = 1U;
> Perhaps change the first ps.chunk_size assignment to use DIV_ROUND_UP
> instead?

I think DIV_ROUND_UP() will exactly the same problem that if chunk_size 
is 0, you still got a 0 result. round_up() only if the 2nd argument is a 
power of 2 while with DIV_ROUND_UP(), the second argument can be any 
number except 0.

Cheers,
Longman

