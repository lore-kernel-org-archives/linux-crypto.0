Received: from arcturus.nroach44.id.au (arcturus.nroach44.id.au [45.32.188.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B679738B7D2;
	Mon, 23 Mar 2026 10:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.32.188.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262234; cv=none; b=WTTQMkhOPzc/kJ804eS/YejvM94ONWcv56HCYXx3k6LRw8jPcZU5XxzD2oLdCfGkm4QDOAC5d9R4QDDJobRAfDOMH1B3rJbnY+FFDEBb0Iqxv4BGm0dPuk3YhVU9McuQFBzJAxDcZOjxqwScbA8mhcW4VQcJi9vldEwJRax3AUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262234; c=relaxed/simple;
	bh=iQLtY6ta498qhuY834GJ2C7zTp1qOkptj78Lq/coWmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fTEgZrGvTrWCJPCH/Qq+3H7fD/5PPuQAbh3qnk8LNi8gAog6wrtUe+OrC2/QbhScn1SH8gVac2OPaBkkFjt+K3HyZh151q4qdEmi1HqkwkwpjtMH6t+5R8MJri5+iyMCKFI7HoUw5zm7dsk0j1kVj9/D/Cj9Nq5acV9u+W1DO0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nroach44.id.au; spf=pass smtp.mailfrom=nroach44.id.au; dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b=Gp6WiqAA; dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b=Gp6WiqAA; dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b=fmYtozpQ; arc=none smtp.client-ip=45.32.188.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nroach44.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nroach44.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b="Gp6WiqAA";
	dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b="Gp6WiqAA";
	dkim=pass (2048-bit key) header.d=nroach44.id.au header.i=@nroach44.id.au header.b="fmYtozpQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nroach44.id.au;
	s=dYX2HNEqNNRL; t=1774262222;
	bh=iQLtY6ta498qhuY834GJ2C7zTp1qOkptj78Lq/coWmM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gp6WiqAAApFsbe4GMSoMpIFZGA6/KRm+YBjlQZ147+YYCE+pm+F+VAv+8EHoPIjtf
	 QbsUNZl1gTf/5FNVkSsIi9Gtq7SV2rnBrNJzp6EHp6KMQLezWoGEZlnge0ITwxP5ZE
	 fz4EX+dyylnXWfhE7nkRKY0ZbwPm0/xmvAemkaRQhUF95axtrQGTfV0k+wfAn0EW4U
	 NStv3Nj7uvJE9YQVrprTyieeM/cF2WW5O/+WPPrmKn88hGV9FGAyr0H9I4SM/F47bG
	 9CiD6GQ3/ppQVFTwuuU4NKy/TaHS0yo0AxYG6UuRF29SE44vOWI9zbQDDGCYIiZUJY
	 LuULEEyq6aCAg==
Received: from arcturus.nroach44.id.au (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by arcturus.nroach44.id.au (Postfix) with ESMTPS id D599831163;
	Mon, 23 Mar 2026 18:37:02 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nroach44.id.au;
	s=dYX2HNEqNNRL; t=1774262222;
	bh=iQLtY6ta498qhuY834GJ2C7zTp1qOkptj78Lq/coWmM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gp6WiqAAApFsbe4GMSoMpIFZGA6/KRm+YBjlQZ147+YYCE+pm+F+VAv+8EHoPIjtf
	 QbsUNZl1gTf/5FNVkSsIi9Gtq7SV2rnBrNJzp6EHp6KMQLezWoGEZlnge0ITwxP5ZE
	 fz4EX+dyylnXWfhE7nkRKY0ZbwPm0/xmvAemkaRQhUF95axtrQGTfV0k+wfAn0EW4U
	 NStv3Nj7uvJE9YQVrprTyieeM/cF2WW5O/+WPPrmKn88hGV9FGAyr0H9I4SM/F47bG
	 9CiD6GQ3/ppQVFTwuuU4NKy/TaHS0yo0AxYG6UuRF29SE44vOWI9zbQDDGCYIiZUJY
	 LuULEEyq6aCAg==
Received: by arcturus.nroach44.id.au (Postfix, from userid 5555)
	id BB55831804; Mon, 23 Mar 2026 18:37:02 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nroach44.id.au;
	s=dYX2HNEqNNRL; t=1774262214;
	bh=iQLtY6ta498qhuY834GJ2C7zTp1qOkptj78Lq/coWmM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fmYtozpQhXj1WFTHXKhFD2vPbm9KI7McC2ldozpRRAYlbr/GYOfV436jHPSVeqpoz
	 aTDptcDFAgjjz8yn2m6WpmvmOzRvuaIm528qrvS540qExc9kNQpHFFMkYXm+x1sqCc
	 FKp5Tbb8rWZR1Mf9etLK76bnmgxy+kTc4pnqjb3VVjluexny1j/b95TCbKtKuOuaY7
	 vj8hkZrG4UddU7Lgan/4dNXIM5JAEirGeRlXUNPKOj3DCx5TzE+lkZMnp0f+NySbWU
	 KAbpAPTxTXEwYR050DZKwtGEbT4xtGJkVbD1kP5ZV550H61kJzyZxFpgUY3SA+9Gyt
	 WGL6ZbtOAfLuw==
Received: from [IPV6:2403:5814:4228:10:6097:a659:11f5:50c] (unknown [IPv6:2403:5814:4228:10:6097:a659:11f5:50c])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by arcturus.nroach44.id.au (Postfix) with ESMTPSA id 2043F31163;
	Mon, 23 Mar 2026 18:36:54 +0800 (AWST)
Message-ID: <29665ec3-5052-4cdd-8eb9-e6c91092de79@nroach44.id.au>
Date: Mon, 23 Mar 2026 18:36:52 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Does the SPARC optimized crypto and CRC code actually work?
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Eric Biggers <ebiggers@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>,
 "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <20260316204211.GA2661@quark>
 <ca9ba2ec-849c-4f86-8ac9-274ac4b5f885@nroach44.id.au>
 <20260317034539.GA2705965@google.com>
 <76ed4ac4c86341c5c9168aeee8cd53566e018001.camel@physik.fu-berlin.de>
Content-Language: en-US
From: Nathaniel Roach <nroach44@nroach44.id.au>
In-Reply-To: <76ed4ac4c86341c5c9168aeee8cd53566e018001.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/3/26 15:16, John Paul Adrian Glaubitz wrote:
> Hi Eric,
>
> On Tue, 2026-03-17 at 03:45 +0000, Eric Biggers wrote:
>> On Tue, Mar 17, 2026 at 10:48:52AM +0800, Nathaniel Roach wrote:
>>> I've been testing some of the PCI changes that have come through on my T5-2.
>>> I'll happily add some tests for the crypto functions, I've just got no idea
>>> how to do so.
>> Well, try enabling all KUnit tests in lib/crc/ and lib/crypto/, as well
>> as CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y.
>>
>> However, will this be a regular testing run, or only a one-off run?  If
>> it will only be one-off, we'll quickly be back to where we started.
>>
>> We need regular testing on either hardware or QEMU.
> If Nathaniel can test the code from time to time for the time being, we should
> already get some coverage. In the near future, we could certainly set up a CI
> job if you let me know what infrastructure to use for it.
>
> Please keep in mind that a lot of us are doing this as volunteers and we don't
> always have the possibilities to respond to such requests within a short time.
>
> Feel free to use the sparclinux issue tracker if you want to file any requests:
>
> https://github.com/sparclinux/issues/issues
>
> Adrian
I enabled the below options, based on what I could find, in my test config:

CONFIG_CRYPTO_SELFTESTS=y
CONFIG_CRYPTO_SELFTESTS_FULL=y
CONFIG_CRYPTO_ARIA,BLOWFISH,CAMELLIA,CAST5,CAST6,DES,FCRYPT,SERPENT,
   SM4_GENERIC,TWOFISH,CTR=m
CONFIG_CRC_KUNIT_TEST=m
CONFIG_CRC_BENCHMARK=y
CONFIG_CRYPTO_LIB_BENCHMARK=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_KUNIT=m

This is what looks to be the relevant parts of dmesg:

# dmesg | grep -i 'crypt\|rng\|aes\|alg:\|opcode'
[    2.191836] CPU CAPS: [hpc,ima,pause,cbcond,aes,des,kasumi,camellia]
[    7.090965] Using sparc64 crc32c opcode optimized CRC32C implementation
[    7.090974] Using sparc64 sha256 opcode optimized SHA-256/SHA-224 
implementation
[    7.090979] Using sparc64 sha512 opcode optimized SHA-512/SHA-384 
implementation
[    7.235616] alg: full crypto tests enabled.  This is intended for 
developer use only.
[   20.488863] random: crng init done
[   20.525724] n2rng v0.3 (Jan 7, 2017)
[   20.525746] n2rng f029b448: Registered RNG HVAPI major 2 minor 0
[   20.525758] n2rng f029b448: Found multi-unit-capable RNG, units: 2
[   20.526479] aes_sparc64: Using sparc64 aes opcodes optimized AES 
implementation
[   20.527437] des_sparc64: Using sparc64 des opcodes optimized DES 
implementation
[   20.528391] camellia_sparc64: Using sparc64 camellia opcodes 
optimized CAMELLIA implementation
[   20.529874] n2rng f029b448: Selftest passed on unit 0
[   20.532270] n2rng f029b448: Selftest passed on unit 1
[   20.532315] n2rng f029b448: RNG ready

Is this sufficient to know if it's correct, or are more tests needed?

Cheers,
Nathaniel.

