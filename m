Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005D92609CC
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758217741; cv=none; b=ZmHrRaTzUVlpzkhxkn1ttIKUQxK4WyA8/F+EIm0usnphnytScfUJLJ1+S+hZtNZCv7LkAyWWfgD8zahPxlRfuRGgsYd/+rN/atK7mgKMYiltQ3CG390V/3+YgyneX/PpauuBMfEY8U/5UpKCMbU7DNXLgOVXfvoI8ZZyhP5GmyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758217741; c=relaxed/simple;
	bh=QH5zAtD/nU9AMBeqShCnqrqXZNHlO6ksXmkvDYKak9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MW4M/f1PF7vlXd96H/A2dH1k3I3J5/Yx4DmyTkdx7YwF13irt8GJD0tJzpGDixhfL/1auxdLDSM2vK84/Ha/QEToSL20H6iO6gqx++uTOdy35GZosfeALivG1sn1u9c/y0BrkbIsnKKO/9/zfVH2Kib9hwEIdPIupFlWjUG3bnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=52PRkJmq; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="52PRkJmq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1758217739; bh=QH5zAtD/nU9AMBeqShCnqrqXZNHlO6ksXmkvDYKak9U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=52PRkJmqfrT8c4krZRaqldrCQzXuDaghqXQL1uhB+yokRqtjXFCYNjIQh/WMGGRy1
	 eH1tpr/2dS7SdFTaeUWjUGT13kT3jJPP5cX0P47vEVeYcbxbTmptKOzZSdKEVqLhFK
	 MApx7KEZFfhZ4HGUUhc1bNTbEAI2dsB3EAfs3o/Ga+BqxO+2sYZZBcg+W5U607v1I1
	 hy3R5tmgCU8VMXKpem3Q/roA+A9gAi39bfT1Dg+nSYV4rWhoL//ddy4+SDOYgjrpOf
	 gU6C8U54ESZ0lf0ugwoKVHqizSTA9ElE2XfnHhsuPXY38RLdKwndaOczt3jKbL7z0z
	 UUOHZ9jnetHKg==
Message-ID: <3e06f746-775e-4b9e-93c9-d1f51f77148f@jvdsn.com>
Date: Thu, 18 Sep 2025 12:48:52 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: FIPS requirements in lib/crypto/ APIs
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, simo@redhat.com
References: <0b7ce82a-1a2f-4be9-bfa7-eaf6a5ef9b40@jvdsn.com>
 <20250918163347.GB1422@quark>
Content-Language: en-US
From: Joachim Vandersmissen <joachim@jvdsn.com>
In-Reply-To: <20250918163347.GB1422@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Eric,

On 9/18/25 11:33 AM, Eric Biggers wrote:
> On Thu, Sep 18, 2025 at 11:00:45AM -0500, Joachim Vandersmissen wrote:
>> Hi Eric,
>>
>> I'm starting a new thread since I don't want to push the SHAKE256 thread
>> off-topic too much.
>>
>> One simple example of a FIPS requirement that I currently don't see in
>> lib/crypto/ is that HMAC keys must be at least 112 bits in length. If the
>> lib/crypto/ HMAC API wants to be FIPS compliant, it must enforce that (i.e.,
>> disallow HMAC computations using those small keys). It's trivial to add a
>> check to __hmac_sha1_preparekey or hmac_sha1_preparekey or
>> hmac_sha1_init_usingrawkey, but the API functions don't return an error
>> code. How would the caller know anything is wrong? Maybe there needs to be a
>> mechanism in place first to let callers know about these kinds of checks?
>>
>> It would be great to have your guidance since you've done so much work on
>> the lib/crypto/ APIs, you obviously know the design very well.
> That's misleading.  First, in the approach to FIPS certification that is
> currently (sort of) supported by the upstream kernel, the FIPS module
> contains the entire kernel.  lib/crypto/ contains kernel-internal
> functions, which are *not* part of the interface of the FIPS module.
> So, lib/crypto/ does *not* need to have a "FIPS compliant API".

Please correct me if I'm wrong, but are the lib/crypto/ APIs not 
exported for everyone to use? Even if the entire kernel is the FIPS 
module, wouldn't that mean the APIs could be used by e.g. dynamically 
loaded kernel modules?

You are right there are some nuances about the HMAC key lengths, as with 
most FIPS requirements. There's other FIPS requirements, like tag sizes 
for HMAC, or IV generation for AES-GCM encryption, that also have very 
similar nuances.

I'm more trying to figure out a general approach to address these kinds 
of requirements. What I usually see in FIPS modules, is that the FIPS 
module API is as conservative as possible, rather than relying on the 
callers to perform the FIPS requirement checks.

>
> Second, according to the document "Implementation Guidance for FIPS
> 140-3 and the Cryptographic Module Validation Program", HMAC with keys
> shorter than 112 bits is still approved for legacy use in verifying
> existing messages.
>
> Third, HMAC is sometimes used with HKDF, where the input keying material
> is passed as the *data*.  The HMAC key length would be the wrong length
> to check in this case.
>
> Fourth, not every user of HMAC is the kernel is necessarily for a
> "security function" of the FIPS module.  Non-security functions can use
> non-FIPS-approved algorithms.
>
> Point is: lib/crypto/ is correct in allowing HMAC keys shorter than 112
> bits.  (And this is a lot like how lib/ also has entirely
> non-FIPS-approved algorithms, like ChaCha20...)  It's up to callers of
> the hmac_*() functions, who have more information about the purpose for
> which HMAC is actually being used, to do the check *if* they need it.
>
> - Eric
>
