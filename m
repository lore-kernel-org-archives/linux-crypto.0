Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12C81EA7DF;
	Tue,  6 Jan 2026 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767700977; cv=none; b=PCtW4pjlYJgk77KH6o9opxoPNOx6bJ7rXEtkIdRyZr1ERc+4+8aMTrRvjHd7sBM94UyxvgS5qNffmInjh3q55xJN4S+IfkJlhrxyU1LfD6P6ae5SzpR3TLEqhaBiZi4TMg8CdZBDoYBpQVNFCVYNEAgK9l/u8LRwxULgWjjV50I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767700977; c=relaxed/simple;
	bh=VzycPchL6W3YH95Wv3DDa29QGY/kqHBCDf/rQbBI+gI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I2ViTRsih1bAhwyH9B8zPQuxKb69lcXcgxCx70Om4YGBUQyxVeW5iy0sHXSsq1gLJ9joKdDH1z/ejekc8Y3inPBYNaExcX15S1P4qa2OIB9WbDcFy7pxDZNy/FBECCFXRFurnlAo42NQ5/W0WmvlaKrkTHqnIT5Cpw+qsr09hjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b=tf4YJ0+M; dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b=KGIDJDLS; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b="tf4YJ0+M";
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b="KGIDJDLS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1767700393;
	bh=VzycPchL6W3YH95Wv3DDa29QGY/kqHBCDf/rQbBI+gI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tf4YJ0+Ml1mPpcheOp/izXggOadhUPLhZh7rfYK1Z2/3t7eQF8QZtbF/LOsPnWZ2z
	 pvoRILLap3H1K28xBdMFx3r+23WpU1KEOXTuiZdDnWUpStT7CyCbsanEAB2t2sdjf/
	 1ru1Gu/B0xU7Iqg7vAj6sziKbbd3sdtaQVOrE2ZYQJGsIg4G0L2FiibDjC6hFuq2sl
	 Ai6Q4nfjfEbilQiBMzFWSNlVjXuLurGG9K687SBOmlZQCuY3fX9z8nWkPJ1+jUDZA8
	 CqdTX1VXMbCo3y08zgRqzJSVr/DGKWxCN8pPb1v/JQZ3vKg3f7D6jvFnEyTc3NfXxZ
	 N2FtJblk8WwUBUSSgG73aVrqd6HfzByEXAMm/keUl//hF3B+Vo6gnQjvSnDCYtCodY
	 qfXyllzYDyEJyd+J8y2UoIsA6KhkEfu2xPFAIiA4R/aWNp1uF4A8KZtKyN5TKT2uWj
	 /0ElgiNo+2NvXrbSo/ahXvT9MMAWUdFTimp7N5nXqYH5RUBdHcXoNVER/Zkj29aHuE
	 lj7SScsTFFKwRfrIQXvb9OuhVx2e4vWahuq9ydBz1950Y5FnCstrZyukHKtiiQ0c6n
	 VQ4O7rkYQ7qquUAVdanK+HmgRa8VOoGQ14n+cZl2e9eguUr/QI/goAOsOpclFcwuum
	 LUEXAdg1cTuNKIRBsBhIaa+Q=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id C9A991E5A36; Tue,  6 Jan 2026 19:53:13 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1767700392;
	bh=VzycPchL6W3YH95Wv3DDa29QGY/kqHBCDf/rQbBI+gI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KGIDJDLSMpI04eBx7FTjS5qbkqd3/Ej20xQeGf8j3iubmCbeAZdCfJKTX+zLuw+6M
	 aLMf+NSslyNC54PS6pa2n5Z42SJeZZdv/xGqAbYjC0DTe8KqavBxba0jqPgPgJ+yuh
	 T/ITuCTA74ELibb8PTRVFTyiKYqAhECPJlB7p9NfpVWe3EqJKcKu8o0dUHW2tq6aSw
	 hovQNWgIaNoGQ6UvzKgtUPeI70bYtPw1ScUh/r1W4RLNmfkJFHvyT0c43VkIOr9MGN
	 e7qlhq8TlNoX+tgPUMlYCt7dMQUTz8oC6ckjPj93cY7ww3JOxZrXOdCJ81pmzHmdEe
	 oYB6V23fKEbr5eBsVIXLpJB8z0mqlp2i4G1gH9CfGbarBERQV5DH+FkA8oDFDYUt5w
	 jacZoMpQJzSaBariYfjtPGhiP5DeJq40863sF15NcFnhI/vva2NPCiQe8iFE626ga2
	 eb8+KRHJjnHF6ihs1zk00zw1HBd0Ep23qCqG6zXWoEVTPMciqL3ogV4xnOBmcV7Jo0
	 +ARnjiFQq2wThgREMTwBVUoTp3rKdqdxXZZHXgDrRV9QdS9YI+gBErP2Qg4bA/u2MI
	 3uajBnlLZtma8+WkzFGvIhg/g4Y/gXy+wCb6QD0MZCy29Q0YRvB4oexT50iA4hPYJt
	 /9ajbaplgjAARRLaYrRamrqg=
Received: from [IPV6:2001:8003:8824:9e00::bec] (unknown [IPv6:2001:8003:8824:9e00::bec])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 6794F1E5B4E;
	Tue,  6 Jan 2026 19:53:12 +0800 (AWST)
Message-ID: <3527d9cb-9982-4302-a9ca-d7ac2a10ccaf@davidgow.net>
Date: Tue, 6 Jan 2026 19:53:07 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: tests: polyval_kunit: Increase iterations for
 preparekey in IRQs
To: Eric Biggers <ebiggers@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260102-kunit-polyval-fix-v1-1-5313b5a65f35@linutronix.de>
 <20260102182748.GB2294@sol>
Content-Language: fr
From: David Gow <david@davidgow.net>
In-Reply-To: <20260102182748.GB2294@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 03/01/2026 à 2:27 AM, Eric Biggers a écrit :
> On Fri, Jan 02, 2026 at 08:32:03AM +0100, Thomas Weißschuh wrote:
>> On my development machine the generic, memcpy()-only implementation of
>> polyval_preparekey() is too fast for the IRQ workers to actually fire.
>> The test fails.
>>
>> Increase the iterations to make the test more robust.
>> The test will run for a maximum of one second in any case.
>>
>> Fixes: b3aed551b3fc ("lib/crypto: tests: Add KUnit tests for POLYVAL")
>> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> 
> Glad to see that people are running these tests!  I actually already
> applied
> https://lore.kernel.org/linux-crypto/20251219085259.1163048-1-davidgow@google.com/
> for this issue, which should be sufficient by itself.  Might be worth
> increasing the iteration count as well, but I'd like to check whether
> any other tests could use a similar change as well.
> 

The polyval one is the only one I got reliably, but I have just managed 
to reproduce this with crc.ctct10dif_test as well.

[19:47:29]     # crc_t10dif_test: EXPECTATION FAILED at 
include/kunit/run-in-irq-context.h:112
[19:47:29]     Expected state.hardirq_func_calls > 0, but
[19:47:29]         state.hardirq_func_calls == 0 (0x0)
[19:47:29]
[19:47:29] Timer function was not called
[19:47:29]     # crc_t10dif_test: EXPECTATION FAILED at 
include/kunit/run-in-irq-context.h:114
[19:47:29]     Expected state.softirq_func_calls > 0, but
[19:47:29]         state.softirq_func_calls == 0 (0x0)
[19:47:29]
[19:47:29] BH work function was not called
[19:47:29] [FAILED] crc_t10dif_test


It's only happening for me on aarch64, with hardware virtualisation (and 
it goes away if the crc test suite is the only one which gets run, 
interestingly).

And, of course, all of the issues go away with the patch applied / with 
-rc4.

Cheers,
-- David

