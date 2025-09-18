Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5B417BB21
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 03:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758167986; cv=none; b=PXtE+WUM6tueW7G2V3N3KEZOySGlBZM4Hi/rKUruPUVxbS1k1HBUDwJd+fbYVS54Fdscxh6SNg2Lw9X7CaVXujZO5xYaBqt4FNV17MTsVmGakxAzulyD+iGxaaCkosJiAeJQv/fdpvIkmVG31Ik6ZCouqsHpwGVqKtcqic9E03k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758167986; c=relaxed/simple;
	bh=kHjkkGX4aQI1kHDejnBSOl1bg6VzbAjucc6G6nfvRHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VrWuULxk5oDEBxfv1sIyLL1FezU9sodeeCgH1so9BD4dyWWZKClvZ5fZxFfr9sHHpo4MyFuIQnEzJ5kl5PD3nJ1InF6s3voO2Ej5NZ4Z0nTvMj6CspCYZvMdq08EAkRzehhfBmYCq/6Y8fNQlI8PKf2NH1er99vmot3hfhBs6/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=hnEjYC89; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="hnEjYC89"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1758167593; bh=kHjkkGX4aQI1kHDejnBSOl1bg6VzbAjucc6G6nfvRHc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hnEjYC89Fc1jJjEsv8HYrO8gsci8QJIWvWu8lzaifRPaGh0ArBYy+ya2h0TKkwb7n
	 NA2Wdg5kLPIuPOgI9mNWQfGG99WwgYt1Pb629zUF+z8sTRXn3ZvTz9XyDq6AOJTlAn
	 cgipQrJop3mjYIDFJX16kIowvvYS6z3WX4J5IqYSWvXVx6EkLSAlT1Uw3nvM4Kkbo/
	 9ak3MWCP9OSTSv2E1gCO/6a/DuaxjO4m0s8y4XYLDkbnQRcAlBDV27TzeUqZTa6kj9
	 6qtTtNT8Pbr7SvEt3z//CpJnWJ02mXI8ZnyML1df8xwngCTyYsCwQgIx2aav2Tp1oj
	 ncyBIIExqaBWw==
Message-ID: <783702f5-4128-4299-996b-fe95efb49a4b@jvdsn.com>
Date: Wed, 17 Sep 2025 22:53:12 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: SHAKE256 support
To: Eric Biggers <ebiggers@kernel.org>, dhowells@redhat.com
Cc: linux-crypto@vger.kernel.org
References: <20250915220727.GA286751@quark>
 <2767539.1757969506@warthog.procyon.org.uk>
 <2768235.1757970013@warthog.procyon.org.uk>
 <3226361.1758126043@warthog.procyon.org.uk> <20250917184856.GA2560@quark>
Content-Language: en-US
From: Joachim Vandersmissen <git@jvdsn.com>
In-Reply-To: <20250917184856.GA2560@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric, David,

On 9/17/25 1:48 PM, Eric Biggers wrote:
> On Wed, Sep 17, 2025 at 05:20:43PM +0100, David Howells wrote:
>
>> For FIPS compliance, IIRC, you *have* to run tests on the algorithms,
>> so wouldn't using kunit just be a waste of resources?
> The lib/crypto/ KUnit tests are real tests, which thoroughly test each
> algorithm.  This includes computing thousands of hashes for each hash
> algorithm, for example.
>
> FIPS pre-operational self-testing, if and when it is required, would be
> a completely different thing.  For example, FIPS often requires only a
> single test (with a single call to the algorithm) per algorithm.  Refer
> to section 10.3.A of "Implementation Guidance for FIPS 140-3 and the
> Cryptographic Module Validation Program"
> (https://csrc.nist.gov/csrc/media/Projects/cryptographic-module-validation-program/documents/fips%20140-3/FIPS%20140-3%20IG.pdf)
>
> Of course, so far the people doing FIPS certification of the whole
> kernel haven't actually cared about FIPS pre-operational self-tests for
> the library functions.  lib/ has had SHA-1 support since 2005, for
> example, and it's never had a FIPS pre-operational self-test.
I'm not too familiar with the history of lib/crypto/, but I have noticed 
over the past months that there has been a noticeable shift to moving 
in-kernel users from the kernel crypto API to the library APIs. While 
this seems to be an overall improvement, it does make FIPS compliance 
more challenging. If the kernel crypto API is the only user of 
lib/crypto/, it is possible to make an argument that the testmgr.c 
self-tests cover the lib/crypto/ implementations (since those would be 
called at some point). However since other code is now calling 
lib/crypto/ directly, that assumption may no longer hold.
>
> *If* that's changing and the people doing FIPS certifications of the
> whole kernel have decided that the library functions actually need FIPS
> pre-operational self-tests after all, that's fine.

Currently I don't see how direct users of the lib/crypto/ APIs can be 
FIPS compliant; self-tests are only one of the requirements that are not 
implemented. It would be one of the more straightforward requirements to 
implement though, if this is something the kernel project would accept 
at that (lib/crypto/) layer.

Kind regards,
Joachim

> But please don't try
> to misuse the actual (KUnit) tests.  Instead, just add exactly what is
> actually required by the FIPS to the appropriate subsys_initcall in the
> library.  For SHA-3 for example, you'd only need to compute and verify a
> single hash, using any of SHA3-224, SHA3-256, SHA3-384, SHA3-512.  Then
> panic() if it fails and fips_enabled is true.
>
> - Eric
>
