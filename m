Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB90196C7C;
	Tue,  7 Oct 2025 03:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759808567; cv=none; b=Lc5J5KtTeMv5pEV9PJMTTCDOX66Xe/xmMwNT/zeXsnZt19ItEa9+9ZBQZGmKNLKBtGQM4leNcZ8Y4kSua8/7tUDGWrR7LYKMHnc67t7X/xr8zqAa1ur+EoxBNxTJP7hA2Fjl9kusnszbt6ihZHD/m+dDSStBFlVHHRgh3Vr+/Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759808567; c=relaxed/simple;
	bh=2ffhrjPipteAJONKOPVl7XKbWoSHlNmXIa/ZaTKNl0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T3bls9N4zrCWw1BjFm08A+S/XrEArC90ynn9tPCYjKSoWl/IQw1UTA0by6YbMvJvQRswZZNawtazjlJkkA//nESoJOTrqoNJHTzr/9qz+1O5wdot0imCgOFpiJAlQITp1emfKX5DWBSQJosuvCoI52Q4OkSABlX71xqqJ6U/Z5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=V9Z0us7k; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="V9Z0us7k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1759808565; bh=2ffhrjPipteAJONKOPVl7XKbWoSHlNmXIa/ZaTKNl0c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V9Z0us7ktQqB+gCZ1TJFKeuHc7wW46JYI945BSahqwOQ9kppTajHIojGuvdmnlSDI
	 Aqf18RGN9VH9dbFSN/pevz3iHW6Fk0HCdnYbqlT6Jbi7KETQq9AxIhjUNIXFFJIK6Z
	 obvSo6vpGsjBtdC4h2xShKvRzskBkjiNIZ1s+/weFt2isBhInISQmD+n4r5Vi1x9Zg
	 VmkitefpVrfs0zXHbkCECxHtblk6L1/1Upf072NPrpwlBJEmkSkvrK1Vrrygxkch4y
	 H0f50HBgDVaSnddFIPQ3bUzUjqAbfBDeokgUh2bxrmi5u5TcDhy4N/wNB1nZhet4fV
	 CF9RbVEOEPV8A==
Message-ID: <87c17942-4c5b-45d6-b25d-089440b3d69b@jvdsn.com>
Date: Mon, 6 Oct 2025 22:42:44 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] lib/crypto: Add FIPS pre-operational self-test for SHA
 algorithms
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Vegard Nossum <vegard.nossum@oracle.com>, David Howells
 <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
References: <20251006172612.75240-1-ebiggers@kernel.org>
 <38ca063d-521a-4fc4-8398-5e77625533c4@jvdsn.com> <20251007032706.GB77681@sol>
From: Joachim Vandersmissen <git@jvdsn.com>
Content-Language: en-US
In-Reply-To: <20251007032706.GB77681@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

FIPS 140-3 always classifies Cryptographic Algorithm Self-Tests (CASTs) 
as conditional, even if they are executed on start-up. The condition 
would then be "start-up" or "initialization" or something similar. IG 
10.3.A explains it relatively well in the background section. For 
example, the Security Policy for 
https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/5036 
shows the CASTs in Table 21.

In any case the name doesn't matter too much, even if you keep it the 
way it is, it wouldn't really impact a validation.

Kind regards,
Joachim

On 10/6/25 10:27 PM, Eric Biggers wrote:
> On Mon, Oct 06, 2025 at 10:03:44PM -0500, Joachim Vandersmissen wrote:
>> Hi Eric,
>>
>> It's a very minor change but I suggest not using "pre-operational
>> self-test". That term specifically refers to a different type of self-test
>> in FIPS 140-3 and it could lead to some confusion here. "cryptographic
>> algorithm self-test" may be better (if you want to be formal), or just
>> "self-test" or "known-answer test".
>>
> I don't think that's quite correct.  FIPS 140-3 divides self-tests into
> two categories, pre-operational (executed unconditionally at start-up
> time) and conditional (executed only when conditions are met, such as an
> algorithm being used for the first time).  This patch chooses the first
> option, pre-operational.
>
> We could just call them algorithm self-tests if we don't want to be
> specific as to what time they run at, though.
>
> - Eric
>
