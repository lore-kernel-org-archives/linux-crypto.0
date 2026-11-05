Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793909184;
	b=xnGdy0U5U5yFdm8GrYUFNtPWJNUYVppAnqQzGoWs7VWou541tRyUXC05g5X8N3uQSe8M
	 +PtLaxJG0tAYZOvzzdC80TH8d3WgbSCHdXtXO2Gza2zlUnqwJ6T8xhYhT7OsyNgp6riZP
	 F6lNEyKq25uATOmr+C3M2c6BB+LJ6HhN8Ok3zlMrUi+kNuKruBPoeqyhzvxrrwZ3cMwli
	 zZK9TK6ASvEwDU74eD+AgkF/AgkoUQaFr/YQ4xrPVWMtCDj4tdPTwhMiB0Q69QHWTb7bi
	 ObpXdxKiJHrKZ58Q0vUIM4tQ5ZKuWq2X5aRkwin34z0gs+RQUxA0GzRMjwONV8pj5ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909184;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=afNkrJKHEYMYBAgRltvvWnGtfPuiupAgs8JNlp3dKrE=;
	b=GEmY9nO1JJ3tCUYgpvFwMrDlP8WANtGb2WPrgUPyiEw9XxauGUZSW++co95mPz7eEmUv
	 p+HJDi6nUTQaRPDHLTknnMgsne7qiX5ASd3YxnRGfbD90WX+FqyAT2EjYTgpnLzGzSG7R
	 gSvdkUQOD4Ln/riZRhNHGKljFptcr0CIFlKMKl2WWul7ZMrigQec+WNjibqqYOJDkkkrn
	 ddZNWWHO2oJ2H6iajbBW2cLuMiCLM1ON01id9ddiS/yIjF+0vTezk3YfRIupAdm2KZl2w
	 Wh62t1K4BXnicxC2Mf/7b8jhnPVI820nSYnsfwBn320YZ3CLkaBSwvz0MagdStbW55Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=VYnl8dYo;
	arc=none smtp.remote-ip=195.10.208.52
Received: from mout-b-203.mailbox.org (mout-b-203.mailbox.org [195.10.208.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA40606D819
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 20:06:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EA40606D819
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=VYnl8dYo
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-b-203.mailbox.org (Postfix) with ESMTPS id 4jLCxJ3ZHBzLm81;
	Thu, 05 Nov 2026 21:06:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793909172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afNkrJKHEYMYBAgRltvvWnGtfPuiupAgs8JNlp3dKrE=;
	b=VYnl8dYo7GwK7yXf88HdF2MbmZ+JR+LsgplCHK3sws2+fHJFNmP38HvgTUwNEQ86sMubUG
	7l/CLG3d4OAcpXlYe54srPgMyeJqxEO/AeJdqunvS0iq5vee674033IeuyVAwVBkPzUHVu
	N3PzQNR0XRJRN2xU9coRAhFUIOHQcObrke57X+lyGGhXqo7Tt+sWUm7iHbmjQgxtha4Opk
	NGXzUJHxi3G337zuBmOBmRlfsFwlBkX9Qx3Mf8j0Kl+hpbgCfcxHGYwW6kc3bwgkcpg+0G
	DLcsQ9gBVVylAKWA+Av2axPHpdQE+ELdPC+r/XvSXSFV68ApDZpctcD4IY6ANw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <ee5bae71-6c0d-4405-b9bd-aeeba3e22bfa@mandelbit.com>
Date: Thu, 5 Nov 2026 21:06:08 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: x86/chacha: Eliminate more never-taken
 branches
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261104225526.68557-1-ebiggers@kernel.org>
 <3349b575-5f1d-4b81-be15-5f92565904e7@mandelbit.com>
 <20261105190833.GA3266627@google.com>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261105190833.GA3266627@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jLCxJ3ZHBzLm81

On 05/11/2026 20:08, Eric Biggers wrote:
> On Thu, Nov 05, 2026 at 04:31:41PM +0100, Antonio Quartulli wrote:
>>    path                 CPU setup              KUnit  perf
>>    -------------------  ---------------------  -----  ------------
>>    AVX-512, zmm         native                 pass   -1.0..-0.1%
> [...]
>> There is a little loss in the zmm case. I presume we can live with that, but
>> was worth mentioning.
> 
> Probably just noise, or maybe instruction alignment which is best
> tweaked separately if needed rather than relying on chance.

My guess is also with the alignment shift.

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

