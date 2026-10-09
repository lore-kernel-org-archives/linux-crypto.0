Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76919440A25;
	Fri,  9 Oct 2026 13:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552387; cv=none; b=W0bT54mMw+2EdbVEXGuu9JpFEbxXfrpfsd7oJFOQ10upmYMFdHeIIXLFrQEbyTZ3QnidNqtQka8EMRVykI1velCyqplOO4kLPUaMmZg4dW1o/iQcuYYHwFFvcvmC/gglfD9Bp8EjtPiZ4qx00JPV1dKB+XOnMKRkOg9LNVY4XZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552387; c=relaxed/simple;
	bh=iVfJIfIE/XENcWWZ9WWJ+tx0CmQq9Yzyw64UOlG421g=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=lExq1YsGM5xWzrGHVBFh/JLi2srAAQhZgZQEe0zbBlhf0fDNbt3yxJEVVJnOzMhKv8NmvKm7+YjRe7v+l1Fn5DJ8IZY6jSon9sqc9kHmH14nbb6OCq/Vs/4W8pgAhpXwMnItlTMWQQU+Ja2I0lNH/DlSDkXSIigFrjNlaccaxkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=Mwb6ScPc; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="Mwb6ScPc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=VfRAaihF3W9H/OxSy62htlpGcHV+yg/dlUcG3KVF9Mc=; b=Mwb6ScPcHwAQ0frNn++S7CnnGo
	GNY3ULWNtVcky4Z39VWOuC9tCXdVNpUclftextn2v4WP21Hj2GBbDeIzJZWAQAsfaTuguOTs+jCKY
	wbchbRfsjX8Fr4Zu9GUkec95YOYDQYgzoZ68Ta7cwlhzsVwRDQ0RCCdR8iCqGcQM8yo74xQUeTXlu
	Kn96WtG6mc4IhV0DibsirohuspAQVXdMHffKVO8arv4Q+wcYPw7LVZtahsi9z9t2g5l6URssU6OYn
	ortqng8fL2weHF2xYMj6whk12A9ZPWzvuO3T20NvlJA/YeLVNAwT/3EFrxfpaxY09DHTZr+vVZ4MV
	ws3v210g==;
Received: from [::1] (port=53922 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xFAcC-0000000Cuxr-0nJ3;
	Fri, 09 Oct 2026 15:26:23 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 09 Oct 2026 15:26:23 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
 <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] lib/crypto: arm64: Fix lost Poly1305 carry when
 resuming NEON state
In-Reply-To: <20261009130310.GA309826@quark>
References: <20261008201949.561207-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261008201949.561207-4-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261009130310.GA309826@quark>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <98223a03dc250211153c1013232f2ce6@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-10-09 15:03, Eric Biggers wrote:
> On Thu, Oct 08, 2026 at 08:19:50PM +0000, Jérémy Jean wrote:
>> These limbs in base 2^26 represent the value
>>       4
>>     + (2^26    ) * 2^26
>>     + (2^26 - 1) * 2^52
>>     + (2^26 - 1) * 2^78
>>     + (2^24 - 1) * 2^104
>>   = 2^128 + 4,
>> so converting back to base 2^64 must produce
>>   h0 = 4, h1 = 0, h2 = 1,
>> so that h0 + h1 * 2^64 + h2 * 2^128 = 2^128 + 4.
>> 
>> The third limb starts at bit 52, so its low 12 bits belong in h0 and
>> its upper 14 bits belong in h1. The low-word ADDS starts from
>>   4 + 2^26 * 2^26 = 2^52 + 4
>> and adds the low 64 bits of
>>   (2^26 - 1) << 52 = 2^78 - 2^52,
>> namely 2^64 - 2^52. The sum is 2^64 + 4, so it leaves h0 = 4 and
>> carry = 1.
>> 
>> The middle word contains the upper 14 bits of the third limb, all of
>> the fourth limb, and the low 24 bits of the fifth limb. The next ADC
>> adds the carry from h0 to
>>   ((2^26 - 1) >> 12) + ((2^26 - 1) << 14),
>> giving
>>   (2^14 - 1) + (2^40 - 2^14) + 1 = 2^40.
>> The following ADDS adds the low 64 bits of
>>   (2^24 - 1) << 40 = 2^64 - 2^40,
>> so the sum is 2^64, h1 wraps to 0, and carry = 1.
>> 
>> The top word starts from the remaining bits of the fifth limb,
>>   (2^24 - 1) >> 24 = 0.
>> The final ADC must add the carry from h1 and set h2 = 1. Writing the
>> carry into d2 instead leaves h2 = 0, so the reconstructed value is 4
>> instead of 2^128 + 4.
> 
> Thanks, but this LLM-generated "explanation" is way too verbose and
> doesn't really say anything useful.  The new test in patch 2 is also
> unnecessarily specialized to this exact issue and implementation, isn't
> properly explained, and it's apparently LLM-generated too.  I'd 
> normally
> give a bit more time for submitters to fix things up, but since it will
> likely just go back into the LLM, I don't think there's much point 
> here.
> So I went ahead and sent out a v3 that addresses these issues.

I did get help from LLM for the test, but I did write the explanation 
myself
to explain the carry propagation in the computations. I thought it 
explained
the carry bug nicely enough with an example, sorry that you disagree.
I also added a paragraph on the probability that this happens, because 
it's
very low and AFAICT, does not really impact current deployements.

Jérémy
