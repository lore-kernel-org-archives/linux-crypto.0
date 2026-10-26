Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.61
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792975592;
	b=ETgnUk8/axKQcw2gBDPyelH0+jlVEbjVlMzRQdEzIIIrDYmLuAjv/jymiclbTz0YMt3x
	 nlYfB6O0qjWkNsFox5+ehIAuqSSK1Fo0UgsLQ35K83nni8h7/PVR1k533PYrw9QpVgQ6e
	 It3PM5+II2Q27put3U7KM1yosDYZY7F4fLmCaNJbyza0s1X6lkUxwwpxRrWWn66+ozG/r
	 OBN7h70IJqWn01lLUHO5s+Jy91jOLUZkwI46DaHU3v9ATe+WUrkzcggk/zbw9oY3zJjEZ
	 wE+cO6KFyldGl9vqopnH4ANCnpH79PSnJ3MVK6QioKlTpa1zO4Eoi9nJla98HsoJTkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792975592;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=FAR0iRKXPMW4E6lnTsRJlnzxCnvWYQ6WdVpcOkANE4A=;
	b=eLZRl3DxyjADN8MijOQtf59sDsHa6fWI9w4DmbKnriZl7NGultaH0CA7EIBM31Me1KhC
	 aWgI62J6r3QN1ncIUB5kYhXdHtr1KyDLbjVQIV6DtWWtCKBvqluTTh7Nw0gQx7Q8eK73r
	 +xnpUF2IJ6yu9NYIQe4oxjWCyRfVZKKO/5/ABEl+9dhbAQCmiisg8XisRw0aKJ1lRu+lB
	 mX9t9bQXqRt1ULJukcXdb/uyvSnpTfVOJiY2t3vC/S8tQdEg65pizT2wTleWiKDvTc7Rc
	 4sB1cgMJG6A6MLzqaCq0SMrktSC3Vfi2VhBTq4ybww8+jWUcpA6cpJhbURfaVwQ2XQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=kbgmTutz;
	arc=none smtp.remote-ip=195.10.208.61
Received: from mout-b-201.mailbox.org (mout-b-201.mailbox.org [195.10.208.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DFF606A31D;
	Mon, 26 Oct 2026 00:46:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3DFF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=kbgmTutz
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-201.mailbox.org (Postfix) with ESMTPS id 4jCZgd5YSgzLlW8;
	Mon, 26 Oct 2026 01:46:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1792975581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FAR0iRKXPMW4E6lnTsRJlnzxCnvWYQ6WdVpcOkANE4A=;
	b=kbgmTutzvbAkkgXjacjxueUC05s3Y82cfmdE2HrNo/7IXzihACN9Jz/ce6qoXyZyvzXsrL
	udGgxEsvd3YjagmYw3G9gHvsl7IoLPDGvkIfKAQUpVa8us0+OsVc+Om939bL2QixO3MWg0
	5qJMA5b6kwexlMCyvmoj7R1SHdm6qqGkRTGAkfHtHGMixL+P0oD2UJOxYZty22r+bbu7+l
	SHdLNkZoN6azxgEiblhurNubGo/fuadFbSponIX3vXAUh19gUFSnhMIowdJeLULZCi6NWK
	E5bEhpVTeyUqfLxx5tJCy+BVWAMj2vqdU3Ycls17CfAhhOTEUp4DQQVtZL7aGQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <3e2dee91-bba4-42e3-9d22-619ea54484e4@mandelbit.com>
Date: Mon, 26 Oct 2026 01:46:19 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] lib/crypto: x86/chacha: Add 16-block AVX-512
 implementation
To: Eric Biggers <ebiggers@kernel.org>, Martin Willi <martin@strongswan.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
 <ardb@kernel.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261025234758.3219829-1-antonio@mandelbit.com>
 <20261026003510.GA1843@sol>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261026003510.GA1843@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jCZgd5YSgzLlW8

Hi Eric, Martin,

On 26/10/2026 01:35, Eric Biggers wrote:
> [+Cc Martin Willi <martin@strongswan.org>]
> 
> On Mon, Oct 26, 2026 at 12:47:53AM +0100, Antonio Quartulli wrote:
>> Hi all,
>>
>> this series adds a 16-block ChaCha implementation for x86 using 512-bit
>> registers. It is preceded by a KUnit suite and benchmark for
>> chacha_crypt(), as lib/crypto has none for plain ChaCha yet.
>>
>> Patch 1 stands on its own and passes with and without patch 2.
>>
>> On AMD Zen 5, the new code doubles chacha_crypt() throughput for inputs
>> of 1 KiB and more, from about 5.2 GB/s to about 10.2 GB/s. It came out
>> of work on the OpenVPN data channel offload driver (ovpn), whose
>> ChaCha20-Poly1305 throughput is CPU-bound: in a VM benchmark it gained
>> about 10% at a 1500-byte MTU and 35% at 9000.
>>
>> iPlease note that I could only measure Zen 5.
>> The new code is not used on the CPUs setting X86_FEATURE_PREFER_YMM
>> (Skylake-X, Ice Lake and Tiger Lake), but it is on
>> Rocket Lake, Sapphire Rapids and later, and on Zen 4, where 512-bit
>> operations are split into two halves. Numbers from any of those would be
>> very welcome.
> 
> Can you clarify how your AVX-512 implementation differs from
> https://lore.kernel.org/linux-crypto/20260722153247.630519-1-martin@strongswan.org/
> ?  See also the feedback I left on it here:
> https://lore.kernel.org/linux-crypto/20260722232424.GA50619@quark/
> That applies to this one too, it looks like.
> 

It doesn't differ in any meaningful way, sorry.

I had missed Martin's patch and mine basically takes the same approach
(sixteen blocks in zmm registers, used for inputs longer than eight
blocks and skipped on CPUs setting X86_FEATURE_PREFER_YMM).
It also doesn't address your consolidation feedback either.

@Martin, since you mentioned a series consolidating the AVX2 and
AVX-512 block functions, please consider my patch 2 withdrawn in favour
of yours.

I'm happy to test and benchmark it, including with ovpn, and if
you'd rather hand the consolidation over, just let me know and I'll see
what I do.

Patch 1 (KUnit tests and benchmark for chacha_crypt()) is independent
of the AVX-512 code: it compares chacha_crypt() against
chacha_block_generic() for every length up to 4100 bytes and random
ones up to 12 KiB, with guard pages, in-place and split calls, plus the
RFC 7539 vector.

@Eric, would you consider it on its own? It would cover Martin's series
as well. I can resend it standalone if that's easier.

> Side note: "Zen 5" needs clarification.  The vector execution units
> aren't as wide on the Zen 5 mobile processors as on Zen 5 desktop and
> server.  Probably your numbers apply to desktop and server only.  (I've
> made that mistake in the past before, but they are indeed different.)
> 

Right, they were measured on a Ryzen 9 9950X (desktop), thanks for
pointing that out.

Thanks,

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

