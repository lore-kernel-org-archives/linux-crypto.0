Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C94848C8CC;
	Tue,  5 May 2026 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777998845; cv=none; b=i04Kbqq5gpdyr2ooZAI5qD+eJDmdkI/KUcGb2dwYpiqlmmOiuQ4cxryVJq6HwzEvRQoGRgy2mSyJjw0qj2ap589e6CWLr31FSjIiSDQN0lox92KX5EwDtqlJMA//pZqBoFitHxzLAfFm4axtWFmMChFUOkkIHtfLUUftOGFxEXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777998845; c=relaxed/simple;
	bh=tN7fwzB7Rvm/u6+2EX9tISVHc7XTHrTV+kwSA1Ez0Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rL9Xfhq/UpSl71xG8UGoRdA6dQ5nWA4CkqQ4u8vJbilJtGTYUa110rSNyq01bVGL2RBxFQhY0Jf5jnW+JVOWyGsutLiJDWKP1bKVsoafiOO6+GtwAO6uRPPkAqLMzbGDt9/IZP26xcAM3fn2hVGCmHQab6CNfaGF5piRBW+L33I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMBNax/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMBNax/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEE9C2BCB4;
	Tue,  5 May 2026 16:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777998844;
	bh=tN7fwzB7Rvm/u6+2EX9tISVHc7XTHrTV+kwSA1Ez0Zg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jMBNax/aPk18eo9Bc84j49KRsEELtbPxD7pgo0d1OndSJao+LiWjXdqk1gtXhPuT1
	 kuOJhYkMOUktGdjR2E3YJcXUnlpTUhmAW76ndOr7z8+hG68ZJ6+cS1n5q4ENRhocXW
	 dKAUX/49J6bYEQaXJtvzkmzXbLwHuWxyLnoKMCq9dFepj7F5ny0kkFOOwsZp88NLWg
	 D2EROoMRaX31/P7PrLsz/8lCYnV41868FvkpN7+3h8iXeCKwyEFQ+W9G3UMv0ECYza
	 O+jlzCOvjHi7K/N1eVD00eLLDtZaYnTDpjGaSxZK7c79btkRt7HuGjc8hZkSgNiq5r
	 yKV4u/mrV67Xg==
Message-ID: <ac6b9bcf-0106-49fd-82ff-20ccc5612fa1@kernel.org>
Date: Tue, 5 May 2026 18:34:00 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: powerpc/md5: Drop powerpc optimized MD5 code
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linuxppc-dev@lists.ozlabs.org,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
References: <20260504041448.15820-1-ebiggers@kernel.org>
 <111ea924-fef5-441e-9849-83f938c913a7@kernel.org> <20260504180044.GC2291@sol>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260504180044.GC2291@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 04/05/2026 à 20:00, Eric Biggers a écrit :
> On Mon, May 04, 2026 at 03:28:24PM +0200, Christophe Leroy (CS GROUP) wrote:
>> Hi Eric,
>>
>> Le 04/05/2026 à 06:14, Eric Biggers a écrit :
>>> Earlier the decision was made to keep this code for a while, despite no
>>> other architectures having optimized MD5 code anymore, because of
>>> someone using it via AF_ALG via libkcapi-hasher
>>> (https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fr%2Ff0d771d5-ed70-444c-957a-ad4c16f6c115%40csgroup.eu%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C8fce00ee4e5a497f0d8808deaa074073%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639135145289986833%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=cS5krthqFluqLlSXBy4Dv0h34gms0bIYRUVfWetoAdg%3D&reserved=0)
>>>
>>> However, with AF_ALG itself now being on its way out due to its
>>> continuous stream of security vulnerabilities
>>> (https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fr%2F20260430011544.31823-1-ebiggers%40kernel.org%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C8fce00ee4e5a497f0d8808deaa074073%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639135145290017177%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=bMbQdEM%2FQYmgz7lelwXuKepC2dZCvKz6Pa6ixwlGtrk%3D&reserved=0),
>>> it's time to be a bit more forceful with nudging people towards
>>> userspace crypto code.  It's always been the better solution anyway, and
>>> it's much more efficient if properly optimized code is used.
>>
>> Ok, why not, but what do you propose as an alternative ? Let me explain the
>> situation.
>>
>> We have two versions of boards:
>> - One with powerpc MPC885E, which embeds a SECURITY Engine called TALITOS
>> for offloading crypto operations
>> - One with powerpc MPC866, which doesn't have the security engine.
>>
>> To use the security engine, our software use the AF_ALG interface (via
>> libkcapi).
>>
>> Our software has to run on both boards, we can't afford two different
>> versions of the software and the software shall have no dead code. Therefore
>> we rely on the capability of the kernel to do the hash by itself when the
>> TALITOS in not available.
>>
>> The kernel has always been the place where we do board specific stuff, not
>> the application. I can't see why the application would have to ask the
>> kernel when the Talitos is there and have to do the hashing by itself when
>> the Talitos is not there.
>>
>> I'm really concerned with the optimised MD5 going away now, and I'm also
>> wondering what will be the way to splice a file into the kernel and get it's
>> MD-5 hash from the TALITOS if AF_ALG goes away in medium-term.
>>
>> What is the way forward ? I'm open to any suggestion as I really can't see
>> where to go for now.
>>
>> But please don't remove powerpc MD5 before we find an alternative solution.
>>
>> Thanks
>> Christophe
> 
> I think I gave the solution in the commit message already, no?  Take the
> same MD5 code and run it in userspace.  It will be even faster than
> invoking that code via AF_ALG.
> 
> Yes, the selection of software vs "security" engine (if you actually
> still need the latter, which in reality you probably don't) would then
> occur in userspace.  But selecting an implementation in userspace isn't
> unusual.  It's no different from how different CPU features are handled
> in userspace.
> 
> Anyway, please don't confuse this patch (which only affects performance)
> with full removal of AF_ALG (which would be a hard break, and won't
> occur until quite far in the future).  This patch is just a nudge in the
> right direction, and a cleanup of the kernel's powerpc support to be
> aligned with all the other architectures.  So I do believe we should
> proceed with this patch.

But this cleanup is a huge performance regression. If it had been a few 
% why not, but here we are talking about 30% more time. And userspace is 
even worse, see below. I really doubt that porting the ASM 
implementation into userspace will make the regression disappear.

Lets give a summary on performance:

With the TALITOS security engine embedded on powerpc 885:

root@miae:~# time md5sum avion.au
6513851d6109d42477b20cd56bf57f28  avion.au
real    0m 0.71s
user    0m 0.00s
sys     0m 0.38s

With kernel PPC MD5:

root@miae:~# time md5sum avion.au
6513851d6109d42477b20cd56bf57f28  avion.au
real    0m 1.01s
user    0m 0.01s
sys     0m 1.00s

With kernel generic MD5:

root@miae:~# time md5sum avion.au
6513851d6109d42477b20cd56bf57f28  avion.au
real    0m 1.31s
user    0m 0.01s
sys     0m 1.30s

With userspace MD5:

root@miae:~# time ./busybox md5sum avion.au
6513851d6109d42477b20cd56bf57f28  avion.au
real    0m 2.38s
user    0m 1.99s
sys     0m 0.38s


Now, we are talking about MD5 which is obsolete and being replaced in 
our systems by SHA256. So a commit message ressembling to the one in 
commit 23e5c306a207 ("lib/crypto: sparc: Drop optimized MD5 code") would 
be better as a justification for the removal.

With the commit message modified to explain that MD5 is obsolete and 
using it is risky as you explained in the Sparc commit message, you can 
add Acked-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

But please consider the above performance comparison when addressing the 
AF_ALG removal.

By the way, what are your plans for SHA1 ? I think SHA1 should likely go 
away as well for the same reason.

Christophe
