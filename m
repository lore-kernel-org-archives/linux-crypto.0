Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB0149E150;
	Fri, 11 Sep 2026 02:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789095213; cv=none; b=svygimq0ZwuHuldxVQcTfnk7A9CtxvPySla5YbA1cisjCQLbONH4fdy2B+vHR1Js9VZWiDRowM3ypLax29zEi6oHXUaeNHzkvzDFex+w5oAd+EygAB3psdxZ3W6do69V8qbV63QD0i2JTtoNdmwpCqfxTM0lEgjdCXVv9QLp/Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789095213; c=relaxed/simple;
	bh=1RhRGsA/+i354nq29SKiIHFX5cjaUHf/p/lQTaN2tk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NVnOIO/MoG//pPaHQIdnHLhvPuCnf3ddYl3F5UJLwJmM+ZdtwL8mAABMTOZ2uTiEh2lyz38qHYxPthRd/QyQBaTWErRHL1XYmrTzTgqRzTttcR/rFdynlUS6snw4PrYiWz+hN8l7y0Kc+T08qj+LXTidP+9BPQWW/cm1zmryXHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=4/pB/uEY; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="4/pB/uEY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1789095211; bh=1RhRGsA/+i354nq29SKiIHFX5cjaUHf/p/lQTaN2tk8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=4/pB/uEYmTrLXPTvO0NmuWhXOUuRYJE0IWF9Re4C1MJhW80WoYEXPuSxueOCTWbFx
	 Sb3ghS3L4wanuWcb987JOWi5s/AEzDSn2NIo+zsqsNJUzqZYvetdpCfyzi0m7e8bp1
	 plSkHrBIcgArcQKVXl2j4m+6FEZJbuD+66NWdVA5cga/LmxaqhSrsV2kxE2bLzlZ10
	 Bcs2k/m9xNYxBLO2/F+caD7bZcr3HekTYiuzqg7k56rdeEuSTOFJEKcTljDp3PiqFM
	 dbr4ECVl4qm2PwplC9QnTulbMoOHFGYDrxxqgcOqVTOxg4yl1LGvFs/A/oV0JDKLXq
	 f4/8+iQv5TG9g==
Message-ID: <e1d45f87-de65-4ff2-903a-80fd2c0b3861@jvdsn.com>
Date: Thu, 10 Sep 2026 21:53:30 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
To: Eric Biggers <ebiggers@kernel.org>, Thomas Huth <thuth@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
References: <20260303060509.246038-1-git@jvdsn.com>
 <abTuFto8Tc3mhRRe@gondor.apana.org.au>
 <64592fee-1956-4a70-a751-9ac3335cfc27@jvdsn.com>
 <9926908a-5f08-43ba-99dd-b83c7067d52b@redhat.com>
 <83d09aa1-729a-47a2-a8e9-381c74e92f42@jvdsn.com>
 <48f12b65-428d-4809-9735-18876b09e759@redhat.com>
 <20260910141456.GA1936@quark>
From: Joachim Vandersmissen <joachim@jvdsn.com>
Content-Language: en-US
In-Reply-To: <20260910141456.GA1936@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Eric,

On 9/10/26 9:14 AM, Eric Biggers wrote:
> On Thu, Sep 10, 2026 at 10:57:32AM +0200, Thomas Huth wrote:
>> On 10/09/2026 05.24, Joachim Vandersmissen wrote:
>>> Hi Thomas,
>>>
>>> On 9/9/26 9:36 AM, Thomas Huth wrote:
>>>> On 15/03/2026 01.43, Joachim Vandersmissen wrote:
>>>>> Hi Herbert,
>>>>>
>>>>> I don't think this one can be applied yet since dm-integrity
>>>>> still uses xxhash64 through the crypto API. This would break
>>>>> fips=1 systems that use it.
>>>> Out of curiosity: Wouldn't such a system be FIPS-incompliant anyway?
>>>> If xxhash64 isn't FIPS-compliant, nobody should use it for
>>>> dm-integrity there, right? So I doubt that there are any systems out
>>>> there that use fips=1 and use xxhash64 at the same time?
>>> There is a risk that users may not know that xxhash64 is not FIPS
>>> compliant and would still use it. Especially considering it was marked
>>> as "fips_allowed = 1" for a while.
>> So isn't that a very bad situation? They think they are FIPS compliant, but
>> actually they are not since they use an unapproved algorithm by accident.
>> Maybe it would be better to include this patch so that they are aware of the
>> mistake? If there is really somebody running into this issue, they could
>> boot once with fips=0, fix their system, reboot again with fips=1 and
>> finally be really compliant. Sounds like the better solution to me. WDYT?
> As described in the dm-integrity documentation, dm-integrity supports
> non-cryptographic checksums for protection from accidental corruption.
> That use case is no different from any other use case of a checksum.
>
> It's also no different from using crc32 or crc32c, which similarly have
> fips_allowed=1 and this patch completely ignores.
>
> The solution is not banning checksums or making any other code change,
> but rather just doing what it seems everyone has already been doing:
> documenting in their FIPS security policy that checksums are only for
> use cases that are not "security functions".

Unfortunately, this is not an option anymore due to the opinion of the 
CMVP that was issued back in March. If you have an account (you can sign 
up for free), you can read it in full here: 
https://cmuf-workspace.org/Products/Projects/Messages.aspx?prjID=3&id=559. 
I can also send a copy of the PDF file privately, if necessary.

The relevant text is:

     1.a. Can xxhash64 be used in approved mode as non-security function 
without any further action (in this case FIPS IG 2.4.A will not be 
applicable)?

     Answer: No, xxhash64 cannot be understood as a non-security 
function because:
     1) It is offered as an equivalent hash alternative to approved hash 
algorithms (i.e., SHA) using the same interface/API and therefore 
appears to an operator that it can provide cryptographic protection 
(i.e., security).
     2) Its return value (i.e., mode indicator) is the same as for 
approved cryptographic functions that provide security.
     3) It is accessed by an interface/API that has “crypto” in the name 
and thus implies security.
     4) It is an available hash function (i.e. PRF) of HMAC, which is a 
keyed algorithm that implies security.

crc32 and crc32c were not explicitly called out in the resolution, which 
is why this patch didn't target them. Though following the same 
rationale, they should also be disabled.

>
> - Eric
