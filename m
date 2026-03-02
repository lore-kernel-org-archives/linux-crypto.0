Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C39FC382F2D;
	Mon,  2 Mar 2026 21:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487298; cv=none; b=ULfxTm5QALEAu/9RyERqe9f9VJzGrtBGreAMGPbnYpai6qHu1uTrYT0bEgDveMyP83dBuww4M6znBfw1TV61cDQTRajgjkgUA7pc7uT8bW+mzXvtO4aoK05jUgzOB4W+Eh7cGdBVEaDMhDAP9CJkJ7bOFCArAivsRqTgEb7qBh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487298; c=relaxed/simple;
	bh=0tJv9rV6qEyOSEMuR5JjWY3q/8OS2yY7n48xan4RsMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nHf5W/FrVDkUFV2ICHD6fDZh56r0HMzPj6zCwvUs0fABSNEQ2Lp7XNxHP2UsytnrZotTaig2YJkEbnEqsoVF9nze8HPagPBUJdmdxZTjoQq4vzLCJvfp/yR1k/wdVv0V/Dty/kdON8O+mU7RKb3UoLr5s03cxcoJCAMuWx5BGLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=O5IoMg1n; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="O5IoMg1n"
Received: from [100.96.208.169] (unknown [52.167.115.14])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8BB9520B6F02;
	Mon,  2 Mar 2026 13:34:56 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8BB9520B6F02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772487297;
	bh=0sPwsXkid4D7p499+yLCcpMJNNRtNakGWmj4FsYf5wQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O5IoMg1nCaKrV7sfm2852A3rm4fc3SyW5fvqB92e/VFM01KIo5zw6ZWLHSBCDSM69
	 VitHlGaOpzIIonQqCZJAbtQQr7rWpgmkJSFD56rVSo/AU27zBFegtKoXwTAtnrNKhl
	 d+DO8Yc9QEAkGGFxLTJVTaTF6BDVChTU2EsXPyiM=
Message-ID: <edc8b5da-022b-4e64-8364-dca2cac410e2@linux.microsoft.com>
Date: Mon, 2 Mar 2026 16:34:55 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Joachim Vandersmissen <git@jvdsn.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jeff Barnes <jeffbarnes@microsoft.com>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
 <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
 <aaKtujHwV0zDFWxi@gondor.apana.org.au>
 <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>
 <aaWB3RkW4AeJ-c9z@gondor.apana.org.au>
Content-Language: en-US
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Autocrypt: addr=jeffbarnes@linux.microsoft.com; keydata=
 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
 BR++r9M2JSHIgP5LESF8KrBJ6s2f4TqSBCpQ
In-Reply-To: <aaWB3RkW4AeJ-c9z@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/2/26 07:26, Herbert Xu wrote:
> On Sun, Mar 01, 2026 at 02:41:28PM -0600, Joachim Vandersmissen wrote:
>> However, Cryptographic Module Validation Program has also recently made it
>> clear that xxhash64 cannot be FIPS approved the way it is currently
>> implemented in the kernel. Even though the designers of xxhash publicly
>> state that it is a non-cryptographic hash, the kernel offers it as part of
>> the shash interface, the same interface as the approved algorithms. The
>> interface / API also has "crypto" in the name, which according to CMVP
>> implies security. CMVP feels that there could be confusion with the approved
>> hash algorithms, so there needs to be some indication that xxhash64 is not
>> FIPS approved. I think blocking xxhash64 in FIPS mode would break btrfs,
>> where it is used for checksumming.
> xxhash64 should be converted to lib/crypto and removed from the
> Crypto API.
>
> Thanks,


I believe Eric Biggers commitfe11ac191ce0ad910f6fda0c628bcff19fcff47d 
did this already.
Best,
Jeff


