Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8940229A1;
	Tue, 17 Feb 2026 20:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361990; cv=none; b=mYuEhZ24Pp8GTBUHOhquW8LyNqrtkTZXORMHKMfK+mhr2ZINQUVGCpUdPgWWmhDA0DWmtOwMWsDCawpxah9hn7BF7vj5t+OUIpaIXGeIS5zJRLyhdo3b061XQ5xOs0ABccX2CHxuB9EE4U+w/h1tu5XIdxKkQyfN8XxIqik7U6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361990; c=relaxed/simple;
	bh=yRj2CMBTyuI6N9ZmnUpcQPn4nReigCXFE8z3++kBb/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iPj+Zg/rk+Cd/Vc+7vli/2lVXCODBuNlgil06vpJTtIriECbty1T7TDCajFsKNEEbz2Vv5nLcTWmiR2vu7aM069PYzHeY+o6OZazRhsA885qe0AAWlrzoQofJQ1eBscnBILKtnLfjZoKTKyRO+fS3wxwqVpRlcorOi+stj2+f6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=qbQ80wGx; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="qbQ80wGx"
Received: from [192.168.1.121] (unknown [72.189.69.117])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6E69220B7165;
	Tue, 17 Feb 2026 12:59:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6E69220B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1771361983;
	bh=CxCIMRpi1hCY5DQ0GY388/ufGKLoBc1zx26E7ufBV5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qbQ80wGxi/8t0ZwuKh34k987cAGCotYdp6NqA9k6JQw0Ne8AjH7BAKY6S5QHuN+lC
	 nRBxMZGUOVNg3CMCJ+jmpTQHefDUFkVXO+k4WhBTFmG+zFj0yX92Dn7G9ZxWQEjlJg
	 OZegOPmoYfd4pqFL/h0V8MSsaMmcwRZ3Ro1iHf3U=
Message-ID: <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
Date: Tue, 17 Feb 2026 15:59:41 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jeff Barnes <jeffbarnes@microsoft.com>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
Content-Language: en-US
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Autocrypt: addr=jeffbarnes@linux.microsoft.com; keydata=
 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
 BR++r9M2JSHIgP5LESF8KrBJ6s2f4TqSBCpQ
In-Reply-To: <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/30/26 00:10, Herbert Xu wrote:
> On Thu, Jan 29, 2026 at 04:04:36PM -0500, jeffbarnes@linux.microsoft.com wrote:
>> From: Jeff Barnes <jeffbarnes@microsoft.com>
>>
>> FIPS 140 validations require a “service indicator” to positively
>> identify when an approved cryptographic service is provided. For
>> RFC4106 AES‑GCM (used by IPsec), this commit exposes a per‑request
>> indicator bit when the IV/nonce construction meets the FIPS uniqueness
>> requirement.
>>
>> Specifically, the indicator is set when the caller uses the RFC4106
>> construction with seqiv (per RFC 4106 §3), where the 32‑bit salt and
>> 64‑bit seqiv together guarantee a unique 96‑bit IV per key. This
>> meets the SP 800‑38D §8.2 uniqueness requirement for GCM.
>>
>> No ABI or uAPI changes. The flag is internal to the crypto API request
>> path and may be consumed by in‑tree callers that need to record service
>> use in a FIPS context.
>>
>> Tests:
>> - Verified that gcm(aes) requests never set the service‑indicator bit.
>> - Verified that rfc4106(gcm(aes)) requests consistently set the bit.
>> - Existing crypto self‑tests continue to pass.
>> - checkpatch.pl: no issues.
>>
>> Signed-off-by: Jeff Barnes <jeffbarnes@microsoft.com>
> Rather than exporting this indicator, I would prefer that we just
> forbid non-compliant combinations when FIPS mode is enabled.

I don't know how to accomplish that.

SP800-38D provides two frameworks for constructing a gcm IV. 
(https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf)

The first construction, described in Sec. 8.2.1, relies on deterministic 
elements to achieve the uniqueness requirement in Sec. 8; the second 
construction, described in Sec. 8.2.2, relies on a sufficiently long 
output string from an approved RBG with a sufficient security strength. 
My patch checks for an implementation of 8.2.1 via rfc4106(gcm(aes)). I 
don't know how a patch could check for 8.2.1 or 8.2.2 from an externally 
generated iv.

Suggestions welcome.

> Thanks,
