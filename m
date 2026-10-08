Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE51934F46F;
	Thu,  8 Oct 2026 20:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791490203; cv=none; b=pWesbRs5mFjUdyMrhyNxjKt73dmn2qwk7P8rkyUANx4fIsTOVEf2wYuMYocgGpKgQL2qaorfY/QgLKYznB9X7y/ZbvuRJAyBaBaQRAHeZutl52yit+tMgwpWnJi9/XIiI/Grr9ikN1TDdNQv3AJhTgkjHVFkwzC9rZxid/S2pmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791490203; c=relaxed/simple;
	bh=KKuQYSPoqVFlZgMofQHblBL21sE9VKaHPTLF8PqoPqg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=igNJ78kGfVOlSZFNQ+x/2hT2n9P2+DYlYeds8B4/UgHgwkEZ0VZg09GbheXZNmyseMZDJmkYM/0pj8bV4sVu7FXS9MaKjyntPB8uH88JkNrKPb7rBCvDQ8wvmz8Ihr3iWAdd7CgZCZvZ4FHesSeLeM6D8OyrzkehU4CitDQQ+w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=DmAqU79N; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="DmAqU79N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=2SOMAf6/FUJCTJbvwoY4BNDpzpbM9WO2QMNyv7qonXs=; b=DmAqU79NR9JIQF+bbOjnOjGVNL
	CTm7BATAzdTRVQN6Zwxy0jAzDfD1N+mKkkvcbUO2Lw7Ij/Anp8zRa/0HtoQLuUbgiEf+KhWiX7/q3
	f5XMUa2B6/PKLP+HIa4RrxL51UOFkhH0Qo3Lix/naF5RDOp/zjupr3uAOG2by0Rhp06EZkjNlowv2
	pDVYx+1CR/tf6BL7EKJT7t6M76GMgG2EGtPwVSv5PLuoUrLjl5zTRlK9QlmDqiz+eAiqLkxd9WWWM
	CzSLogS2utHFsKSaUaWt6lCBEFBEJk6dbrVLd5nGy7NQiYZj/RN2uFNYnJ9FsrMff5fRnutkejlNf
	QEomQdLg==;
Received: from [::1] (port=54016 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xEuR8-00000002h9s-0j14;
	Thu, 08 Oct 2026 22:09:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 08 Oct 2026 22:09:54 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
 <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: arm64: Fix lost Poly1305 carry when resuming
 NEON state
In-Reply-To: <20261007223726.GA24521@quark>
References: <20261007220235.200818-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261007223726.GA24521@quark>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <e15602ed17e6798be95d5780f7e07961@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-10-08 00:37, Eric Biggers wrote:
> On Wed, Oct 07, 2026 at 10:02:36PM +0000, Jérémy Jean wrote:
>> When poly1305_blocks_neon() resumes from a radix-2^26 state with an 
>> odd
>> number of input blocks, it converts the accumulator back to radix-2^64
>> before consuming the first block. The final ADC stores the carry into 
>> d2,
>> but the following accumulation and poly1305_mult() use h2.  If the
>> conversion overflows across bit 128, the carry is dropped and the 
>> emitted
>> tag is wrong.
>> 
>> Store the carry back into h2. This matches the other conversion paths 
>> and
>> preserves the represented accumulator.
>> 
>> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate 
>> OpenSSL/CRYPTOGAMS NEON implementation")
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>> ---
>>  lib/crypto/arm64/poly1305-armv8.pl | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/lib/crypto/arm64/poly1305-armv8.pl 
>> b/lib/crypto/arm64/poly1305-armv8.pl
>> index f1930c6..234398f 100644
>> --- a/lib/crypto/arm64/poly1305-armv8.pl
>> +++ b/lib/crypto/arm64/poly1305-armv8.pl
>> @@ -375,7 +375,7 @@ poly1305_blocks_neon:
>>  	adc	$h1,$h1,xzr
>>  	lsr	$h2,x14,#24
>>  	adds	$h1,$h1,x14,lsl#40
>> -	adc	$d2,$h2,xzr		// can be partially reduced...
>> +	adc	$h2,$h2,xzr		// preserve carry into top limb

Hello Eric,

> This needs a regression test in lib/crypto/tests/poly1305_kunit.c.

I have prepared one, and will send it along in the v2.

> Please include more details in the commit message about under what
> circumstances that carry bit could be nonzero.

I have expanded the commit message of the bugfix: it should be clearer
in the v2. In particular, I have added an explicit example and provided
probability estimates for which this bug would trigger under nominal 
use.
The probability is so low that this should never happen for normal use;
the fix merely fixes correctness of the algorithm.

> It seems this was introduced by commit 03dc4adf91c8bc of
> https://github.com/dot-asm/cryptogams just before the kernel imported
> the code.  The bug never reached the copy of this file in OpenSSL.  Do
> you agree?  If so, please mention this information in the commit 
> message
> too, and also open an issue at https://github.com/dot-asm/cryptogams so
> that it can be fixed there as well.

Agreed. I have added a short paragraph about that in the commit message
as well. I will see later to open an issue on
https://github.com/dot-asm/cryptogams.

Regards,
Jérémy
