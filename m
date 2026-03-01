Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55D3155A5D;
	Sun,  1 Mar 2026 20:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772398285; cv=none; b=NMRncfXicF+9ANsD25XNbLnZHOzYLV8Fv/aROYDioZG2+8UJrsknV7PMNbqwOJqGe2tPVrYaTqHNcrWEhLptou9y6SII0+UccrsCJKbskmvGFBCzDna9cZM8jqlQ1bk3KA/H7wkeyZugl2Pixq5ZckLO8LUwfyJl3sHOR/aIkAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772398285; c=relaxed/simple;
	bh=xxScFDXZFLwvE4b9e5MMxC9rSLQ4IWpZjGvuheuuvjo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WLUpsXgLPC02F8FRFydGVtLPCBy/6okEAmFVFf3iNxcx1BZ1n1QIvHRQkt6wN/TtiX+SXtKw/DvAQhfgrgq0pCfuR707LeIW8VBsphn/XaN47MgkMHnJby7Sf56+kB1ncQXPwxEUqAhVummpTN9Ky+Jq6KDC0s8vNFe+fzc/vvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=Eo82i87o; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="Eo82i87o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1772397689; bh=xxScFDXZFLwvE4b9e5MMxC9rSLQ4IWpZjGvuheuuvjo=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=Eo82i87oj3B2nqqKu/WjOM0C25Qd9JXRIJQXDR2MoJW4Pk7OIUeSC0dMOKajRGCiG
	 MxhgEP8RImwMtG8zNDxClqHZ89LTYDA+gd0ZLZTHpIf80Ao2JOaUDnesiDByXNNTGW
	 TPTirThN8zvIeJ4Gy0cnAPhUuWtJZG41qdLuWQxGAStWzd7TLieaGcbAbmPXAXnBVa
	 E7YDMkPaFFjQJz4IXFvWO+52HWjGpyzEsHGlk3PCrbW308IJBd+31qhacZbXMRj1N3
	 7bHQNt3hXR1VnQ8Lz4323hMo9cdzJwoUPbrl1k1w6vVJFi1R9Z3Vy7957j0Hgw9j4t
	 LNvXGb+29Hq0g==
Message-ID: <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>
Date: Sun, 1 Mar 2026 14:41:28 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jeff Barnes <jeffbarnes@linux.microsoft.com>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jeff Barnes <jeffbarnes@microsoft.com>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
 <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
 <aaKtujHwV0zDFWxi@gondor.apana.org.au>
Content-Language: en-US
In-Reply-To: <aaKtujHwV0zDFWxi@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Herbert,

On 2/28/26 2:56 AM, Herbert Xu wrote:
> On Tue, Feb 17, 2026 at 03:59:41PM -0500, Jeff Barnes wrote:
>> I don't know how to accomplish that.
>>
>> SP800-38D provides two frameworks for constructing a gcm IV. (https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf)
>>
>> The first construction, described in Sec. 8.2.1, relies on deterministic
>> elements to achieve the uniqueness requirement in Sec. 8; the second
>> construction, described in Sec. 8.2.2, relies on a sufficiently long output
>> string from an approved RBG with a sufficient security strength. My patch
>> checks for an implementation of 8.2.1 via rfc4106(gcm(aes)). I don't know
>> how a patch could check for 8.2.1 or 8.2.2 from an externally generated iv.
>>
>> Suggestions welcome.
> Rather than setting the FIPS_COMPLIANCE flag, why not simply ban the
> non-compliant cases from being used in FIPS mode?
>
> Sure that would mean banning gcm(aes) in FIPS mode, and only
> allowing seqiv(gcm(aes)) but that's OK because we have the
> FIPS_INTERNAL flag to deal with this by only allowing gcm(aes)
> to be used to construct something like seqiv(gcm(aes)).

Like you said, this could work for seqiv(gcm(aes)), if there are truly 
no usecases for gcm(aes) when the kernel is in FIPS mode.

However, Cryptographic Module Validation Program has also recently made 
it clear that xxhash64 cannot be FIPS approved the way it is currently 
implemented in the kernel. Even though the designers of xxhash publicly 
state that it is a non-cryptographic hash, the kernel offers it as part 
of the shash interface, the same interface as the approved algorithms. 
The interface / API also has "crypto" in the name, which according to 
CMVP implies security. CMVP feels that there could be confusion with the 
approved hash algorithms, so there needs to be some indication that 
xxhash64 is not FIPS approved. I think blocking xxhash64 in FIPS mode 
would break btrfs, where it is used for checksumming.

Kind regards,
Joachim

> Of course this would need to be tested since FIPS_INTERNAL was
> introduced for something else but I see no reason why it can't
> be used for gcm too.
>
> Cheers,
