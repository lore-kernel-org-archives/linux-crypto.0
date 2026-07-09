Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA382D73B5
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783615579; cv=none; b=gMbxYeNqREgnZBzPQ6UCh5q/ySABqU8p3SgeMIu3lfcYyM15/EENafdyGOnRTi+fVhipMobnNLROXzZ1LpDyfQHYG63FPfypH2N8cToq65MZQWgS/BUvSprohWf6OjVgueMrcUqbSpkR/VbaZhneEJtIHbXpngGVnrcqhUnkpKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783615579; c=relaxed/simple;
	bh=otTC6SWPYJMqjzpxVTTZFK7pUqDlvYF9xisxG/ze9rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bvxjnQkkhhc9OSq4PsddmmBaVPMFuRIyo2k10ZolAmGsZHbgDMC+hXv1gdachrZZ3UZP4Fw4jllZxXprmx+nTEm8W3woK8aONqM4GPdgk9/yE3+l2XtBiVtFSFfhqbWLb59DqiEl9ARVgFMQOh+Mp8MJegEUDvRDvtSp38xs7eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VEgBn30C; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VEgBn30C"
Message-ID: <00f69e6f-9c8a-40fa-8f90-783923852554@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783615576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tDEpryh+SyUxaQOwREu9yoL0dzQRuks+AVWoUMvWH+Y=;
	b=VEgBn30CHTdK7CxCe8VsvHk1a+iCuix3qq23Y/QMRtkn7G7lfZW2itY1ZE4fxSPHjXx5Kv
	P4RRk2YOyCpe1bhBQSZgdyIcfVFAkLXCT1Q3LUgmIJcsIXjB4Hhh3liHWXU78ImijFhD6M
	GGY/hIApEhcChOXZ0PZQ/MtgK9rT8/E=
Date: Thu, 9 Jul 2026 17:46:03 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 29/33] bpf: crypto: Use AES-CBC and AES-ECB libraries
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf <bpf@vger.kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-30-ebiggers@kernel.org>
 <10eafa42-1142-4ed2-a485-f46c496bddfb@linux.dev>
 <20260707182049.GA2238@quark>
 <d1cdfc23-b336-49a9-8833-29f05b5b9fec@linux.dev>
 <20260707231652.GA2264445@google.com>
 <5f9c3aab-5339-463c-a86d-edac297e1e95@linux.dev>
 <20260709154713.GB6853@quark>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20260709154713.GB6853@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 09/07/2026 16:47, Eric Biggers wrote:
> On Wed, Jul 08, 2026 at 12:47:43PM +0100, Vadim Fedorenko wrote:
>> On 08/07/2026 00:16, Eric Biggers wrote:
>>> On Tue, Jul 07, 2026 at 11:50:33PM +0100, Vadim Fedorenko wrote:
>>>>> Does this mean the AES-ECB support is unnecessary and can be dropped?
>>>>
>>>> Let's keep it if it doesn't hurt.
>>>
>>> It kind of does.  It is "bad" crypto that would have to continue to be
>>> maintained, and someone might start using it accidentally.
>>
>> AES-ECB was introduced as a cipher to use in QUIC-LB draft,
>> draft-ietf-quic-load-balancers-21
>>
>> I know it is expired draft, but it may be worth keeping this cipher
>> as QUIC WG github is still active
> 
> Sigh.  We shouldn't implement Internet-Drafts that have clear issues
> with how they use cryptography.  They're likely to change when they
> undergo cryptography review.  We went through this same thing with
> TCP-AO, where I ended up joining the tcpm working group and getting the
> draft fixed.  Do I need to do the same with this one too?

Looks like they need some crypto expert joining WG, but I'm not
currently following the group, unfortunately.
