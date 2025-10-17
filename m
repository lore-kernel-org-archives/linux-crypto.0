Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5982427FB1E;
	Fri, 17 Oct 2025 08:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689516; cv=none; b=bJjVjynbLurPFd4ufS9Fg6ML3Y1rPDUbQkAClpJIBMKvyL9mr2Zt4C2jrFHjcXw6N9peeaZkRIUqIdCcVCXd8utL+Yao0hdDkpRbdKITk+RUYJ+wqAiglwGNpWULQTVCpbZ0QYNK1fUGOjAjwxNjdyY9RON2gNsvbF5q8A3YvEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689516; c=relaxed/simple;
	bh=iNUZxqwDecR8yWAIldsv+lyzkvZSugSUQI/10bkGy6s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Pvy1t+7m/yO7wCfyoSiiVxN0wBULxAMyk9YgAsnK4fxeqQyaP+7Gbs6N+y1M1Sg/1iSyUndjdjHYxMeSnQWGrNrwVJwg4pxdft30pY5HU+Ti25wJ561uahxPLUEc3eFvE+zJlWRaTJuLlfk3Grl1mkI5+cUxb4B+djCU5/nSx/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qq3tnVMg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qq3tnVMg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=ZeSeqQKg3TYnz8PTmE+N8spxfM7AvB6/stYqeCy1agk=; b=qq3tnVMgMS9l724cmZbmTckkQk
	qFVnhwrYV+Sbm97q5+K8rYVhtXhQ83YbKaLpG/W2lZq3+YMlmFXR8gsV6Au2XxNlZzBsuFfvkpPkf
	fqrqRV0+1d1LtAvLoKpln5pCmhV+2lojsobYNZ4+XEE7+0Gxy+WHJgCfZW1EXHCUD5OolP/E6Q7LR
	2o6JQmlH/vkmfz3mWWM+3+OzSqeIKKVremS3oMlpqGEqeu8fgWwOjcG0lg/bytMuvbBQxJ/O5pjbd
	ixzUVV68Osx5xmmk/nG5wxKu8B2P+e4FRKQ9//OyHHM9TcbNGYQIS3ge5nZnMWNAJvM9T52iL/BAz
	fh+kjmLw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9flt-00DN7r-0f;
	Fri, 17 Oct 2025 16:25:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:25:09 +0800
Date: Fri, 17 Oct 2025 16:25:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, ardb@kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
Message-ID: <aPH9ZQP0m8Pq5Iy-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014003123.GA2763@sol>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, Oct 01, 2025 at 07:31:09PM -0700, Eric Biggers wrote:
>> This patchset replaces the 256-bit vector implementation of AES-GCM for
>> x86_64 with one that requires AVX2 rather than AVX512.  This greatly
>> improves AES-GCM performance on CPUs that have VAES but not AVX512, for
>> example by up to 74% on AMD Zen 3.  For more details, see patch 1.
>> 
>> This patchset also renames the 512-bit vector implementation of AES-GCM
>> for x86_64 to be named after AVX512 rather than AVX10/512, then adds
>> some additional optimizations to it.
>> 
>> This patchset applies to next-20250929 and is targeting 6.19.  Herbert,
>> I'd prefer to just apply this myself.  But let me know if you'd prefer
>> to take it instead (considering that AES-GCM hasn't been librarified
>> yet).  Either way, there's no hurry, since this is targeting 6.19.
>> 
>> Eric Biggers (8):
>>   crypto: x86/aes-gcm - add VAES+AVX2 optimized code
>>   crypto: x86/aes-gcm - remove VAES+AVX10/256 optimized code
>>   crypto: x86/aes-gcm - rename avx10 and avx10_512 to avx512
>>   crypto: x86/aes-gcm - clean up AVX512 code to assume 512-bit vectors
>>   crypto: x86/aes-gcm - reorder AVX512 precompute and aad_update
>>     functions
>>   crypto: x86/aes-gcm - revise some comments in AVX512 code
>>   crypto: x86/aes-gcm - optimize AVX512 precomputation of H^2 from H^1
>>   crypto: x86/aes-gcm - optimize long AAD processing with AVX512
>> 
>>  arch/x86/crypto/Makefile                      |    5 +-
>>  arch/x86/crypto/aes-gcm-aesni-x86_64.S        |   12 +-
>>  arch/x86/crypto/aes-gcm-vaes-avx2.S           | 1150 +++++++++++++++++
>>  ...m-avx10-x86_64.S => aes-gcm-vaes-avx512.S} |  722 +++++------
>>  arch/x86/crypto/aesni-intel_glue.c            |  264 ++--
>>  5 files changed, 1667 insertions(+), 486 deletions(-)
>>  create mode 100644 arch/x86/crypto/aes-gcm-vaes-avx2.S
>>  rename arch/x86/crypto/{aes-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} (69%)
>> 
>> base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a
> 
> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

Oops, I didn't see this email until it was too late.  Since the
patches should be identical I don't think it matters.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
