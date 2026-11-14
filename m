Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=129.153.194.31
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794629201;
	b=ci8iwLNTrGZnm8hnkSPQUNrqLvRbhs2ak0FawUHsruDQ+sxSI9mTpo7+hZdpbhwPIO82
	 Zw3kdJvL/lmQmZx1cSvTPn/cDxsFjKBbytbSreYh5zecGm25Wz4rqqEDdqxc8oAQGEpb3
	 zkVeIo4h96mDPSqG1cHxFLBcEteDI+ipBBpsApS8B3Xz1ThCgTg/uAHshhErL9Q9yDjin
	 LYCEfsRj6XJncIGS5W3mBR4w17Cd23qJeR/kDg8jBZOW3k3+0BDVmPABClS8B/wDzWSvz
	 gmXWGSI2SOttLpOW2DLPaP18uiVGXfuLed14AdhBwmtZFo+gJLLjwejS7ggAW7M/aEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794629201;
	h=DMARC-Filter:DKIM-Signature:Message-ID:Date:MIME-Version:Subject:To:
	 Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=288b126lkD3AT+8CFugGZ0QSvZWK/kr0VOMASle0sIQ=;
	b=m/WG1Eq0ZmJHk89BftIv38ggutilHcp6fLL1gpLF//QDdB6krs0WUqHDe1Jw6JE5EUxu
	 Q18zkTq4IRKoWvVSgYhozdcLdgobP3ufuPWKRcc7tmtwqLXkA5XnJcRF+rJv0coot0u6r
	 qqhIg2JkwRed1YRS0Bcd1fdXcQRny7VFpkEaEvEae+6/qY5E5hjH9PMLYMW7fT9rssLQy
	 1BspnSbpYB48/IJOetaM1fUx7qN2zAdbNFYiGo3x5LS1h/DCUtCo0Xo9Ev1+taeCAJ0h/
	 zqgl74HZbEUxqOmazhk8ov5mUM+B5Eg/gh0TWhXkesi4AJ9hdi7hOi7mjpEOMyofh/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jvdsn.com;
	spf=pass smtp.mailfrom=jvdsn.com;
	dkim=pass header.d=jvdsn.com header.i=@jvdsn.com header.a=rsa-sha256 header.s=mail header.b=n7yZ0lNi;
	arc=none smtp.remote-ip=129.153.194.31
Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0026F606A329
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 04:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0026F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jvdsn.com header.i=@jvdsn.com header.a=rsa-sha256 header.s=mail header.b=n7yZ0lNi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1794629194; bh=ouKylOcqxf7DGXzNs+Q/10xu6JoedBqseBlPk65Rt2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n7yZ0lNith0wHK1Q/Zl8MHCtPR98jFJTmjY88VfVH5nrowcaGT9ichfGpAqYjXs5E
	 1RhJVHKhUx+gW4MLpIN9qZ66bAGdIwmIrkrBcOvJMZxm1qzZonpfxpvacep+GKHabN
	 c1ClIIE1JVNOQqoeeh7YYa+j/TCbaRILF/wfg/+fa58VY91m8uVAcDgcWkbUFtE+Vi
	 ms4B0gEar1n8dvT/6wgTcRP06uf39zgF40wq2KqbSW1XZm9b9pE/9MHd9QDh88gNAe
	 3JmAhF5hQc732yM+qaKCOKEsSrVErCVkog4rAnBY+XnVosqd/WhyUpCYTPRLDJnx/U
	 iUqlsy/BFLI7g==
Message-ID: <b5b02f17-6fb0-4453-b4d7-bb3010dbb5f2@jvdsn.com>
Date: Fri, 13 Nov 2026 22:06:33 -0600
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH 04/14] crypto: jitterentropy - Add library API
To: Eric Biggers <ebiggers@kernel.org>, Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
References: <20261018204618.104876-1-ebiggers@kernel.org>
 <20261018204618.104876-5-ebiggers@kernel.org>
 <cc552609-ece5-4f82-94b2-b00edf0f92a7@redhat.com>
 <20261113195742.GA2147@quark>
From: Joachim Vandersmissen <git@jvdsn.com>
Content-Language: en-US
In-Reply-To: <20261113195742.GA2147@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 1:57 PM, Eric Biggers wrote:
> On Fri, Nov 13, 2026 at 12:28:12PM +0100, Thomas Huth wrote:
>> Am 18.10.26 um 22:46 schrieb Eric Biggers:
>>> Make the jitterentropy RNG accessible using a regular set of functions.
>>>
>>> This will allow drbg.c to just access it directly, instead of going
>>> through the overly-general crypto_rng abstraction.
>>>
>>> Later commits will remove crypto_rng.
>>>
>>> Note that the library API should also continue to meet all the same
>>> certification requirements, including the health check which occurs on
>>> the first call to crypto_jent_alloc().
>>>
>>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>>> ---
>> ...
>>> +int crypto_jent_get_bytes(struct jitterentropy *rng, u8 *out,
>>> +			  unsigned int out_len)
>>> +{
>>> +	int ret;
>>> +
>>> +	guard(mutex)(&rng->jent_lock);
>>> +
>>> +	ret = jent_read_entropy(rng->entropy_collector, out, out_len);
>>> +
>>> +	if (ret == -3) {
>>> +		/* Handle permanent health test error */
>>> +		/*
>>> +		 * If the kernel was booted with fips=1, it implies that
>>> +		 * the entire kernel acts as a FIPS 140 module. In this case
>>> +		 * an SP800-90B permanent health test error is treated as
>>> +		 * a FIPS module error.
>>> +		 */
>>> +		if (fips_enabled)
>>> +			panic("Jitter RNG permanent health test failure\n");
>>> +
>>> +		pr_err("Jitter RNG permanent health test failure\n");
>>> +		return -EFAULT;
>> EFAULT means "bad address" in the sense of a page fault ... not sure whether
>> this is the appropriate error code here? Maybe -EIO would be a better fit?
> I intentionally left the EFAULT unchanged from the old code in
> jent_kcapi_random(), to limit the scope of this conversion.  I agree
> that EFAULT is not an appropriate error code here though, and feel free
> to send a separate patch that changes it to something else.  Thanks!
For what it's worth, the EFAULT is publicly documented for some 
validations of this entropy source. This is not a real objection to 
changing it though, since those are point-in-time validations that don't 
apply anymore if the code changed.

The only hard requirement for certification is that the code is 
different from the other two branches (EAGAIN and EINVAL).
>
> - Eric
