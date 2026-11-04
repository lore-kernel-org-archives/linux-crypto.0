Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.61
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793750549;
	b=mfKVgqYZY4DDmFmjvojGJFtVR5kNl7BHxl6akyV3OUYf/8L2X9DBXX/Qf6rDyeefT0gQ
	 2y1VIGb98mokd7NGehfIu2kWiSx7XHn4q0LyxpszEzeI5d/5O3F6P/77eypNpGs5340A2
	 zNOlVNUGVCIdeXRixOZXOdjaR4UykxuKv85uJs+xvv+vHOkuwdeC20VhfqkHnvpXRg1Nh
	 XFJTuOFHU8DMirTio3uguGqJdV3auuupl02UPoUELOtm2ZIv8VJrTYGLuCfoeR/ckQ8gc
	 UwBTX2NSPNWVy+9sVeTJGui8uV/PFkp7EfIkSLm66foQsRJEUpYBZxfhik49b7KeNoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793750549;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=NFOuYUhAlrEqd62YbgZwOb+1oo3zwNmF5VnAYfL6KPA=;
	b=zM5/xPbnUapccV5puJenDHCK/HhW0DY3i2gU36ag7JtgrrmwGJrObfWNWIGSM7fWRUJu
	 1c43+Qv56Cga3sSA6nVgJLdbUsn6RElfB75HjC3ixlwOVQqAdS5fOvnaqMuzLEdSV9emG
	 hG5vNLf89+PAWhbjkaPiNGnmUKfnmcdL6gMt40h0VjzrJDOQI7sVkrSIl1MD6oRN+I10R
	 Db0imM/q3JakYXSQdITKCIVlHkVZlzkgww0TwyOlPaY3oZFwXg+BJyOagaWEQ5cZ6ssMJ
	 utxWSBmDMoy9/FTOoj0B2QJvBtZ979O5KoH852iLlqq3/ljSgMPCe9gsePhKqklWe+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=sL0qW9kF;
	arc=none smtp.remote-ip=195.10.208.61
Received: from mout-b-201.mailbox.org (mout-b-201.mailbox.org [195.10.208.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8084606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 00:02:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8084606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=sL0qW9kF
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-201.mailbox.org (Postfix) with ESMTPS id 4jK5Gc64CrzLmSk;
	Wed, 04 Nov 2026 01:02:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793750536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NFOuYUhAlrEqd62YbgZwOb+1oo3zwNmF5VnAYfL6KPA=;
	b=sL0qW9kFlETiXeH63ttGz624t3wENo7hWYq9luTY+x4gP2eZPrN+SSIf1tel6XK9H3U1XM
	VyR7vW2z4MsMI+HBWctRpdiJMdp0AZhDHyl8ZOucWj5O3tucejWcXiZi6K/aQEBFCWCA4T
	9PAH4JTpiuog9AQ/Oytp5aHEa4eSQbttq4fJGzUyRphdm94nOYhzuNmcxsskLj+06LlxTi
	LdEWn4RAZe/TMPb98ar7/7Q+KQtae8Ojy+WUSh79DDYOsMLNurPGQtu5hHHo1+PY+2j3dG
	ndmge9+A4eLJ8rlvvo/IfkW8jnXPTyviaX73sjpZCtG6L+qT0K9y4Hq1a+YvBg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <8b8ec7f8-8417-4a68-9efd-e7ff492a46e9@mandelbit.com>
Date: Wed, 4 Nov 2026 01:02:13 +0100
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
Subject: Re: [PATCH] lib/crypto: x86/chacha: Use bzhi to simplify mask
 generation
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Willi <martin@strongswan.org>
References: <20261103235027.63382-1-ebiggers@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261103235027.63382-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jK5Gc64CrzLmSk

Hi,

On 04/11/2026 00:50, Eric Biggers wrote:
> When XOR'ing the bytes from a partial register at the end, use the bzhi
> instruction (from BMI2) to generate the needed mask a bit more
> efficiently.  All real processors with AVX-512 also have BMI2, so we
> might as well make use of it.  This follows the example of the AVX-512
> optimized AES-GCM code which already does this.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

KUnit test is happy and my tests (on Zen 5) too :)

Tested-by: Antonio Quartulli <antonio@mandelbit.com>

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

