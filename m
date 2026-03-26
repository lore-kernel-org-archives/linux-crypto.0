Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA4831717B
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 09:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518395; cv=none; b=Ei2/kHuavI09ZnTMPyvXzYReg5+z1hCPpmyiF9rLAMZ+8egSZZRJQmmkpn1vreyBO0zQVSMGAh3tqTxs1Sx9jKB6UqEmgwQDN/BiBJBPKgNixqClCBljkfKjveWXxxMaz9LBlakOZXt3mgMLG9TNhFMsBxQAF0nfg/mNrxXrG5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518395; c=relaxed/simple;
	bh=/ePnU4+lOo5eOaImX73MZTOmaKDBi4z3YpI5LmFb2YY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I/UImdh1YOkDRnw94EVoPuRb/wcOVBZSW4O5WdNaKxMFQmEqwm5R2alMHwl+mR9rWxTsoBqbi8IjQcgUAmb3TlQ0nG8+l4z4Cn4oWAHfMfiMMTTMu40dbSaDBT6Xm7Gal0ukUIaQ804sQ90QW6bd9yKcqlhEI6xtKckaARKutL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=VNaGRExV; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="VNaGRExV"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 7D94EC56685;
	Thu, 26 Mar 2026 09:46:58 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5A3BD5FDEB;
	Thu, 26 Mar 2026 09:46:30 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id CD9B810451B26;
	Thu, 26 Mar 2026 10:46:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774518389; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=pGegp8oyJ+w6MV5D1IOR1vrx6d1Kzo4MmL6SdV9FVl4=;
	b=VNaGRExVqdYCbZuqLlv0Waj54YxFHewZwTeKzUKxIfTYKlrn3TFHA/aVlW3Iyt12AvO23G
	les20wLbIhVmpJxnO+oWOy1TzsRs0uLWTkrBioZ1kOWPIbgJf2Oc8pacUL6dft3izTPUkZ
	Yc54CvZtUH6fhwbieyTFIpbHl7fZOYdfGAbDv8j8DdH8TC+ciSaZomx+XDvezyi+OdTK0g
	EDXubBm/TilDGXxg1fKpEI3srciv68hRJgl1M/YYwLOLHkxiGntzqSbKoqaS0+J33RPwrm
	h6kNdXZLUdquKYkoehwNVzGI3mcgPzpOyWObc1NDB2A8ubMc3aM9OGqYrl5q5g==
Message-ID: <5a91d084-a1f6-4911-8592-a4f5dd3f3e13@bootlin.com>
Date: Thu, 26 Mar 2026 10:46:26 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Need some clarification about CRYPTO_AHASH_ALG_BLOCK_ONLY
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>
References: <4f93481a-a0e5-4a9f-8aae-00d3189ccc58@bootlin.com>
 <b53feadd-8246-43cf-a768-740cb73d2553@bootlin.com>
 <acTt7q5nXMBsDcxv@gondor.apana.org.au>
Content-Language: en-US
From: Paul Louvel <paul.louvel@bootlin.com>
In-Reply-To: <acTt7q5nXMBsDcxv@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi,

> This flag is meant to be temporary in nature.
What does that mean ? The flag will be subject to changes in the near future ?

> Historically, crypto API hash drivers processed partial blocks at the
> end directly and the API played no role in it.
>
> This has resulted in complexities in the drivers and associated bugs.
I agree. I am currently working on the talitos crypto driver, which includes 
code to handle partial blocks. The SEC1 (currently supported by the talitos 
driver) is older hardware that only accepts data with a length that is a 
multiple of the underlying hashing algorithm's block size. Would it make sense 
for the crypto API to have a flag to handle such limitations automatically?

> The API is now able to handle partial blocks for the drivers and
> the flag is an indication of the driver's preference for it.
Understood.

> For a reference, see the aspeed driver which has been converted
> to the new way of handling partial block data.
Ok.

Thank you,

On 3/26/26 9:27 AM, Herbert Xu wrote:
>> On 3/20/26 10:42 AM, Paul Louvel wrote:
>>> Hello,
>>>
>>> I have stumbled across a flag defined in include/crypto/internal/hash.h
>>> : CRYPTO_AHASH_ALG_BLOCK_ONLY.
>>> To get more information about what exact behavior this flag do, I read
>>> the crypto_ahash_update function.
>>>  From the looks of it, it seems that the API will call the tfm update if
>>> there is enough bytes (and by enough I mean at least a block size), from
>>> the internal buffer and the incoming ahash_request.
>>> In this case, I find the BLOCK_ONLY naming a bit of a misnomer, since it
>>> only guarantee you than req->nbytes will be at least a block size.
>>> I initially though that the API would only give a request that are a
>>> multiple of the block size.
>>>
>>> This flag, among others, are relatively recent.
>>> I think adding documentation about these flags would be a great idea.
> This flag is meant to be temporary in nature.
>
> Historically, crypto API hash drivers processed partial blocks at the
> end directly and the API played no role in it.
>
> This has resulted in complexities in the drivers and associated bugs.
>
> The API is now able to handle partial blocks for the drivers and
> the flag is an indication of the driver's preference for it.
>
> For a reference, see the aspeed driver which has been converted
> to the new way of handling partial block data.
>
> Cheers,

-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

