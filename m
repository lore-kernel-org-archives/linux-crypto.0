Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794524056;
	b=ZTVkAo06o/hOAX932rJopuLJ6Q6ltg/CyMwiy+0HI9s0+e5SdrX7ZvLd3f2T4aW9qEzd
	 Sgb0deNh13VI21wjwrFPGpelRVC037iKPN3uW8oIiAk6mhiSS0rMpeIB2V15wxMD//a0E
	 204AgU2G3h/K5jkrPc2EJCJZGKQjVgERW7OXHPIPMa4s15GSr9EV6HyBIG9DK/14HZwCU
	 Y2JJXT1AEtNLVC4aDtFvTnQkmvCZ7vC/6CUcIVyPjPosNwdJq2eHPYHpmZ2rYbbYAnf5k
	 g8urnsYZ8W5stu07j2gUztAeRYWrdnqGwwjtTdSo+Yx3BCAtVojH0pC5dKf0pWpdmDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794524056;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=3A2o/0R5Gfp0PfuhwYBp0nZGhDg5okhLIrRDf7jWboU=;
	b=bWcOJ/BSXFd29kBDiBT2EPI7m1e9ttpaLA7HR11GnwKKHlO7h6DAp0b7rFIc2KujN7aq
	 4sdTwrk9exXXO9EuhrgN7dE30S15CN/a8bpkVk7pAg88IYYufxkYIcU1XuHpyv+IDoOrK
	 LGCd/Vvbi/IiLqXafAyAopfA5L7TiLwwqAIJ3flfjZEIOUC/miYZROkxelGM/N6feoBgi
	 u9R1vlXA4AHkfjn3fFQE7+4tn89P+iXrGKeyKBoiX9P+j1Z0uNTLA6GmA21CRkQPw/Yuk
	 yr7lwjYb9oQQGGuuReWT+r+iD88af03fg1jPuDnEtH8RHWknfiaBIjQop7tMNbb6lcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=XLF9tsq9;
	arc=none smtp.remote-ip=195.10.208.47
Received: from mout-b-107.mailbox.org (mout-b-107.mailbox.org [195.10.208.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D4E606A323
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:54:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0D4E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=XLF9tsq9
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-107.mailbox.org (Postfix) with ESMTPS id 4jQbKt5H1cz3xKB;
	Thu, 12 Nov 2026 23:54:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794524050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3A2o/0R5Gfp0PfuhwYBp0nZGhDg5okhLIrRDf7jWboU=;
	b=XLF9tsq9p3t2RTNGXHc6N+aSGJKPlndao2xrbCC0ka0SsTQFYn29nV1/CExzy+0bM7njtg
	9z1BYVeRHjrxVDY8NyoE4mmAFnDyzeZQsd5o5vOZAdvgnWwaZSJ4Xjla++ifuCQWQiY+1f
	HxIR+RpHrCS/x/4Vjvz9V8nPH7bVi26X1P8tlDmwd31u3aGavn/MBOieiNSkHSpoAildex
	HonvKcjpJ4jAqI/GnnopnFre43dMi5pZn0uTlH/bOQbf2n7sIrhExurLep2Oh3GB7WpYPA
	ty0COFfYEYqiMT0C672DVZorARAz2wkK0SEuMNFzuxV1t+kPHZh85qeMH136Jw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <c24fdd26-7e77-4dca-a0fc-94c998ebdff8@mandelbit.com>
Date: Thu, 12 Nov 2026 23:54:05 +0100
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
Subject: Re: [RFC PATCH 0/5] lib/crypto: Add AEGIS-128X4
To: "Jason A. Donenfeld" <jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: Antonio Quartulli <antonio@openvpn.net>, linux-crypto@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, Ralf Lici <ralf@mandelbit.com>
References: <20261112125432.3064939-1-antonio@openvpn.net>
 <1906b5ed-7650-484c-9eb0-a99c8e27c943@app.fastmail.com>
 <CAHmME9qSPWDhrvoQH=QX2hj+Ei7mcTYFqy-M+kMnJhgzRuJ1dQ@mail.gmail.com>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <CAHmME9qSPWDhrvoQH=QX2hj+Ei7mcTYFqy-M+kMnJhgzRuJ1dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4jQbKt5H1cz3xKB

On 12/11/2026 17:44, Jason A. Donenfeld wrote:
> On Thu, Nov 12, 2026 at 5:20 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>>> This series adds AEGIS-128X4, the 4-way parallel variant of AEGIS-128L
>>> specified in RFC 10032 (Informational, September 2026), as a crypto
>>> library with an x86_64 VAES-AVX512 implementation, a KUnit test suite
>>> and benchmark, and a crypto API wrapper.
>>>
>>> AEGIS-128X4 runs four AEGIS-128L instances, one per 128-bit lane of a
>>> 512-bit vector, so that each state update is eight VAESENC instructions
>>> on zmm registers.  On CPUs with VAES and AVX-512 it is very fast even for
>>> short messages, which is what makes it attractive for network protocols.
>>>
>>> The intended user is ovpn, the OpenVPN data channel offload driver. In
>>> single-stream ovpn tests over a 100 Gbit/s link, with both ciphers used
>>> through the crypto API, the sending CPU spent 1266 cycles per packet with
>>> AEGIS-128X4 against 1448 with AES-GCM over TCP, and 1032 against 1122
>>> with UDP GSO input. It is posted as an RFC because ovpn can't use it
>>> yet.
>>>
>>
>> We used to have implementations of aegis128l and aegis256 in the kernel as
>> well (along with morus), but we removed them on the basis that it was
>> aegis128 that won the competition.
>>
>> As far as I know, nobody actually uses any of that code, though, so I am
>> quite to surprised to see now that it was aegis128 that was dropped
>> from the portfolio, and aegis128l and aegis256 have made a miraculous
>> return, along with some other variants that appear to be tied to the
>> register width. What happens when 8-way vector registers become
>> commonplace? Create yet another aegis variant that case use them
>> efficiently?
>>
>> So I'm struggling to see why we should take this RFC seriously, to be
>> honest ...
> 
> I'm also not really sure what's going on. CAESAR competition selected
> aegis128 and listed 128l and 256 as "additional finalists". And then
> RFC10032 has written up 128L, 256, 128X, 256X, but not the original
> 128 that was selected. And then none of this has been picked up by
> NIST. Meanwhile, NIST's light weight crypto competition selected
> ASCON, which as the "lightweight" as opposed to "high performance"
> pick in CAESAR. So I dunno! I've been waiting for the dust to settle
> for a little bit.

To be honest I did not try to figure out what was going on, but for sure 
there was "some confusion".

By looking at RFC10032 and its references, it seems that various studies 
were conducted on AEGIS128 after it won CAESAR and they highlighted some 
deficiencies. I am assuming that this is why it was decided to skip it 
during the standardization process and focus on its stronger siblings.

This said, our decision to work on AEGIS128X4 came from the fact that it 
was expected to be faster than AES-GCM (current default for ovpn), 
especially when working on chunks larger than a standard packet (i.e. 
TSO/GSO/GRO case).

With RFC10032 standardizing it (and its siblings), we thought this would 
be the beginning of the AEGIS era, with more use cases popping up.

RFC10032 was published last September - why wouldn't you take this 
seriously at this point?

I am not the one writing ciphers and judging them during competitions, 
therefore I think the 8-way question should not be for me :-)

As a side note, our tests on a prototype ovpn using AEGIS128X4 confirmed 
higher throughput, therefore we were hoping to have a chance to see it 
merged.




Regards,


-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

