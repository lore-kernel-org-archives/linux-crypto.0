Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD71B12B94;
	Thu, 12 Mar 2026 14:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773324062; cv=none; b=RIaatcx1N/ivu3oJHdktlAQBMNAkIbezFOrTNO3L5pWbS+kNKmUyTo4nr0WN5t+jryeXluzt+NuWQzYv7m2Sth5aKm4+4AtiN+5mDB9ed9dO73o8iP1Z5/kVk0I2Rtvicl6IT0AfcZyDWtVitVb+8opvpiNXHGfCfTlIJPx+dKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773324062; c=relaxed/simple;
	bh=+q1Komu+5utSHtJJpCIGbnPhj/81TiO+FupdKOlRKV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sr+lNbEExh6fOHWFw9YQALmH8FgZPXRIguvkr/niLoS+E+893kufVhvmhlZzGqYKU9FU162J+OJhSDUxtOiWgT5dqP2HUBu3rRyfRce0eKCrQg+yt1HavxmjTEvta2qsM/gaKJYzunNQ79dPIUHwmSVt3QyFs/5rSwjvDUyqWqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Jc0evgsZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Jc0evgsZ"
Received: from [100.96.1.41] (unknown [52.167.115.14])
	by linux.microsoft.com (Postfix) with ESMTPSA id 774AB20B710C;
	Thu, 12 Mar 2026 07:01:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 774AB20B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773324061;
	bh=vgifgPVqkFEoM0HESSAroxX4sJ9Iu/cJH5ToqYe3NTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jc0evgsZAz3UiVsEYk6p39ZmAZpoD0ArZ1RV3bmWJGrTucaiwLGVpClzZRM1S8tzy
	 hUMzklI3qwY2fd0MRjVBm8Ud1dItHvQBHl6E94Uvn+CILFODWO55WgXaKK3ok/py0/
	 /5jGPsOQaqipGw7BCkzl+ITCqpuO2YCDLYxAhu6s=
Message-ID: <a9e6bf51-1222-4901-b7a9-9d47c0abbac5@linux.microsoft.com>
Date: Thu, 12 Mar 2026 10:00:59 -0400
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
Cc: Joachim Vandersmissen <git@jvdsn.com>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jeff Barnes <jeffbarnes@microsoft.com>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
 <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
 <ce1d34d9-23f9-4d1e-b790-6af75d1555ed@linux.microsoft.com>
 <aaKtujHwV0zDFWxi@gondor.apana.org.au>
 <a73a2556-3fa3-45fc-bf06-a62e8367e953@jvdsn.com>
 <145cfedf-7510-44b7-b1b7-6569144e7b21@linux.microsoft.com>
 <aaZXa9GHhbvmyqLR@gondor.apana.org.au>
Content-Language: en-US
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Autocrypt: addr=jeffbarnes@linux.microsoft.com; keydata=
 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
 BR++r9M2JSHIgP5LESF8KrBJ6s2f4TqSBCpQ
In-Reply-To: <aaZXa9GHhbvmyqLR@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/26 22:37, Herbert Xu wrote:
> On Mon, Mar 02, 2026 at 04:51:38PM -0500, Jeff Barnes wrote:
>>
>> For instance, ceph, samba, tls, to name a few. They all instantiate the
>> gcm(aes) template. They all construct their own IV. They are all compliant
>> to SP 800-38d. I am pretty sure that at least one constructs it per 8.2.2
>> while the rest construct per 8.2.1.
> 
> Perhaps they could switch to IV generation in a way that's similar
> to seqiv?
Actually, there's no need to do that. They are all compliant already 
with the spec.

The issue according to the CMVP (NIST) is that because the kernel crypto 
api is, well, an api, that it is *possible* to instantiate the gcm(aes) 
template and generate an IV in a non-compliant way. Even when pressing 
the point that the kernel is monolithic, hence self-contained, and 
booted with lockdown=integrity, the point is lost on the certifying 
body. Their response is to implement the service indicator "like all the 
other distros". That is a very unfortunate way of putting it. It is what 
it is.

So currently, for the kernel (crypto api) to pass FIPS 140-3 
certification, the only viable solution is to either implement the 
out-of-tree patch or disallow gcm(aes) in FIPS mode. Of the two, the 
out-of-tree patch is expensive but the lesser of the two evils.

I like the idea of automatically switching to seqiv or rfc4106 templates 
when in FIPS mode. The unfortunate consequence is scale. There are 24 
gcm(aes) template instantiations spread out through the kernel tree with 
about as many maintainers. Each of them generate an IV. That seems to me 
to be too large scale.

Please reconsider.

Best regards,
Jeff

> 
> Cheers,

