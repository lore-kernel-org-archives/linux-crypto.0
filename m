Received: from mr5.vodafonemail.de (mr5.vodafonemail.de [145.253.228.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86E61EB46
	for <linux-crypto@vger.kernel.org>; Tue,  9 Apr 2024 10:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712658936; cv=none; b=fOD7PQmiq9fhH7KB3Smw0Dcf6dSw5PdZMI/4lYqBLadwzvLtAkawrpen+4EfNH5csrf+ui6GQDCCVzUihR+rMM5OPghU9uivfSRyGqkkScMhN+SlC2PCtpXeanmxuzBe9fSdxYg0IWZeoyewA7sZ6YxUqLmJ70g0XFTyJqZnnA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712658936; c=relaxed/simple;
	bh=feIO4vhUUWJr1V0i/YIkTv8TafJAXqFA1Uetb7wB0XU=;
	h=Message-ID:From:To:Cc:References:In-Reply-To:Subject:Date:
	 MIME-Version:Content-Type; b=flWJyiKwOuYFBu5O+ivEPP3U0aeLQ9x11nL44pR0c4MeyAyojdYnhFIwN/6hvYLtUCosyiy/cjkAhjxy7HkCIhGhaoMKuzDQjoZsW2xwE5z+P5fa54euWiUxoaG14vwyMFN7YIJQ8xr/tY8GFeEBF9+vOFgd2kMVUaB80l1ixzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=BHkfNvT8; arc=none smtp.client-ip=145.253.228.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="BHkfNvT8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1712658330;
	bh=8JWY77Jy81sKv/3l+Z79iqEIm5lCvTg7Noh+jhhkpmQ=;
	h=Message-ID:From:To:References:In-Reply-To:Subject:Date:
	 Content-Type:X-Mailer:From;
	b=BHkfNvT8e8qUoeD7GLcmg6DIPaJHkrvYOgYv28JRF5f+L9d+c1cktRKn24QIW/YuT
	 4Nsrg4dnX5PSPki2fayHIYaisET3WboejGRd1yqDBcq8641jeRKXpEauEYhH0tpVOh
	 qhp5cjIjZppLbumarKeB6kvPNxyAW+XoJ/EBM5n0=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr5.vodafonemail.de (Postfix) with ESMTPS id 4VDMY60pLJz1yHn;
	Tue,  9 Apr 2024 10:25:30 +0000 (UTC)
Received: from H270 (p54805648.dip0.t-ipconnect.de [84.128.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4VDMXv5yDtz9tj4;
	Tue,  9 Apr 2024 10:25:16 +0000 (UTC)
Message-ID: <4D8C090A8BD54C05A97F57A0F640E94F@H270>
From: "Stefan Kanthak" <stefan.kanthak@nexgo.de>
To: "Eric Biggers" <ebiggers@kernel.org>,
	<ardb@kernel.org>
Cc: <linux-crypto@vger.kernel.org>
References: <5EEE09A9021540A5AAD8BFEEE915512D@H270> <20240408123734.GB732@quark.localdomain> <9088939CC5454139901CEDD97DAFB004@H270> <20240408151832.GE732@quark.localdomain>
In-Reply-To: <20240408151832.GE732@quark.localdomain>
Subject: Re: [PATCH 1/2] crypto: s(h)aving 40+ bytes off arch/x86/crypto/sha256_ni_asm.S
Date: Tue, 9 Apr 2024 12:23:13 +0200
Organization: Me, myself & IT
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6002.18197
X-MimeOLE: Produced By Microsoft MimeOLE V6.1.7601.24158
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 2502
X-purgate-ID: 155817::1712658325-0EFFBA4B-4A8EEA38/0/0

"Eric Biggers" <ebiggers@kernel.org> wrote:

> [+Cc linux-crypto]
> 
> Please use reply-all so that the list gets included.
> 
> On Mon, Apr 08, 2024 at 04:15:32PM +0200, Stefan Kanthak wrote:
>> Hi Eric,
>> 
>> > On Mon, Apr 08, 2024 at 11:26:52AM +0200, Stefan Kanthak wrote:
>> >> Use shorter SSE2 instructions instead of some SSE4.1
>> >> use short displacements into K256
>> >> 
>> >> --- -/arch/x86/crypto/sha256_ni_asm.S
>> >> +++ +/arch/x86/crypto/sha256_ni_asm.S
>> > 
>> > Thanks!  I'd like to benchmark this to see how it affects performance,
>> 
>> Performance is NOT affected: if CPUs weren't superscalar, the patch might
>> save 2 to 4 processor cycles as it replaces palignr/pblendw (slow) with
>> punpck*qdq (fast and shorter)
>> 
>> > but unfortunately this patch doesn't apply.  It looks your email client
>> > corrupted your patch by replacing tabs with spaces.  Can you please use
>> > 'git send-email' to send patches?
>> 
>> I don't use git at all; I'll use cURL instead.

[...]

>> > Please make sure to run the crypto self-tests too.
>> 
>> I can't, I don't use Linux at all; I just noticed that this function uses
>> 4-byte displacements and palignr/pblendw instead of punpck?qdq after pshufd 
>> 
>> > The above is storing the two halves of the state in the wrong order.
>> 
>> ARGH, you are right; I recognized it too, wanted to correct it, but was
>> interrupted and forgot it after returning to the patch. Sorry.
> 
> I'm afraid that if you don't submit a probably formatted and tested patch, your
> patch can't be accepted.  We can treat it as a suggestion, though since you're
> sending actual code it would really help if it had your Signed-off-by.

Treat is as suggestion.
I but wonder that in the past 9 years since Tim Chen submitted the SHA-NI code
(which was copied umpteen times by others and included in their own code bases)
nobody noticed/questioned (or if so, bothered to submit a patch like mine, that
reduces the code size by 5%, upstream) why he used 16x "pshufd $14, %xmm0, %xmm0"
instead of the 1 byte shorter "punpckhqdq %xmm0, %xmm0" or "psrldq $8, %xmm0"
(which both MAY execute on more ports or faster than the shuffle instructions,
depending on the micro-architecture), why he used 8x a 4-byte instead of a 1-byte
displacement, or why he used "palignr/pblendw" instead of the shorter "punpck?qdq".

regards
Stefan

PS: aaaahhhh, you picked my suggestion up and applied it to the AES routine.
