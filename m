Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C27392802;
	Mon,  1 Jun 2026 10:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309013; cv=none; b=kodkJfYnxPjEXdOn5plz/Sbs7dQ6DcOZwDqXmGSAL3DBs2oPOKzjAPz9iwxfqxDb0y+MQqq73iXQEtfIujZTMt6TJHSjiVVzEOKaLc8GlCI4ebQ/l/XD9Xf0lq6UF8jQxC4InWa56lxH6phSJJfhKIlNSJRmQB5HD5qFw78mwNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309013; c=relaxed/simple;
	bh=RsTD+VZBlyOoOf5WwbVh6Lu3hCkdqUYZeBGck86rAkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JLHil99bnK3LSH29nIAlkqxcboIuSfmzjzuaRc91qE4PL+m35vJUd0yYG7X2Sa9QMvEuo/0z51D249m2BL/R629TU1d6Hbphe7OfhALIGFqyIvHcUTXMz0Q2tgxyRkmbDj2O2qt1IOErsE/lLnaOGlzOVFYc1NfC97KWc+z+qE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7aOINlS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7aOINlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DA31F00893;
	Mon,  1 Jun 2026 10:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780309010;
	bh=rLUMAWRxBdfmFTs8LNIHmzEZytQbW+Xc+BUjC9/2o0A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S7aOINlSnvXjC4VODR2gcvnT859UOCd2R2Q6UtOkh6kOFx7YJsDPdYvDdLORc95/d
	 wH+DjNQU2YtefBESa835nFE+DCNAvED8XkHb7SAr24k3D9dUL85WLflSqlWqef5MHj
	 wGpmpDYuHZ3vPEJkHXeMvjVsUUBD4jsp+NimAUpr44NJJZliIayarU+DJBpP2pfydn
	 BuAfOxXqiA3QNXYH3Pu87zeKYnLRZ4GgGylVv4Uwvdb1frDpMprMh4iXeKoQCu0Vlq
	 4Oz8fWuBR6cAiFQFoXvLXNJXHpZWkjNrcIWladps/Lu9Cgu1da0yq1sDytlsWAI2Jk
	 02NzfZCSC1y5g==
Message-ID: <0878baba-6dda-492e-b260-90d9117431e1@kernel.org>
Date: Mon, 1 Jun 2026 12:16:45 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/29] crypto: talitos - Prepare crypto implementation
 file splitting
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-5-cb1ad6cdea49@bootlin.com>
 <22245899-e046-41f1-8707-94f172b310e9@kernel.org>
 <DIXL0OBC6IP9.3UNVLNBMZ7EZ9@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <DIXL0OBC6IP9.3UNVLNBMZ7EZ9@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 01/06/2026 à 10:49, Paul Louvel a écrit :
> Hi Christophe,
> 
>> Le 28/05/2026 à 11:08, Paul Louvel a écrit :
>>> Remove the static qualifier on multiple function that will be called
>>> inside each crypto implementation file.
>>> Add them to the main driver header file.
>>
>> I didn't have time to look at the generated text yet but I'm a bit
>> sceptic with this change, or more than the change itself, about its
>> purpose. And even more when I see patches 24 and 25.
> 
> About patch 24 and 25: one of the main purpose of this series is to get rid of
> the is_sec1 scattered around the core code of the driver.

I think we can find more efficient ways to do it, for instance using 
static branches (jump label).

> 
>> Most functions here are small helpers. To be shared between several C
>> files they deserve becoming static inlines in talitos.h, not global
>> functions.
> 
> I did not look at the generated text either for this change but I bet the
> compiler is inlining these calls. Adding them as static inline is more explicit.

Today the compiler is inlining these calls for sure, and it also gets 
rid of the is_sec1 at all unless you unlikely build with both 
CRYPTO_DEV_TALITOS1 and CRYPTO_DEV_TALITOS2.
But once you call them from a different C file, then it can't be inlined 
anymore.

> 
> I understand that there is a performance penalty, since there will be no
> inlining, and a memory dereferencing for a call through function pointer.

Not only a memory dereferencing, but all the preparation for calling a 
subfunction: creating a stack frame, saving the link register, saving 
volatile registers, loading the address to call into a register, saving 
it into CTR register, then doing a branch to CTR. And of course the 
impact on the call flow, instruction cache loading, pipeline, etc ...
So this is definitely a huge cost compared to the cost of the one or two 
loads done by the helper itself.

> 
>> Indeed, most of the time is_sec1 is known at build time because in most
>> cases has_ftr_sec1() will constant fold into true or false during build.
>> This is because it is very unlikely that someone build a kernel to run
>> on both MPC 82xx and MPC 83xx at the same time. Therefore it is really
>> unlikely that this in built with both CRYPTO_DEV_TALITOS1 and
>> CRYPTO_DEV_TALITOS2 at the same time.
> 
> As for patch 24, 25 and onwards, the same space optimization apply here. If the
> kernel is built with CRYPTO_DEV_TALITOS1, there will be no SEC2-related function
> in the generated text, and vice versa.

I'm not thinking about space optimisation but processing optimisation. 
In the current implementation you have a flat branchless execution flow. 
Here you are introducing branching, and worse: indirect branching. As 
mentioned by David, it has a serious cost, more than what (young) people 
may think. When only two choices are needed an if/else remains the most 
efficient.

Christophe

> 
>>
>> I can understand for a function like talitos_submit() but not for
>> functions like to_talitos_ptr() or to_talitos_ptr_ext_set() whose
>> purpose is really to get inlined into the caller.
>>
>> Christophe
>>
> 
> These changes are needed to split the driver into multiple files.
> 
> Best regards,
> Paul.
> 

