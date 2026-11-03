Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713810;
	b=mmQYPo4vk6k9XNuIwA5i+Rg4p1pNoGp67QaQYgCQ+hgq2s9NZzfmyBtJTY+eIu9Bj4sw
	 25sqhp2j9flRlJ/Ds9FIWijo7ywGIxKHDk41z6qd4IdZJS8Q2bhXgcwxsZxxzntBcXSE5
	 xOY0a9Y6Zou3v1TvoX9jF9CJincKyLdg5XGHCTJ6GTkT9aM9ThOU6fHn7TuRVOFPyjrr3
	 KxRd6MIxf4XCzkxi2d0GycSIEuH1Lhyw4ecNPD7R5qkEUnlZlN3q36FWUk34GtfvOfJGK
	 Ylj7ceg8JJUPcY+BTk4VFNGJ8Wu8wRvJpHsMCxhES3YIfhMEVF2AzdCEuerFY2YWvOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713810;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=D9Bh52UpfAm+qb3j8t6IEKEI/Dr/0E/0m1u5bOYdNYk=;
	b=J5Byokru4EUPqk2/lIMyhzo6A4g/s02+Wu4IkG81SQaOCLSEmsR2WoOc45n7Usi39IKQ
	 vw2id6RKMRhLmLyalJcseNXJUXaexu7lBY9D8iZ7UeHH99wd/aAec97Gv403k6mAGlvY3
	 rmOMqCOF3eiOG65tRF20yQZQRiUBdMSj8P/2tTBBNqk1hRSGHXBhUNYSDwMJIptzN7Jbo
	 /oQpuOPiREuc75X3dtZTca5gumlRQa2mm6v1gNRxvdT8UbaW5KvBhehN4WsvXUbhPi4Ol
	 btKGuzj3l1XCy4S+55dSgBY7Feo/2/5qLER8gITMJn78znd8R8dNJeTQV7cLrNsp14A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=WPSWNBuJ;
	arc=none smtp.remote-ip=195.10.208.46
Received: from mout-b-106.mailbox.org (mout-b-106.mailbox.org [195.10.208.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AAA606A327
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 13:50:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33AAA606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=WPSWNBuJ
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-106.mailbox.org (Postfix) with ESMTPS id 4jJqh617Y3zNll3;
	Tue, 03 Nov 2026 14:49:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793713798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D9Bh52UpfAm+qb3j8t6IEKEI/Dr/0E/0m1u5bOYdNYk=;
	b=WPSWNBuJ8wN+mFXYt/pSqZyJ49NXGsYeLZmbiWG9GSAiocOJJaDCSTM0h7Rmz2DGeGKcKS
	/rz/t2V3KjO/puDRZ3N46XPx23hQi0r7f536w8YtMtrAMIyp7Jzw/bNJfJVHtYrDG4g+Ft
	bsv8VGasT0g4jSdTQUMS3FXGK7PuwurmR5R5OB7+4tCdJmnieGUVpcdZKJWHE5wcjNxN9L
	IIlw0glMca3GJ1s3UpfkSNmMZ2U4Y/PjPCrvF6Ftx8dUmKtyWuxay7O5r+3041nUwvAUBD
	d4uRcgqSSa7t4jmcT79YgnxoNZjKC3SxgMu1xAxkrkzN59fg88HMxyUN+W+qOQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <0f5fa2f9-84a1-403a-b279-afed3c939a01@mandelbit.com>
Date: Tue, 3 Nov 2026 14:49:56 +0100
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
Subject: Re: [PATCH v2 0/3] lib/crypto: x86/chacha: Add a 16-block AVX-512
 function
To: Martin Willi <martin@strongswan.org>, Eric Biggers <ebiggers@kernel.org>,
 linux-crypto@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
References: <20261102113926.2765176-1-martin@strongswan.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261102113926.2765176-1-martin@strongswan.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jJqh617Y3zNll3

Hi,

On 02/11/2026 12:39, Martin Willi wrote:
> Here is v2 of the 16-block ChaCha function for 512-bit zmm registers.
> Patch 1 renames the assembly file, patch 2 wraps the 8-block code in
> a macro, and patch 3 adds the 16-block function on top.
> 
> I previously mentioned a larger series with more AVX refactorings to
> shared macros along with a 4-block zmm variant. That needs some
> more work, so here is just the 16-block variant.
> 
> v1 used embedded broadcasts for the final ChaCha state add. This comes
> with a minor regression on older Intel chips when used in the 8-block
> variant. Therefore I kept the state words in registers in the macro
> version used by both 8/16-block variants, see patch 3.
> 
> I don't have a Zen 4, which splits zmm instructions into two 256-bit
> halves, so I can't tell how the 16-block function performs there.
> If anybody has access to one, numbers from there would be great.
> 
> Changes in v2:
>   - Rename chacha-avx512vl-x86_64.S to chacha-avx512-x86_64.S
>   - Generate the 8- and 16-block functions from a shared macro
>   - Drop the cpu_has_xfeatures() and X86_FEATURE_AVX512F checks
>   - Keep the state words in registers for the final add
>   - Benchmark with the ChaCha KUnit suite instead of tcrypt
> 
> v1: https://lore.kernel.org/linux-crypto/20260722153247.630519-1-martin@strongswan.org/
> 
> Martin Willi (3):
>    lib/crypto: x86/chacha: Rename the AVX-512VL assembly file
>    lib/crypto: x86/chacha: Wrap the 8-block AVX-512 code in a macro
>    lib/crypto: x86/chacha: Add a 16-block AVX-512 function
> 
>   lib/crypto/Makefile                           |   2 +-
>   ...x512vl-x86_64.S => chacha-avx512-x86_64.S} | 730 +++++++++++-------
>   lib/crypto/x86/chacha.h                       |  28 +-
>   3 files changed, 477 insertions(+), 283 deletions(-)
>   rename lib/crypto/x86/{chacha-avx512vl-x86_64.S => chacha-avx512-x86_64.S} (55%)
> 
> 
> base-commit: c90bb21618db40f1f30a1c0ed58d4f46b27dba26

Thanks for this v2!

Unfortunately no Zen 4 here to test with.

This said, I gave the code a go on my Ryzen 9 3950X and I matched the 
results without encountering any issue.

For the whole series:

Tested-by: Antonio Quartulli <antonio@mandelbit.com>

Regards,

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

