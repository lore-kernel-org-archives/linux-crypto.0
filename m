Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B90D235358;
	Thu, 10 Sep 2026 03:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789011233; cv=none; b=SA823bCacqyN9vnurS8GiS+IRGCoK8scyu9jJZbVIdsTOtwdg0u4PeoxZ/TgaTzdFDkUAdU582kw80Gv24A5FpqDG1JPAg8+OYlXFuFhe4STjEBq0lTC0Wzy5yd5fZVbo7KmztKKxrvosRHn1NLonAt4Igon5AdDj0wODe5igdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789011233; c=relaxed/simple;
	bh=OSmlZrTtowYwV7CqDLWVt9GCCCLsHOffm7LbDvdbciM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T8CSBBRAUzwHJODZNxUOnVMkMqETejnLhX4aDBDmxaVrPm0k3zISw0a53fXaSk9jqa+mH2SDqJLfgHHnylAZjdcSx/+tFWidl03Z9qf0DO61lu52b+/5DN6JUxypjfm34DFXxVukdUuEbLsufn4BfUq44LU1sgFbnLQ3i5w5VTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=HMl5re/5; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="HMl5re/5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1789010683; bh=OSmlZrTtowYwV7CqDLWVt9GCCCLsHOffm7LbDvdbciM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HMl5re/5pdfhQrloFTxpSn/Wk9I1N8fBDHCI6Ld7/Mg7K+E2nnE8xYPUFEzyE2KRY
	 u0NV9bNtzXgBAKx7ZRR/FsDbpZQSYHWx42SDjwhEVFbr5ylQBqcMCSPLFX1L/lmv7Y
	 hh8iWN+Zr6v1wDM9hD/iSLa73K00w4EJyM2tWF9xB8oFOQhiM5KWtY6do013FIdpCJ
	 kYTfsi+G219Xs1QFuj6tTQ8O3qPSzJDAvaqNj4I5zwDc0/JnoNhHN+/ZxhsgRzIuYF
	 RrKLLKluVok3nHmgNN18D5yI59CfAFvWCbdZcPLR4dq78IoP2vuAAMECDfYLSGEKXw
	 yg5zRNbaS8t3A==
Message-ID: <83d09aa1-729a-47a2-a8e9-381c74e92f42@jvdsn.com>
Date: Wed, 9 Sep 2026 22:24:42 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
To: Thomas Huth <thuth@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
References: <20260303060509.246038-1-git@jvdsn.com>
 <abTuFto8Tc3mhRRe@gondor.apana.org.au>
 <64592fee-1956-4a70-a751-9ac3335cfc27@jvdsn.com>
 <9926908a-5f08-43ba-99dd-b83c7067d52b@redhat.com>
From: Joachim Vandersmissen <joachim@jvdsn.com>
Content-Language: en-US
In-Reply-To: <9926908a-5f08-43ba-99dd-b83c7067d52b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Thomas,

On 9/9/26 9:36 AM, Thomas Huth wrote:
> On 15/03/2026 01.43, Joachim Vandersmissen wrote:
>> Hi Herbert,
>>
>> I don't think this one can be applied yet since dm-integrity still 
>> uses xxhash64 through the crypto API. This would break fips=1 systems 
>> that use it.
>
> Out of curiosity: Wouldn't such a system be FIPS-incompliant anyway? 
> If xxhash64 isn't FIPS-compliant, nobody should use it for 
> dm-integrity there, right? So I doubt that there are any systems out 
> there that use fips=1 and use xxhash64 at the same time?

There is a risk that users may not know that xxhash64 is not FIPS 
compliant and would still use it. Especially considering it was marked 
as "fips_allowed = 1" for a while.

Distributions that actually need FIPS validation will probably apply 
this patch anyway and deal with the breakage if it happens.

>
>  Thomas
>
>>
>> On 3/14/26 12:11 AM, Herbert Xu wrote:
>>> On Tue, Mar 03, 2026 at 12:05:09AM -0600, Joachim Vandersmissen wrote:
>>>> xxhash64 is not a cryptographic hash algorithm, but is offered in the
>>>> same API (shash) as actual cryptographic hash algorithms such as
>>>> SHA-256. The Cryptographic Module Validation Program (CMVP), managing
>>>> FIPS certification, believes that this could cause confusion. xxhash64
>>>> must therefore be blocked in FIPS mode.
>>>>
>>>> The only usage of xxhash64 in the kernel is btrfs. Commit fe11ac191ce0
>>>> ("btrfs: switch to library APIs for checksums") recently modified the
>>>> btrfs code to use the lib/crypto API, avoiding the Kernel 
>>>> Cryptographic
>>>> API. Consequently, the removal of xxhash64 from the Crypto API in FIPS
>>>> mode should now have no impact on btrfs usage.
>>>>
>>>> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
>>>> ---
>>>>   crypto/testmgr.c | 1 -
>>>>   1 file changed, 1 deletion(-)
>>> Patch applied.  Thanks.
>>
>
