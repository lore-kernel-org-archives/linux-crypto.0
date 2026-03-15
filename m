Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E814E1D61BC;
	Sun, 15 Mar 2026 00:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773535990; cv=none; b=EVLW4QWHjYdIRzAYjTvBSi1urm9IFPUie4ePf4FzMZbhzX6EFLCR/It3XFQcVYriZU+fgIwE28RVAT1ww2gEPBF4yux3PaoNR2wT1ms/muSrusKA1cxOJXWYv6Vo6e/BBtlsMfDk+TUlSK5XoAIyVP7OHuMrMghs1mcN2oYADrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773535990; c=relaxed/simple;
	bh=LU1uB/HE/c/73zPowr6km/30RYw7pRFXyU+zsrSKI7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWANTQWYv58BA4JaGZw4dnjUvB0xi8Pf3fgQRatZQPJqZgV5f8vdNqU8rRg8GkNaMZ5zQE6Vkx1lpzbIw5p8qcvZVRL5ObkbELhaNUB9cluWvNG5yIeyxz8K9xlEBjZtgtIT1hytBHmHDwdh0JQYCq0CpshqBuCIvo/c6zeJg1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=AL1xq9CH; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="AL1xq9CH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1773535396; bh=LU1uB/HE/c/73zPowr6km/30RYw7pRFXyU+zsrSKI7Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AL1xq9CHRXZnZYKrXiPg8HC0aDmz6xDNbxJnMgiI4k1KnR4DtrDcPBUcPTCpP26+Q
	 Cs5iJ1A1EwiJu2XFsfvxB1e0+MLDNgt1MavHb3UUtDmwWL/UqfdX7At6lCt6WQuBVq
	 /6e40lRRX99Q1HD8Vu7kYatWyOR9uu01tTvcL2/ahsPHwQYsZILfbyosb6+9vR+4D5
	 kMx2tc0J9m68A1pp4K45Pe6OT6LVU3LrfdcEsAKLfMgYBM9mHqS2xjgncHqwvw/IF8
	 TSzNQzLfuJ1/6wMvVO/MsGJYj9+G2oSE7z3RoAADQ9wP+n4ODySKTFoP3CHfRt3gKz
	 KZ4YXmGfqG8mw==
Message-ID: <64592fee-1956-4a70-a751-9ac3335cfc27@jvdsn.com>
Date: Sat, 14 Mar 2026 19:43:15 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Joachim Vandersmissen <git@jvdsn.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260303060509.246038-1-git@jvdsn.com>
 <abTuFto8Tc3mhRRe@gondor.apana.org.au>
Content-Language: en-US
From: Joachim Vandersmissen <git@jvdsn.com>
In-Reply-To: <abTuFto8Tc3mhRRe@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Herbert,

I don't think this one can be applied yet since dm-integrity still uses 
xxhash64 through the crypto API. This would break fips=1 systems that 
use it.

Kind regards,
Joachim

On 3/14/26 12:11 AM, Herbert Xu wrote:
> On Tue, Mar 03, 2026 at 12:05:09AM -0600, Joachim Vandersmissen wrote:
>> xxhash64 is not a cryptographic hash algorithm, but is offered in the
>> same API (shash) as actual cryptographic hash algorithms such as
>> SHA-256. The Cryptographic Module Validation Program (CMVP), managing
>> FIPS certification, believes that this could cause confusion. xxhash64
>> must therefore be blocked in FIPS mode.
>>
>> The only usage of xxhash64 in the kernel is btrfs. Commit fe11ac191ce0
>> ("btrfs: switch to library APIs for checksums") recently modified the
>> btrfs code to use the lib/crypto API, avoiding the Kernel Cryptographic
>> API. Consequently, the removal of xxhash64 from the Crypto API in FIPS
>> mode should now have no impact on btrfs usage.
>>
>> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
>> ---
>>   crypto/testmgr.c | 1 -
>>   1 file changed, 1 deletion(-)
> Patch applied.  Thanks.
