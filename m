Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793892810;
	b=3bvKMNMo8l/qc1J/Skk7QmBS6R9Xhswao1uVxNaGKul9JHb/ZHu9VVNY091nfcRvD/AJ
	 16lAdT842Wia708n4uW+jvtzbCYoGHZokXzWWCSBzqjz82tuqbrkzHhQcrum/EVYRxICK
	 BLAapQhXHwfVto8IOxvpUCDWLMDUfgE1sawchkXGNdiLdUeW4WBwNJ7/VzHencXA1yoOp
	 RXlIKkLjtjPB6uE9T2C4Ikf9wg1E/ZKrk9GYhNgIRQV71WJBD7dMzdT2PLvp2TpHzds/U
	 WBBrFrR2ObzNblKTGCK6tkuUPuT5xuavJfPfIS8x18+o74hM3TNf9KBZN8gD4f3p7/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892810;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=lEbwlfSNUpQ9Fk5UUCojZRKXZCZegOH+Ad3J8BBRI2Y=;
	b=gxywH40/yn+hGklgeaPzAOeQUvBOqHeWDyeMpbFn49Hkm0KOkuM8mnEEIhOWgUj1Zk4x
	 x87FoZe1SjFt8nPGfRgjGajzT5x6k/iYEKZQvPJU7hhsEYcFcKKBFYVHlfOKfTGaiHu8z
	 GCMM/O73zrhPt3SpU7i7//kuDBdrgeOj2OGHEr9LMvKc3RIklgvEvoZgoFegfZEZhpBSJ
	 J+VvvKpafAcN5vdde5jYgysKWxLqCS4pqHRoNKmBcRuTwUjQy6lHk7x/kXi1oQLvJmJfN
	 x/ssroDOv/xW+kTGBFTGHN1wQ0e1lk3OyJ9e5axnuxSnsTzhsMQzVNjYtd4AGnRAUaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=BFszO3Yo;
	arc=none smtp.remote-ip=195.10.208.51
Received: from mout-b-206.mailbox.org (mout-b-206.mailbox.org [195.10.208.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADC6606A329
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 15:33:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DADC6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=BFszO3Yo
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-206.mailbox.org (Postfix) with ESMTPS id 4jL5tR6qcGzbD;
	Thu, 05 Nov 2026 16:33:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793892799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lEbwlfSNUpQ9Fk5UUCojZRKXZCZegOH+Ad3J8BBRI2Y=;
	b=BFszO3YotH2kKB4UT0b/2JkERDCsG/amSMtGh73VtbjzLtG55htZXWTt3gPqwgj6j9CXin
	4GWsKhErfd1Rj1Doy3nMV3PDHfTdPkrPpf0RvhHdAQndkyzg+mlq0w8ZJ+v86kP8l1saqL
	rAt/fJWSgDAG45/PfLhuQa9YlkPt7sp9cTxdxVeTRSKGrhCr34jwBuiCqiC055TV+MjTs0
	h91MbQrgHvKxX3+qVdZA0DAxp31XAV7mjyJ0H5llzWmdbL3h586vIMWdVN4vrfP7RYQaBe
	qqD5ftySiTMEAKgclS6sLYpAIFu66Al4WLBk1drFXeLTYy0EEJN4IY98de5JrA==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <01247287-fa97-4f2b-8d9d-42b22c3511a4@mandelbit.com>
Date: Thu, 5 Nov 2026 16:33:19 +0100
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
Subject: Re: [PATCH] lib/crypto: tests: Add some additional lengths to the
 ChaCha benchmark
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261104230626.87060-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261104230626.87060-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jL5tR6qcGzbD

Tested on Zen 5 (Ryzen 9 9950X) in a KVM guest, on top of base
9fbbbaefd5f9. KUnit chacha suite passes and the benchmark reports
all 13 lengths on every x86 code path:

   path                 CPU setup              KUnit  benchmark
   -------------------  ---------------------  -----  ------------
   AVX-512, zmm         native                 pass   13/13 lengths
   AVX-512VL, ymm only  spoofed SKX (6/0x55)   pass   13/13 lengths
   AVX2                 clearcpuid=avx512f     pass   13/13 lengths
   SSSE3                clearcpuid=avx2        pass   13/13 lengths

Nit: there's a tab between "256," and "511," while the rest of the
array is aligned with spaces.

Tested-by: Antonio Quartulli <antonio@mandelbit.com>

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

